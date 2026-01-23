{{ config(materialized='table') }}

    select
    study_study_id::text as "Study_study_id",
    external_id::text as "external_id"
    from {{ ref('alpha_study_external_id') }}
    