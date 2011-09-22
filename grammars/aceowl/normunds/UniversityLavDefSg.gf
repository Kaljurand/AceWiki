---------------------------------------------------------------------
-- Domain-specific lexicon (content words, incl. multi-word units) --
-- Default linearization                                           --
---------------------------------------------------------------------

concrete UniversityLavDefSg of University = OntologyLavDefSg ** open ResLavDefSg, ResLav in {
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
		enrolls = mkParticiple "uzņēmis" ;
		enrolledIn = mkParticiple "uzņemts" ;
		includes = mkVerb "iekļauj" Obj ;
		includedIn = mkParticiple "iekļauts" ;
		takes = mkVerb "apgūst" Obj ;
		teaches = mkVerb "māca" Obj ;

		partOf = mkNoun "daļa" ;
}
