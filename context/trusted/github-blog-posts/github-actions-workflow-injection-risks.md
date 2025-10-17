# How to catch GitHub Actions workflow injections before attackers do

URL Source: https://github.blog/security/vulnerability-research/how-to-catch-github-actions-workflow-injections-before-attackers-do/

Published Time: 2025-07-16T09:00:00-07:00

Markdown Content:

Strengthen your repositories against actions workflow injections — one of the most common vulnerabilities.

July 16, 2025

You already know that security is important to keep in mind when creating code and maintaining projects. Odds are, you also know that it’s much easier to think about security from the ground up rather than trying to squeeze it in at the end of a project.

But did you know that GitHub Actions injections are one of the most common vulnerabilities in projects stored in GitHub repositories? Thankfully, this is a relatively easy vulnerability to address, and GitHub has some tools to make it even easier.

*Image 1*: A bar chart detailing the most common vulnerabilities found by CodeQL in 2024. In order from most to least, they are: injection, broken access control, insecure design, cryptographic failures, identification and authentication failures, security misconfigurations, software and data integrity failures, security logging and monitoring failures, server side request forgery, and vulnerable and outdated components.

_From the 2024 Octoverse report detailing the most common types of OWASP-classified vulnerabilities identified by CodeQL in 2024. Our latest data shows a similar trend, highlighting the continued risks of injection attacks despite continued warnings for several decades._

Embracing a security mindset
----------------------------

The truth is that security is not something that is ever “done.” It’s a continuous process, one that you need to keep focusing on to help keep your code safe and secure. While automated tools are a huge help, they’re not an all-in-one, fire-and-forget solution.

This is why it’s important to understand the causes behind security vulnerabilities as well as how to address them. No tool will be 100% effective, but by increasing your understanding and deepening your knowledge, you will be better able to respond to threats.

With that in mind, let’s talk about one of the most common vulnerabilities found in GitHub repositories.

Explaining actions workflow injections
--------------------------------------

