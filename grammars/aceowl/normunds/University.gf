---------------------------------------------------
-- Language-independent domain-specific concepts --
---------------------------------------------------

abstract University = Ontology ** {
	fun
		-- Classes
		AcademicProgram, Assistant, Course, MandatoryCourse,
			OptionalCourse, Person, Professor, Student, Teacher : C ;

		-- Properties (predicates)
		constitutes, enrolls, enrolledIn, includes, includedIn, takes, teaches : P ;

		-- Properties (predicate nominatives)
		partOf : PN ;
}
