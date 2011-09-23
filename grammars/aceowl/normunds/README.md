Exploring Grūzītis' GF implementation of the OWL-compatible fragment of ACE
===========================================================================

Experiments with Normunds Grūzītis' GF implementation of
the OWL-compatible fragment of ACE and comparing with with
the AceWiki's implementation.

The implementation was obtained from http://valoda.ailab.lv/cnl/ (v0.6.1)

For conciseness reasons, in the following Grūzītis' implementation is referred to as
*ALO* (short for "ACE compliant controlled Latvian for ontology authoring and verbalization").


Plan
----

  1. Based on ALO Wildlife, add a grammar that covers the AceWiki ACEOWL test words
  2. Generate with AceWiki ACEOWL all the sentences up to a certain length
  3. Parse these generated sentences using the ALO GF grammar
  4. Report how many are parsed (and the parsing speed etc.)


Structure of ALO
----------------

Files:

  * Ontology.gf
  * OntologyAce.gf
  * OntologyEng.gf (note: resource!)
  * ResAce.gf
  * ResEng.gf

Modules:

  * abstract Ontology
  * concrete OntologyAce of Ontology = open OntologyEng, ResEng
  * resource OntologyEng = open ResEng
  * resource ResAce = open ResEng
  * resource ResEng


Problems
--------

### ALO does not support word forms

  - solution 1: implement wordform support in GF
  - solution 2: search/replace wordforms in the AceWiki output to the base form required by ALO grammar

### GF can generate trees up to a certain depth vs. AceWiki can generate sentences up to a certain token length


Differences
-----------

### Not supported by ALO (but are supported by AceWiki)

  + Questions [TODO: clarify]
  + Wordforms (e.g. past participles)
  + Proper names
  + Existential sentences (sentences that do not start with `every`/`no`/`if`)
  + Numbers and gen. quantifiers (at most 3)

## Other

  + AceWiki supports the deprecated "such that" (ALO does not)
  + ALO supports questions of the form "is there ...?" (AceWiki does not [TODO: check])


Which AceWiki sentences does ALO support
----------------------------------------

If we have _all_ the AceWiki sentences in one file (`acewiki.txt`) then we can
pipe them into GF like this:

    $ cat acewiki.txt | sed "s/^/p \"/" | sed 's/$/"/' |  gf --run AcewikitestAce.gf

This wraps every sentence into the GF parse-command (`p "sentence"`) before sending it into GF.
The output will show the parse tree or an error message.

Note that _all_ refers to a reasonably large/interesting subset of all the AceWiki-supported sentences.
In the following the subset contains 19718 sentences.

If we take the AceWiki test set and apply no changes to it then parsing it with ALO gives
us a parse tree in only 3 cases.
This is the output after applying `sort | uniq -c | sort -nr` to it.

       3465 The parser failed at token "somebody"
       2953 The parser failed at token "Mary"
       2692 The parser failed at token "everybody"
       2396 The parser failed at token "it"
       2115 The parser failed at token "X"
       1648 The parser failed at token "a"
       1500 The parser failed at token "friend"
        942 The parser failed at token "there"
        735 The parser failed at token "who"
        718 The parser failed at token "which"
        220 The parser failed at token "exactly"
        114 The parser failed at token "the"
        109 The parser failed at token "every"
         39 The parser failed at token "not"
         23 The parser failed at token "mad-about"
         23 The parser failed at token "does"
         23 The parser failed at token "asked"
          1 Statement (UniversalQuantification (UniversalClass Every (Class Woman))) asks (ExistentialQuantification (ExistentialClass Some (Class Woman)))
          1 Rule (UniversalQuantification (UniversalClass Every (Class Woman))) asks (UniversalQuantification (UniversalClass Every (Class Woman)))
          1 Generalization (UniversalQuantification (UniversalClass Every (Class Woman))) isA (Class Woman)

With some changes, 69 sentences get parsed:

    cat acewiki.txt | grep -vf not_supported.txt | sed -f wordform_changes.sed |\
    sed "s/^/p \"/" | sed 's/$/"/' |  gf --run AcewikitestAce.gf | grep -v "^The pa" | grep -v '^$' | wc

TODO: to be continued...
