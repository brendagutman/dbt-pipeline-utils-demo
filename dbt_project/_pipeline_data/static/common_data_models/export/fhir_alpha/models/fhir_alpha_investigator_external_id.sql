{{ config(materialized='table') }}

    select
    investigator_id::integer as "Investigator_id",
    external_id::text as "external_id"
    from {{ ref('alpha_investigator_external_id') }}
    