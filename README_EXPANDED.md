# dbt-pipeline-utils-demo

A comprehensive demonstration repository showcasing how to use **dbt** (data build tool) with the **pipeline-utils** library to create scalable, multi-study data transformation pipelines. This project illustrates best practices for organizing study data, automating model generation, and building FHIR-compliant exportable data.

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Workflow Overview](#workflow-overview)
- [Study Configuration](#study-configuration)
- [Detailed Workflow](#detailed-workflow)
- [Project Architecture](#project-architecture)
- [From Scratch Setup](#from-scratch-setup)
- [Configuration](#configuration)
- [Advanced Usage](#advanced-usage)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)
- [FHIR Export](#fhir-export)
- [Resources](#resources)

## Overview

This demo project illustrates:
- Setting up a dbt project for data pipeline orchestration
- Organizing study-specific and pipeline-specific data
- Using `dbt-pipeline-utils` to automatically generate and manage dbt models
- Building multi-study data pipelines with shared transformation logic
- Creating standardized data exports (Example: FHIR format)
- Scaling to multiple studies with minimal code duplication

## Project Structure

```
.
├── _study_data/              # Study-specific data files
│   ├── bleat/                # Bleat study data
│   │   ├── _bleat_study.yaml # Study configuration
│   │   ├── condition.csv      # Study data
│   │   ├── condition_dd.csv   # Data dictionary
│   │   ├── participants.csv   # Study data
│   │   └── participants_dd.csv# Data dictionary
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
│   │   │   ├── bleat/
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

## Quick Start

### Prerequisites
- Python 3.12+
- pip (Python package manager)
- Basic familiarity with dbt and SQL

### 1. Clone & Setup

```bash
git clone <repo-url>
cd dbt-pipeline-utils-demo
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 2. Run the Demo Pipeline

```bash
# Run dbt commands and the dbt_pipeline_utils commands from the dir containting dbt_project.yaml
cd dbt_project

# Generate pipeline models for Moomoo study
generate_pipeline -sc '_study_data/moomoo/_moomoo_study.yaml' -d '_pipeline_data'

# Install dbt dependencies
dbt deps

# Import data into the database
import_data -sc '_study_data/moomoo/_moomoo_study.yaml' -d '_pipeline_data'

# View results
dbt show --select include_moomoo_src_condition

# Generate and view documentation
dbt docs generate && dbt docs serve
```


Read this and give it a lift. quickly.
do your pdq
use the utils in the sandbox. and harmonize aadsc locally

see if Josh thinks the demo looks good.











## Workflow Overview

This project uses a four-step process for building data transformation pipelines:

1. **Generate Pipeline** — Uses `generate_pipeline` to create dbt models based on study configuration
2. **Install Dependencies** — Uses `dbt deps` to download external packages
3. **Import Data** — Uses `import_data` to load study data into the database
4. **Run Models** — Executes `dbt run` to transform the data

The workflow is designed to be repeatable and scalable, allowing you to add new studies without manually modifying existing models.

### Key Benefits

- **Automated Model Generation** — No need to manually write SQL for every study
- **Scalability** — Add new studies by providing YAML config + CSV files
- **Consistency** — All studies follow the same transformation patterns
- **Flexibility** — Customize transformations through YAML and macros
- **Documentation** — Auto-generates lineage and documentation

## Study Configuration

Each study requires two key components:

### Study YAML File (`_{study_name}_study.yaml`)

Defines study metadata and table information:

```yaml
study_name: moomoo
description: Moomoo study data - participant health records
tables:
  - name: condition
    source_dir: condition.csv
    description: Clinical conditions reported for participants
  - name: participant
    source_dir: participants.csv
    description: Basic participant demographic information
```

### Study Data Files

**Data Files** (`.csv`)
- Raw study data in CSV format
- First row contains column headers
- Example: `condition.csv`, `participants.csv`

**Data Dictionaries** (`*_dd.csv`)
- Describes each column in the data files
- Columns: `column_name`, `data_type`, `description`, etc.
- Enables automated validation and documentation
- Example: `condition_dd.csv`, `participants_dd.csv`

### Example Data Dictionary Format

```csv
column_name,data_type,description,required
participant_id,string,Unique identifier for participant,true
condition_name,string,Name of medical condition,true
onset_date,date,Date condition was diagnosed,false
status,string,Current status of condition,true
```

## Detailed Workflow

### Step 1: Generate Pipeline Models

```bash
cd dbt_project

generate_pipeline -sc '_study_data/moomoo/_moomoo_study.yaml' -d '_pipeline_data'
```

**What this command does:**
- Reads the study YAML configuration from `_study_data/moomoo/_moomoo_study.yaml`
- Accesses pipeline templates in `_pipeline_data/`
- Creates source definitions in `models/include/moomoo/sources.yml`
- Generates staging models in `models/include/moomoo/models/`
- These models clean, validate, and standardize the raw data
- Updates `dbt_project.yml` with study-specific configurations

**Generated files include:**
- `models/include/moomoo/sources.yml` — Defines raw data sources
- `models/include/moomoo/models/stg_moomoo_*.sql` — Staging models
- `models/include/moomoo/docs/` — Model documentation

### Step 2: Install dbt Dependencies

```bash
dbt deps
```

**What this command does:**
- Downloads any dbt packages referenced in `packages.yml`
- Installs external macros and custom tests
- Sets up the dbt working environment

### Step 3: Import Study Data

```bash
import_data -sc '_study_data/moomoo/_moomoo_study.yaml' -d '_pipeline_data'
```

**What this command does:**
- Reads CSV files from the study directory
- Loads data into DuckDB (or configured database)
- Creates raw source tables that dbt references
- Validates data against data dictionaries
- Generates validation reports
- Creates `seeds/` files for version control (optional)

### Step 4: Run Models and View Results

```bash
# Run all models
dbt run

# View specific model results
dbt show --select include_moomoo_src_condition

# Run only Moomoo models
dbt run --select include_moomoo.*
```

## Project Architecture

### Model Layers

The project uses a layered architecture for data transformation:

```
Raw Data (CSV files)
    ↓
[Import Data]
    ↓
Source Tables (in database)
    ↓
[Generate Pipeline + dbt run]
    ↓
Staging Models (stg_*)
    ↓
Access Layer (standardized views)
    ↓
Export Models (FHIR, marts)
    ↓
Final Output (CSV, JSON, database views)
```

### Model Organization

```
dbt_project/models/
├── include/                 # Study-specific models (auto-generated)
│   ├── bleat/
│   │   ├── sources.yml      # Source definitions for Bleat
│   │   ├── docs/            # Documentation
│   │   └── models/          # Staging and transformation models
│   │       ├── stg_bleat_condition.sql
│   │       ├── stg_bleat_participant.sql
│   │       └── ...
│   ├── moomoo/
│   │   └── ...
│   └── docs/                # Shared documentation
├── access/                  # Standardized access layer
│   └── access_alpha/
│       └── models/
│           ├── access_demographics.sql
│           ├── access_condition.sql
│           └── ...
└── export/                  # Final export models
    └── fhir_alpha/
        └── models/
            ├── fhir_patient.sql
            ├── fhir_condition.sql
            ├── fhir_observation.sql
            └── ...
```

## From Scratch Setup

To create a new dbt pipeline project from scratch:

### 1. Initialize Repository

```bash
git init dbt-pipeline-project
cd dbt-pipeline-project
git branch -M main
```

### 2. Create dbt Project

```bash
dbt init dbt_project
```

When prompted:
- Select `dbt-duckdb` as the adapter (recommended for demo)
- Use default settings for other prompts

### 3. Create Data Directories

```bash
mkdir -p _study_data
mkdir -p _pipeline_data/static/common_data_models
```

### 4. Add Study Data

Create study directory structure:

```bash
mkdir -p _study_data/mystudyname
```

Add files:
```
_study_data/mystudyname/
├── _mystudyname_study.yaml
├── table1.csv
├── table1_dd.csv
├── table2.csv
└── table2_dd.csv
```

### 5. Create requirements.txt

```bash
# Python 3.12
dbt-core==1.9.4
dbt-duckdb==1.9.3
pandas==2.2.3
dbt_pipeline_utils @ git+https://github.com/NIH-NCPI/pipeline-utils.git@bg/refactor_test_utils
search_dragon @ git+https://github.com/NIH-NCPI/search-dragon.git
```

### 6. Install Dependencies

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 7. Configure dbt

Inside `dbt_project/`:
- Remove `models/example/` directory
- Delete `dbt_project.yml` (will be auto-generated)
- Create `.gitignore`:

```
# Ignore generated files
dbt.duckdb
target/
logs/
```

### 8. Run Pipeline Generation

```bash
cd dbt_project
generate_pipeline -sc '../_study_data/mystudyname/_mystudyname_study.yaml' -d '../_pipeline_data'
dbt deps
import_data -sc '../_study_data/mystudyname/_mystudyname_study.yaml' -d '../_pipeline_data'
dbt run
dbt docs generate && dbt docs serve
```

## Configuration

### DuckDB Configuration

By default, dbt uses an in-memory DuckDB database. To persist data:

**In `dbt_project.yml` or `profiles.yml`:**

```yaml
config-version: 2

profile: 'default'

model-paths: ['models']
analysis-paths: ['analyses']
test-paths: ['tests']
data-paths: ['data']
macro-paths: ['macros']
snapshot-paths: ['snapshots']
seed-paths: ['seeds']

target-path: 'target'
clean-targets:
  - 'target'
  - 'dbt_packages'

models:
  dbt_pipeline_utils_demo:
    +materialized: view

# DuckDB specific settings
profiles:
  default:
    target: dev
    outputs:
      dev:
        type: duckdb
        path: 'dbt.duckdb'  # Persisted database file
        threads: 4
        timeout_seconds: 300
```

### Database Adapter Settings

**Available adapters:**
- **dbt-duckdb** (default) — In-memory/file-based SQL engine
- **dbt-postgres** — PostgreSQL connection

**To use PostgreSQL:**

```yaml
profiles:
  default:
    target: dev
    outputs:
      dev:
        type: postgres
        host: localhost
        user: postgres
        password: password
        port: 5432
        dbname: dbt_db
        schema: public
        threads: 4
```

## Advanced Usage

### Running Specific Studies

```bash
# Run only Moomoo study models
dbt run --select include_moomoo.*

# Run only Bleat study models
dbt run --select include_bleat.*

# Run a specific model
dbt run --select include_moomoo_src_condition
```

### Testing Models

```bash
# Run all tests
dbt test

# Run tests for specific study
dbt test --select include_moomoo.*

# Run specific test file
dbt test --select models/include/moomoo/tests/test_*.sql
```

### Generating Documentation

```bash
# Generate dbt documentation
dbt docs generate

# Serve docs locally (opens browser)
dbt docs serve
# Visit http://localhost:8000

# Export docs to static HTML
dbt docs generate --static
```

### Freshness Checks

Monitor when source data was last updated:

```bash
# Check source freshness
dbt source freshness

# Check specific source
dbt source freshness --select include_moomoo_src
```

### Snapshot Models

Track changes over time:

```bash
dbt snapshot
```

### Lineage Analysis

View model dependencies:

```bash
# View DAG (Directed Acyclic Graph)
dbt docs generate
# Click "DAG" in the web UI

# Export DAG as JSON
dbt run-operation generate_manifest
```

### Incremental Models

For large datasets, use incremental models:

```sql
{{
  config(
    materialized='incremental',
    unique_key='participant_id',
  )
}}

select * from {{ source('moomoo', 'condition') }}

{% if execute %}
  and date_created > (select max(date_created) from {{ this }})
{% endif %}
```

## Troubleshooting

### Common Issues & Solutions

**Issue: `generate_pipeline` command not found**

```bash
# Verify installation
which generate_pipeline

# Reinstall pipeline-utils
pip uninstall dbt_pipeline_utils -y
pip install --no-cache-dir "dbt_pipeline_utils @ git+https://github.com/NIH-NCPI/pipeline-utils.git@bg/refactor_test_utils"

# Verify again
generate_pipeline --help
```

**Issue: `dbt parse` fails with missing YAML files**

```bash
# Check for syntax errors
dbt parse --debug

# Verify study YAML format
cat _study_data/moomoo/_moomoo_study.yaml

# Ensure file paths are relative to study directory
```

**Issue: Model tests fail**

```bash
# Run with debug output
dbt test --debug

# Test specific model
dbt test --select model_name

# View test details
cat target/run_results.json
```

**Issue: DuckDB database is locked**

```bash
# Close any open connections
# Remove corrupted database
rm dbt.duckdb

# Run again (creates new database)
dbt run
```

**Issue: Out of memory with large datasets**

```bash
# Increase DuckDB memory
# In dbt_project.yml, add:
# threads: 4
# timeout_seconds: 600

# Or process in batches:
# Add filter in source definition to limit initial load
```

**Issue: `import_data` fails**

```bash
# Check file paths
ls -la _study_data/mystudyname/

# Verify CSV format
head -5 _study_data/mystudyname/*.csv

# Check data dictionary
head -5 _study_data/mystudyname/*_dd.csv

# Run with verbose output
import_data -sc '_study_data/mystudyname/_mystudyname_study.yaml' -d '_pipeline_data' -v
```

### Performance Optimization

```bash
# Run models in parallel (faster)
dbt run --threads 8

# Enable full refresh (rebuild from scratch)
dbt run --full-refresh

# Run specific model and dependencies
dbt run --select +model_name+

# Run specific model and downstream
dbt run --select model_name+

# Skip materialization changes
dbt run --defer --state ./target
```

### Debugging Techniques

**Enable debug mode:**
```bash
dbt run --debug
dbt test --debug
dbt parse --debug
```

**View compiled SQL:**
```bash
cat target/compiled/dbt_pipeline_utils_demo/models/include/moomoo/models/stg_moomoo_condition.sql
```

**Profile dbt performance:**
```bash
# View execution metrics
cat target/run_results.json | python -m json.tool

# Check build time
dbt run --profiles-dir . 2>&1 | grep "Completed successfully"
```

**View model lineage:**
```bash
# Query manifest
python3 << 'EOF'
import json
with open('target/manifest.json') as f:
    manifest = json.load(f)
    for node_id, node in manifest['nodes'].items():
        if 'moomoo' in node_id:
            print(f"{node['name']}: depends on {node['depends_on']}")
EOF
```

## Best Practices

### 1. Version Control

- **Commit:** Study YAML configs, data dictionaries, custom macros, tests
- **Ignore:** Database files, compiled SQL, target/ directory
- **Track:** `requirements.txt` for reproducibility

```bash
# .gitignore
dbt.duckdb
target/
logs/
dbt_packages/
.DS_Store
*.pyc
__pycache__/
```

### 2. Model Development

- Start with **source definitions** (raw data references)
- Add **staging models** for cleaning and validation
- Create **access layer** for standardized views
- Build **export models** for final outputs
- Document all models with YAML descriptions

```yaml
# Example model YAML
models:
  - name: stg_moomoo_condition
    description: Cleaned condition records from Moomoo study
    columns:
      - name: participant_id
        description: Unique participant identifier
        tests:
          - not_null
          - unique
```

### 3. Testing Strategy

- **Null tests:** Check for required fields
- **Unique tests:** Validate primary keys
- **Referential integrity:** Cross-table relationships
- **Data quality:** Custom validation rules

```yaml
# Example tests
tests:
  - name: unique_participant_id
    models: [stg_moomoo_condition]
    columns: [participant_id]
    
  - name: not_null_participant_id
    models: [stg_moomoo_condition]
    columns: [participant_id]
```

### 4. Documentation

- **Model descriptions:** What does this model do?
- **Column lineage:** Where does each column come from?
- **Dependencies:** Which models feed into this?
- **Transformations:** What SQL transformations occur?

### 5. Performance

- **Index frequently filtered columns**
- **Materialize frequently used models** (vs views)
- **Partition large datasets** by time period
- **Monitor query execution times**

```sql
-- Example materialized model
{{
  config(
    materialized='table',
  )
}}

select * from {{ ref('stg_moomoo_condition') }}
```

## FHIR Export

This project includes FHIR-compliant export models that transform study data into standardized health data formats.

### Available FHIR Resources

Located in `models/export/fhir_alpha/`:

- **Patient** — Demographics and participant information
- **Condition** — Clinical conditions
- **Observation** — Measurements and observations
- **ResearchStudy** — Study information
- **ResearchSubject** — Participant enrollment

### Example FHIR Export

```bash
# Run FHIR export models
dbt run --select export.fhir_alpha.*

# View FHIR patient records
dbt show --select export.fhir_alpha.fhir_patient

# Export to JSON
dbt run-operation export_to_json --args '{table: fhir_patient}'
```

### FHIR Validation

The models validate data against FHIR specifications:
- Required fields are populated
- Codes match FHIR value sets
- Dates are in ISO 8601 format
- References are valid

## Resources & Support

### dbt Official Resources

- [dbt Documentation](https://docs.getdbt.com/docs/introduction) — Learn dbt fundamentals
- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices) — Industry standards
- [dbt Discourse](https://discourse.getdbt.com/) — Q&A community
- [dbt Community Slack](https://community.getdbt.com/) — Real-time chat
- [dbt Events](https://events.getdbt.com) — Webinars and conferences
- [dbt Blog](https://blog.getdbt.com/) — Latest updates and case studies

### Development Tools

- [Harlequin](https://harlequin.sh/) — SQL IDE for interactive queries
  ```bash
  harlequin -r "/tmp/dbt.duckdb"
  ```

- [dbt-pipeline-utils](https://github.com/NIH-NCPI/pipeline-utils) — Automated model generation
  - GitHub: https://github.com/NIH-NCPI/pipeline-utils
  - Updates: `pip install --upgrade --no-cache-dir "dbt_pipeline_utils @ git+..."`

- [search-dragon](https://github.com/NIH-NCPI/search-dragon) — Search utilities
  - GitHub: https://github.com/NIH-NCPI/search-dragon

### Learning Resources

- [dbt Fundamentals Course](https://learn.getdbt.com/) — Free interactive course
- [Analytics Engineering Guide](https://www.getdbt.com/what-is-analytics-engineering/) — Methodology
- [SQL Style Guide](https://docs.getdbt.com/reference/resources/sql-conventions) — Best practices

## Next Steps

1. Run through the [Quick Start](#quick-start) section
2. Add your own study using the [From Scratch Setup](#from-scratch-setup) guide
3. Review [Project Architecture](#project-architecture) to understand model layers
4. Implement tests and documentation following [Best Practices](#best-practices)
5. Explore [FHIR Export](#fhir-export) for standardized data output

## License

This project is provided as a demonstration of dbt and pipeline-utils capabilities.

---

**Last Updated:** January 2026  
**dbt Version:** 1.9.4  
**Python Version:** 3.12+  
**Tested Adapters:** dbt-duckdb (v1.9.3)
