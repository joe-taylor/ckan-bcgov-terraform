# CKAN Terraform
This repo exists to automatically set up a local instance of the BC Data Catalogue, which at the time of writing is a combination of stock CKAN 2.7.5 and various custom extensions.  An assumption is made that you are working on the catalogue but with some tweaks it could work for any version of CKAN.

## What does this do?

Assuming your system meets the [requirements](#requirements), running `terraform init && terraform apply -parallelism=1` will accomplish the following:

 1) 3 docker containers are running.
 	- solr
 	- redis
 	- postgres
 2) A database backup from `./db/ckan.dump` is restored into the aforementioned postgres container.
 3) A python2 virtual environment is available and activated in `./src/venv`.
 4) CKAN 2.7.5 and a number of ckan extensions and tools are cloned from github, optionally from a personal fork. Each repository is cloned into `./src` and checked out at whatever branch is specified in the config (`terraform.tfvars`).
 5) These various python packages have been installed into the virtual environment using pip.

CKAN runs directly on your local machine and thus uses your local install of python and pip. As such, you'll need to configure it to match the requirements yourself. CKAN is not started automatically; see instructions below for how to do that.


## Requirements

This procedure assumes you have preinstalled the following. Pay special attention to the version numbers as they are important. An example sequence of actions/commands for OS X is [provided below](#example-setup-instructions-for-os-x-big-sur).

- python 2.7.x
	- pip
	- virtualenv 16.x
- openssl
- terraform v0.11.7. A binary is available for download in the [terraform releases archive](https://www.terraform.io/downloads.html)
- wget
- git
- libmagic c library
- docker

### Example setup instructions for OS X Big Sur

Let's assume you are starting from a totally fresh install of OS X. Python 2.7 is already installed. To install the rest, start by [installing homebrew](https://brew.sh/), and then run the following commands from terminal. Together these will install pip, virtualenv, openssl, wget, git, and libmagic.

    python2 -m ensurepip
    pip2 install virtualenv==16.0.0
    brew install openssl wget git libmagic

Following the above, only terraform and docker remain to be installed. Manually download the 0.11.7 terraform binary from [terraform's archives](https://www.terraform.io/downloads.html) and drop it in your `PATH` accessible location of choice (e.g. `/usr/local/bin`). Next, install [Docker Desktop](https://www.docker.com/products/docker-desktop).


## Usage

1) Copy terraform.tfvars.example to terraform.tfvars.
2) Modify the contents to match your needs.
3) add a db dump file to `./db` called `ckan.dump`.
4) Run `terraform -version` to ensure you're running version 0.11.7, as specified above.
5) Run `terraform init` to initialize all the modules from remote.
6) (OPTIONAL) Run `terraform plan` to see what the command intends to do.
7) Run `terraform apply` and you'll see the same output as step 6 above. Respond yes and let
terraform do it's job.

## Notes about TFVars
- Install path is relative to the root of this directory (the directory of this README file)

## Manual steps
Some files are intentionally omitted from this install process as they are confidential. So follow the steps below
1) source ${path.root}/${local.installPath}/venv/bin/activate;
2) Provide the bcdc_licenses.json file in {installPath}/ckanext-bcgov/ckanext/bcgov/scripts/data/bcdc_licenses.json
3) Then run solr indexing, (See #Solr)
4) If you do not want to be on the master branches for a particular repo you must check it out and
re-run the pip/python install.

## Running
1) Activate the venv `source {installPath}/venv/bin/activate` (Note you should now be able to run paster commands
2) cd into `{installPath}/ckanext-bcgov` (or whatever extension you're working on)
3) Run with `paster serve --reload --reload-interval=2 ../conf/ckan.ini`

## Parallelism Conundrum
There is a problem where if you run terraform apply as normal the venv will not be set up perfectly.
This is due to it installing things into that environment in parallel. There is at present 3 work arounds.
Listed in order of there effectiveness (higher numbers are better)
1) Install the plugins manually (python setup.py develop) for every repo that it fetches
2) Run `terraform apply -parallelism=1` this limits parallelism and solves the problem but takes longer to install the non repos
3) Run `terraform apply` after it finishes nuke the .*.tf files in {installPath} and then run `terraform apply -parallelism=1`

I haven't found a good solution to this via code, but that doesn't mean that one doesn't exist.

## Solr
To index the solr database run `paster --plugin=ckan search-index rebuild -c {installPath}/conf/ckan.ini`

## Datastore
To create the datastore you need to run an additional command.
1) Activate the venv `source {installPath}/venv/bin/activate`
2) `paster --plugin=ckan datastore set-permissions -c conf/ckan.ini | docker exec -i ckan_postgres-.{installPathWithDots} psql -U ckan`

## Datapusher
To run the datapusher
1) Activate the venv `source {installPath}/venv/bin/activate`
2) cd to {installPath}/datapusher
3) python datapusher/main.py deployment/datapusher_settings.py

## Creating a User
1) Activate the venv `source {installPath}/venv/bin/activate` (Note you should now be able to run paster commands
2) `paster --plugin=ckan user add <username> email=<address> -c {installPath}/conf/ckan.ini`
3) (Optional if you want admin privileges) `paster --plugin=ckan sysadmin add <username> email=<address> -c {installPath}/conf/ckan.ini`

## Troubleshooting
Sometimes the terraform execution will fail for one of the repos. When it does this
you will get an error along the lines of
```
1 error(s) occurred:

* module.dev.module.ckanextGaReportRepo.local_file.repo: Error running command...
```

When this happens delete the file in the install path that corresponding file.
In the case above `.ckanext-ga-report.tf` and retry the terraform apply (note it will only do work thats required)

If the postgres container starts and shutdown immediately the permissions on your db folder are probably incorrect.
Make sure that they are global read/writable

## Future enhancements

- Use terraform's loop feature to download repos from a list
- Remove the dependency on a database dump file
- find a solution to the parallelism conundrum

Copyright 2019, Province of British Columbia.
