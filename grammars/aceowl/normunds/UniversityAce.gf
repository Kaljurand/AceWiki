---------------------------------------------------------------------
-- Domain-specific lexicon (content words, incl. multi-word units) --
---------------------------------------------------------------------

concrete UniversityAce of University = OntologyAce ** open ResAce, ResEng in {
	flags
		optimize = all_subs ;
		optimize = values ;

	lin
		AcademicProgram = ResAce.mkMWU (ResEng.mkAdjective "academic") (ResEng.mkNoun "program") ;
		Assistant = ResAce.mkNoun "assistant" ;
		Course = ResAce.mkNoun "course" ;
		MandatoryCourse = ResAce.mkMWU (ResEng.mkAdjective "mandatory") (ResEng.mkNoun "course") ;
		OptionalCourse = ResAce.mkMWU (ResEng.mkAdjective "optional") (ResEng.mkNoun "course") ;
		Person = ResAce.mkNoun "person" ;
		Professor = ResAce.mkNoun "professor" ;
		Student = ResAce.mkNoun "student" ;
		Teacher = ResAce.mkNoun "teacher" ;

		constitutes = ResAce.mkVerb "constitute" Obj ;
		enrolls = ResAce.mkParticiple "enrolled" Obj ;
		enrolledIn = ResAce.mkParticiple "enrolled" In Place ;
		includes = ResAce.mkVerb "include" Obj ;
		includedIn = ResAce.mkParticiple "included" In Place ;
		takes = ResAce.mkVerb "take" Obj ;
		teaches = ResAce.mkVerb "teach" Obj ;

		partOf = ResAce.mkNoun "part" Of ;
}
