Terraform MongoDB Atlas AWS PrivateLink
=======================================

[![CircleCI](https://circleci.com/gh/infrablocks/terraform-mongodbatlas-cluster.svg?style=svg)](https://circleci.com/gh/infrablocks/terraform-mongodbatlas-cluster)

A Terraform module for creating an AWS PrivateLink endpoint for MongoDB Atlas.

The AWS PrivateLink endpoint requires:
* An existing project within a MongoDB organisation
* An existing VPC in AWS

The AWS PrivateLink endpoint consists of:
* TODO

Usage
-----

To use the module, include something like the following in your terraform 
configuration:

```hcl-terraform
module "mongodbatlas_aws_privatelink" {
  source  = "infrablocks/aws-privatelink/mongodbatlas"
  version = "0.1.0"
}
```

As mentioned above, the privatelink applies to an existing project. 
Whilst the project can be created using any mechanism you like, the 
[MongoDB Atlas Project](https://github.com/infrablocks/terraform-mongodbatlas-project)
module will create everything you need. See the 
[docs](https://github.com/infrablocks/terraform-mongodbatlas-project/blob/master/README.md)
for usage instructions.

### Inputs

| Name                             | Description                                                                   | Default             | Required                             |
|----------------------------------|-------------------------------------------------------------------------------|:-------------------:|:------------------------------------:|


### Outputs

| Name                                    | Description                                               |
|-----------------------------------------|-----------------------------------------------------------|


Development
-----------

### Machine Requirements

In order for the build to run correctly, a few tools will need to be installed 
on your development machine:

* Ruby (2.3.1)
* Bundler
* git
* git-crypt
* gnupg
* direnv

#### Mac OS X Setup

Installing the required tools is best managed by [homebrew](http://brew.sh).

To install homebrew:

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Then, to install the required tools:

```
# ruby
brew install rbenv
brew install ruby-build
echo 'eval "$(rbenv init - bash)"' >> ~/.bash_profile
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
eval "$(rbenv init -)"
rbenv install 2.3.1
rbenv rehash
rbenv local 2.3.1
gem install bundler

# git, git-crypt, gnupg
brew install git
brew install git-crypt
brew install gnupg

# direnv
brew install direnv
echo "$(direnv hook bash)" >> ~/.bash_profile
echo "$(direnv hook zsh)" >> ~/.zshrc
eval "$(direnv hook $SHELL)"

direnv allow <repository-directory>
```

### Running the build

To provision module infrastructure, run tests and then destroy that 
infrastructure, execute:

```bash
./go
```

To provision the module contents:

```bash
./go deployment:harness:provision[<deployment_identifier>]
```

To destroy the module contents:

```bash
./go deployment:harness:destroy[<deployment_identifier>]
```

### Common Tasks

#### Generating an SSH key pair

To generate an SSH key pair:

```
ssh-keygen -t rsa -b 4096 -C integration-test@example.com -N '' -f config/secrets/keys/bastion/ssh
```

#### Managing CircleCI keys

To encrypt a GPG key for use by CircleCI:

```bash
openssl aes-256-cbc \
  -e \
  -md sha1 \
  -in ./config/secrets/ci/gpg.private \
  -out ./.circleci/gpg.private.enc \
  -k "<passphrase>"
```

To check decryption is working correctly:

```bash
openssl aes-256-cbc \
  -d \
  -md sha1 \
  -in ./.circleci/gpg.private.enc \
  -k "<passphrase>"
```

Contributing
------------

Bug reports and pull requests are welcome on GitHub at 
https://github.com/infrablocks/terraform-mongodbatlas-aws-privatelink. 
This project is intended to be a safe, welcoming space for collaboration, and 
contributors are expected to adhere to the 
[Contributor Covenant](http://contributor-covenant.org) code of conduct.


License
-------

The library is available as open source under the terms of the 
[MIT License](http://opensource.org/licenses/MIT).
