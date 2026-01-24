{{ config(materialized='table') }}

    select
    publication_id::integer as "Publication_id",
    external_id::text as "external_id"
    from {{ ref('alpha_publication_external_id') }}
    