{{ config(materialized='table') }}

    select
    study_study_id::text as "Study_study_id",
    contact_id::integer as "contact_id"
    from {{ ref('alpha_study_contact') }}
    