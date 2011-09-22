---------------------------------------------------
-- Language-independent domain-specific concepts --
---------------------------------------------------

abstract Wildlife = Ontology ** {
	fun
		-- Classes
		Animal, Branch, Carnivore, Giraffe, Herbivore, Leaf, Lion, Plant, TastyPlant, Tree : C ;

		-- Properties (predicates)
		eats : P ;

		-- Properties (predicate nominatives)
		nourishmentOf, partOf : PN ;
}
