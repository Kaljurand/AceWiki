---------------------------------------------------------------------------
-- Domain-independent English morphology (incl. some syntactic features) --
-- Common parameters and functions                                       --
---------------------------------------------------------------------------

resource ResEng = {
	flags
		optimize = noexpand ;
		optimize = values ;

	param
		IndefiniteDet = A | An ;
		Voice = Act | Pass ;
		Number = Sg | Pl ;
		Polarity = Pos | Neg ;
		VerbType = Obj | Place ;
		Preposition = In | At | NoPrep ;
		CopulaType = Is | Has | RoleCop ;

	oper
		Noun : Type = {s : Number => Str ; a : IndefiniteDet} ;
		Adjective : Type = {s : Str ; a : IndefiniteDet} ;
		Verb : Type = Voice => Polarity => Number => Str ;
		Copula : Type = CopulaType => Polarity => Number => Str ;

		--------------------------------------------------------------------------------------------

		mkNoun : Str -> Noun = \lemma -> {
			s = table {
				Sg => lemma ;
				Pl => mkPlural lemma
			} ;
			a = mkIndefDet lemma
		} ;

		mkPlural : Str -> Str = \lemma ->
			case lemma of {
				stem + "f" => stem + "ves" ;
				stem + "h" => stem + "es" ;
				_ => lemma + "s"
			} ;

		mkAdjective : Str -> Adjective = \lemma -> {
			s = lemma ;
			a = mkIndefDet lemma
		} ;

		mkIndefDet : Str -> IndefiniteDet = \lemma ->
			case lemma of {
				"eu" + _ => A ;
				"uni" + _ => A ;
				"un" + _ => An ;
				"u" + _ => A ;
				("a" | "e" | "i" | "o") + _ => An ;
				_ => A
			} ;

		mkMWU : Adjective -> Noun -> Noun = \adj,noun -> {
			s = \\num => adj.s ++ noun.s ! num ;
			a = adj.a
		} ;

		--------------------------------------------------------------------------------------------

		mkCop : Copula = table {
			Is => table {
				Pos => table {
					Sg => "is" ;
					Pl => "are"
				} ;
				Neg => table {
					Sg => "is not" ;
					Pl => "are not"
				}
			} ;
			Has => table {
				Pos => table {
					Sg => "has" ;
					Pl => "have"
				} ;
				Neg => table {
					Sg => "has not" ;
					Pl => "have not"
				}
			} ;
			RoleCop => table {
				Pos => \\_ => [] ;
				Neg => table {
					Sg => "does not" ;
					Pl => "do not"
				}
			}
		} ;

		--------------------------------------------------------------------------------------------

		mkVerb = overload {
			mkVerb : Str -> VerbType -> Verb = mkVerb_Reg ;
			mkVerb : Str -> Preposition -> VerbType -> Verb = mkVerb_Reg_Prep ;
			mkVerb : Str -> Str -> VerbType -> Verb = mkVerb_Irreg ;
			mkVerb : Str -> Str -> Preposition -> VerbType -> Verb = mkVerb_Irreg_Prep ;
		} ;

		mkVerb_Reg : Str -> VerbType -> Verb = \inf,type -> mkVerb_Reg_Prep inf NoPrep type ;

		mkVerb_Reg_Prep : Str -> Preposition -> VerbType -> Verb = \inf,prep,type -> table {
			Act => mkVerb_Act inf type prep ;
			Pass => mkVerb_Pass (mkVerb_Reg_Past inf) type prep
		} ;

		mkVerb_Irreg : Str -> Str -> VerbType -> Verb = \inf,past,type ->
			mkVerb_Irreg_Prep inf past NoPrep type ;

		mkVerb_Irreg_Prep : Str -> Str -> Preposition -> VerbType ->
			Verb = \inf,past,prep,type -> table {
				Act => mkVerb_Act inf type prep ;
				Pass => mkVerb_Pass past type prep
			} ;

		mkVerb_Reg_Pres : Str -> Str = \inf ->
			case inf of {
				_ + "h" => inf + "es" ;
				_ => inf + "s"
			} ;

		mkVerb_Reg_Past : Str -> Str = \inf ->
			case inf of {
				_ + "e" => inf + "d" ;
				_ => inf + "ed"
			} ;

		mkVerb_Act : Str -> VerbType -> Preposition ->
			Polarity => Number => Str = \inf,type,prep ->
				case type of {
					Obj => table {
						Pos => table {
							Sg => mkVerb_Reg_Pres inf ;
							Pl => inf
						} ;
						Neg => table {
							Sg => "does not" ++ inf ;
							Pl => "do not" ++ inf
						}
					} ;
					Place => table {
						Pos => table {
							Sg => mkVerb_Place (mkVerb_Reg_Pres inf) prep ;
							Pl => mkVerb_Place inf prep
						} ;
						Neg => table {
							Sg => "does not" ++ (mkVerb_Place inf prep) ;
							Pl => "do not" ++ (mkVerb_Place inf prep)
						}
					}
				} ;

		mkVerb_Pass : Str -> VerbType -> Preposition ->
			Polarity => Number => Str = \past,type,prep ->
				case type of {
					Obj => table {
						Pos => table {
							Sg => "is" ++ past ++ "by" ;
							Pl => "are" ++ past ++ "by"
						} ;
						Neg => table {
							Sg => "is not" ++ past ++ "by" ;
							Pl => "are not" ++ past ++ "by"
						}
					} ;
					Place => table {
						Pos => table {
							Sg => "is" ++ (mkVerb_Place past prep) ++ "by" ;
							Pl => "are" ++ (mkVerb_Place past prep) ++ "by"
						} ;
						Neg => table {
							Sg => "is not" ++ (mkVerb_Place past prep) ++ "by" ;
							Pl => "are not" ++ (mkVerb_Place past prep) ++ "by"
						}
					}
				} ;

		mkVerb_Place : Str -> Preposition -> Str = \vform,prep ->
			let p : Str = case prep of {
				In => "in" ;
				At => "at" ;
				None => []
			}
			in vform ++ p ;

		--------------------------------------------------------------------------------------------

		mkParticiple = overload {
			mkParticiple : Str -> VerbType -> Verb = mkParticiple_Obj ;
			mkParticiple : Str -> Preposition -> VerbType -> Verb = mkParticiple_Prep ;
		} ;

		mkParticiple_Obj : Str -> VerbType -> Verb = \past,type ->
			mkParticiple_Prep past NoPrep type ;

		mkParticiple_Prep : Str -> Preposition -> VerbType -> Verb = \past,prep,type ->
			case type of {
				Obj => table {
					Act => table {
						Pos => table {
							Sg => "has" ++ past ;
							Pl => "have" ++ past
						} ;
						Neg => table {
							Sg => "has not" ++ past ;
							Pl => "have not" ++ past
						}
					} ;
					Pass => table {
						Pos => table {
							Sg => "is" ++ past ++ "by" ;
							Pl => "are" ++ past ++ "by"
						} ;
						Neg => table {
							Sg => "is not" ++ past ++ "by" ;
							Pl => "are not" ++ past ++ "by"
						}
					}
				} ;
				Place => table {
					Act => table {
						Pos => table {
							Sg => "is" ++ (mkVerb_Place past prep) ;
							Pl => "are" ++ (mkVerb_Place past prep)
						} ;
						Neg => table {
							Sg => "is not" ++ (mkVerb_Place past prep) ;
							Pl => "are not" ++ (mkVerb_Place past prep)
						}
					} ;
					Pass => table {
						Pos => table {
							Sg => "is" ++ (mkVerb_Place past prep) ++ "by" ;
							Pl => "are" ++ (mkVerb_Place past prep) ++ "by"
						} ;
						Neg => table {
							Sg => "is not" ++ (mkVerb_Place past prep) ++ "by" ;
							Pl => "are not" ++ (mkVerb_Place past prep) ++ "by"
						}
					}
				}
			} ;
}
