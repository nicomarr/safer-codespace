Title: Adding features to a devcontainer.json file - GitHub Docs

URL Source: https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/adding-features-to-a-devcontainer-file

Markdown Content:
Adding features to a devcontainer.json file - GitHub Docs

===============

[Skip to main content](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/adding-features-to-a-devcontainer-file#main-content)

[GitHub Docs](https://docs.github.com/en)

Version: Free, Pro, & Team

Search or ask Copilot

Search or ask Copilot

Select language: current language is English

Search or ask Copilot

Search or ask Copilot

Open menu

Open Sidebar

*   [Codespaces](https://docs.github.com/en/codespaces "Codespaces")/
*   [Setting up your project](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces "Setting up your project")/
*   [Configuring dev containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers "Configuring dev containers")/
*   [Adding features](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/adding-features-to-a-devcontainer-file "Adding features")

[Home](https://docs.github.com/en)

[Codespaces](https://docs.github.com/en/codespaces)
---------------------------------------------------

*   [Quickstart](https://docs.github.com/en/codespaces/quickstart)
*   Getting started
    *   [What are Codespaces?](https://docs.github.com/en/codespaces/about-codespaces/what-are-codespaces)
    *   [Codespaces features](https://docs.github.com/en/codespaces/about-codespaces/codespaces-features)
    *   [The codespace lifecycle](https://docs.github.com/en/codespaces/about-codespaces/understanding-the-codespace-lifecycle)
    *   [Deep dive into Codespaces](https://docs.github.com/en/codespaces/about-codespaces/deep-dive)

*   Developing in a codespace
    *   [Develop in a codespace](https://docs.github.com/en/codespaces/developing-in-a-codespace/developing-in-a-codespace)
    *   [Create a codespace for a repo](https://docs.github.com/en/codespaces/developing-in-a-codespace/creating-a-codespace-for-a-repository)
    *   [Create a codespace from a template](https://docs.github.com/en/codespaces/developing-in-a-codespace/creating-a-codespace-from-a-template)
    *   [Delete a codespace](https://docs.github.com/en/codespaces/developing-in-a-codespace/deleting-a-codespace)
    *   [Open an existing codespace](https://docs.github.com/en/codespaces/developing-in-a-codespace/opening-an-existing-codespace)
    *   [Work collaboratively](https://docs.github.com/en/codespaces/developing-in-a-codespace/working-collaboratively-in-a-codespace)
    *   [Source control](https://docs.github.com/en/codespaces/developing-in-a-codespace/using-source-control-in-your-codespace)
    *   [Pull requests](https://docs.github.com/en/codespaces/developing-in-a-codespace/using-github-codespaces-for-pull-requests)
    *   [Stop a codespace](https://docs.github.com/en/codespaces/developing-in-a-codespace/stopping-and-starting-a-codespace)
    *   [Forward ports](https://docs.github.com/en/codespaces/developing-in-a-codespace/forwarding-ports-in-your-codespace)
    *   [Rebuilding a container](https://docs.github.com/en/codespaces/developing-in-a-codespace/rebuilding-the-container-in-a-codespace)
    *   [Default environment variables](https://docs.github.com/en/codespaces/developing-in-a-codespace/default-environment-variables-for-your-codespace)
    *   [Persist variables and files](https://docs.github.com/en/codespaces/developing-in-a-codespace/persisting-environment-variables-and-temporary-files)
    *   [Connecting to a private network](https://docs.github.com/en/codespaces/developing-in-a-codespace/connecting-to-a-private-network)
    *   [Machine learning](https://docs.github.com/en/codespaces/developing-in-a-codespace/getting-started-with-github-codespaces-for-machine-learning)
    *   [Visual Studio Code](https://docs.github.com/en/codespaces/developing-in-a-codespace/using-github-codespaces-in-visual-studio-code)
    *   [GitHub CLI](https://docs.github.com/en/codespaces/developing-in-a-codespace/using-github-codespaces-with-github-cli)

*   Customizing your codespace
    *   [Rename a codespace](https://docs.github.com/en/codespaces/customizing-your-codespace/renaming-a-codespace)
    *   [Change your shell](https://docs.github.com/en/codespaces/customizing-your-codespace/changing-the-shell-in-a-codespace)
    *   [Change the machine type](https://docs.github.com/en/codespaces/customizing-your-codespace/changing-the-machine-type-for-your-codespace)

*   Setting your user preferences
    *   [Personalize your codespaces](https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account)
    *   [Set the default editor](https://docs.github.com/en/codespaces/setting-your-user-preferences/setting-your-default-editor-for-github-codespaces)
    *   [Set the default region](https://docs.github.com/en/codespaces/setting-your-user-preferences/setting-your-default-region-for-github-codespaces)
    *   [Set the timeout](https://docs.github.com/en/codespaces/setting-your-user-preferences/setting-your-timeout-period-for-github-codespaces)
    *   [Configure automatic deletion](https://docs.github.com/en/codespaces/setting-your-user-preferences/configuring-automatic-deletion-of-your-codespaces)
    *   [Choose the host image](https://docs.github.com/en/codespaces/setting-your-user-preferences/choosing-the-stable-or-beta-host-image)

*   Setting up your project
    *   Adding a dev container configuration
        *   [Introduction to dev containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers)
        *   [Setting up a Node.js project](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/setting-up-your-nodejs-project-for-codespaces)
        *   [Setting up a C# (.NET) project](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/setting-up-your-dotnet-project-for-codespaces)
        *   [Setting up a Java project](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/setting-up-your-java-project-for-codespaces)
        *   [Setting up a PHP project](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/setting-up-your-php-project-for-codespaces)
        *   [Setting up a Python project](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/setting-up-your-python-project-for-codespaces)

    *   Configuring dev containers
        *   [Set a minimum machine spec](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/setting-a-minimum-specification-for-codespace-machines)
        *   [Adding features](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/adding-features-to-a-devcontainer-file)
        *   [Automatically opening files](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/automatically-opening-files-in-the-codespaces-for-a-repository)
        *   [Specifying recommended secrets](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/specifying-recommended-secrets-for-a-repository)

    *   Setting up your repository
        *   [Facilitating codespace creation](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/setting-up-your-repository/facilitating-quick-creation-and-resumption-of-codespaces)
        *   [Set up a template repo](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/setting-up-your-repository/setting-up-a-template-repository-for-github-codespaces)

*   Prebuilding your codespaces
    *   [About prebuilds](https://docs.github.com/en/codespaces/prebuilding-your-codespaces/about-github-codespaces-prebuilds)
    *   [Configure prebuilds](https://docs.github.com/en/codespaces/prebuilding-your-codespaces/configuring-prebuilds)
    *   [Allow external repo access](https://docs.github.com/en/codespaces/prebuilding-your-codespaces/allowing-a-prebuild-to-access-other-repositories)
    *   [Manage prebuilds](https://docs.github.com/en/codespaces/prebuilding-your-codespaces/managing-prebuilds)
    *   [Test dev container changes](https://docs.github.com/en/codespaces/prebuilding-your-codespaces/testing-dev-container-changes)

*   Managing your codespaces
    *   [Codespaces secrets](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-your-account-specific-secrets-for-github-codespaces)
    *   [Repository access](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-repository-access-for-your-codespaces)
    *   [Security logs](https://docs.github.com/en/codespaces/managing-your-codespaces/reviewing-your-security-logs-for-github-codespaces)
    *   [GPG verification](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-gpg-verification-for-github-codespaces)

*   Managing your organization
    *   [Enable or disable Codespaces](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/enabling-or-disabling-github-codespaces-for-your-organization)
    *   [Billing and ownership](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/choosing-who-owns-and-pays-for-codespaces-in-your-organization)
    *   [List organization codespaces](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/listing-the-codespaces-in-your-organization)
    *   [Manage Codespaces costs](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/managing-the-cost-of-github-codespaces-in-your-organization)
    *   [Manage secrets](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/managing-development-environment-secrets-for-your-repository-or-organization)
    *   [Audit logs](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/reviewing-your-organizations-audit-logs-for-github-codespaces)
    *   [Restrict machine types](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-access-to-machine-types)
    *   [Restrict codespace creation](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-the-number-of-organization-billed-codespaces-a-user-can-create)
    *   [Restrict base image](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-the-base-image-for-codespaces)
    *   [Restrict port visibility](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-the-visibility-of-forwarded-ports)
    *   [Restrict timeout periods](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-the-idle-timeout-period)
    *   [Restrict the retention period](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-the-retention-period-for-codespaces)

*   Reference
    *   [Access a private registry](https://docs.github.com/en/codespaces/reference/allowing-your-codespace-to-access-a-private-registry)
    *   [Copilot in Codespaces](https://docs.github.com/en/codespaces/reference/using-github-copilot-in-github-codespaces)
    *   [VS Code Command Palette](https://docs.github.com/en/codespaces/reference/using-the-vs-code-command-palette-in-codespaces)
    *   [Security in Codespaces](https://docs.github.com/en/codespaces/reference/security-in-github-codespaces)
    *   [Disaster recovery](https://docs.github.com/en/codespaces/reference/disaster-recovery-for-github-codespaces)

*   Troubleshooting
    *   [Codespaces logs](https://docs.github.com/en/codespaces/troubleshooting/github-codespaces-logs)
    *   [Codespaces clients](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-github-codespaces-clients)
    *   [Included usage](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-included-usage)
    *   [Exporting changes](https://docs.github.com/en/codespaces/troubleshooting/exporting-changes-to-a-branch)
    *   [Creation and deletion](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-creation-and-deletion-of-codespaces)
    *   [Authenticating to repositories](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-authentication-to-a-repository)
    *   [Connection](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-your-connection-to-github-codespaces)
    *   [Codespaces prebuilds](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-prebuilds)
    *   [Personalization](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-personalization-for-codespaces)
    *   [Port forwarding](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-port-forwarding-for-github-codespaces)
    *   [GPG verification](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-gpg-verification-for-github-codespaces)
    *   [Working with support](https://docs.github.com/en/codespaces/troubleshooting/working-with-support-for-github-codespaces)

*   [github.dev editor](https://docs.github.com/en/codespaces/the-githubdev-web-based-editor)
*   [Guides](https://docs.github.com/en/codespaces/guides)

*   [Codespaces](https://docs.github.com/en/codespaces "Codespaces")/
*   [Setting up your project](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces "Setting up your project")/
*   [Configuring dev containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers "Configuring dev containers")/
*   [Adding features](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/adding-features-to-a-devcontainer-file "Adding features")

Adding features to a devcontainer.json file
===========================================

With features, you can quickly add tools, runtimes, or libraries to your dev container configuration.

Tool navigation
---------------

*   [Visual Studio Code](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/adding-features-to-a-devcontainer-file?tool=vscode)
*   [Web browser](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/adding-features-to-a-devcontainer-file?tool=webui)

Features are self-contained units of installation code and dev container configuration, designed to work across a wide range of base container images. You can use features to quickly add tools, runtimes, or libraries to your codespace image. For more information, see the [available features](https://containers.dev/features) and [features specification](https://containers.dev/implementors/features/) on the Development Containers website.

You can add features to a `devcontainer.json` file from VS Code or from your repository on GitHub. Use the tabs in this article to display instructions for each of these ways of adding features.

[Adding features to a `devcontainer.json` file](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/adding-features-to-a-devcontainer-file#adding-features-to-a-devcontainerjson-file)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1.   Navigate to your repository on GitHub, find your `devcontainer.json` file, and click  to edit the file.

If you don't already have a `devcontainer.json` file, you can create one now. For more information, see [Introduction to dev containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers#creating-a-custom-dev-container-configuration).

2.   To the right of the file editor, in the **Marketplace** tab, browse or search for the feature you want to add, then click the name of the feature.

![Image 6: Screenshot of the "Marketplace" tab with "Terra" in the search box and the Terraform feature listed in the search results.](https://docs.github.com/assets/cb-80759/images/help/codespaces/feature-marketplace.png) 
3.   Under "Installation," click the code snippet to copy it to your clipboard, then paste the snippet into the `features` object in your `devcontainer.json` file.

![Image 7: Screenshot of the "Marketplace" tab showing the installation code snippet for Terraform.](https://docs.github.com/assets/cb-159859/images/help/codespaces/feature-installation-code.png) 
```jsonc
"features": {
     // ...
     "ghcr.io/devcontainers/features/terraform:1": {},
     // ...
 }
```
4.   By default, the latest version of the feature will be used. To choose a different version, or configure other options for the feature, expand the properties listed under "Options" to view the available values, then add the options by manually editing the object in your `devcontainer.json` file.

![Image 8: Screenshot of the "Options" section of the "Marketplace" tab, with the "version" and "tflint" properties expanded.](https://docs.github.com/assets/cb-44765/images/help/codespaces/feature-options.png) 
```jsonc
"features": {
     // ...
     "ghcr.io/devcontainers/features/terraform:1": {
         "version": "1.1",
         "tflint": "latest"
     },
     // ...
 }
```
5.   Commit the changes to your `devcontainer.json` file.

The configuration changes will take effect in new codespaces created from the repository. To make the changes take effect in existing codespaces, you will need to pull the updates to the `devcontainer.json` file into your codespace, then rebuild the container for the codespace. For more information, see [Introduction to dev containers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers#applying-configuration-changes-to-a-codespace).

Note

To add features in VS Code while you are working locally, and not connected to a codespace, you must have the "Dev Containers" extension installed and enabled. For more information about this extension, see the [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

1.   Access the VS Code Command Palette with Shift+Command+P (Mac) or Ctrl+Shift+P (Windows/Linux).

2.   Start typing "add dev" then click **Codespaces: Add Dev Container Configuration Files**.

![Image 9: Screenshot of the Command Palette, with "add dev" entered and "Codespaces: Add Dev Container Configuration Files" listed.](https://docs.github.com/assets/cb-12613/images/help/codespaces/add-prebuilt-container-command.png) 
3.   Click **Modify your active configuration**.

4.   Update your feature selections, then click **OK**.

5.   If you're working in a codespace, a prompt will appear in the lower-right corner. To rebuild the container and apply the changes to the codespace you're working in, click **Rebuild Now**.

![Image 10: Screenshot of the message: "We've noticed a change to the dev container configuration." Below this is the "Rebuild Now" button.](https://docs.github.com/assets/cb-21360/images/help/codespaces/rebuild-prompt.png) 

Help and support
----------------

![Image 11: The Copilot Icon in front of an explosion of color.](https://docs.github.com/assets/images/search/copilot-action.png)
Get quick answers!
------------------

Ask Copilot your question.

Ask Copilot

### Did you find what you needed?

Yes No 

[Privacy policy](https://docs.github.com/en/site-policy/privacy-policies/github-privacy-statement)

### Help us make these docs great!

All GitHub docs are open source. See something that's wrong or unclear? Submit a pull request.

[Make a contribution](https://github.com/github/docs/blob/main/content/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/adding-features-to-a-devcontainer-file.md)
[Learn how to contribute](https://docs.github.com/contributing)

### Still need help?

[Provide GitHub Feedback](https://github.com/community/community/discussions/categories/codespaces)

[Contact support](https://support.github.com/)

Legal
-----

*   © 2025 GitHub, Inc.
*   [Terms](https://docs.github.com/en/site-policy/github-terms/github-terms-of-service)
*   [Privacy](https://docs.github.com/en/site-policy/privacy-policies/github-privacy-statement)
*   [Status](https://www.githubstatus.com/)
*   [Pricing](https://github.com/pricing)
*   [Expert services](https://services.github.com/)
*   [Blog](https://github.blog/)
