{{ config(materialized='table') }}

    select
    study_id::text as "study_id",
    parent_study::text as "parent_study",
    study_title::text as "study_title",
    study_code::text as "study_code",
    study_short_name::text as "study_short_name",
    study_description::text as "study_description",
    selection_criteria::text as "selection_criteria",
    website::text as "website",
    expected_number_of_participants::integer as "expected_number_of_participants",
    actual_number_of_participants::integer as "actual_number_of_participants",
    acknowledgments::text as "acknowledgments",
    citation_statement::text as "citation_statement",
    doi::text as "doi",
    vbr_id::integer as "vbr_id"
    from {{ ref('alpha_study') }}
    