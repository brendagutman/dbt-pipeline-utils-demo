{{ config(materialized='table') }}

    select
    subject_subject_id::text as "Subject_subject_id",
    external_id::text as "external_id"
    from {{ ref('alpha_subject_external_id') }}
    