Title: Setting a minimum specification for codespace machines - GitHub Docs

URL Source: http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/setting-a-minimum-specification-for-codespace-machines

Markdown Content:
Setting a minimum specification for codespace machines - GitHub Docs

===============

[Skip to main content](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/setting-a-minimum-specification-for-codespace-machines#main-content)

[GitHub Docs](http://docs.github.com/en)

Version: Free, Pro, & Team

Search or ask Copilot

Search or ask Copilot

Select language: current language is English

Search or ask Copilot

Search or ask Copilot

Open menu

Open Sidebar

*   [Codespaces](http://docs.github.com/en/codespaces "Codespaces")/
*   [Setting up your project](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces "Setting up your project")/
*   [Configuring dev containers](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers "Configuring dev containers")/
*   [Set a minimum machine spec](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/setting-a-minimum-specification-for-codespace-machines "Set a minimum machine spec")

[Home](http://docs.github.com/en)

[Codespaces](http://docs.github.com/en/codespaces)
--------------------------------------------------

*   [Quickstart](http://docs.github.com/en/codespaces/quickstart)
*   Getting started
    *   [What are Codespaces?](http://docs.github.com/en/codespaces/about-codespaces/what-are-codespaces)
    *   [Codespaces features](http://docs.github.com/en/codespaces/about-codespaces/codespaces-features)
    *   [The codespace lifecycle](http://docs.github.com/en/codespaces/about-codespaces/understanding-the-codespace-lifecycle)
    *   [Deep dive into Codespaces](http://docs.github.com/en/codespaces/about-codespaces/deep-dive)

*   Developing in a codespace
    *   [Develop in a codespace](http://docs.github.com/en/codespaces/developing-in-a-codespace/developing-in-a-codespace)
    *   [Create a codespace for a repo](http://docs.github.com/en/codespaces/developing-in-a-codespace/creating-a-codespace-for-a-repository)
    *   [Create a codespace from a template](http://docs.github.com/en/codespaces/developing-in-a-codespace/creating-a-codespace-from-a-template)
    *   [Delete a codespace](http://docs.github.com/en/codespaces/developing-in-a-codespace/deleting-a-codespace)
    *   [Open an existing codespace](http://docs.github.com/en/codespaces/developing-in-a-codespace/opening-an-existing-codespace)
    *   [Work collaboratively](http://docs.github.com/en/codespaces/developing-in-a-codespace/working-collaboratively-in-a-codespace)
    *   [Source control](http://docs.github.com/en/codespaces/developing-in-a-codespace/using-source-control-in-your-codespace)
    *   [Pull requests](http://docs.github.com/en/codespaces/developing-in-a-codespace/using-github-codespaces-for-pull-requests)
    *   [Stop a codespace](http://docs.github.com/en/codespaces/developing-in-a-codespace/stopping-and-starting-a-codespace)
    *   [Forward ports](http://docs.github.com/en/codespaces/developing-in-a-codespace/forwarding-ports-in-your-codespace)
    *   [Rebuilding a container](http://docs.github.com/en/codespaces/developing-in-a-codespace/rebuilding-the-container-in-a-codespace)
    *   [Default environment variables](http://docs.github.com/en/codespaces/developing-in-a-codespace/default-environment-variables-for-your-codespace)
    *   [Persist variables and files](http://docs.github.com/en/codespaces/developing-in-a-codespace/persisting-environment-variables-and-temporary-files)
    *   [Connecting to a private network](http://docs.github.com/en/codespaces/developing-in-a-codespace/connecting-to-a-private-network)
    *   [Machine learning](http://docs.github.com/en/codespaces/developing-in-a-codespace/getting-started-with-github-codespaces-for-machine-learning)
    *   [Visual Studio Code](http://docs.github.com/en/codespaces/developing-in-a-codespace/using-github-codespaces-in-visual-studio-code)
    *   [GitHub CLI](http://docs.github.com/en/codespaces/developing-in-a-codespace/using-github-codespaces-with-github-cli)

*   Customizing your codespace
    *   [Rename a codespace](http://docs.github.com/en/codespaces/customizing-your-codespace/renaming-a-codespace)
    *   [Change your shell](http://docs.github.com/en/codespaces/customizing-your-codespace/changing-the-shell-in-a-codespace)
    *   [Change the machine type](http://docs.github.com/en/codespaces/customizing-your-codespace/changing-the-machine-type-for-your-codespace)

*   Setting your user preferences
    *   [Personalize your codespaces](http://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account)
    *   [Set the default editor](http://docs.github.com/en/codespaces/setting-your-user-preferences/setting-your-default-editor-for-github-codespaces)
    *   [Set the default region](http://docs.github.com/en/codespaces/setting-your-user-preferences/setting-your-default-region-for-github-codespaces)
    *   [Set the timeout](http://docs.github.com/en/codespaces/setting-your-user-preferences/setting-your-timeout-period-for-github-codespaces)
    *   [Configure automatic deletion](http://docs.github.com/en/codespaces/setting-your-user-preferences/configuring-automatic-deletion-of-your-codespaces)
    *   [Choose the host image](http://docs.github.com/en/codespaces/setting-your-user-preferences/choosing-the-stable-or-beta-host-image)

*   Setting up your project
    *   Adding a dev container configuration
        *   [Introduction to dev containers](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers)
        *   [Setting up a Node.js project](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/setting-up-your-nodejs-project-for-codespaces)
        *   [Setting up a C# (.NET) project](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/setting-up-your-dotnet-project-for-codespaces)
        *   [Setting up a Java project](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/setting-up-your-java-project-for-codespaces)
        *   [Setting up a PHP project](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/setting-up-your-php-project-for-codespaces)
        *   [Setting up a Python project](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/setting-up-your-python-project-for-codespaces)

    *   Configuring dev containers
        *   [Set a minimum machine spec](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/setting-a-minimum-specification-for-codespace-machines)
        *   [Adding features](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/adding-features-to-a-devcontainer-file)
        *   [Automatically opening files](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/automatically-opening-files-in-the-codespaces-for-a-repository)
        *   [Specifying recommended secrets](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/specifying-recommended-secrets-for-a-repository)

    *   Setting up your repository
        *   [Facilitating codespace creation](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/setting-up-your-repository/facilitating-quick-creation-and-resumption-of-codespaces)
        *   [Set up a template repo](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/setting-up-your-repository/setting-up-a-template-repository-for-github-codespaces)

*   Prebuilding your codespaces
    *   [About prebuilds](http://docs.github.com/en/codespaces/prebuilding-your-codespaces/about-github-codespaces-prebuilds)
    *   [Configure prebuilds](http://docs.github.com/en/codespaces/prebuilding-your-codespaces/configuring-prebuilds)
    *   [Allow external repo access](http://docs.github.com/en/codespaces/prebuilding-your-codespaces/allowing-a-prebuild-to-access-other-repositories)
    *   [Manage prebuilds](http://docs.github.com/en/codespaces/prebuilding-your-codespaces/managing-prebuilds)
    *   [Test dev container changes](http://docs.github.com/en/codespaces/prebuilding-your-codespaces/testing-dev-container-changes)

*   Managing your codespaces
    *   [Codespaces secrets](http://docs.github.com/en/codespaces/managing-your-codespaces/managing-your-account-specific-secrets-for-github-codespaces)
    *   [Repository access](http://docs.github.com/en/codespaces/managing-your-codespaces/managing-repository-access-for-your-codespaces)
    *   [Security logs](http://docs.github.com/en/codespaces/managing-your-codespaces/reviewing-your-security-logs-for-github-codespaces)
    *   [GPG verification](http://docs.github.com/en/codespaces/managing-your-codespaces/managing-gpg-verification-for-github-codespaces)

*   Managing your organization
    *   [Enable or disable Codespaces](http://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/enabling-or-disabling-github-codespaces-for-your-organization)
    *   [Billing and ownership](http://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/choosing-who-owns-and-pays-for-codespaces-in-your-organization)
    *   [List organization codespaces](http://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/listing-the-codespaces-in-your-organization)
    *   [Manage Codespaces costs](http://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/managing-the-cost-of-github-codespaces-in-your-organization)
    *   [Manage secrets](http://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/managing-development-environment-secrets-for-your-repository-or-organization)
    *   [Audit logs](http://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/reviewing-your-organizations-audit-logs-for-github-codespaces)
    *   [Restrict machine types](http://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-access-to-machine-types)
    *   [Restrict codespace creation](http://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-the-number-of-organization-billed-codespaces-a-user-can-create)
    *   [Restrict base image](http://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-the-base-image-for-codespaces)
    *   [Restrict port visibility](http://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-the-visibility-of-forwarded-ports)
    *   [Restrict timeout periods](http://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-the-idle-timeout-period)
    *   [Restrict the retention period](http://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-the-retention-period-for-codespaces)

*   Reference
    *   [Access a private registry](http://docs.github.com/en/codespaces/reference/allowing-your-codespace-to-access-a-private-registry)
    *   [Copilot in Codespaces](http://docs.github.com/en/codespaces/reference/using-github-copilot-in-github-codespaces)
    *   [VS Code Command Palette](http://docs.github.com/en/codespaces/reference/using-the-vs-code-command-palette-in-codespaces)
    *   [Security in Codespaces](http://docs.github.com/en/codespaces/reference/security-in-github-codespaces)
    *   [Disaster recovery](http://docs.github.com/en/codespaces/reference/disaster-recovery-for-github-codespaces)

*   Troubleshooting
    *   [Codespaces logs](http://docs.github.com/en/codespaces/troubleshooting/github-codespaces-logs)
    *   [Codespaces clients](http://docs.github.com/en/codespaces/troubleshooting/troubleshooting-github-codespaces-clients)
    *   [Included usage](http://docs.github.com/en/codespaces/troubleshooting/troubleshooting-included-usage)
    *   [Exporting changes](http://docs.github.com/en/codespaces/troubleshooting/exporting-changes-to-a-branch)
    *   [Creation and deletion](http://docs.github.com/en/codespaces/troubleshooting/troubleshooting-creation-and-deletion-of-codespaces)
    *   [Authenticating to repositories](http://docs.github.com/en/codespaces/troubleshooting/troubleshooting-authentication-to-a-repository)
    *   [Connection](http://docs.github.com/en/codespaces/troubleshooting/troubleshooting-your-connection-to-github-codespaces)
    *   [Codespaces prebuilds](http://docs.github.com/en/codespaces/troubleshooting/troubleshooting-prebuilds)
    *   [Personalization](http://docs.github.com/en/codespaces/troubleshooting/troubleshooting-personalization-for-codespaces)
    *   [Port forwarding](http://docs.github.com/en/codespaces/troubleshooting/troubleshooting-port-forwarding-for-github-codespaces)
    *   [GPG verification](http://docs.github.com/en/codespaces/troubleshooting/troubleshooting-gpg-verification-for-github-codespaces)
    *   [Working with support](http://docs.github.com/en/codespaces/troubleshooting/working-with-support-for-github-codespaces)

*   [github.dev editor](http://docs.github.com/en/codespaces/the-githubdev-web-based-editor)
*   [Guides](http://docs.github.com/en/codespaces/guides)

*   [Codespaces](http://docs.github.com/en/codespaces "Codespaces")/
*   [Setting up your project](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces "Setting up your project")/
*   [Configuring dev containers](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers "Configuring dev containers")/
*   [Set a minimum machine spec](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/setting-a-minimum-specification-for-codespace-machines "Set a minimum machine spec")

Setting a minimum specification for codespace machines
======================================================

You can avoid under-resourced machine types being used for GitHub Codespaces for your repository.

Who can use this feature?
-------------------------

People with write permissions to a repository can create or edit the codespace configuration.

In this article
---------------

*   [Overview](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/setting-a-minimum-specification-for-codespace-machines#overview)
*   [Setting a minimum machine specification](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/setting-a-minimum-specification-for-codespace-machines#setting-a-minimum-machine-specification)
*   [Further reading](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/setting-a-minimum-specification-for-codespace-machines#further-reading)

[Overview](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/setting-a-minimum-specification-for-codespace-machines#overview)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Each codespace that you create is hosted on a separate virtual machine. When you create a codespace from a repository, you can usually choose from different types of virtual machines. Each machine type has different resources (processor cores, memory, storage) and, by default, the machine type with the least resources is used. For more information, see [Changing the machine type for your codespace](http://docs.github.com/en/codespaces/customizing-your-codespace/changing-the-machine-type-for-your-codespace#about-machine-types).

If your project needs a certain level of compute power, you can configure GitHub Codespaces so that only machine types that meet these requirements can be used by default, or selected by users. You configure this in a `devcontainer.json` file.

Unpublished codespaces (codespaces created from a template that are not linked to a repository on GitHub) always run on a virtual machine with the same specifications. You can't change the machine type of an unpublished codespace.

Important

Access to some machine types may be restricted at the organization level. Typically this is done to prevent people choosing higher resourced machines that are billed at a higher rate. If your repository is affected by an organization-level policy for machine types you should make sure you don't set a minimum specification that would leave no available machine types for people to choose. For more information, see [Restricting access to machine types](http://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-access-to-machine-types).

[Setting a minimum machine specification](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/setting-a-minimum-specification-for-codespace-machines#setting-a-minimum-machine-specification)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1.   You can configure the codespaces that are created for your repository by adding settings to a `devcontainer.json` file. If your repository doesn't already contain a `devcontainer.json` file, you can add one now. See [Adding a dev container configuration to your repository](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration).

2.   Edit the `devcontainer.json` file, adding the `hostRequirements` property at the top level of the file, within the enclosing JSON object. For example:

JSON"hostRequirements": {
   "cpus": 8,
   "memory": "8gb",
   "storage": "32gb"
}

```json
"hostRequirements": {
   "cpus": 8,
   "memory": "8gb",
   "storage": "32gb"
}
``` 
You can specify any or all of the options: `cpus`, `memory`, and `storage`.

To check the specifications of the GitHub Codespaces machine types that are currently available for your repository, step through the process of creating a codespace until you see the choice of machine types. For more information, see [Creating a codespace for a repository](http://docs.github.com/en/codespaces/developing-in-a-codespace/creating-a-codespace-for-a-repository#creating-a-codespace-for-a-repository).

3.   Save the file and commit your changes to the required branch of the repository.

Now when you create a codespace for that branch of the repository, and you go to the creation configuration options, you will only be able to select machine types that match or exceed the resources you've specified.

![Image 2: Screenshot of a list of machine types. The 2- and 4-core options are labeled "Below dev container requirements."](http://docs.github.com/assets/cb-47546/images/help/codespaces/machine-types-limited-choice.png) 

[Further reading](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/setting-a-minimum-specification-for-codespace-machines#further-reading)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*   [Introduction to dev containers](http://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers)

Help and support
----------------

![Image 3: The Copilot Icon in front of an explosion of color.](http://docs.github.com/assets/images/search/copilot-action.png)
Get quick answers!
------------------

Ask Copilot your question.

Ask Copilot

### Did you find what you needed?

Yes No 

[Privacy policy](http://docs.github.com/en/site-policy/privacy-policies/github-privacy-statement)

### Help us make these docs great!

All GitHub docs are open source. See something that's wrong or unclear? Submit a pull request.

[Make a contribution](https://github.com/github/docs/blob/main/content/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/setting-a-minimum-specification-for-codespace-machines.md)
[Learn how to contribute](http://docs.github.com/contributing)

### Still need help?

[Provide GitHub Feedback](https://github.com/community/community/discussions/categories/codespaces)

[Contact support](https://support.github.com/)

Legal
-----

*   © 2025 GitHub, Inc.
*   [Terms](http://docs.github.com/en/site-policy/github-terms/github-terms-of-service)
*   [Privacy](http://docs.github.com/en/site-policy/privacy-policies/github-privacy-statement)
*   [Status](https://www.githubstatus.com/)
*   [Pricing](https://github.com/pricing)
*   [Expert services](https://services.github.com/)
*   [Blog](https://github.blog/)
