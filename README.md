# Home

A repository for persistent setup and configuration files in the MacOS home directory.

## Post Installer

The following steps should be taken upon a fresh install of **Sequoia 15.3.1 or later**.

### Installing Git

Install git with the following command:

```bash
brew install git
```

### Cloning The Repository

Navigate to your home directory and initialize a git repository under branch "main":

```bash
cd ~/ && git init -b main
```

Add the remote repository to your home directory:

```bash
git remote add origin https://github.com/seamicole/home-macos.git
```

Pull the remote repository into your home directory:

```bash
git pull origin main --allow-unrelated-histories
```
