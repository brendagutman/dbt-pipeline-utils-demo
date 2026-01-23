{{ config(materialized='table') }}

    select
    study_study_id::text as "Study_study_id",
    data_category::text as "data_category"
    from {{ ref('alpha_study_data_category') }}
    