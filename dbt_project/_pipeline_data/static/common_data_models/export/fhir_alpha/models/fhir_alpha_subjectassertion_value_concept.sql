{{ config(materialized='table') }}

    select
    subjectassertion_assertion_id::text as "SubjectAssertion_assertion_id",
    value_concept_concept_curie::text as "value_concept_concept_curie"
    from {{ ref('alpha_subjectassertion_value_concept') }}
    