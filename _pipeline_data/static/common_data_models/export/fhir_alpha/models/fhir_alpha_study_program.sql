{{ config(materialized='table') }}

    select
    study_study_id::text as "Study_study_id",
    program::text as "program"
    from {{ ref('alpha_study_program') }}
    