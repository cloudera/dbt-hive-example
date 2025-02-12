# Contributing to `dbt_tpch_test`

1. [About this document](#about-this-document)
2. [Getting the code](#getting-the-code)
3. [Setting up Python and virtual environment](#setting-up-python-and-virtual-environment)
4. [Data generation with TPC-H data generation tool](#data-generation-with-tpc-h-data-generation-tool)
4. [Submitting a Pull Request](#submitting-a-pull-request)

## About this document
This document is a guide for anyone interested in contributing to this repository. It outlines how to create issues and submit pull requests (PRs).

We assume users have a Linux or MacOS system. You should have familiarity with:

- Python `virturalenv`
- Python modules
- `pip`
- common command line utilities like `git`.

## Getting the code

 `git` is needed in order to download and modify the `dbt_tpch_test` code. There are several ways to install Git. For MacOS, we suggest installing [Xcode](https://developer.apple.com/support/xcode/) or [Xcode Command Line Tools](https://mac.install.guide/commandlinetools/index.html).

### External contributors

If you are not a member of the `Cloudera` GitHub organization, you can contribute to `dbt_tpch_test` by forking the repository. For more on forking, check out the [GitHub docs on forking](https://help.github.com/en/articles/fork-a-repo). In short, you will need to:

1. fork the `dbt-hive-example` repository
2. clone your fork locally
3. check out a new branch for your proposed changes
4. push changes to your fork
5. open a pull request of your forked repository against `cloudera/dbt-hive-example`

### Cloudera contributors

If you are a member of the `Cloudera` GitHub organization, you will have push access to the `dbt_tpch_test` repo. Rather than forking `dbt-hive-example` to make your changes, clone the repository like normal, and check out feature branches.

## Setting up Python and virtual environment
To install ```python``` and ```virtualenv```  run this command:
```
brew install python@3.11 virtualenv
```
Now create a virtual environment with ```python3.11``` in the folder called ```venv```
```
virtualenv venv --python=python3.11
````
Activate the virtual environment:
```
. venv/bin/activate 
```
## Installing requirements and packages

Install dbt-core and dbt-hive
```
pip install -r requirements.txt
```
Install the required packages mentioned in ```package.yml``` file:
```
dbt deps
```
## Data generation with TPC-H data generation tool
In this project we have used 1GB TPC-H sample data. TPC-H is a decision support benchmark (Decision Support Benchmark), which consists of a set of business-oriented special query and concurrent data modification. This sample data has been then loaded in Hive data warehouse, so that we can utilise it in our project.

Below are the steps to  generate tpch sample data:
* Download the TPC-H tools zip file from [here](https://tpc.org/tpc_documents_current_versions/current_specifications5.asp).
* Extract the zip file to a location on your system.
* Change to the dbgen directory and make a copy of the makefile template.
```
 cd TPC-H\ V3.0.1/dbgen 
 cp makefile.suite makefile
```
* Configure the following settings in the makefile:
```
CC = gcc
DATABASE = SQLSERVER
MACHINE=LINUX
WORKLOAD = TPCH
```
* Run make to build the dbgen utility:
```
make
```
* Use the following ```dbgen``` command to generate a 1GB set of data files for the tpch database:
```
 ./dbgen -s 1  
```
After this, run ```ls -1 *.tbl ``` to see the data files that appear in the working directory, one for each table in the tpch database
Output:
```
customer.tbl
lineitem.tbl
nation.tbl
orders.tbl
part.tbl
partsupp.tbl
region.tbl
supplier.tbl
```
## Submitting a Pull Request

A `dbt-hive-example` maintainer will review your PR and will determine if it has passed regression tests. They may suggest code revisions for style and clarity, or they may request that you add unit or functional tests. These are good things! We believe that, with a little bit of help, anyone can contribute high-quality code.

Once all tests are passing and your PR has been approved, a `dbt-hive-example` maintainer will merge your changes into the active development branch. And that's it! Happy developing :tada:




