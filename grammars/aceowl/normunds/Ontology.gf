---------------------------------------------
-- Language- and domain-independent syntax --
---------------------------------------------

abstract Ontology = {
	cat
		S ; R ; VCl ; VR ;
		A_Bar ; AT_Bar ; AC_Bar ; AL_Bar ; E_Bar ; ET_Bar ; EC_Bar ; EL_Bar ;
		C_Bar ; D_Bar ; L_Bar ; V_Bar ; VL_Bar ;
		AllT ; All ; ExT ; Ex ; NoBut ; Def ; Ref ; Conj ; Cop ; Var ; C ; P ; PN ;

	fun
		--Specification : S -> S -> S ;

		--------------------------------------------------------------------------------------------

		Statement : A_Bar -> P -> E_Bar -> S ;
		InverseStatement : A_Bar -> P -> E_Bar -> S ;

		NegatedStatement : A_Bar -> P -> E_Bar -> S ;
		InverseNegatedStatement : A_Bar -> P -> E_Bar -> S ;

		Generalization : A_Bar -> Cop -> C_Bar -> S ;
		NegatedGeneralization : A_Bar -> Cop -> C_Bar -> S ;

		AnonymousGeneralization : A_Bar -> Cop -> ET_Bar -> S ;
		NegatedAnonymousGeneralization : A_Bar -> Cop -> ET_Bar -> S ;

		RoleStatement : A_Bar -> Cop -> L_Bar -> E_Bar -> S ;
		InverseRoleStatement : A_Bar -> Cop -> L_Bar -> E_Bar -> S ;

		NegatedRoleStatement : A_Bar -> Cop -> L_Bar -> E_Bar -> S ;
		InverseNegatedRoleStatement : A_Bar -> Cop -> L_Bar -> E_Bar -> S ;

		ConditionalStatement : VCl -> VCl -> S ;

		--------------------------------------------------------------------------------------------

		Rule : A_Bar -> P -> A_Bar -> S ;
		InverseRule : A_Bar -> P -> A_Bar -> S ;

		--------------------------------------------------------------------------------------------

		Query : C_Bar -> S ;
		AnonymousQuery : ET_Bar -> S ;

		--------------------------------------------------------------------------------------------

		CoordinatedRestriction : R -> Conj -> R -> R ;

		Restriction : Ref -> P -> E_Bar -> R ;
		AnaphoricRestriction : Ref -> P -> D_Bar -> R ;
		RoleRestriction : Ref -> Cop -> L_Bar -> E_Bar -> R ;

		InverseRestriction : Ref -> P -> E_Bar -> R ;
		InverseAnaphoricRestriction : Ref -> P -> D_Bar -> R ;
		InverseRoleRestriction : Ref -> Cop -> L_Bar -> E_Bar -> R ;

		NegatedRestriction : Ref -> P -> E_Bar -> R ;
		NegatedAnaphoricRestriction : Ref -> P -> D_Bar -> R ;
		NegatedRoleRestriction : Ref -> Cop -> L_Bar -> E_Bar -> R ;

		InverseNegatedRestriction : Ref -> P -> E_Bar -> R ;
		InverseNegatedAnaphoricRestriction : Ref -> P -> D_Bar -> R ;
		InverseNegatedRoleRestriction : Ref -> Cop -> L_Bar -> E_Bar -> R ;

		RestrictionByGeneralization : Ref -> Cop -> C_Bar -> R ;
		NegatedRestrictionByGeneralization : Ref -> Cop -> C_Bar -> R ;

		--------------------------------------------------------------------------------------------

		UniversalQuantification : AC_Bar -> A_Bar ;
		AnonymousUniversalQuantification : AT_Bar -> A_Bar ;

		ExistentialQuantification : EC_Bar -> E_Bar ;
		AnonymousExistentialQuantification : ET_Bar -> E_Bar ;

		UniversalRoleQuantification : AL_Bar -> A_Bar ;
		ExistentialRoleQuantification : EL_Bar -> E_Bar ;

		--------------------------------------------------------------------------------------------

		UniversalThing : AllT -> AT_Bar ;
		UniversalRestrictedThing : AllT -> R -> AT_Bar ;

		ExistentialThing : ExT -> ET_Bar ;
		ExistentialRestrictedThing : ExT -> R -> ET_Bar ;

		OnlyRestrictedThing : NoBut -> ExT -> R -> ET_Bar ;

		--------------------------------------------------------------------------------------------

		UniversalRole : A_Bar -> All -> L_Bar -> AL_Bar ;
		ExistentialRole : E_Bar -> Ex -> L_Bar -> EL_Bar ;

		UniversalClass : All -> C_Bar -> AC_Bar ;
		ExistentialClass : Ex -> C_Bar -> EC_Bar ;
		OnlyClass : NoBut -> C_Bar -> EC_Bar ;

		Anaphor : Def -> C_Bar -> D_Bar ;

		--------------------------------------------------------------------------------------------

		Role : PN -> L_Bar ;
		RestrictedRole : PN -> R -> L_Bar ;

		Class : C -> C_Bar ;
		RestrictedClass : C -> R -> C_Bar ;

		--------------------------------------------------------------------------------------------

		CoordinatedVariableClause : VCl -> Conj -> VCl -> VCl ;

		VariableClause : V_Bar -> P -> V_Bar -> VCl ;
		InverseVariableClause : V_Bar -> P -> V_Bar -> VCl ;

		InverseVariableRoleClause : V_Bar -> Cop -> VL_Bar -> V_Bar -> VCl ;

		NegatedVariableClause : V_Bar -> P -> V_Bar -> VCl ;
		InverseNegatedVariableClause : V_Bar -> P -> V_Bar -> VCl ;

		InverseNegatedVariableRoleClause : V_Bar -> Cop -> VL_Bar -> V_Bar -> VCl ;

		--------------------------------------------------------------------------------------------

		CoordinatedVariableRestriction : VR -> Conj -> VR -> VR ;

		VariableRestriction : Ref -> P -> V_Bar -> VR ;
		InverseVariableRestriction : Ref -> P -> V_Bar -> VR ;

		InverseVariableRoleRestriction : Ref -> Cop -> VL_Bar -> V_Bar -> VR ;

		NegatedVariableRestriction : Ref -> P -> V_Bar -> VR ;
		InverseNegatedVariableRestriction : Ref -> P -> V_Bar -> VR ;

		InverseNegatedVariableRoleRestriction : Ref -> Cop -> VL_Bar -> V_Bar -> VR ;

		--------------------------------------------------------------------------------------------

		DefiniteVariable : Var -> V_Bar ;
		DefiniteRestrictedVariable : Var -> VR -> V_Bar ;

		IndefiniteVariable : ExT -> V_Bar ;
		IndefiniteRestrictedVariable : ExT -> VR -> V_Bar ;

		VariableRole : PN -> VL_Bar ;
		--RestrictedVariableRole : PN -> VR -> VL_Bar ;

		--------------------------------------------------------------------------------------------

		Everything : AllT ;
		Something : ExT ;

		Every : All ;
		Some : Ex ;
		Definite : Def ;
		Only : NoBut ;

		Link : Ref ;
		And, Or : Conj ;

		isA : Cop ;

		X, Y, Z : Var ;
}
