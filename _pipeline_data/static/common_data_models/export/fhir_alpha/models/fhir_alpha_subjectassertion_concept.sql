{{ config(materialized='table') }}

    select
    subjectassertion_assertion_id::text as "SubjectAssertion_assertion_id",
    concept_concept_curie::text as "concept_concept_curie"
    from {{ ref('alpha_subjectassertion_concept') }}
    