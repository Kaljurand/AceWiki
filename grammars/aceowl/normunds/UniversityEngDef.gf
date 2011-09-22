---------------------------------------------------------------------
-- Domain-specific lexicon (content words, incl. multi-word units) --
-- Default linearization                                           --
---------------------------------------------------------------------

concrete UniversityEngDef of University = OntologyEngDef ** open ResEng in {
	flags
		optimize = all_subs ;
		optimize = values ;

	lin
		AcademicProgram = mkMWU (mkAdjective "academic") (mkNoun "program") ;
		Assistant = mkNoun "assistant" ;
		Course = mkNoun "course" ;
		MandatoryCourse = mkMWU (mkAdjective "mandatory") (mkNoun "course") ;
		OptionalCourse = mkMWU (mkAdjective "optional") (mkNoun "course") ;
		Person = mkNoun "person" ;
		Professor = mkNoun "professor" ;
		Student = mkNoun "student" ;
		Teacher = mkNoun "teacher" ;

		constitutes = mkVerb "constitute" Obj ;
		enrolls = mkParticiple "enrolled" Obj ;
		enrolledIn = mkParticiple "enrolled" In Place ;
		includes = mkVerb "include" Obj ;
		includedIn = mkParticiple "included" In Place ;
		takes = mkVerb "take" "taken" Obj ;
		teaches = mkVerb "teach" "taught" Obj ;

		partOf = mkNoun "part" ;
}
