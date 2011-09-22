---------------------------------------------------------
-- Domain-independent English grammar & function words --
-- Default linearization                               --
---------------------------------------------------------

concrete OntologyEngDef of Ontology = open OntologyEng, ResEng in {
	flags
		optimize = all_subs ;

	oper
		mkInvRoleStmt : Polarity -> ABar -> Copula -> NBar -> EBar ->
			MainClause = \pol,subj,cop,pred,obj ->
				subj.s ! pol ++
				cop ! Is ! Pos ! Sg ++ mkEx ! pred.a ++ pred.s ! Sg ++ "of" ++ obj.s ++ "." ;

		mkRoleRestr : Polarity -> RelativeRef -> Copula -> NBar -> EBar ->
			RelativeClause = \pol,pron,cop,pred,obj ->
				\\num => pron ++ cop ! Has ! pol ! num ++
						 obj.s ++ "as" ++ mkEx ! pred.a ++ pred.s ! Sg ;

		mkInvRoleRestr : Polarity -> RelativeRef -> Copula -> NBar -> EBar ->
			RelativeClause = \pol,pron,cop,pred,obj ->
				\\num => pron ++ cop ! Is ! pol ! num ++
						 mkEx ! pred.a ++ pred.s ! Sg ++ "of" ++ obj.s ;

		mkInvVarRoleCl : Polarity -> VBar -> Copula -> NBar -> VBar ->
			MainClause = \pol,subj,cop,pred,obj ->
				subj ++ cop ! Is ! pol ! Sg ++ mkEx ! pred.a ++ pred.s ! Sg ++ "of" ++ obj ;

		mkInvVarRoleRestr : Polarity -> RelativeRef -> Copula -> NBar -> VBar ->
			RelativeClause = \pol,pron,cop,pred,obj ->
				\\num => pron ++ cop ! Is ! pol ! num ++
						 mkEx ! pred.a ++ pred.s ! Sg ++ "of" ++ obj ;

	lincat
		S, VCl = MainClause ;
		R, VR = RelativeClause ;

		A_Bar, AT_Bar, AC_Bar, AL_Bar = ABar ;
		E_Bar, ET_Bar, EC_Bar, EL_Bar = EBar ;
		D_Bar = DBar ;
		V_Bar = VBar ;

		C_Bar, L_Bar, VL_Bar = NBar ;
		C, PN = Noun ;

		AllT = UniversalPron ;
		ExT = ExistentialPron ;

		All = UniversalDet ;
		Ex = ExistentialDet ;
		Def = DefiniteDet ;
		NoBut = OnlyDet ;

		Ref = RelativeRef ;
		Conj = Conjunction ;
		Var = Variable ;

		Cop = Copula ;
		P = Verb ;

	lin
		--Specification stmt1 stmt2 = mkText stmt1 stmt2 ;

		--------------------------------------------------------------------------------------------

		Statement subj pred obj = mkStmt Act Pos subj pred obj ;
		InverseStatement subj pred obj = mkStmt Pass Pos subj pred obj ;

		NegatedStatement subj pred obj = mkStmt Act Neg subj pred obj ;
		InverseNegatedStatement subj pred obj = mkStmt Pass Neg subj pred obj ;

		--------------------------------------------------------------------------------------------

		Generalization subj cop compl = mkGen Pos subj cop compl ;
		NegatedGeneralization subj cop compl = mkGen Neg subj cop compl ;

		AnonymousGeneralization subj cop compl = mkAnonGen Pos subj cop compl ;
		NegatedAnonymousGeneralization subj cop compl = mkAnonGen Neg subj cop compl ;

		--------------------------------------------------------------------------------------------

		RoleStatement subj cop pred obj = mkRoleStmt Pos subj cop pred obj ;
		InverseRoleStatement subj cop pred obj = mkInvRoleStmt Pos subj cop pred obj ;

		NegatedRoleStatement subj cop pred obj = mkRoleStmt Neg subj cop pred obj ;
		InverseNegatedRoleStatement subj cop pred obj = mkInvRoleStmt Neg subj cop pred obj ;

		--------------------------------------------------------------------------------------------

		ConditionalStatement if then = mkCondStmt if then ;

		--------------------------------------------------------------------------------------------

		Rule subj pred obj = mkRule Act subj pred obj ;
		InverseRule subj pred obj = mkRule Pass subj pred obj ;

		--------------------------------------------------------------------------------------------

		Query subj = mkQuery subj ;
		AnonymousQuery subj = mkAnonQuery subj ;

		--------------------------------------------------------------------------------------------

		CoordinatedRestriction rel_1 conj rel_2 = mkCoordRestr rel_1 conj rel_2 ;

		Restriction pron pred obj = mkRestr Act Pos pron pred obj ;
		InverseRestriction pron pred obj = mkRestr Pass Pos pron pred obj ;

		AnaphoricRestriction pron pred obj = mkRestr Act Pos pron pred obj ;
		InverseAnaphoricRestriction pron pred obj = mkRestr Pass Pos pron pred obj ;

		RoleRestriction pron cop pred obj = mkRoleRestr Pos pron cop pred obj ;
		InverseRoleRestriction pron cop pred obj = mkInvRoleRestr Pos pron cop pred obj ;

		NegatedRestriction pron pred obj = mkRestr Act Neg pron pred obj ;
		InverseNegatedRestriction pron pred obj = mkRestr Pass Neg pron pred obj ;

		NegatedAnaphoricRestriction pron pred obj = mkRestr Act Neg pron pred obj ;
		InverseNegatedAnaphoricRestriction pron pred obj = mkRestr Pass Neg pron pred obj ;

		NegatedRoleRestriction pron cop pred obj = mkRoleRestr Neg pron cop pred obj ;
		InverseNegatedRoleRestriction pron cop pred obj = mkInvRoleRestr Neg pron cop pred obj ;

		RestrictionByGeneralization pron cop compl = mkGenRestr Pos pron cop compl ;
		NegatedRestrictionByGeneralization pron cop compl = mkGenRestr Neg pron cop compl ;

		--------------------------------------------------------------------------------------------

		UniversalQuantification nbar = mkABar nbar ;
		AnonymousUniversalQuantification pbar = mkABar pbar ;

		ExistentialQuantification nbar = mkEBar nbar ;
		AnonymousExistentialQuantification pbar = mkEBar pbar ;

		UniversalRoleQuantification nbar = mkABar nbar ;
		ExistentialRoleQuantification nbar = mkEBar nbar ;

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

		--------------------------------------------------------------------------------------------

		Anaphor the nbar = mkDBar the nbar ;

		--------------------------------------------------------------------------------------------

		Role noun = mkClass noun ;
		RestrictedRole noun rel = mkRestrClass noun rel ;

		Class noun = mkClass noun ;
		RestrictedClass noun rel = mkRestrClass noun rel ;

		--------------------------------------------------------------------------------------------

		CoordinatedVariableClause cl_1 conj cl_2 = mkCoordVarCl cl_1 conj cl_2 ;

		VariableClause subj pred obj = mkVarCl Act Pos subj pred obj ;
		InverseVariableClause subj pred obj = mkVarCl Pass Pos subj pred obj ;

		InverseVariableRoleClause subj cop pred obj = mkInvVarRoleCl Pos subj cop pred obj ;

		NegatedVariableClause subj pred obj = mkVarCl Act Neg subj pred obj ;
		InverseNegatedVariableClause subj pred obj = mkVarCl Pass Neg subj pred obj ;

		InverseNegatedVariableRoleClause subj cop pred obj = mkInvVarRoleCl Neg subj cop pred obj ;

		--------------------------------------------------------------------------------------------

		CoordinatedVariableRestriction rel_1 conj rel_2 = mkCoordRestr rel_1 conj rel_2 ;

		VariableRestriction pron pred obj = mkVarRestr Act Pos pron pred obj ;
		InverseVariableRestriction pron pred obj = mkVarRestr Pass Pos pron pred obj ;

		InverseVariableRoleRestriction pron cop pred obj =
			mkInvVarRoleRestr Pos pron cop pred obj ;

		NegatedVariableRestriction pron pred obj = mkVarRestr Act Neg pron pred obj ;
		InverseNegatedVariableRestriction pron pred obj = mkVarRestr Pass Neg pron pred obj ;

		InverseNegatedVariableRoleRestriction pron cop pred obj =
			mkInvVarRoleRestr Neg pron cop pred obj ;

		--------------------------------------------------------------------------------------------

		DefiniteVariable var = mkVar var ;
		DefiniteRestrictedVariable var rel = mkRestrVar var rel ;

		IndefiniteVariable thing = mkIndefVar thing ;
		IndefiniteRestrictedVariable thing rel = mkIndefRestrVar thing rel ;

		VariableRole noun = mkClass noun ;
		--RestrictedVariableRole noun rel = mkRestrClass noun rel ;

		--------------------------------------------------------------------------------------------

		Everything = mkAllT ;
		Something = mkExT ;

		Every = mkAll ;
		Some = mkEx ;
		Definite = "the" ;
		Only = "nothing but" ;

		Link = "that" ;

		isA = mkCop ;

		And = "and" ;
		Or = "or" ;

		X = "X" ;
		Y = "Y" ;
		Z = "Z" ;
}
