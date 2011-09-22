---------------------------------------------------------------------
-- Domain-specific lexicon (content words, incl. multi-word units) --
---------------------------------------------------------------------

concrete WildlifeEngVar of Wildlife = OntologyEngDef ** open ResEng in {
	flags
		optimize = all_subs ;
		optimize = values ;

	lin
		Animal = mkNoun "animal" ;
		Branch = mkNoun "branch" ;
		Carnivore = mkNoun "carnivore" ;
		Giraffe = mkNoun "giraffe" ;
		Herbivore = mkNoun "herbivore" ;
		Leaf = mkNoun "leaf" ;
		Lion = mkNoun "lion" ;
		Plant = mkNoun "plant" ;
		TastyPlant = mkMWU (mkAdjective "tasty") (mkNoun "plant") ;
		Tree = mkNoun "tree" ;

		eats = mkVerb "eat" "eaten" Obj ;

		nourishmentOf = mkNoun "nourishment" ;
		partOf = mkNoun "part" ;
}
