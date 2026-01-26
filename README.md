## Workflow Overview

This project uses a three-step process for building data transformation pipelines:

1. **Generate Pipeline** — Uses `generate_pipeline` to create dbt models based on study configuration
2. **Import Data** — Uses `import_data` to load study data into the pipeline
3. **Run Models** — Executes `dbt run` to transform the data

The workflow is designed to be repeatable and scalable, allowing you to add new studies without manually modifying existing models.

## Study Configuration Files

Each study requires two key components:

### Study YAML File (`_{study_name}_study.yaml`)
Defines study metadata and table information:
```yaml
study_name: moomoo
description: Moomoo study data
tables:
  - name: condition
    source_dir: condition.csv
  - name: participant
    source_dir: participants.csv
```

## Detailed Workflow with Examples

### Step 1: Generate Pipeline Models

```bash
cd dbt_project

generate_pipeline -sc '_study_data/moomoo/_moomoo_study.yaml' -d '_pipeline_data'
```

This command:
- Reads the study YAML configuration
- Creates source definitions in `models/include/moomoo/`
- Generates staging models that clean and standardize data
- Updates dbt dependencies

### Step 2: Install dbt Dependencies

```bash
dbt deps
```

Downloads any external dbt packages referenced in `packages.yml`.

### Step 3: Import Study Data

```bash
import_data -sc '_study_data/moomoo/_moomoo_study.yaml' -d '_pipeline_data'
```

This command:
- Loads CSV files into the database (DuckDB by default)
- Creates source tables that dbt can reference
- Validates data against data dictionaries

### Step 4: View Generated Models

```bash
dbt show --select include_moomoo_src_condition
```

Displays the results of a specific model to verify the pipeline is working.

## Using the Pipeline

### Adding a New Study

1. **Prepare study data:**
   ```
   _study_data/new_study/
   ├── _new_study_study.yaml
   ├── table1.csv
   ├── table1_dd.csv
   ├── table2.csv
   └── table2_dd.csv
   ```

2. **Run pipeline generation:**
   ```bash
   cd dbt_project
   generate_pipeline -sc '_study_data/new_study/_new_study_study.yaml' -d '_pipeline_data'
   dbt deps
   import_data -sc '_study_data/new_study/_new_study_study.yaml' -d '_pipeline_data'
   ```

3. **Verify with dbt:**
   ```bash
   dbt run
   dbt test
   ```

### Exporting Data

Once models are run, you can:

**View results in DuckDB:**
```bash
harlequin -r "/tmp/dbt.duckdb"
```

**Query specific models:**
```bash
dbt show --select model_name
```

**Export to files:**
Models can be configured to output CSV, Parquet, or other formats.

## Project Model Architecture

### Directory Structure

```
dbt_project/models/
├── include/                 # Study-specific models
│   ├── bleat/              # Bleat study models
│   ├── moomoo/             # Moomoo study models
│   └── docs/               # Documentation
├── access/                 # Access layer (standardized)
│   └── access_alpha/       # Access models for alpha data
└── export/                 # Export models (FHIR, etc.)
    └── fhir_alpha/         # FHIR-compliant export models
```

### Model Layers

- **Include** — Study source definitions and staging models
- **Access** — Standardized, deduplicated views of study data
- **Export** — Final output models (FHIR, flat tables, etc.)

## Advanced Usage

### Running Specific Studies

```bash
# Run only Moomoo study models
dbt run --select include_moomoo.*

# Run only Bleat study models
dbt run --select include_bleat.*
```

### Testing Models

```bash
# Run all tests
dbt test

# Run tests for specific study
dbt test --select include_moomoo.*
```

### Generating Documentation

```bash
# Generate and serve dbt docs
dbt docs generate
dbt docs serve
# Opens browser at http://localhost:8000
```

### Freshness Checks

Monitor when source data was last updated:
```bash
dbt source freshness
```

## Demo

Example walkthrough of the full pipeline:

```bash
# From the repository root run the requirements
pip install -r requirements.txt

# Run dbt commands from the dir containing the dbt_project.yml. 
cd dbt_project

generate_pipeline -sc '_study_data/moomoo/_moomoo_study.yaml' -d '_pipeline_data'

dbt deps

import_data -sc '_study_data/moomoo/_moomoo_study.yaml' -d '_pipeline_data'

dbt show --select include_moomoo_src_condition

# Example dbt run commands were generated in: dbt_project/run_commands/include/moomoo/run_moomoo_20250119.sh. 

# Generate and serve documentation
dbt docs generate && dbt docs serve

# ---------------------------------------------------------

# Once familiar with the pipeline structure try adding another study
generate_pipeline -sc '_study_data/bleat/_bleat_study.yaml' -d '_pipeline_data'

dbt deps

import_data -sc '_study_data/bleat/_bleat_study.yaml' -d '_pipeline_data'

dbt show --select include_bleat_src_condition

# Generate and serve documentation
dbt docs generate && dbt docs serve
```


## Documentation & Resources

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
