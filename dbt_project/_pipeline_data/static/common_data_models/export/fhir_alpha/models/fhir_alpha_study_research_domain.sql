{{ config(materialized='table') }}

    select
    study_study_id::text as "Study_study_id",
    research_domain::text as "research_domain"
    from {{ ref('alpha_study_research_domain') }}
    