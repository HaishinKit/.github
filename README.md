# 🧩 HaishinKit shared GitHub configuration

[![Milestone tests](https://github.com/HaishinKit/.github/actions/workflows/test-milestones.yml/badge.svg)](https://github.com/HaishinKit/.github/actions/workflows/test-milestones.yml)

Organization-wide community files and reusable GitHub Actions workflows for HaishinKit projects.

## 📋 Release milestones

The [shared workflow](.github/workflows/milestones.yml) manages milestones in the **calling repository**:

- **PR merged into the default branch:** preserve an existing milestone, or assign the earliest open release milestone (`0.20.4` or `v0.20.4`). If none exists, leave the PR unassigned. Closed and non-version milestones are never used as a fallback.
- **GitHub Release published:** close the open milestone matching the tag, allowing a leading `v` on either name. A missing or already-closed milestone is a successful no-op.

Milestones must be created manually. Publishing a tag alone does not close a milestone.

## 🔌 Use in a project

Add `.github/workflows/milestones.yml` to each repository:

```yaml
name: Release milestones
on:
  pull_request_target:
    types: [closed]
  release:
    types: [published]
permissions:
  contents: read
  issues: write
  pull-requests: write
jobs:
  milestones:
    uses: HaishinKit/.github/.github/workflows/milestones.yml@main
```

`@main` follows the shared implementation. Replace it with a commit SHA to pin a revision. Remove any previous PR milestone assignment workflow to avoid duplicate runs.

Releases published with `GITHUB_TOKEN` do not trigger another release workflow. After successful publication, call the shared workflow directly from the release workflow:

```yaml
jobs:
  # The existing release job exposes its successfully published tag as an output.
  close-milestone:
    needs: release
    if: ${{ always() && needs.release.outputs.published-tag != '' }}
    permissions:
      contents: read
      issues: write
      pull-requests: write
    uses: HaishinKit/.github/.github/workflows/milestones.yml@main
    with:
      release-tag: ${{ needs.release.outputs.published-tag }}
```

The shared workflow verifies that the release is published before closing its milestone. It uses runner-provided Ruby and GitHub CLI, without checking out or executing PR code. No additional secrets are required.

## 🧪 Validation

Run `/usr/bin/ruby tests/milestones_test.rb` to check assignment, publication, no-op, and failure behavior without calling GitHub. The same tests run on pull requests and pushes to `main`.

## 🤝 Community

- [Organization profile](profile/README.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Support guidelines](SUPPORT.md)
- [Pull request template](PULL_REQUEST_TEMPLATE.md)
