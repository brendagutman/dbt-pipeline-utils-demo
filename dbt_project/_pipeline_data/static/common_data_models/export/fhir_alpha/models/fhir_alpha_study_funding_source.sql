{{ config(materialized='table') }}

    select
    study_study_id::text as "Study_study_id",
    funding_source::text as "funding_source"
    from {{ ref('alpha_study_funding_source') }}
    