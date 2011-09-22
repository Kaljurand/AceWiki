---------------------------------------------------------
-- Domain-independent Latvian grammar & function words --
-- Free variation                                      --
---------------------------------------------------------

concrete OntologyLavVar of Ontology = open OntologyLav, ResLavVar, ResLav in {
	flags
		coding = utf8 ;
		optimize = all_subs ;

	oper
		mkCondStmt : MainClause -> MainClause -> MainClause = \if,then -> {
			s = "ja" ++ if.s ++ "," ++ ("tad" | []) ++ then.s ++ "."
		} ;

		--------------------------------------------------------------------------------------------

		mkRestr : Polarity -> Polarity -> RelativeRef -> Verb -> EBar ->
			RelativeClause = \pol_v,pol_o,pron,verb,obj ->
				case obj.r.r of {
					Restr => mkRestr_Named pol_v pol_o pron verb obj ;
					Nonrestr => case obj.t of {
						Named => mkRestr_Named pol_v pol_o pron verb obj |
								 mkRestr_Attr pol_v pol_o pron verb obj ;
						Anon => mkRestr_Anon pol_v pol_o pron verb obj |
								mkRestr_Named pol_v pol_o pron verb obj |
								mkRestr_Attr pol_v pol_o pron verb obj
					}
				} ;

		mkInvRestr : Polarity -> Polarity -> RelativeRef -> Verb -> EBar ->
			RelativeClause = \pol_v,pol_s,pron,verb,subj ->
				case subj.r.r of {
					Restr => mkInvRestr_Named pol_v pol_s pron verb subj ;
					Nonrestr => case subj.t of {
						Named => mkInvRestr_Named pol_v pol_s pron verb subj ;
						Anon => mkInvRestr_Anon pol_v pol_s pron verb subj |
								mkInvRestr_Named pol_v pol_s pron verb subj
					}
				} ;

		mkAnaphRestr : Polarity -> RelativeRef -> Verb -> DBar ->
			RelativeClause = \pol,pron,verb,noun ->
				mkAnaphRestr_Left pol (Expl|Impl) pron verb noun |
				mkAnaphRestr_Right pol pron verb noun |
				mkAnaphRestr_Attr pol pron verb noun ;

		mkInvAnaphRestr : Polarity -> RelativeRef -> Verb -> DBar ->
			RelativeClause = \pol,pron,verb,noun ->
				mkInvAnaphRestr_Left pol (Expl|Impl) pron verb noun |
				mkInvAnaphRestr_Right pol pron verb noun ;

		--------------------------------------------------------------------------------------------

		mkExistRole : XBar -> ExistentialDet -> NBar -> XBar = \xbar,ex,nbar -> {
			s = case nbar.r.r of {
				Restr => mkExistRoleStr xbar (Impl|Expl) ex nbar ;
				Nonrestr => mkExistRoleStr xbar (Expl|Impl) ex nbar
			} ;
			g = nbar.g ;
			r = nbar.r
		} ;

		mkExistClass : ExistentialDet -> NBar -> XBar = \ex,nbar -> {
			s = case nbar.r.r of {
				Restr => mkExistClassStr (Impl|Expl) ex nbar ;
				Nonrestr => mkExistClassStr (Expl|Impl) ex nbar
			} ;
			g = nbar.g ;
			r = nbar.r
		} ;

		mkRestrClass : Noun -> RelativeClause -> NBar = \noun,rel -> {
			s = \\c => case rel.t.t of {
				Rel => noun.s ! c ++ "," ++ rel.s ! noun.g ! c ;
				Attr => rel.s ! noun.g ! c ++ noun.s ! c
			} ;
			g = noun.g ;
			r = {r = Restr ; t = rel.t.t}
		} ;

		--------------------------------------------------------------------------------------------

		mkAllT : UniversalPron = {
			s = table {
				Nonrestr => mkPron_Nongend "jebkas" |
							(mkPron_Gend ("ikviens" | "katrs" | "viss")) ! Masc ;
				Restr => mkPron_Nongend "tas" | mkPron_Nongend "jebkas" |
						 (mkPron_Gend ("ikviens" | "katrs" | "viss")) ! Masc
			}
		} ;

		mkExT : ExistentialPron = {
			s = mkPron_Nongend "kaut" (mkPron_Nongend "kas") | (mkPron_Gend "kāds") ! Masc
		} ;

		mkAll : UniversalDet = {
			s = mkPron_Gend ("ikviens" | "katrs")
		} ;

		mkDef : DefiniteDet = {
			s = table {
				Expl => mkPron_Demonstr (DemonstrThis | DemonstrThat) ;
				Impl => mkPron_Demonstr_Empty
			}
		} ;

		mkRef : RelativeRef = {
			s = table {
				Expl => mkPron_Rel (RelThat | RelWhich) ;
				Impl => mkPron_Rel_Empty
			}
		} ;

	lincat
		S, VCl = MainClause ;
		R = RelativeClause ;
		VR = RelativeVarClause ;

		A_Bar, AT_Bar, ET_Bar, AL_Bar, EL_Bar, AC_Bar, EC_Bar = XBar ;
		E_Bar = EBar ;
		D_Bar = DBar ;
		V_Bar = VBar ;

		C_Bar, L_Bar, VL_Bar = NBar ;
		C, PN = Noun ;

		AllT = UniversalPron ;
		ExT = ExistentialPron ;

		Var = Variable ;

		All = UniversalDet ;
		Ex = ExistentialDet ;
		Def = DefiniteDet ;
		NoBut = OnlyDet ;

		Ref = RelativeRef ;
		Conj = Conjunction ;

		Cop = Copula ;
		P = Verb ;

	lin
		--Specification stmt1 stmt2 = mkText stmt1 stmt2 ;

		--------------------------------------------------------------------------------------------

		Statement subj pred obj = mkStmt Pos Pos subj pred obj ;
		InverseStatement obj pred subj = mkInvStmt Pos Pos obj pred subj ;

		NegatedStatement subj pred obj = mkStmt Neg (Neg|Pos) subj pred obj ;
		InverseNegatedStatement obj pred subj = mkInvStmt Neg (Neg|Pos) obj pred subj ;

		--------------------------------------------------------------------------------------------

		Generalization subj cop compl = mkGen Pos subj cop compl ;
		NegatedGeneralization subj cop compl = mkGen Neg subj cop compl ;

		AnonymousGeneralization subj cop compl = mkAnonGen Pos Pos subj cop compl ;
		NegatedAnonymousGeneralization subj cop compl = mkAnonGen Neg (Neg|Pos) subj cop compl ;

		--------------------------------------------------------------------------------------------

		RoleStatement subj cop pred obj = mkRoleStmt Pos subj cop pred obj ;
		InverseRoleStatement obj cop pred subj = mkInvRoleStmt Pos obj cop pred subj ;

		NegatedRoleStatement subj cop pred obj = mkRoleStmt Neg subj cop pred obj ;
		InverseNegatedRoleStatement obj cop pred subj = mkInvRoleStmt Neg obj cop pred subj ;

		--------------------------------------------------------------------------------------------

		ConditionalStatement if then = mkCondStmt if then ;

		--------------------------------------------------------------------------------------------

		Rule subj pred obj = mkRule subj pred obj ;
		InverseRule obj pred subj = mkInvRule obj pred subj ;

		--------------------------------------------------------------------------------------------

		Query subj = mkQuery subj ;
		AnonymousQuery subj = mkAnonQuery subj ;

		--------------------------------------------------------------------------------------------

		CoordinatedRestriction rel_1 conj rel_2 = mkCoordRestr rel_1 conj rel_2 ;

		Restriction pron pred obj = mkRestr Pos Pos pron pred obj ;
		InverseRestriction pron pred subj = mkInvRestr Pos Pos pron pred subj ;

		AnaphoricRestriction pron pred obj = mkAnaphRestr Pos pron pred obj ;
		InverseAnaphoricRestriction pron pred subj = mkInvAnaphRestr Pos pron pred subj ;

		RoleRestriction pron cop pred obj = mkRoleRestr Pos pron cop pred obj ;
		InverseRoleRestriction pron cop pred subj = mkInvRoleRestr Pos pron cop pred subj ;

		NegatedRestriction pron pred obj = mkRestr Neg (Neg|Pos) pron pred obj ;
		InverseNegatedRestriction pron pred subj = mkInvRestr Neg (Neg|Pos) pron pred subj ;

		NegatedAnaphoricRestriction pron pred obj = mkAnaphRestr Neg pron pred obj ;
		InverseNegatedAnaphoricRestriction pron pred subj = mkInvAnaphRestr Neg pron pred subj ;

		NegatedRoleRestriction pron cop pred obj = mkRoleRestr Neg pron cop pred obj ;
		InverseNegatedRoleRestriction pron cop pred subj = mkInvRoleRestr Neg pron cop pred subj ;

		RestrictionByGeneralization pron cop compl = mkGenRestr Pos pron cop compl ;
		NegatedRestrictionByGeneralization pron cop compl = mkGenRestr Neg pron cop compl ;

		--------------------------------------------------------------------------------------------

		UniversalQuantification nbar = mkXBar nbar ;
		AnonymousUniversalQuantification pbar = mkXBar pbar ;

		ExistentialQuantification nbar = mkEBar Named nbar ;
		AnonymousExistentialQuantification pbar = mkEBar Anon pbar ;

		UniversalRoleQuantification nbar = mkXBar nbar ;
		ExistentialRoleQuantification nbar = mkEBar Named nbar ;

		--------------------------------------------------------------------------------------------

		UniversalThing thing = mkUnivThing thing ;
		UniversalRestrictedThing thing rel = mkRestrUnivThing thing rel ;

		ExistentialThing thing = mkExistThing thing ;
		ExistentialRestrictedThing thing rel = mkRestrExistThing thing rel ;

		OnlyRestrictedThing nb thing rel = mkRestrOnlyThing nb thing rel ;

		--------------------------------------------------------------------------------------------

		UniversalRole xbar all nbar = mkUnivRole xbar all nbar ;
		ExistentialRole xbar ex nbar = mkExistRole xbar ex nbar ;

		UniversalClass all nbar = mkUnivClass all nbar ;
		ExistentialClass ex nbar = mkExistClass ex nbar ;
		OnlyClass nb nbar = mkOnlyClass nb nbar ;

		Anaphor the noun = mkDBar the noun ;

		--------------------------------------------------------------------------------------------

		Role noun = mkClass noun ;
		RestrictedRole noun rel = mkRestrClass noun rel ;

		Class noun = mkClass noun ;
		RestrictedClass noun rel = mkRestrClass noun rel ;

		--------------------------------------------------------------------------------------------

		CoordinatedVariableClause cl_1 conj cl_2 = mkCoordVarCl cl_1 conj cl_2 ;

		VariableClause subj pred obj = mkVarCl Pos Pos subj pred obj ;
		InverseVariableClause obj pred subj = mkInvVarCl Pos Pos obj pred subj ;

		InverseVariableRoleClause obj cop pred subj = mkInvVarRoleCl Pos obj cop pred subj ;

		NegatedVariableClause subj pred obj = mkVarCl Neg (Neg|Pos) subj pred obj ;
		InverseNegatedVariableClause obj pred subj = mkInvVarCl Neg (Neg|Pos) obj pred subj ;

		InverseNegatedVariableRoleClause obj cop pred subj = mkInvVarRoleCl Neg obj cop pred subj ;

		--------------------------------------------------------------------------------------------

		CoordinatedVariableRestriction rel_1 conj rel_2 = mkCoordVarRestr rel_1 conj rel_2 ;

		VariableRestriction pron pred obj =	mkVarRestr Pos Pos pron pred obj ;
		InverseVariableRestriction pron pred subj = mkInvVarRestr Pos Pos pron pred subj ;

		InverseVariableRoleRestriction pron cop pred subj =
			mkInvVarRoleRestr Pos pron cop pred subj ;

		NegatedVariableRestriction pron pred obj = mkVarRestr Neg (Neg|Pos) pron pred obj ;

		InverseNegatedVariableRestriction pron pred subj =
			mkInvVarRestr Neg (Neg|Pos) pron pred subj ;

		InverseNegatedVariableRoleRestriction pron cop pred subj =
			mkInvVarRoleRestr Neg pron cop pred subj ;

		--------------------------------------------------------------------------------------------

		DefiniteVariable var = mkDefVar var ;
		DefiniteRestrictedVariable var rel = mkDefRestrVar var rel ;

		IndefiniteVariable thing = mkIndefVar thing ;
		IndefiniteRestrictedVariable thing rel = mkIndefRestrVar thing rel ;

		VariableRole noun = mkClass noun ;
		--RestrictedVariableRole noun rel = mkRestrVarRole noun rel ;

		--------------------------------------------------------------------------------------------

		Everything = mkAllT ;
		Something = mkExT ;

		Every = mkAll ;
		Some = mkEx ;
		Definite = mkDef ;
		Only = "tikai" ;

		Link = mkRef ;
		isA = mkCop ;

		And = "un" ;
		Or = "vai" ;

		X = mkVar "X" ;
		Y = mkVar "Y" ;
		Z = mkVar "Z" ;
}
