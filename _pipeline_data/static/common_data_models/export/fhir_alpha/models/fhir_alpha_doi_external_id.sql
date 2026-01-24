{{ config(materialized='table') }}

    select
    doi_doi::text as "DOI_doi",
    external_id::text as "external_id"
    from {{ ref('alpha_doi_external_id') }}
    