{{ config(materialized='table') }}

    select
    virtualbiorepository_id::integer as "VirtualBiorepository_id",
    external_id::text as "external_id"
    from {{ ref('alpha_virtualbiorepository_external_id') }}
    