{{ config(materialized='table') }}

    select
    study_study_id::text as "Study_study_id",
    study_design::text as "study_design"
    from {{ ref('alpha_study_study_design') }}
    