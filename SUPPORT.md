# Support
HaishinKit contributors have limited availability to address general support questions. I hope you will resolve it on your own.

## 📕 Bug report.
A good bug report must meet the following conditions. We consider a well-written bug report a valuable asset to the community and welcome submissions from everyone.

1. **Aimed at solving the problem**  
2. **Concise documentation of the three key elements: ① Observed behavior, ② Expected behavior, ③ Steps to reproduce**  
3. **Written in a way understandable to a third-party maintainer**  

Bug reports that fail to meet these criteria are considered your problem, not ours. Please address them independently.

### Response Policy
The author will respond according to the following table:  

| Classification | Response |
|:---------------|:---------|
| **Users**       | Must provide complete and accurate information. Reports that do not meet the standards will be closed. |
| **Contributors**| The author will ask additional questions and debug the issue to assist in resolving it. |

<details>
  <summary>How to Write a Good Bug Report?</summary>

### Required Standards

#### 1. **Aimed at solving the problem**  
Issues should focus on collaborative problem-solving within the community. Just as there are no bug-free programs, there are no perfect bug reports. Maintainers may ask follow-up questions, or others experiencing similar issues may provide additional details.  
Reporters are expected to actively provide further information. While this may be tedious, please respond to questions.  
Some people submit issues just to complain or notify others without the intent to contribute; such submissions are unwelcome and will not be recognized as valuable contributions.

#### 2. **Concise documentation of the three key elements: ① Observed behavior, ② Expected behavior, ③ Steps to reproduce**  

Every bug report must include these three elements. Missing any of them makes it difficult for maintainers to understand and resolve the issue. Templates include these items; ensure you fill them out. Missing information reduces the likelihood of resolution.

##### ① **Observed Behavior**  
Explain what happened. Saying "It doesn't work" is vague. Specify whether it crashes, doesn't play, or exhibits some other issue.  

##### ② **Expected Behavior**  
Clearly state what you expect to happen. Avoid writing only logical negations of the observed behavior, such as "It shouldn't crash." Describe your actual expectation.  
For example:  

```plaintext
You: I reported a bug. Expecting it not to crash during live playback! Please fix.  
Me: I've fixed it.  
You: It's still not working.  
Me: It shouldn't crash, right?  
You: I can't even play the video.  
Me: Ah, the codec isn't supported at the OS level. It's a limitation.  
You: What!?  
Me: You should’ve mentioned that from the start.  
```

##### ③ Steps to Reproduce

HaishinKit is a library, and there are various ways to use it. Issues may arise depending on how it is utilized.

When reporting a bug, please specify the actions you took, the settings you used, and provide the minimal steps and code necessary to reproduce the issue. If reproducing the issue is difficult, it will likely remain unresolved. Even if the end-user environment lacks sufficient information to provide 100% reproducible steps, avoid omitting this section entirely. Instead, describe any tendencies or patterns you observed that might help identify the problem.

#### 3. Write Clearly for Third-Party Maintainers

Make sure your report is easy to understand for third-party maintainers. Avoid using internal jargon or ambiguous terms, such as "streaming," which can be interpreted as either broadcasting or viewing. HaishinKit is often used in corporate settings, so have a colleague review your report from the perspective of whether it is clear to an outsider before submitting it.

### Examples of Bug Reports

Below are examples of past bug reports, along with explanations of what makes a good report.

#### 📝 [Missing required module 'SwiftPMSupport'](https://github.com/shogo4405/HaishinKit.swift/issues/1502)

This issue lacked the "steps to reproduce," which made it difficult to address and led to it being closed after no further details were provided. It was disappointing to see that effective communication for problem-solving was not achieved.

- The author requested reproducible steps but did not receive a useful response.
- Some users chimed in, claiming to have the same problem, but their input added noise without providing new information.
- Suggestions for workarounds were made, but since the root cause was unknown, they could not be confidently adopted.
- A flood of comments from individuals not usually involved in discussions led to increased mistrust. It would have been preferable for colleagues to discuss these issues privately within their teams.

