This is a dbt sample project for Hive using the TPC-H example dataset and queries.
More details about TPC-H can be found on [TPC Website](https://www.tpc.org/tpch/) and in this [specification document](https://www.tpc.org/TPC_Documents_Current_Versions/pdf/TPC-H_v3.0.1.pdf).

In this project we are using 1GB TPC-H dataset that is present in the Hive warehouse.

## Getting Started
It is recommended to use ```venv``` to create a Python virtual environment for the demo.

### Requirements
* 3.8 <= Python <= 3.11
* dbt-core
* git

### Install

Start by cloning this repo

```
git clone https://github.com/nsharma-25/dbt-tpch-example.git
```



Next install dbt-core and dbt-hive

```
cd dbt-tpch-test
pip install -r requirements.txt
```
Install the required packages mentioned in ```package.yml``` file:

```
dbt deps
```

### Configure

Create a dbt profile in ~/.dbt/profiles.yml

The sample profile looks like this:

```
dbt_tpch_test:
  outputs:
    dev_hive:
      type: hive
      use_http_transport: true
      use_ssl: true
      auth_type: ldap 
      schema: <schema_name>
      threads: 4
      user: <user>
      password: <password>
      host: <hive host name>
      port: 443
      http_path: cliservice
  target: dev_hive

```
Test the profile with ```dbt debug```


### Using dbt

**dbt seed**

To load the data present in the seeds folder, run

```
dbt seed
```

22 files are present in the Seeds folder, where each file conatins the expected output of the tpch queries.

Everytime to you make a change in seed data, you must run ```dbt seed```  again to update it. You can also run the dbt seed command with the ```--select``` flag like

```
dbt seed --select <seed-name>
```

**dbt run**

There are 3 sets of models in this project. Each set of models contain their own ```schema.yml``` file

* Firstly, we have ```raw```. Our raw models make use of [Sources](https://docs.getdbt.com/docs/build/sources). This is data that already exists in our database that dbt needs to refer to. 

  Our raw models are defined in ```dbt_tpch_test/models/raw/```.

* Next, we have ```staging```. These are [Models](https://docs.getdbt.com/docs/build/sql-models). Our staging models use the ```source()``` method to refer to the Sources we defined in our raw models. The staging models are intermediate models created over our raw data to  rename the columns. The staging models have been materialized as tables.

  Our 7 staging models are defined in ```dbt_tpch_test/models/staging/```

* Lastly, we have ```tpch_queries```. These are [Models](https://docs.getdbt.com/docs/build/sql-models) that use the ```ref()``` method to refer to the staging models. These are the models based on the standard tpch_queries and have been materialized as View.

  Our  22 ```tpch_queries``` models are present in the ```models/tpch_queries.

Run the models with

```
dbt run  
```
Running a specifc model

```
dbt run --select <model-name>
```
**dbt test**

Our project has been configured with a couple of tests. As of this project, we are using a package called [dbt-utils](https://github.com/dbt-labs/dbt-utils). Macros for the custom tests can also be added to the ```dbt_tpch_test/macros/``` folder. More info about tests can be found [here](https://docs.getdbt.com/docs/build/data-tests).

Few tests that has been included in this project are checking the column values to be unique, not null and also comparing the equality of models in this case the equality of actual output tables and the expected output tables (which have been included in the ```dbt_tpch_test/seeds/expected``` folder).

These tests can be mentioned in the schema of the models.
Specific test can be run with ```--select``` flag, like

```
dbt test --select <test-name>
``````

Example:

tpch_queries_schema.yml
  ```
  models:
  - name: tpch_q01
    tests:
      - dbt_utils.equality:
          compare_model: ref('q01_output')
  ```        
stg_tpch_schema.yml

```
models:
  - name: stg_tpch_customer
    columns:
      - name: customer_key
        tests:
          - unique
          - not_null
```          
**Run the models again**

To get the latest data into our mart model, we must run the models again.

Run the models again with
```
dbt run
```
### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices



