require 'json'
require 'open3'
require 'tmpdir'
require 'yaml'

class MilestonesTest
  WORKFLOW = File.expand_path('../.github/workflows/milestones.yml', __dir__)
  SCRIPT = YAML.load_file(WORKFLOW).fetch('jobs').fetch('milestones').fetch('steps').first.fetch('run')
               .split("<<'RUBY'\n", 2).last.sub(/\nRUBY\s*\z/, '')

  def run_workflow(milestones: [], issue: {}, tag: '', release: nil, merged: true, base: 'main', api_failure: false, event_name: 'pull_request_target')
    Dir.mktmpdir do |dir|
      File.write("#{dir}/event.json", JSON.generate({
        'repository' => { 'default_branch' => 'main' },
        'pull_request' => { 'number' => 42, 'merged' => merged, 'base' => { 'ref' => base } },
        'release' => release
      }))
      File.write("#{dir}/fixture.json", JSON.generate({ milestones: milestones, issue: issue, release: release, api_failure: api_failure }))
      File.write("#{dir}/gh", <<~'RUBY')
        #!/usr/bin/ruby
        require 'json'
        fixture = JSON.parse(File.read(ENV.fetch('FIXTURE')))
        if fixture['api_failure']
          warn 'API unavailable'
          exit 1
        end
        if ARGV.include?('PATCH')
          File.open(ENV.fetch('CALLS'), 'a') { |file| file.puts(JSON.generate(ARGV)) }
          puts '{}'
        elsif ARGV.any? { |arg| arg.include?('/milestones?') }
          puts JSON.generate([fixture['milestones']])
        elsif ARGV.any? { |arg| arg.include?('/releases?') }
          puts JSON.generate([[fixture['release']].compact])
        else
          puts JSON.generate(fixture['issue'])
        end
      RUBY
      File.chmod(0755, "#{dir}/gh")
      output, error, status = Open3.capture3({
        'PATH' => "#{dir}:#{ENV.fetch('PATH')}", 'FIXTURE' => "#{dir}/fixture.json", 'CALLS' => "#{dir}/calls",
        'GITHUB_EVENT_PATH' => "#{dir}/event.json", 'GITHUB_EVENT_NAME' => event_name,
        'GITHUB_REPOSITORY' => 'HaishinKit/example', 'RELEASE_TAG' => tag
      }, '/usr/bin/ruby', '-rjson', '-ropen3', stdin_data: SCRIPT)
      calls = File.exist?("#{dir}/calls") ? File.readlines("#{dir}/calls").map { |line| JSON.parse(line) } : []
      [status.success?, output + error, calls]
    end
  end

  def milestone(number, title)
    { 'number' => number, 'title' => title }
  end

  def test_assigns_earliest_open_release_without_nonrelease_fallback
    ok, _, calls = run_workflow(milestones: [milestone(1, 'Future'), milestone(2, '0.21.0'), milestone(3, 'v0.20.4')])
    assert ok
    assert_equal 1, calls.size
    assert_includes calls.first, 'milestone=3'
  end

  def test_no_open_milestone_remains_unassigned
    [[], [milestone(1, 'Future')]].each do |milestones|
      ok, _, calls = run_workflow(milestones: milestones)
      assert ok
      assert_empty calls
    end
  end

  def test_keeps_existing_assignment
    ok, _, calls = run_workflow(issue: { 'milestone' => milestone(1, '0.20.4') })
    assert ok
    assert_empty calls
  end

  def test_ignores_unmerged_and_other_branch_prs
    [{ merged: false }, { base: 'release' }].each do |arguments|
      ok, _, calls = run_workflow(**arguments)
      assert ok
      assert_empty calls
    end
  end

  def test_closes_only_matching_milestones_and_accepts_v_prefix
    release = { 'tag_name' => 'v0.20.3', 'draft' => false, 'published_at' => '2026-11-21T00:00:00Z' }
    ok, _, calls = run_workflow(tag: 'v0.20.3', release: release,
                               milestones: [milestone(1, '0.20.3'), milestone(2, '0.20.4')])
    assert ok
    assert_equal 1, calls.size
    assert_includes calls.first, 'repos/HaishinKit/example/milestones/1'
    assert_includes calls.first, 'state=closed'
  end

  def test_already_closed_or_missing_milestone_is_a_noop
    release = { 'tag_name' => '0.20.3', 'draft' => false, 'published_at' => '2026-11-21T00:00:00Z' }
    ok, _, calls = run_workflow(tag: '0.20.3', release: release)
    assert ok
    assert_empty calls
  end

  def test_release_published_event_reads_the_tag_from_the_payload
    release = { 'tag_name' => '0.20.3', 'draft' => false, 'published_at' => '2026-11-21T00:00:00Z' }
    ok, _, calls = run_workflow(event_name: 'release', release: release, milestones: [milestone(1, 'v0.20.3')])
    assert ok
    assert_equal 1, calls.size
    assert_includes calls.first, 'state=closed'
  end

  def test_unpublished_or_draft_release_does_not_close_milestone
    [nil, { 'tag_name' => '0.20.3', 'draft' => true }].each do |release|
      ok, _, calls = run_workflow(tag: '0.20.3', release: release, milestones: [milestone(1, '0.20.3')])
      refute ok
      assert_empty calls
    end
  end

  def test_api_failure_is_reported
    ok, output, calls = run_workflow(api_failure: true)
    refute ok
    assert_includes output, '::error title=Milestone update failed::'
    assert_empty calls
  end

  def assert(value)
    raise 'Assertion failed' unless value
  end

  def refute(value)
    assert(!value)
  end

  def assert_equal(expected, actual)
    raise "Expected #{expected.inspect}, got #{actual.inspect}" unless expected == actual
  end

  def assert_includes(collection, value)
    assert(collection.include?(value))
  end

  def assert_empty(collection)
    assert(collection.empty?)
  end
end

suite = MilestonesTest.new
tests = MilestonesTest.instance_methods.grep(/^test_/).sort
tests.each do |test|
  suite.public_send(test)
  puts "PASS #{test}"
end
puts "#{tests.size} tests passed."