##### Feedback
| Aspect          | Does                                            | Don't                                      |
|------------------|------------------------------------------------|-------------------------------------------|
| **Observed Behavior** | A build error occurs.                         | A build error occurs.                     |
| **Expected Behavior** | The code compiles and the app launches successfully. | The app starts normally.                  |
| **Steps to Reproduce** | 1. Launch Xcode 16.X.<br>2. Create a new project.<br>3. Add Package Dependencies to the project.<br>4. Run the build. | Simply provide the `Package.swift` code. |

Even with the above steps, the exact reproduction method remains unclear.

#### 📝 [Crashing after few seconds](https://github.com/shogo4405/HaishinKit.swift/issues/1639)

This report was closed due to its lack of clarity for third parties. Comments from apparent colleagues were also insufficient, as they described the issue without addressing the author's questions about reproducibility, leaving dissatisfaction.

- The term "streaming" was ambiguous—whether it referred to broadcasting or viewing was unclear, though the latter was assumed.
- It was unclear whether the issue involved RTMP or SRT.
- For playback issues, information about the broadcasting side (e.g., video codec, audio codec) was missing.
- It was uncertain whether the code was user-written or from a test suite.
- The logs were poorly formatted and difficult to read.

##### Feedback
| Aspect          | Does                                            | Don't                                      |
|------------------|------------------------------------------------|-------------------------------------------|
| **Observed Behavior** | A crash occurs when viewing a live stream via SRT. | Streaming results in a crash.             |
| **Expected Behavior** | The live stream continues without crashing. | The app does not crash.                   |
| **Steps to Reproduce** | **Prerequisites:**<br>The server uses XXX.<br>The broadcaster uses OBS, streaming H.264 video and Opus audio.<br><br>**Steps:**<br>1. Launch the sample app (iOS).<br>2. Navigate to the viewing tab.<br>3. Tap the "View" button. | A crash occurs after a few seconds of streaming. |

### Examples of Unacceptable Behavior

Strict adherence to the code of conduct will be enforced in these cases.

#### 📝 [timestamp is error, when has B frame](https://github.com/shogo4405/HaishinKit.swift/issues/1551)  
#### 📝 [timestamp is not increase!](https://github.com/shogo4405/HaishinKit.swift/issues/1550)  
#### 📝 [frame type is error](https://github.com/shogo4405/HaishinKit.swift/issues/1549)

These reports lacked sufficient details for "Observed Behavior," "Expected Behavior," and "Steps to Reproduce." They also failed to consider clarity for third-party understanding and were subsequently closed. The following actions were deemed unacceptable, resulting in the authors being blocked:

- Spamming identical content across multiple issues.
- Using abusive language towards others.
</details>

## ✍️ Frequently Asked Questions and Answers
### 📝 English
#### When will the next release be?
We only provide this information to GitHub sponsors and some contributors. Releases are made once a certain number of PRs have accumulated. In urgent cases, we can release for a fee of 300 USD.

#### Does this feature exist?
We only provide this information to GitHub sponsors and some contributors. The main features are listed in the README.md. We also offer a sample app. Please try it out and judge for yourself.

#### Is there a plan to implement this feature?
We only provide this information to GitHub sponsors and some contributors. This is an individually developed OSS, so the development pace is not fast. Even if I say it will be implemented, it could take a year or six months, so it's better to assume there are no plans to implement it.

#### Can you implement this feature?
Please request it as a suggestion in the Ideas section of the GitHub Discussion. If I find the feature to be beneficial, I may implement it. Additionally, I do accept paid development requests.

### 📝 日本語
### 次回のリリースはいつされますか？
GitHubのスポンサー様と一部の貢献者にのみお答えしています。ある程度PRが溜まってからリリースしています。緊急の場合は、300USDで実施しております。
### こういう機能はありますか？
GitHubのスポンサー様と一部の貢献者にのみお答えしています。主要な機能なREADME.mdに記載しています。また、Exampleアプリを提供しています。そちらで試してみてご判断ください。
### こういう機能の実装予定はありますか？
GitHubのスポンサー様と一部の貢献者にのみお答えしています。個人開発のOSSであり開発ペースは早くはありません。もし、あると回答しても1年後になったり、半年後になったりする可能性もあり。実装予定はないと思ってくれたほうがよいです。
### こういう機能を実装してくれますか？
GitHub DiscussionのIdeaに要望としてリクエストしてください。有益な機能であると私が判断した場合に実装する場合があります。また、有料での開発相談は受け付けています。
