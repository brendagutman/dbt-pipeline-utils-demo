{{ config(materialized='table') }}

    select
    demographics_subject_id::text as "Demographics_subject_id",
    external_id::text as "external_id"
    from {{ ref('alpha_demographics_external_id') }}
    