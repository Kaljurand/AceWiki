---------------------------------------------------------------------
-- Domain-specific lexicon (content words, incl. multi-word units) --
---------------------------------------------------------------------

concrete AcewikitestAce of Acewikitest = OntologyAce ** open ResAce, ResEng in {
	flags
		optimize = all_subs ;
		optimize = values ;

	lin
		Woman = ResAce.mkNoun "woman" ;
		asks = ResAce.mkVerb "ask" Obj ;
		friendOf = ResAce.mkNoun "friend" Of ;
}
