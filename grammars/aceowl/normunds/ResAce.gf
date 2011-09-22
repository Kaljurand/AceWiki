---------------------------------------------------------------------------
-- Domain-independent English morphology (incl. some syntactic features) --
-- Input/output format for/of the ACE parser/verbalizer                  --
---------------------------------------------------------------------------

resource ResAce = open ResEng in {
	flags
		optimize = noexpand ;
		optimize = values ;

	param
		RoleAffix = Of | Has | NoAffix ;

	oper
		mkNoun = overload {
			mkNoun : Str -> Noun = mkNoun_Typical ;
			mkNoun : Str -> RoleAffix -> Noun = mkNoun_Affixed ;
		} ;

		mkNoun_Typical : Str -> Noun = \lemma -> mkNoun_Affixed lemma NoAffix ;

		mkNoun_Affixed : Str -> RoleAffix -> Noun = \lemma,aff ->
			let name : Str = case aff of {
				Of => lemma + "-of" ;
				Has => "has-" + lemma ;
				NoAffix => lemma
			}
			in {
				s = \\_ => name ;
				a = mkIndefDet lemma
			} ;

		mkMWU : Adjective -> Noun -> Noun = \adj,noun -> {
			s = \\num => adj.s + "-" + noun.s ! num ;
			a = adj.a
		} ;

		--------------------------------------------------------------------------------------------

		mkVerb = overload {
			mkVerb : Str -> VerbType -> Verb = mkVerb_Reg ;
			mkVerb : Str -> Preposition -> VerbType -> Verb = mkVerb_Reg_Prep ;
		} ;

		mkVerb_Reg : Str -> VerbType -> Verb = \verb,type ->
			mkVerb_Reg_Prep verb NoPrep type ;

		mkVerb_Reg_Prep : Str -> Preposition -> VerbType -> Verb = \verb,prep,type -> table {
			Act => mkVerb_Act verb type prep ;
			Pass => mkVerb_Pass verb type prep
		} ;

		mkVerb_Act : Str -> VerbType -> Preposition ->
			Polarity => Number => Str = \verb,type,prep ->
				let vform_obj : Str = mkVerb_Reg_Pres verb
				in let vform_place : Str = mkVerb_Place (mkVerb_Reg_Pres verb) prep
				in case type of {
					Obj => table {
						Pos => \\_ => vform_obj ;
						Neg => table {
							Sg => "does not" ++ vform_obj ;
							Pl => "do not" ++ vform_obj
						}
					} ;
					Place => table {
						Pos => \\_ => vform_place ;
						Neg => table {
							Sg => "does not" ++ vform_place ;
							Pl => "do not" ++ vform_place
						}
					}
				} ;

		mkVerb_Pass : Str -> VerbType -> Preposition ->
			Polarity => Number => Str = \verb,type,prep ->
				let vform_obj : Str = mkVerb_Reg_Pres verb
				in let vform_place : Str = mkVerb_Place (mkVerb_Reg_Pres verb) prep
				in case type of {
					Obj => table {
						Pos => table {
							Sg => "is" ++ vform_obj ++ "by" ;
							Pl => "are" ++ vform_obj ++ "by"
						} ;
						Neg => table {
							Sg => "is not" ++ vform_obj ++ "by" ;
							Pl => "are not" ++ vform_obj ++ "by"
						}
					} ;
					Place => table {
						Pos => table {
							Sg => "is" ++ vform_place ++ "by" ;
							Pl => "are" ++ vform_place ++ "by"
						} ;
						Neg => table {
							Sg => "is not" ++ vform_place ++ "by" ;
							Pl => "are not" ++ vform_place ++ "by"
						}
					}
				} ;

		mkVerb_Place : Str -> Preposition -> Str = \verb,prep ->
			let p : Str = case prep of {
				In => "-in" ;
				At => "-at" ;
				NoPrep => ""
			}
			in verb + p ;

		--------------------------------------------------------------------------------------------

		mkParticiple = overload {
			mkParticiple : Str -> VerbType -> Verb = mkParticiple_Obj ;
			mkParticiple : Str -> Preposition -> VerbType -> Verb = mkParticiple_Prep ;
		} ;

		mkParticiple_Obj : Str -> VerbType -> Verb = \past,type ->
			mkParticiple_Prep past NoPrep type ;

		mkParticiple_Prep : Str -> Preposition -> VerbType -> Verb = \past,prep,type ->
			let vform_obj : Str = "has-" + past
			in let vform_place : Str = mkVerb_Place past prep
			in case type of {
				Obj => table {
					Act => table {
						Pos => \\_ => vform_obj ;
						Neg => table {
							Sg => "does not" ++ vform_obj ;
							Pl => "do not" ++ vform_obj
						}
					} ;
					Pass => table {
						Pos => table {
							Sg => "is" ++ vform_obj ++ "by" ;
							Pl => "are" ++ vform_obj ++ "by"
						} ;
						Neg => table {
							Sg => "is not" ++ vform_obj ++ "by" ;
							Pl => "are not" ++ vform_obj ++ "by"
						}
					}
				} ;
				Place => table {
					Act => table {
						Pos => \\_ => vform_place ;
						Neg => table {
							Sg => "is not" ++ vform_place ;
							Pl => "are not" ++ vform_place
						}
					} ;
					Pass => table {
						Pos => table {
							Sg => "is" ++ vform_place ++ "by" ;
							Pl => "are" ++ vform_place ++ "by"
						} ;
						Neg => table {
							Sg => "is not" ++ vform_place ++ "by" ;
							Pl => "are not" ++ vform_place ++ "by"
						}
					}
				}
			} ;
}
