{{ config(materialized='table') }}

    select
    study_study_id::text as "Study_study_id",
    publication_id::integer as "publication_id"
    from {{ ref('alpha_study_publication') }}
    