So what exactly is a GitHub Actions workflow injection? This is when a malicious attacker is able to submit a command that is run by a [workflow](https://docs.github.com/actions/writing-workflows/about-workflows) in your repository. This can happen when an attacker controls the data, such as when they create an issue title or a branch name, and you execute that untrusted input. For example, you might execute it in the run portion of your workflow.

One of the most common causes of this is with the `${{}}` syntax in your code. In the preprocessing step, this syntax will automatically expand. That expansion may alter your code by inserting new commands. Then, when the system executes the code, these malicious commands are executed too.

Consider the following workflow as an example:

```
- name: print title
  run: echo "${{ github.event.issue.title }}"
```

Let’s assume that this workflow is triggered whenever a user creates an issue. Then an attacker can create an issue with malicious code in the title, and the code will be executed when this workflow runs. The attacker only needs to do a small amount of trickery such as adding backtick characters to the title: `touch pwned.txt`. Furthermore, this code will run using the permissions granted to the workflow, permissions the attacker is otherwise unlikely to have.

This is the root of the actions workflow injection. The biggest issues with actions workflow injections are awareness that this is a problem and finding all the instances that could lead to this vulnerability.

How to proactively protect your code
------------------------------------

As stated earlier, it’s easier to prevent a vulnerability from appearing than it is to catch it after the fact. To that end, there are a few things that you should keep in mind while writing your code to help protect yourself from actions workflow injections.

While these are valuable tips, remember that even if you follow all of these guidelines, it doesn’t guarantee that you’re completely protected.

### Use environment variables

Remember that the actions workflow injections happen as a result of expanding what should be treated as untrusted input. When it is inserted into your workflow, if it contains malicious code, it changes the intended behavior. Then when the workflow triggers and executes, the attacker’s code runs.

One solution is to avoid using the `${{}}` syntax in workflow sections like `run`. Instead, expand the untrusted data into an environment variable and then use the environment variable when you are running the workflow. If you consider our example above, this would change to the following.

```
- name: print title
  env:
    TITLE: ${{ github.event.issue.title }}
  run: echo "$TITLE"
```

This won’t make the input trusted, but it will help to protect you from some of the ways attackers could take advantage of this vulnerability. We encourage you to do this, but still remember that this data is untrusted and could be a potential risk.

### The principle of least privilege is your best friend

When an actions workflow injection triggers, it runs with the permissions granted to the workflow. You can specify what permissions workflows have by [setting the permissions for the workflow’s GITHUB_TOKEN](https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/controlling-permissions-for-github_token#defining-access-for-the-github_token-permissions). For this reason, it’s important to make sure that your workflows are only running with the lowest privilege levels they need in order to perform duties. Otherwise, you might be giving an attacker permissions you didn’t intend if they manage to inject their code into your workflow.

### Be cautious with `pull_request_target`

The impact is usually much more devastating when injection happens in a workflow that is triggered on `pull_request_target` than on `pull_request`. There is a significant difference between the `pull_request` and `pull_request_target` workflow triggers.

The `pull_request` workflow trigger prevents write permissions and secrets access on the target repository by default when it’s triggered from a fork. Note that when the workflow is triggered from a branch in the same repository, it has access to secrets and potentially has write permissions. It does this in order to help prevent unauthorized access and protect your repository.

By contrast, the `pull_request_target` workflow trigger gives the workflow writer the ability to release some of the restrictions. While this is important for some scenarios, it does mean that by using `pull_request_target` instead of `pull_request`, you are potentially putting your repository at a greater risk.

This means you should be using the `pull_request` trigger unless you have a very specific need to use `pull_request_target`. And if you are using the latter, you want to take extra care with the workflow given the additional permissions.

The problem’s not just on main
------------------------------

It’s not uncommon to create several branches while developing your code, often for various features or bug fixes. This is a normal part of the software development cycle. And sometimes we’re not the best at remembering to close and delete those branches after merging or after we’ve finished working with them. Unfortunately, these branches are still a potential vulnerability if you’re using the `pull_request_target` trigger.

An attacker can target a workflow that runs on a pull request in a branch, and still take advantage of this exploit. This means that you can’t just assume your repository is safe because the workflows against your `main` branch are secure. You need to review all of the branches that are publicly visible in your repository.

What CodeQL brings to the table
-------------------------------

[CodeQL](https://codeql.github.com/) is GitHub’s code analysis tool that provides automated security checks against your code. The specific feature of CodeQL that is most relevant here is [the code scanning feature](https://docs.github.com/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning-with-codeql), which can provide feedback on your code and help identify potential security vulnerabilities. We recently [made the ability to scan GitHub Actions workflow files generally available](https://github.blog/changelog/2025-04-22-github-actions-workflow-security-analysis-with-codeql-is-now-generally-available/), and you can use this feature to look for several types of vulnerabilities, such as potential actions workflow injection risks.

One of the reasons CodeQL is so good at finding where untrusted data might be used is because of taint tracking. We [added taint tracking to CodeQL](https://github.blog/security/application-security/how-to-secure-your-github-actions-workflows-with-codeql/#taint-tracking-is-key) for actions late last year. With taint tracking, CodeQL tracks where untrusted data flows through your code and identifies potential risks that might not be as obvious as the previous examples.

Enabling CodeQL to scan your actions workflows is as easy as [enabling CodeQL code scanning with the default setup](https://docs.github.com/code-security/code-scanning/enabling-code-scanning/configuring-default-setup-for-code-scanning), which automatically includes analyzing actions workflows and will run on any [protected branch](https://docs.github.com/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches). You can then check for the code scanning results to identify potential risks and start fixing them.

If you’re already using [the advanced setup for CodeQL](https://docs.github.com/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/configuring-advanced-setup-for-code-scanning), you can add support for scanning your actions workflows by adding the `actions` language to the target languages. These scans will be performed going forward and help to identify these vulnerabilities.

While we won’t get into it in this blog, it’s important to know that CodeQL code scanning runs several queries—it’s not just good at finding actions workflow injections. We encourage you to give it a try and see what it can find.

While CodeQL is a very effective tool—and it is really good at finding this specific vulnerability—it’s still not going to be 100% effective. Remember that no tool is perfect, and you should focus on keeping a security mindset and taking a critical idea to your own code. By keeping this in the forefront of your thoughts, you will be able to develop more secure code and help prevent these vulnerabilities from ever appearing in the first place.

Future steps
------------

Actions workflow injections are known to be one of the most prevalent vulnerabilities in repositories available on GitHub. However, they are relatively easy to address. The biggest issues with eliminating this vulnerability are simply being aware that they’re a problem and discovering the possible weak spots in your code.

Now that you’re aware of the issue, and have CodeQL on your side as a useful tool, you should be able to start looking for and fixing these vulnerabilities in your own code. And if you keep the proactive measures in mind, you’ll be in a better position to prevent them from occurring in future code you write.

If you’d like to learn more about actions workflow injections, we previously published [a four-part series about keeping your actions workflows secure](https://securitylab.github.com/resources/github-actions-preventing-pwn-requests/). The [second part](https://securitylab.github.com/resources/github-actions-untrusted-input/) is specifically about actions workflow injections, but we encourage you to give the entire series a read.

**Need some help searching through your code to look for potential vulnerabilities?**[Set up code scanning](https://docs.github.com/code-security/code-scanning/enabling-code-scanning/configuring-default-setup-for-code-scanning) in your project today.

Written by
----------

Dylan Birtolo


--- content of this file has been reviewed & modified to remove unnecessary information ---