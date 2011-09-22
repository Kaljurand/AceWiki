---------------------------------------------------------
-- Domain-independent English grammar & function words --
-- Common parameters and functions                     --
---------------------------------------------------------

resource OntologyEng = open ResEng in {
	flags
		optimize = all_subs ;

	param
		Restricted = Nonrestr | Restr ;

	oper
		MainClause : Type = Str ;
		RelativeClause : Type = Number => Str ;
		PolarizedPhrase : Type = Polarity => Str ;

		ABar : Type = {s : PolarizedPhrase ; r : Restricted} ;
		EBar, DBar : Type = {s : Str ; r : Restricted} ;
		NBar : Type = {s : Number => Str ; a : IndefiniteDet ; r : Restricted} ;
		VBar : Type = Str ;

		UniversalPron : Type = PolarizedPhrase ;
		ExistentialPron : Type = Number => Str ;

		UniversalDet : Type = {s : PolarizedPhrase ; e : Str} ;
		ExistentialDet : Type = IndefiniteDet => Str ;
		DefiniteDet, OnlyDet : Type = Str ;

		RelativeRef, Conjunction, Variable : Type = Str ;

		--------------------------------------------------------------------------------------------

		mkText : MainClause -> MainClause -> MainClause = \stmt1,stmt2 ->
			stmt1 ++ stmt2 ;

		--------------------------------------------------------------------------------------------

		mkStmt : Voice -> Polarity -> ABar -> Verb -> EBar ->
			MainClause = \voi,pol,subj,verb,obj ->
				subj.s ! pol ++ verb ! voi ! Pos ! Sg ++ obj.s ++ "." ;

		--------------------------------------------------------------------------------------------

		mkGen : Polarity -> ABar -> Copula -> NBar -> MainClause = \pol,subj,cop,compl ->
			subj.s ! pol ++ cop ! Is ! Pos ! Sg ++ mkEx ! compl.a ++ compl.s ! Sg ++ "." ;

		mkAnonGen : Polarity -> ABar -> Copula -> EBar ->
			MainClause = \pol,subj,cop,compl ->
				subj.s ! pol ++ cop ! Is ! Pos ! Sg ++ compl.s ++ "." ;

		--------------------------------------------------------------------------------------------

		mkRoleStmt : Polarity -> ABar -> Copula -> NBar -> EBar ->
			MainClause = \pol,subj,cop,pred,obj ->
				"for" ++ subj.s ! pol ++ "its" ++
				pred.s ! Sg ++ cop ! Is ! Pos ! Sg ++ obj.s ++ "." ;

		--------------------------------------------------------------------------------------------

		mkCondStmt : MainClause -> MainClause -> MainClause = \if,then ->
			"if" ++ if ++ "then" ++ then ++ "." ;

		--------------------------------------------------------------------------------------------

		mkRule : Voice -> ABar -> Verb -> ABar -> MainClause = \voi,subj,pred,obj ->
			subj.s ! Pos ++ pred ! voi ! Pos ! Sg ++ obj.s ! Pos ++ "." ;

		--------------------------------------------------------------------------------------------

		mkQuery : NBar -> MainClause = \subj ->
			case subj.r of {
				Restr => "is there" ++ mkEx ! subj.a ++ subj.s ! Sg ++ "?" ;
				Nonrestr => variants {}
			} ;

		mkAnonQuery : EBar -> MainClause = \subj ->
			case subj.r of {
				Restr => "is there" ++ subj.s ++ "?" ;
				Nonrestr => variants {}
			} ;

		--------------------------------------------------------------------------------------------

		mkCoordRestr : RelativeClause -> Conjunction -> RelativeClause ->
			RelativeClause = \rel_1,conj,rel_2 ->
				\\num => rel_1 ! num ++ conj ++ rel_2 ! num ;

		mkRestr : Voice -> Polarity -> RelativeRef -> Verb -> EBar ->
			RelativeClause = \voi,pol,pron,verb,obj ->
				\\num => pron ++ verb ! voi ! pol ! num ++ obj.s ;

		mkGenRestr : Polarity -> RelativeRef -> Copula -> NBar ->
			RelativeClause = \pol,pron,cop,compl ->
				\\num => pron ++ cop ! Is ! pol ! num ++ mkEx ! compl.a ++ compl.s ! Sg ;

		--------------------------------------------------------------------------------------------

		mkABar : ABar -> ABar = \abar -> {
			s = abar.s ;
			r = abar.r
		} ;

		mkEBar : EBar -> EBar = \ebar -> {
			s = ebar.s ;
			r = ebar.r
		} ;

		mkDBar : DefiniteDet -> NBar -> DBar = \the,nbar -> {
			s = case nbar.r of {
				Restr => variants {} ;
				Nonrestr => the ++ nbar.s ! Sg
			} ;
			r = nbar.r
		} ;

		--------------------------------------------------------------------------------------------

		mkUnivThing : UniversalPron -> ABar = \thing -> {
			s = \\pol => thing ! pol ;
			r = Nonrestr
		} ;

		mkRestrUnivThing : UniversalPron -> RelativeClause -> ABar = \thing,rel -> {
			s = \\pol => thing ! pol ++ rel ! Sg ;
			r = Restr
		} ;

		mkExistThing : ExistentialPron -> EBar = \thing -> {
			s = thing ! Sg ;
			r = Nonrestr
		} ;

		mkRestrExistThing : ExistentialPron -> RelativeClause -> EBar = \thing,rel -> {
			s = thing ! Sg ++ rel ! Sg ;
			r = Restr
		} ;

		mkRestrOnlyThing : OnlyDet -> ExistentialPron -> RelativeClause ->
			EBar = \nb,thing,rel -> {
				s = nb ++ thing ! Pl ++ rel ! Pl ;
				r = Restr
			} ;

		--------------------------------------------------------------------------------------------

		mkUnivRole : ABar -> UniversalDet -> NBar -> ABar = \abar,all,nbar -> {
			s = \\pol => case nbar.r of {
				Restr => "for" ++ all.e ++ abar.s ! pol ++ "its" ++ nbar.s ! Sg ;
				Nonrestr => all.s ! pol ++ nbar.s ! Sg ++ "of" ++ abar.s ! pol
			} ;
			r = nbar.r
		} ;

		mkExistRole : EBar -> ExistentialDet -> NBar -> EBar = \ebar,ex,nbar -> {
			s = ex ! nbar.a ++ nbar.s ! Sg ++ "of" ++ ebar.s ;
			r = nbar.r
		} ;

		mkUnivClass : UniversalDet -> NBar -> ABar = \all,nbar -> {
			s = \\pol => all.s ! pol ++ nbar.s ! Sg ;
			r = nbar.r
		} ;

		mkExistClass : ExistentialDet -> NBar -> EBar = \ex,nbar -> {
			s = ex ! nbar.a ++ nbar.s ! Sg ;
			r = nbar.r
		} ;

		mkOnlyClass : OnlyDet -> NBar -> EBar = \nb,nbar -> {
			s = nb ++ nbar.s ! Pl ;
			r = nbar.r
		} ;

		--------------------------------------------------------------------------------------------

		mkClass : Noun -> NBar = \noun -> {
			s = \\num => noun.s ! num ;
			a = noun.a ;
			r = Nonrestr
		} ;

		mkRestrClass : Noun -> RelativeClause -> NBar = \noun,rel -> {
			s = \\num => noun.s ! num ++ rel ! num ;
			a = noun.a ;
			r = Restr
		} ;

		--------------------------------------------------------------------------------------------

		mkVarCl : Voice -> Polarity -> VBar -> Verb -> VBar ->
			MainClause = \voi,pol,subj,verb,obj ->
				case pol of {
					Pos => subj ++ verb ! voi ! Pos ! Sg ++ obj ;
					Neg => ("it is false that" ++ subj ++ verb ! voi ! Pos ! Sg ++ obj) | (subj ++ verb ! voi ! Neg ! Sg ++ obj)
				} ;

		mkCoordVarCl : MainClause -> Conjunction -> MainClause ->
			MainClause = \cl_1,conj,cl_2 ->
				cl_1 ++ conj ++ cl_2 ;

		mkVarRestr : Voice -> Polarity -> RelativeRef -> Verb -> VBar ->
			RelativeClause = \voi,pol,pron,verb,obj ->
				\\num => pron ++ verb ! voi ! pol ! num ++ obj ;

		mkVar : Variable -> VBar = \var -> var ;

		mkRestrVar : Variable -> RelativeClause -> VBar = \var,rel ->
			var ++ rel ! Sg ;

		mkIndefVar : ExistentialPron -> VBar = \thing ->
			thing ! Sg ;

		mkIndefRestrVar : ExistentialPron -> RelativeClause ->
			VBar = \thing,rel -> thing ! Sg ++ rel ! Sg ;

		--------------------------------------------------------------------------------------------

		mkAllT : UniversalPron = table {
			Pos => "everything" ;
			Neg => "nothing"
		} ;

		mkExT : ExistentialPron = table {
			Sg => "something" ;
			Pl => "things"
		} ;

		mkAll : UniversalDet = {
			s = table {
				Pos => "every" ;
				Neg => "no"
			} ;
			e = []
		} ;

		mkEx : ExistentialDet = table {
			A => "a" ;
			An => "an"
		} ;
}
