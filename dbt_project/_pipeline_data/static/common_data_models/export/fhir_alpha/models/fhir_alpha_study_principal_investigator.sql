{{ config(materialized='table') }}

    select
    study_study_id::text as "Study_study_id",
    principal_investigator_id::integer as "principal_investigator_id"
    from {{ ref('alpha_study_principal_investigator') }}
    