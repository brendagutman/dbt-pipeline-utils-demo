{{ config(materialized='table') }}

    select
    id::integer as "id",
    name::text as "name",
    institution::text as "institution",
    invesitgator_title::text as "invesitgator_title",
    email::text as "email"
    from {{ ref('alpha_investigator') }}
    