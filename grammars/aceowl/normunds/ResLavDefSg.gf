---------------------------------------------------------------------------
-- Domain-independent Latvian morphology (incl. some syntactic features) --
-- Default linearization                                                 --
---------------------------------------------------------------------------

resource ResLavDefSg = open ResLav in {
	flags
		coding = utf8 ;
		optimize = noexpand ;
		optimize = values ;

	oper
		mkPron_Rel : RelPronType -> RelativePronoun = \type ->
			case type of {
				RelThat => mkPron_Rel_That ;
				RelWhich => mkPron_Rel_Which
			} ;

		mkPron_Rel_That : RelativePronoun = table {
			Masc => table {
				Nom => "kas" ;
				Gen => "kura" ;
				Acc => "ko" ;
				Loc => "kurā"
			} ;
			Fem => table {
				Nom => "kas" ;
				Gen => "kuras" ;
				Acc => "ko" ;
				Loc => "kurā"
			}
		} ;

		--------------------------------------------------------------------------------------------

		mkParticiple : Str -> Verb = \lemma ->
				let	type : VerbType = case lemma of {
					s + "is" => Obj ;
					s + "ts" => Place
				}
				in mkPart_Type lemma type ;

		mkPart_Type : Str -> VerbType -> Verb = \lemma,type ->
			case type of {
				Obj => mkPart_Obj_Full lemma ;
				Place => mkPart_Place_Full lemma
			} ;
}
