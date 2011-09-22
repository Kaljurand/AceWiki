---------------------------------------------------------------------
-- Domain-specific lexicon (content words, incl. multi-word units) --
-- Free variation                                                  --
---------------------------------------------------------------------

concrete UniversityLavVar of University = OntologyLavVar ** open ResLavVar, ResLav in {
	flags
		coding = utf8 ;
		optimize = all_subs ;
		optimize = values ;

	lin
		AcademicProgram = mkMWU (mkAdjective "akadēmisks") (mkNoun "programma") ;
		Assistant = mkNoun "asistents" ;
		Course = mkNoun "kurss" ;
		MandatoryCourse = mkMWU (mkAdjective "obligāts") (mkNoun "kurss") ;
		OptionalCourse = mkMWU (mkNoun "izvēle") (mkNoun "kurss") ;
		Person = mkNoun "persona" ;
		Professor = mkNoun "profesors" ;
		Student = mkNoun "students" ;
		Teacher = mkNoun "pasniedzējs" ;

		constitutes = mkVerb "veido" Obj ;
		enrolls = mkParticiple "uzņēmis" | mkVerb "uzņem" Obj ;
		enrolledIn = mkParticiple "uzņemts" ;
		includes = mkVerb ("iekļauj" | "ietver") Obj ;
		includedIn = mkParticiple "iekļauts" | mkVerb "ietilpst" Place ;
		takes = mkVerb ("apgūst" | "ņem") Obj ;
		teaches = mkVerb ("māca" | "pasniedz") Obj ;

		partOf = mkNoun "daļa" ;
}
