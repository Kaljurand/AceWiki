Exploring Grūzītis' GF implementation of the OWL-compatible fragment of ACE
===========================================================================

Experiments with Normunds Grūzītis' GF implementation of
the OWL-compatible fragment of ACE and comparing with with
the AceWiki's implementation.

The implementation was obtained from http://valoda.ailab.lv/cnl/ (v0.6.1)


Plan
----

  1. Based on Wildlife, add a grammar that covers the AceWiki ACEOWL test words
  2. Generate with AceWiki ACEOWL all the sentences up to a certain length
  3. Parse these generated sentences using the ACEOWL GF grammar
  4. Report how many are parsed (and the parsing speed etc.)


Problems
--------

### Normund's grammar does not support word forms

  - solution 1: implement wordform support in GF
  - solution 2: search/replace wordforms in the AceWiki output to the base form required by Normund's grammar

### GF can generate trees up to a certain depth vs. AceWiki can generate sentences up to a certain token length


Differences
-----------

More fundamental differences

  + Normunds does not support questions
  + Normunds does not support wordforms
  + Normunds does not support proper names
  + Normunds does not support existential sentences (sentences that do not start with `every`/`no`/`if`)
  + AceWiki supports the deprecated "such that" (Normunds does not)
