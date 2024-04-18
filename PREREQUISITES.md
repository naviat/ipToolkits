# Prerequisites

## Compatibility and requirements

- UNIX/Linux or OS X environment
- MongoDB Community v7.0
- NodeJS v20.12.2
- NPM v10.5.0
- Terraform
- kubectl
- kind
- helm

## Installing prerequisites

### MongoDB 7.0

Follow these steps to install MongoDB Community Edition using Homebrew's brew package manager.

#### 1. Tap the MongoDB Homebrew Tap to download the official Homebrew formula for MongoDB and the Database Tools, by running the following command in your macOS Terminal

 ```shell
 brew tap mongodb/brew
 ```

 If you have already done this for a previous installation of MongoDB, you can skip this step.

#### 2. To update Homebrew and all existing formulae

 ```shell
 brew update
 ```

#### 3. To install and start MongoDB, run the following command in your macOS Terminal application

 ```shell
 brew install mongodb-community@7.0
 brew services start mongodb-community@7.0
 ```

### NodeJS & NVM

 Following this [guide](https://tecadmin.net/install-nvm-macos-with-homebrew/)

### Helm, kubectl, terraform

 Following official document.
