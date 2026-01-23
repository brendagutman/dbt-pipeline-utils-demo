{{ config(materialized='table') }}

    select
    id::integer as "id",
    bibliographic_reference::text as "bibliographic_reference",
    website::text as "website"
    from {{ ref('alpha_publication') }}
    