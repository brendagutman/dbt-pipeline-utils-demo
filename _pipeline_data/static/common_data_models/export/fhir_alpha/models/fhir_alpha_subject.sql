{{ config(materialized='table') }}

    select
    subject_id::text as "subject_id",
    subject_type::text as "subject_type",
    organism_type::text as "organism_type"
    from {{ ref('alpha_subject') }}
    