{{ config(materialized='table') }}

    select
    virtualbiorepository_id::integer as "VirtualBiorepository_id",
    contact_id::integer as "contact_id"
    from {{ ref('alpha_virtualbiorepository_contact') }}
    