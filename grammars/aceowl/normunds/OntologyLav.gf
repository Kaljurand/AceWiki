---------------------------------------------------------
-- Domain-independent Latvian grammar & function words --
-- Common parameters and functions                     --
---------------------------------------------------------

resource OntologyLav = open ResLav in {
	flags
		coding = utf8 ;
		optimize = all_subs ;

	param
		Restricted = Nonrestr | Restr ;
		RestrType = Rel | Attr ;
		ClassType = Anon | Named ;
		Usage = Expl | Impl ;

	oper
		PolarizedCase : Type = Case => Polarity => Str ;
		RestrictionInfo : Type = {r : Restricted ; t : RestrType} ;

		MainClause : Type = {s : Str} ;
		RelativeClause : Type = {s : Gender => Case => Str ; t : RestrictionInfo} ;
		RelativeVarClause : Type = {s : Str} ;

		XBar : Type = {s : PolarizedCase ; g : Gender ; r : RestrictionInfo} ;
		EBar : Type = {s : PolarizedCase ; g : Gender ; r : RestrictionInfo ; t : ClassType} ;
		NBar : Type = {s : Case => Str ; g : Gender ; r : RestrictionInfo} ;
		DBar : Type = {s : Usage => Case => Str ; g : Gender} ;
		VBar : Type = {s : PolarizedCase ; r : RestrictionInfo} ;

		UniversalPron : Type = {s : Restricted => NongenderedPronoun} ;
		ExistentialPron : Type = {s : NongenderedPronoun} ;

		UniversalDet : Type = {s : GenderedPronoun} ;
		ExistentialDet : Type = {s : Usage => GenderedPronoun} ;
		DefiniteDet : Type = {s : Usage => DemonstrativePronoun} ;
		OnlyDet : Type = Str ;

		RelativeRef : Type = {s : Usage => RelativePronoun} ;
		Conjunction : Type = Str ;

		--------------------------------------------------------------------------------------------

		mkText : MainClause -> MainClause -> MainClause = \stmt1,stmt2 -> {
			s = stmt1.s ++ stmt2.s
		} ;

		--------------------------------------------------------------------------------------------

		mkStmt : Polarity -> Polarity -> XBar -> Verb -> EBar ->
			MainClause = \pol_v,pol_o,subj,verb,obj -> {
				s = subj.s ! Nom ! pol_v ++ mkComma subj.r ++
					verb.s ! subj.g ! pol_v ++ obj.s ! verb.o ! pol_o ++ "."
			} ;

		mkInvStmt : Polarity -> Polarity -> XBar -> Verb -> EBar ->
			MainClause = \pol_v,pol_s,obj,verb,subj -> {
				s = obj.s ! verb.o ! pol_v ++ mkComma obj.r ++
					verb.s ! subj.g ! pol_v ++ subj.s ! Nom ! pol_s ++ "."
			} ;

		--------------------------------------------------------------------------------------------

		mkGen : Polarity -> XBar -> Copula -> NBar -> MainClause = \pol,subj,cop,compl -> {
			s = subj.s ! Nom ! pol ++ mkComma subj.r ++ cop ! pol ++ compl.s ! Nom ++ "."
		} ;

		mkAnonGen : Polarity -> Polarity -> XBar -> Copula -> XBar ->
			MainClause = \pol_v,pol_c,subj,cop,compl -> {
			s = subj.s ! Nom ! pol_v ++ mkComma subj.r ++
				cop ! pol_v ++ compl.s ! Nom ! pol_c ++ "."
		} ;

		--------------------------------------------------------------------------------------------

		mkRoleStmt : Polarity -> XBar -> Copula -> NBar -> EBar ->
			MainClause = \pol,subj,cop,nbar,obj -> {
				s = subj.s ! Gen ! pol ++ mkComma subj.r ++
					nbar.s ! Nom ++ mkComma nbar.r ++ cop ! pol ++ obj.s ! Nom ! pol ++ "."
			} ;

		mkInvRoleStmt : Polarity -> XBar -> Copula -> NBar -> EBar ->
			MainClause = \pol,obj,cop,nbar,subj -> {
				s = obj.s ! Nom ! pol ++ mkComma obj.r ++
					cop ! pol ++ subj.s ! Gen ! pol ++ mkComma subj.r ++ nbar.s ! Nom ++ "."
			} ;

		--------------------------------------------------------------------------------------------

		mkRule : XBar -> Verb -> XBar -> MainClause = \subj,pred,obj -> {
			s = subj.s ! Nom ! Pos ++ mkComma subj.r ++
				pred.s ! subj.g ! Pos ++ obj.s ! pred.o ! Pos ++ "."
		} ;

		mkInvRule : XBar -> Verb -> XBar -> MainClause = \obj,pred,subj -> {
			s = obj.s ! pred.o ! Pos ++ mkComma obj.r ++
				pred.s ! subj.g ! Pos ++ subj.s ! Nom ! Pos ++ "."
		} ;

		--------------------------------------------------------------------------------------------

		mkQuery : NBar -> MainClause = \subj -> {
			s = case subj.r.r of {
				Restr => "vai ir" ++ (mkPron_Gend "kāds") ! subj.g ! Nom ! Pos ++
						 subj.s ! Nom ++ "?" ;
				Nonrestr => variants {}
			}
		} ;

		mkAnonQuery : XBar -> MainClause = \subj -> {
			s = case subj.r.r of {
				Restr => "vai ir" ++ subj.s ! Nom ! Pos ++ "?" ;
				Nonrestr => variants {}
			}
		} ;

		--------------------------------------------------------------------------------------------

		mkCoordRestr : RelativeClause -> Conjunction -> RelativeClause ->
			RelativeClause = \rel_1,conj,rel_2 -> {
				s = \\g,c => rel_1.s ! g ! c ++ mkComma rel_1.t ++ conj ++ rel_2.s ! g ! c ;
				t = {
					r = rel_2.t.r ;
					t = case rel_1.t.t of {
						Rel => Rel ;
						Attr => case rel_2.t.t of {
							Rel => Rel ;
							Attr => Attr
						}
					}
				}
			} ;

		--------------------------------------------------------------------------------------------

		mkRestr_Named : Polarity -> Polarity -> RelativeRef -> Verb -> EBar ->
			RelativeClause = \pol_v,pol_o,pron,verb,obj -> {
				s = \\g,_ => pron.s ! Expl ! g ! Nom ++
							 verb.s ! g ! pol_v ++ obj.s ! verb.o ! pol_o ;
				t = {r = obj.r.r ; t = Rel}
			} ;

		mkRestr_Anon : Polarity -> Polarity -> RelativeRef -> Verb -> EBar ->
			RelativeClause = \pol_v,pol_o,pron,verb,obj -> {
				s = \\g,_ => pron.s ! Expl ! g ! Nom ++
							 obj.s ! verb.o ! pol_o ++ verb.s ! g ! pol_v ;
				t = {r = obj.r.r ; t = Rel}
			} ;

		mkRestr_Attr : Polarity -> Polarity -> RelativeRef -> Verb -> EBar ->
			RelativeClause = \pol_v,pol_o,pron,verb,obj -> {
				s = \\g,c => pron.s ! Impl ! g ! Nom ++
							 obj.s ! verb.o ! pol_o ++ verb.a ! g ! c ! pol_v ;
				t = {r = obj.r.r ; t = Attr}
			} ;

		--------------------------------------------------------------------------------------------

		mkInvRestr_Named : Polarity -> Polarity -> RelativeRef -> Verb -> EBar ->
			RelativeClause = \pol_v,pol_s,pron,verb,subj -> {
				s = \\g,_ => pron.s ! Expl ! g ! verb.o ++
							 verb.s ! subj.g ! pol_v ++ subj.s ! Nom ! pol_s ;
				t = {r = subj.r.r ; t = Rel}
			} ;

		mkInvRestr_Anon : Polarity -> Polarity -> RelativeRef -> Verb -> EBar ->
			RelativeClause = \pol_v,pol_s,pron,verb,subj -> {
				s = \\g,_ => pron.s ! Expl ! g ! verb.o ++
							 subj.s ! Nom ! pol_s ++ verb.s ! subj.g ! pol_v ;
				t = {r = subj.r.r ; t = Rel}
			} ;

		--------------------------------------------------------------------------------------------

		mkAnaphRestr_Left : Polarity -> Usage -> RelativeRef -> Verb -> DBar ->
			RelativeClause = \pol,det,pron,verb,noun -> {
				s = \\g,_ => pron.s ! Expl ! g ! Nom ++
							 noun.s ! det ! verb.o ++ verb.s ! g ! pol ;
				t = {r = Nonrestr ; t = Rel}
			} ;

		mkAnaphRestr_Right : Polarity -> RelativeRef -> Verb -> DBar ->
			RelativeClause = \pol,pron,verb,noun -> {
				s = \\g,_ => pron.s ! Expl ! g ! Nom ++
							 verb.s ! g ! pol ++ noun.s ! Expl ! verb.o ;
				t = {r = Nonrestr ; t = Rel}
			} ;

		mkAnaphRestr_Attr : Polarity -> RelativeRef -> Verb -> DBar ->
			RelativeClause = \pol,pron,verb,noun -> {
				s = \\g,c => pron.s ! Impl ! g ! Nom ++
							 noun.s ! Expl ! verb.o ++ verb.a ! g ! c ! pol ;
				t = {r = Nonrestr ; t = Attr}
			} ;

		--------------------------------------------------------------------------------------------

		mkInvAnaphRestr_Left : Polarity -> Usage -> RelativeRef -> Verb -> DBar ->
			RelativeClause = \pol,det,pron,verb,noun -> {
				s = \\g,_ => pron.s ! Expl ! g ! verb.o ++
							 noun.s ! det ! Nom ++ verb.s ! noun.g ! pol ;
				t = {r = Nonrestr ; t = Rel}
			} ;

		mkInvAnaphRestr_Right : Polarity -> RelativeRef -> Verb -> DBar ->
			RelativeClause = \pol,pron,verb,noun -> {
				s = \\g,_ => pron.s ! Expl ! g ! verb.o ++
							 verb.s ! noun.g ! pol ++ noun.s ! Expl ! Nom ;
				t = {r = Nonrestr ; t = Rel}
			} ;

		--------------------------------------------------------------------------------------------

		mkRoleRestr : Polarity -> RelativeRef -> Copula -> NBar -> EBar ->
			RelativeClause = \pol,pron,cop,nbar,obj -> {
				s = \\g,_ => pron.s ! Expl ! g ! Gen ++
							 nbar.s ! Nom ++ mkComma nbar.r ++ cop ! pol ++ obj.s ! Nom ! pol ;
				t = {r = obj.r.r ; t = Rel}
			} ;

		mkInvRoleRestr : Polarity -> RelativeRef -> Copula -> NBar -> EBar ->
			RelativeClause = \pol,pron,cop,nbar,subj -> {
				s = \\g,_ => pron.s ! Expl ! g ! Nom ++
							 cop ! pol ++ subj.s ! Gen ! pol ++ nbar.s ! Nom ;
				t = {r = subj.r.r ; t = Rel}
			} ;

		--------------------------------------------------------------------------------------------

		mkGenRestr : Polarity -> RelativeRef -> Copula -> NBar ->
			RelativeClause = \pol,pron,cop,noun -> {
				s = \\g,_ => pron.s ! Expl ! g ! Nom ++ cop ! pol ++ noun.s ! Nom ;
				t = {r = noun.r.r ; t = Rel}
			} ;

		--------------------------------------------------------------------------------------------

		mkXBar : XBar -> XBar = \xbar -> {
			s = \\c,pol => xbar.s ! c ! pol ;
			g = xbar.g ;
			r = xbar.r
		} ;

		mkEBar : ClassType -> XBar -> EBar = \type,xbar -> {
			s = \\c,pol => xbar.s ! c ! pol ;
			g = xbar.g ;
			r = xbar.r ;
			t = type
		} ;

		mkDBar : DefiniteDet -> NBar -> DBar = \the,noun -> {
			s = case noun.r.r of {
				Restr => variants {} ;
				Nonrestr => \\det,c => the.s ! det ! noun.g ! c ++ noun.s ! c
			} ;
			g = noun.g
		} ;

		--------------------------------------------------------------------------------------------

		mkUnivThing : UniversalPron -> XBar = \thing -> {
			s = \\c,pol => thing.s ! Nonrestr ! c ! pol ;
			g = Masc ;
			r = {r = Nonrestr ; t = Rel}
		} ;

		mkRestrUnivThing : UniversalPron -> RelativeClause -> XBar = \thing,rel -> {
			s = \\c,pol => thing.s ! Restr ! c ! pol ++ "," ++ rel.s ! Masc ! c ;
			g = Masc ;
			r = {r = Restr ; t = Rel}
		} ;

		mkExistThing : ExistentialPron -> XBar = \thing -> {
			s = \\c,pol => thing.s ! c ! pol ;
			g = Masc ;
			r = {r = Nonrestr ; t = Rel}
		} ;

		mkRestrExistThing : ExistentialPron -> RelativeClause -> XBar = \thing,rel -> {
			s = \\c,pol => thing.s ! c ! pol ++ "," ++ rel.s ! Masc ! c ;
			g = Masc ;
			r = {r = Restr ; t = Rel}
		} ;

		mkRestrOnlyThing : OnlyDet -> ExistentialPron -> RelativeClause ->
			XBar = \nb,thing,rel -> {
				s = \\c,pol => nb ++ thing.s ! c ! pol ++ "," ++ rel.s ! Masc ! c ;
				g = Masc ;
				r = {r = Restr ; t = Rel}
			} ;

		--------------------------------------------------------------------------------------------

		mkUnivRole : XBar -> UniversalDet -> NBar -> XBar = \xbar,all,nbar -> {
			s = \\c,pol => xbar.s ! Gen ! pol ++ mkComma xbar.r ++
						   all.s ! nbar.g ! c ! pol ++ nbar.s ! c ;
			g = nbar.g ;
			r = nbar.r
		} ;

		mkExistRoleStr : XBar -> Usage -> ExistentialDet -> NBar ->
			PolarizedCase = \xbar,det,ex,nbar ->
				\\c,pol => xbar.s ! Gen ! pol ++ mkComma xbar.r ++
						   ex.s ! det ! nbar.g ! c ! pol ++ nbar.s ! c ;

		--------------------------------------------------------------------------------------------

		mkUnivClass : UniversalDet -> NBar -> XBar = \all,nbar -> {
			s = \\c,pol => all.s ! nbar.g ! c ! pol ++ nbar.s ! c ;
			g = nbar.g ;
			r = nbar.r
		} ;

		mkExistClassStr : Usage -> ExistentialDet -> NBar -> PolarizedCase = \det,ex,nbar ->
			\\c,pol => ex.s ! det ! nbar.g ! c ! pol ++ nbar.s ! c ;

		mkOnlyClass : OnlyDet -> NBar -> XBar = \nb,nbar -> {
			s = \\c,_ => nb ++ nbar.s ! c ;
			g = nbar.g ;
			r = nbar.r
		} ;

		--------------------------------------------------------------------------------------------

		mkClass : Noun -> NBar = \noun -> {
			s = \\c => noun.s ! c ;
			g = noun.g ;
			r = {r = Nonrestr ; t = Rel}
		} ;

		mkRestrVarRole : Noun -> RelativeVarClause -> NBar = \noun,rel -> {
			s = \\c => noun.s ! c ++ "," ++ rel.s ;
			g = noun.g ;
			r = {r = Restr ; t = Rel}
		} ;

		--------------------------------------------------------------------------------------------

		mkVarCl : Polarity -> Polarity -> VBar -> Verb -> VBar ->
			MainClause = \pol_v,pol_o,subj,verb,obj -> {
				s = subj.s ! Nom ! pol_v ++ mkComma subj.r ++
				verb.s ! Masc ! pol_v ++ obj.s ! verb.o ! pol_o
			} ;

		mkCoordVarCl : MainClause -> Conjunction -> MainClause ->
			MainClause = \cl_1,conj,cl_2 -> {
				s = cl_1.s ++ conj ++ cl_2.s
			} ;

		mkInvVarCl : Polarity -> Polarity -> VBar -> Verb -> VBar ->
			MainClause = \pol_v,pol_s,obj,verb,subj -> {
				s = obj.s ! verb.o ! pol_v ++ mkComma obj.r ++
					verb.s ! Masc ! pol_v ++ subj.s ! Nom ! pol_s
			} ;

		mkInvVarRoleCl : Polarity -> VBar -> Copula -> NBar -> VBar ->
			MainClause = \pol,obj,cop,nbar,subj -> {
				s = obj.s ! Nom ! pol ++ mkComma obj.r ++
					cop ! pol ++ subj.s ! Gen ! pol ++ mkComma subj.r ++ nbar.s ! Nom
			} ;

		--------------------------------------------------------------------------------------------

		mkCoordVarRestr : RelativeVarClause -> Conjunction -> RelativeVarClause ->
			RelativeVarClause = \rel_1,conj,rel_2 -> {
				s = rel_1.s ++ conj ++ rel_2.s
			} ;

		mkVarRestr : Polarity -> Polarity -> RelativeRef -> Verb -> VBar ->
			RelativeVarClause = \pol_v,pol_o,pron,verb,obj -> {
				s = pron.s ! Expl ! Masc ! Nom ++ verb.s ! Masc ! pol_v ++ obj.s ! verb.o ! pol_o
			} ;

		mkInvVarRestr : Polarity -> Polarity -> RelativeRef -> Verb -> VBar ->
			RelativeVarClause = \pol_v,pol_s,pron,verb,subj -> {
				s = pron.s ! Expl ! Masc ! verb.o ++ verb.s ! Masc ! pol_v ++ subj.s ! Nom ! pol_s
			} ;

		mkInvVarRoleRestr : Polarity -> RelativeRef -> Copula -> NBar -> VBar ->
			RelativeVarClause = \pol,pron,cop,nbar,subj -> {
				s = pron.s ! Expl ! Masc ! Nom ++
					cop ! pol ++ subj.s ! Gen ! pol ++ mkComma subj.r ++ nbar.s ! Nom
			} ;

		--------------------------------------------------------------------------------------------

		mkDefVar : Variable -> VBar = \var -> {
			s = \\c,_ => var.s ! c ;
			r = {r = Nonrestr ; t = Rel}
		} ;

		mkDefRestrVar : Variable -> RelativeVarClause -> VBar = \var,rel -> {
			s = \\c,_ => var.s ! c ++ "," ++ rel.s ;
			r = {r = Restr ; t = Rel}
		} ;

		mkIndefVar : ExistentialPron -> VBar = \thing -> {
			s = \\c,pol => thing.s ! c ! pol ;
			r = {r = Nonrestr ; t = Rel}
		} ;

		mkIndefRestrVar : ExistentialPron -> RelativeVarClause -> VBar = \thing,rel -> {
			s = \\c,pol => thing.s ! c ! pol ++ "," ++ rel.s ;
			r = {r = Restr ; t = Rel}
		} ;

		--------------------------------------------------------------------------------------------

		mkEx : ExistentialDet = {
			s = table {
				Expl => mkPron_Gend "kāds" ;
				Impl => mkPron_Gend_Empty
			}
		} ;

		--------------------------------------------------------------------------------------------

		mkComma : RestrictionInfo -> Str = \restr ->
			case restr.r of {
				Restr => case restr.t of {
					Rel => "," ;
					Attr => []
				} ;
				Nonrestr => []
			} ;
}
