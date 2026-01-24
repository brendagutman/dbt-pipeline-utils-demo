{{ config(materialized='table') }}

    select
    id::integer as "id",
    name::text as "name",
    institution::text as "institution",
    website::text as "website",
    vbr_readme::text as "vbr_readme"
    from {{ ref('alpha_virtualbiorepository') }}
    