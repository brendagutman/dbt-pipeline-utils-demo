{{ config(materialized='table') }}

    select
    record_id::integer as "Record_id",
    external_id::text as "external_id"
    from {{ ref('alpha_record_external_id') }}
    