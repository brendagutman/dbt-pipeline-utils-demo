# dbt-pipeline-utils-demo
The purpose of this repo is to allow for dbt_pipeline_utils(alias 'pipeline utils') users to familiarize themselves with the package before use within a dbt pipeline. 

## Workflow Overview

This project uses a three-step process for building data transformation pipelines:

1. **Generate Pipeline** — Uses `generate_pipeline` to create dbt models based on study configuration
2. **Import Data** — Uses `import_data` to load study data into the pipeline
3. **Run Models** — Executes `dbt run` to transform the data

The workflow is designed to be repeatable and scalable, allowing you to add new studies without manually modifying existing models.

## Study Configuration Files
<!-- TODO add data/example_data -->


## Detailed Workflow

### Step 1: Generate Pipeline Models
    - Uses the study config file, and others(…. if something isn’t right ask a teammate), to generate all documents needed for the study, in the correct file locations defined for the organization.  
    - Rerun the utils generation if needed. Many docs files are generated with the utils. These can be HARD to keep up with if not generating them programmatically. If one of the data dictionaries has an error, fix the data dictionary, and rerun the generation script. The **generation script will not overwrite files** in most cases so as to not remove any major work(sql files especially) if you need these regenerated, delete the files manually before re-Running the generation script.

```bash
cd dbt_project

# generate_pipeline -sc {study config path} -d {pipeline data path}
generate_pipeline -sc '_study_data/moomoo/_moomoo_study.yaml' -d '_pipeline_data'
```


### Step 2: Install dbt Dependencies
Downloads any external dbt packages referenced in `packages.yml`.

```bash
dbt deps
```

### Step 3: Import Study Data
This command:
- Loads CSV files into the database (DuckDB is used in this demo)
- Creates source tables that dbt can reference

```bash
# import_data -sc {study config path} -d {pipeline data path}
import_data -sc '_study_data/moomoo/_moomoo_study.yaml' -d '_pipeline_data'
```


### Step 4: View Generated Models
Displays the results of a specific model to verify the pipeline is working.

```bash
dbt show --select include_moomoo_src_condition
```


### Step 5: Generating Documentation

```bash
# Generate and serve dbt docs
dbt docs generate
dbt docs serve
# Opens browser at http://localhost:8000
```

### Step 6: Add an additional study
Repeat steps 1-5 for the `gregor_synthetic` study.


## Project Model Architecture

## Project Structure

```
.
├── _study_data/                           # Study-specific data files
│   ├── gregor_synthetic/                  # gregor_synthetic study data
│   │   ├── _gregor_synthetic_study.yaml   # Study configuration
│   │   ├── condition.csv                  # Study data
│   │   ├── condition_dd.csv               # Data dictionary
│   │   ├── participants.csv               # Study data
│   │   └── participants_dd.csv            # Data dictionary
│   └── moomoo/               # Moomoo study data
│       ├── _moomoo_study.yaml
│       ├── condition.csv
│       ├── condition_dd.csv
│       ├── participants.csv
│       └── participants_dd.csv
├── _pipeline_data/           # Pipeline-specific configuration and templates
│   └── static/               # Static data models and configurations
│       └── common_data_models/
│           ├── additions_template.csv
│           ├── export/       # Export model templates
│           └── internal/     # Internal data models
├── dbt_project/              # Main dbt project directory
│   ├── models/               # dbt models
│   │   ├── include/          # Study-specific models (auto-generated)
│   │   │   ├── gregor_synthetic/
│   │   │   ├── moomoo/
│   │   │   └── docs/
│   │   ├── access/           # Access layer models
│   │   └── export/           # Export models (FHIR, etc.)
│   ├── macros/               # dbt macros and utilities
│   ├── seeds/                # Seed data files
│   ├── tests/                # dbt tests
│   ├── run_commands/         # Generated run scripts by study
│   └── dbt_project.yml       # dbt project configuration (auto-generated)
├── logs/                     # Log files from pipeline runs
├── requirements.txt          # Python dependencies
└── README.md                 
```



### Development Tools

- [Harlequin](https://harlequin.sh/) — SQL IDE for interactive DuckDB querying
  ```bash
  # Once setup, run this command to query via the terminal
  harlequin -r "/tmp/dbt.duckdb"
  ```

- [dbt-pipeline-utils GitHub](https://github.com/NIH-NCPI/pipeline-utils) — Main utilities repository
```bash
# Uninstall and reinstall the utils if necessary.
pip uninstall dbt_pipeline_utils 
pip install --no-cache-dir "dbt_pipeline_utils @ git+https://github.com/NIH-NCPI/pipeline-utils.git@bg/refactor_test_utils"
```

### dbt Resources
- [dbt Documentation](https://docs.getdbt.com/docs/introduction) — Learn dbt fundamentals
- [dbt Discourse](https://discourse.getdbt.com/) — Common questions and answers
- [dbt Community Slack](https://community.getdbt.com/) — Real-time discussions and support
- [dbt Events](https://events.getdbt.com) — Webinars and conferences
- [dbt Blog](https://blog.getdbt.com/) — Best practices and updates


### Starting a dbt pipeline repo from scratch. Steps to set up this demo. 
- Create and pull down a new GitHub repo
- Run `dbt init` in the terminal - name the project 'dbt_project'
- Create a data dir for study specific data. Demo purposes - demo_project/_study_data
- Gather study data and store locally.
- Create a data dir for pipeline specific data. Demo purposes - demo_project/_pipeline_data
- Gather pipeline specific data and store locally.
- Add gitignore
- delete root dbt_project.yml to be regenerated by the utils
- Add and run requirements.txt
