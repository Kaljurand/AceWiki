---------------------------------------------------------------------
-- Domain-specific lexicon (content words, incl. multi-word units) --
---------------------------------------------------------------------

concrete WildlifeAce of Wildlife = OntologyAce ** open ResAce, ResEng in {
	flags
		optimize = all_subs ;
		optimize = values ;

	lin
		Animal = ResAce.mkNoun "animal" ;
		Branch = ResAce.mkNoun "branch" ;
		Carnivore = ResAce.mkNoun "carnivore" ;
		Giraffe = ResAce.mkNoun "giraffe" ;
		Herbivore = ResAce.mkNoun "herbivore" ;
		Leaf = ResAce.mkNoun "leaf" ;
		Lion = ResAce.mkNoun "lion" ;
		Plant = ResAce.mkNoun "plant" ;
		TastyPlant = ResAce.mkMWU (ResEng.mkAdjective "tasty") (ResEng.mkNoun "plant") ;
		Tree = ResAce.mkNoun "tree" ;

		eats = ResAce.mkVerb "eat" Obj ;

		nourishmentOf = ResAce.mkNoun "nourishment" Of ;
		partOf = ResAce.mkNoun "part" Of ;
}
