---------------------------------------------------------------------------
-- Domain-independent Latvian morphology (incl. some syntactic features) --
-- Common parameters and functions                                       --
---------------------------------------------------------------------------

resource ResLav = {
	flags
		coding = utf8 ;
		optimize = noexpand ;
		optimize = values ;

	param
		Gender = Masc | Fem ;
		Case = Nom | Gen | Acc | Loc ;
		Polarity = Pos | Neg ;
		AdjType = IndefAdj | DefAdj ;
		Declension = D1_1 | D1_2 | D2 | D3 | D4 | D5 ;
		VerbType = Obj | Place ;
		DemonstrPronType = DemonstrThis | DemonstrThat ;
		RelPronType = RelThat | RelWhich ;

	oper
		Noun : Type = {s : Case => Str ; g : Gender} ;
		Adjective : Type = {s : Gender => AdjType => Case => Str} ;
		GenderedPronoun : Type = Gender => Case => Polarity => Str ;
		DefiniteParticiple : Type = Gender => Case => Polarity => Str ;
		NongenderedPronoun : Type = Case => Polarity => Str ;
		DemonstrativePronoun : Type = Gender => Case => Str ;
		RelativePronoun : Type = Gender => Case => Str ;
		Variable : Type = {s : Case => Str} ;
		Copula : Type = Polarity => Str ;
		Verb : Type = {s : Gender => Polarity => Str ; a : DefiniteParticiple ; o : Case} ;
		Participle : Type = {s : Gender => Str ; a : DefiniteParticiple} ;

		--------------------------------------------------------------------------------------------

		mkPron_Gend : Str -> GenderedPronoun = \lemma ->
			let	stem : Str = case lemma of {
				s + ("s"|"š"|"a") => s ;
				_ => lemma
			}
			in table {
				Masc => table {
					Nom => table {
						Pos => lemma ;
						Neg => "neviens"
					} ;
					Gen => table {
						Pos => stem + "a" ;
						Neg => "neviena"
					} ;
					Acc => table {
						Pos => stem + "u" ;
						Neg => "nevienu"
					} ;
					Loc => table {
						Pos => stem + "ā" ;
						Neg => "nevienā"
					}
				} ;
				Fem => table {
					Nom => table {
						Pos => stem + "a" ;
						Neg => "neviena"
					} ;
					Gen => table {
						Pos => stem + "as" ;
						Neg => "nevienas"
					} ;
					Acc => table {
						Pos => stem + "u" ;
						Neg => "nevienu"
					} ;
					Loc => table {
						Pos => stem + "ā" ;
						Neg => "nevienā"
					}
				}
			} ;

		mkPron_Gend_Empty : GenderedPronoun = \\_,_,_ => [] ;

		--------------------------------------------------------------------------------------------

		mkPron_Nongend = overload {
			mkPron_Nongend : Str -> NongenderedPronoun = mkPron_Nongend_Simple ;
			mkPron_Nongend : Str -> NongenderedPronoun ->
				NongenderedPronoun = mkPron_Nongend_Compound ;
		} ;

		mkPron_Nongend_Simple : Str -> NongenderedPronoun = \lemma ->
			let	stem : Str = case lemma of {
				s + "as" => s ;
				_ => lemma
			}
			in table {
				Nom => table {
					Pos => stem + "as" ;
					Neg => "nekas"
				} ;
				Gen => table {
					Pos => stem + "ā" ;
					Neg => "nekā"
				} ;
				Acc => table {
					Pos => stem + "o" ;
					Neg => "neko"
				} ;
				Loc => table {
					Pos => stem + "ur" ;
					Neg => "nekur"
				}
			} ;

		mkPron_Nongend_Compound : Str -> NongenderedPronoun ->
			NongenderedPronoun = \prefix,pron -> table {
				Nom => table {
					Pos => prefix ++ pron ! Nom ! Pos ;
					Neg => pron ! Nom ! Neg
				} ;
				Gen => table {
					Pos => prefix ++ pron ! Gen ! Pos ;
					Neg => pron ! Gen ! Neg
				} ;
				Acc => table {
					Pos => prefix ++ pron ! Acc ! Pos ;
					Neg => pron ! Acc ! Neg
				} ;
				Loc => table {
					Pos => prefix ++ pron ! Loc ! Pos ;
					Neg => pron ! Loc ! Neg
				}
			} ;

		--------------------------------------------------------------------------------------------

		mkPron_Demonstr : DemonstrPronType -> DemonstrativePronoun = \type ->
			case type of {
				DemonstrThis => mkPron_Demonstr_This ;
				DemonstrThat => mkPron_Demonstr_That
			} ;

		mkPron_Demonstr_This : DemonstrativePronoun = table {
			Masc => table {
				Nom => "šis" ;
				Gen => "šī" ;
				Acc => "šo" ;
				Loc => "šajā"
			} ;
			Fem => table {
				Nom => "šī" ;
				Gen => "šīs" ;
				Acc => "šo" ;
				Loc => "šajā"
			}
		} ;

		mkPron_Demonstr_That : DemonstrativePronoun = table {
			Masc => table {
				Nom => "tas" ;
				Gen => "tā" ;
				Acc => "to" ;
				Loc => "tajā"
			} ;
			Fem => table {
				Nom => "tā" ;
				Gen => "tās" ;
				Acc => "to" ;
				Loc => "tajā"
			}
		} ;

		mkPron_Demonstr_Empty : DemonstrativePronoun = \\_,_ => [] ;

		--------------------------------------------------------------------------------------------

		mkPron_Rel_Which : RelativePronoun = table {
			Masc => table {
				Nom => "kurš" ;
				Gen => "kura" ;
				Acc => "kuru" ;
				Loc => "kurā"
			} ;
			Fem => table {
				Nom => "kura" ;
				Gen => "kuras" ;
				Acc => "kuru" ;
				Loc => "kurā"
			}
		} ;

		mkPron_Rel_Empty : RelativePronoun = \\_,_ => [] ;

		--------------------------------------------------------------------------------------------

		mkNoun : Str -> Noun = \lemma ->
			let	decl : Declension = case lemma of {
				s + "is" => D2 ;
				s + "us" => D3 ;
				s + "s" => D1_1 ;
				s + "a" => D4 ;
				s + "e" => D5
			}
			in mkNoun_Decl lemma decl ;

		mkNoun_Decl : Str -> Declension -> Noun = \lemma,decl ->
			case decl of {
				D1_1 => mkNoun_D1_1 lemma ;
				D1_2 => mkNoun_D1_2 lemma ;
				D2 => mkNoun_D2 lemma ;
				D3 => mkNoun_D3 lemma ;
				D4 => mkNoun_D4 lemma ;
				D5 => mkNoun_D5 lemma
			} ;

		mkNoun_D1_1 : Str -> Noun = \lemma ->
			let	stem : Str = case lemma of {
				s + "s" => s ;
				_ => lemma
			}
			in {
				s = table {
					Nom => stem + "s" ;
					Gen => stem + "a" ;
					Acc => stem + "u" ;
					Loc => stem + "ā"
				} ;
				g = Masc
			} ;

		mkNoun_D1_2 : Str -> Noun = \lemma ->
			let	stem : Str = case lemma of {
				s + "š" => s ;
				_ => lemma
			}
			in {
				s = table {
					Nom => stem + "š" ;
					Gen => stem + "a" ;
					Acc => stem + "u" ;
					Loc => stem + "ā"
				} ;
				g = Masc
			} ;

		mkNoun_D2 : Str -> Noun = \lemma ->
			let	stem : Str = case lemma of {
				s + "is" => s ;
				_ => lemma
			}
			in {
				s = table {
					Nom => stem + "is" ;
					Gen => stem + "a" ;
					Acc => stem + "i" ;
					Loc => stem + "ī"
				} ;
				g = Masc
			} ;

		mkNoun_D3 : Str -> Noun = \lemma ->
			let	stem : Str = case lemma of {
				s + "us" => s ;
				_ => lemma
			}
			in {
				s = table {
					Nom => stem + "us" ;
					Gen => stem + "us" ;
					Acc => stem + "u" ;
					Loc => stem + "ū"
				} ;
				g = Masc
			} ;

		mkNoun_D4 : Str -> Noun = \lemma ->
			let	stem : Str = case lemma of {
				s + "a" => s ;
				_ => lemma
			}
			in {
				s = table {
					Nom => stem + "a" ;
					Gen => stem + "as" ;
					Acc => stem + "u" ;
					Loc => stem + "ā"
				} ;
				g = Fem
			} ;

		mkNoun_D5 : Str -> Noun = \lemma ->
			let	stem : Str = case lemma of {
				s + "e" => s ;
				_ => lemma
			}
			in {
				s = table {
					Nom => stem + "e" ;
					Gen => stem + "es" ;
					Acc => stem + "i" ;
					Loc => stem + "ē"
				} ;
				g = Fem
			} ;

		--------------------------------------------------------------------------------------------

		mkAdjective : Str -> Adjective = \lemma ->
			let	stem : Str = case lemma of {
				s + ("s"|"š"|"a") => s ;
				_ => lemma
			}
			in {
				s = table {
					Masc => table {
						IndefAdj => table {
							Nom => lemma ;
							Gen => stem + "a" ;
							Acc => stem + "u" ;
							Loc => stem + "ā"
						} ;
						DefAdj => table {
							Nom => stem + "ais" ;
							Gen => stem + "ā" ;
							Acc => stem + "o" ;
							Loc => stem + "ajā"
						}
					} ;
					Fem => table {
						IndefAdj => table {
							Nom => stem + "a" ;
							Gen => stem + "as" ;
							Acc => stem + "u" ;
							Loc => stem + "ā"
						} ;
						DefAdj => table {
							Nom => stem + "ā" ;
							Gen => stem + "ās" ;
							Acc => stem + "o" ;
							Loc => stem + "ajā"
						}
					}
				}
			} ;

		--------------------------------------------------------------------------------------------

		mkMWU = overload {
			mkMWU : Adjective -> Noun -> Noun = mkMWU_AdjNoun ;
			mkMWU : Adjective -> AdjType -> Noun -> Noun = mkMWU_AdjTypeNoun ;
			mkMWU : Noun -> Noun -> Noun = mkMWU_NounNoun ;
		} ;

		mkMWU_AdjNoun : Adjective -> Noun -> Noun = \adj,noun -> mkMWU_AdjTypeNoun adj DefAdj noun ;

		mkMWU_AdjTypeNoun : Adjective -> AdjType -> Noun -> Noun = \adj,type,noun -> {
			s = table {
				Nom => adj.s ! noun.g ! type ! Nom ++ noun.s ! Nom ;
				Gen => adj.s ! noun.g ! type ! Gen ++ noun.s ! Gen ;
				Acc => adj.s ! noun.g ! type ! Acc ++ noun.s ! Acc ;
				Loc => adj.s ! noun.g ! type ! Loc ++ noun.s ! Loc
			} ;
			g = noun.g
		} ;

		mkMWU_NounNoun : Noun -> Noun -> Noun = \attr,noun -> {
			s = table {
				Nom => attr.s ! Gen ++ noun.s ! Nom ;
				Gen => attr.s ! Gen ++ noun.s ! Gen ;
				Acc => attr.s ! Gen ++ noun.s ! Acc ;
				Loc => attr.s ! Gen ++ noun.s ! Loc
			} ;
			g = noun.g
		} ;

		--------------------------------------------------------------------------------------------

		mkVar : Str -> Variable = \var -> {
			s = table {
				Nom => var + "-s" ;
				Gen => var + "-a" ;
				Acc => var + "-u" ;
				Loc => var + "-ā"
			}
		} ;

		--------------------------------------------------------------------------------------------

		mkCop : Copula = table {
			Pos => "ir" ;
			Neg => "nav"
		} ;

		--------------------------------------------------------------------------------------------

		mkVerb : Str -> VerbType -> Verb = \verb,type ->
			let	obj : Case = case type of {
				Obj => Acc ;
				Place => Loc
			}
			in {
				s = \\_ => table {
					Pos => verb ;
					Neg => "ne" + verb
				} ;
				a = let stem : Str = case verb of {
					s + "a" => s ;
					s + ("ē" | "o") => s + "j" ;
					_ => verb
				}
				in table {
					Masc => table {
						Nom => table {
							Pos => stem + "ošais" ;
							Neg => "ne" + stem + "ošais"
						} ;
						Gen => table {
							Pos => stem + "ošā" ;
							Neg => "ne" + stem + "ošā"
						} ;
						Acc => table {
							Pos => stem + "ošo" ;
							Neg => "ne" + stem + "ošo"
						} ;
						Loc => table {
							Pos => stem + "ošajā" ;
							Neg => "ne" + stem + "ošajā"
						}
					} ;
					Fem => table {
						Nom => table {
							Pos => stem + "ošā" ;
							Neg => "ne" + stem + "ošā"
						} ;
						Gen => table {
							Pos => stem + "ošās" ;
							Neg => "ne" + stem + "ošās"
						} ;
						Acc => table {
							Pos => stem + "ošo" ;
							Neg => "ne" + stem + "ošo"
						} ;
						Loc => table {
							Pos => stem + "ošajā" ;
							Neg => "ne" + stem + "ošajā"
						}
					}
				} ;
				o = obj
			} ;

		--------------------------------------------------------------------------------------------

		mkPart_Obj : Str -> Participle = \lemma ->
			let	stem : Str = case lemma of {
				s + "is" => s ;
				_ => lemma
			}
			in {
				s = table {
					Masc => stem + "is" ;
					Fem => stem + "usi"
				} ;
				a = table {
					Masc => table {
						Nom => table {
							Pos => stem + "ušais" ;
							Neg => "ne" + stem + "ušais"
						} ;
						Gen => table {
							Pos => stem + "ušā" ;
							Neg => "ne" + stem + "ušā"
						} ;
						Acc => table {
							Pos => stem + "ušo" ;
							Neg => "ne" + stem + "ušo"
						} ;
						Loc => table {
							Pos => stem + "ušajā" ;
							Neg => "ne" + stem + "ušajā"
						}
					} ;
					Fem => table {
						Nom => table {
							Pos => stem + "ušā" ;
							Neg => "ne" + stem + "ušā"
						} ;
						Gen => table {
							Pos => stem + "ušās" ;
							Neg => "ne" + stem + "ušās"
						} ;
						Acc => table {
							Pos => stem + "ušo" ;
							Neg => "ne" + stem + "ušo"
						} ;
						Loc => table {
							Pos => stem + "ušajā" ;
							Neg => "ne" + stem + "ušajā"
						}
					}
				}
			} ;

		mkPart_Obj_Full : Str -> Verb = \lemma -> {
			s = table {
				Masc => table {
					Pos => "ir" ++ (mkPart_Obj lemma).s ! Masc ;
					Neg => "nav" ++ (mkPart_Obj lemma).s ! Masc
				} ;
				Fem => table {
					Pos => "ir" ++ (mkPart_Obj lemma).s ! Fem ;
					Neg => "nav" ++ (mkPart_Obj lemma).s ! Fem
				}
			} ;
			a =(mkPart_Obj lemma).a ;
			o = Acc
		} ;

		mkPart_Obj_Reduced : Str -> Verb = \lemma -> {
			s = table {
				Masc => table {
					Pos => (mkPart_Obj lemma).s ! Masc ;
					Neg => "nav" ++ (mkPart_Obj lemma).s ! Masc
				} ;
				Fem => table {
					Pos => (mkPart_Obj lemma).s ! Masc ;
					Neg => "nav" ++ (mkPart_Obj lemma).s ! Fem
				}
			} ;
			a = (mkPart_Obj lemma).a ;
			o = Acc
		} ;

		--------------------------------------------------------------------------------------------

		mkPart_Place : Str -> Participle = \lemma ->
			let	stem : Str = case lemma of {
				s + "ts" => s ;
				_ => lemma
			}
			in {
				s = table {
					Masc => stem + "ts" ;
					Fem => stem + "ta"
				} ;
				a = table {
					Masc => table {
						Nom => table {
							Pos => stem + "tais" ;
							Neg => "ne" + stem + "tais"
						} ;
						Gen => table {
							Pos => stem + "tā" ;
							Neg => "ne" + stem + "tā"
						} ;
						Acc => table {
							Pos => stem + "to" ;
							Neg => "ne" + stem + "to"
						} ;
						Loc => table {
							Pos => stem + "tajā" ;
							Neg => "ne" + stem + "tajā"
						}
					} ;
					Fem => table {
						Nom => table {
							Pos => stem + "tā" ;
							Neg => "ne" + stem + "tā"
						} ;
						Gen => table {
							Pos => stem + "tās" ;
							Neg => "ne" + stem + "tās"
						} ;
						Acc => table {
							Pos => stem + "to" ;
							Neg => "ne" + stem + "to"
						} ;
						Loc => table {
							Pos => stem + "tajā" ;
							Neg => "ne" + stem + "tajā"
						}
					}
				}
			} ;

		mkPart_Place_Full : Str -> Verb = \lemma -> {
			s = table {
				Masc => table {
					Pos => "ir" ++ (mkPart_Place lemma).s ! Masc ;
					Neg => "nav" ++ (mkPart_Place lemma).s ! Masc
				} ;
				Fem => table {
					Pos => "ir" ++ (mkPart_Place lemma).s ! Fem ;
					Neg => "nav" ++ (mkPart_Place lemma).s ! Fem
				}
			} ;
			a = (mkPart_Place lemma).a ;
			o = Loc
		} ;

		mkPart_Place_Reduced : Str -> Verb = \lemma -> {
			s = table {
				Masc => table {
					Pos => (mkPart_Place lemma).s ! Masc ;
					Neg => "nav" ++ (mkPart_Place lemma).s ! Masc
				} ;
				Fem => table {
					Pos => (mkPart_Place lemma).s ! Fem ;
					Neg => "nav" ++ (mkPart_Place lemma).s ! Fem
				}
			} ;
			a = (mkPart_Place lemma).a ;
			o = Loc
		} ;
}
