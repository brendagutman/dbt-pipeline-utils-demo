{{ config(materialized='table') }}

    select
    doi::text as "doi",
    bibliographic_reference::text as "bibliographic_reference"
    from {{ ref('alpha_doi') }}
    