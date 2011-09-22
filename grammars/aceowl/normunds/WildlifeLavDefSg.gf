---------------------------------------------------------------------
-- Domain-specific lexicon (content words, incl. multi-word units) --
-- Default linearization                                           --
---------------------------------------------------------------------

concrete WildlifeLavDefSg of Wildlife = OntologyLavDefSg ** open ResLavDefSg, ResLav in {
	flags
		coding = utf8 ;
		optimize = all_subs ;
		optimize = values ;

	lin
		Animal = mkNoun "dzīvnieks" ;
		Branch = mkNoun "zars" ;
		Carnivore = mkNoun "plēsējs" ;
		Giraffe = mkNoun "žirafe" ;
		Herbivore = mkNoun "zālēdājs" ;
		Leaf = mkNoun "lapa" ;
		Lion = mkNoun "lauva" ;
		Plant = mkNoun "augs" ;
		TastyPlant = mkMWU (mkAdjective "garšīgs") IndefAdj (mkNoun "augs") ;
		Tree = mkNoun "koks" ;

		eats = mkVerb "ēd" Obj ;

		nourishmentOf = mkNoun "barība" ;
		partOf = mkNoun "daļa" ;
}
