{{ config(materialized='table') }}

    select
    demographics_subject_id::text as "Demographics_subject_id",
    race::text as "race"
    from {{ ref('alpha_demographics_race') }}
    