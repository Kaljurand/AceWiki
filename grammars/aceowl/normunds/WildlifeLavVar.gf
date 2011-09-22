---------------------------------------------------------------------
-- Domain-specific lexicon (content words, incl. multi-word units) --
-- Free variation                                                  --
---------------------------------------------------------------------

concrete WildlifeLavVar of Wildlife = OntologyLavVar ** open ResLavVar, ResLav in {
	flags
		coding = utf8 ;
		optimize = all_subs ;
		optimize = values ;

	lin
		Animal = mkNoun "dzīvnieks" ;
		Branch = mkNoun "zars" ;
		Carnivore = mkNoun ("plēsējs" | "plēsonis" | "plēsoņa") ;
		Giraffe = mkNoun "žirafe" ;
		Herbivore = mkNoun "zālēdājs" ;
		Leaf = mkNoun "lapa" ;
		Lion = mkNoun "lauva" ;
		Plant = mkNoun "augs" ;
		TastyPlant = mkMWU (mkAdjective "garšīgs") (IndefAdj|DefAdj) (mkNoun "augs") ;
		Tree = mkNoun "koks" ;

		eats = mkVerb "ēd" Obj ;

		nourishmentOf = mkNoun "barība" ;
		partOf = mkNoun "daļa" ;
}
