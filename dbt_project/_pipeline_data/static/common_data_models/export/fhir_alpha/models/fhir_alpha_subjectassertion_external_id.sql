{{ config(materialized='table') }}

    select
    subjectassertion_assertion_id::text as "SubjectAssertion_assertion_id",
    external_id::text as "external_id"
    from {{ ref('alpha_subjectassertion_external_id') }}
    