{{ config(materialized='table') }}

    select
    study_study_id::text as "Study_study_id",
    clinical_data_source_type::text as "clinical_data_source_type"
    from {{ ref('alpha_study_clinical_data_source_type') }}
    