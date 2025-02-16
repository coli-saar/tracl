#import "acl.typ":*
#import "macros.typ":*  // include this in every *.typ file to make macros visible

#set page(numbering: "1")

#show: doc => acl(doc,
  anonymous: true,
  title: [#dataset: A Dataset of Everyday NP-hard Optimization Problems],
 /* Alternate titles:
    - Wolves in Sheep's Clothing: The NPC-EVAL Corpus
    - It's an NP-Hard Knock Life
    - (S)HOP: The (Saarland) Dataset of Hard Optimization Problems
  */
  authors: (
    (
      name: "Alex Duchnowski",
      affiliation: [Saarland University],
      email: "aduchnowski@coli.uni-saarland.de",
    ),
    (
      name: "Ellie Pavlick",
      affiliation: [Brown University],
      email: "ellie_pavlick@brown.edu",
    ),
    (
      name: "Alexander Koller",
      affiliation: [Saarland University],
      email: "koller@coli.uni-saarland.de",
    ),
  ),
)

#abstract[
  We introduce the dataset of #dataset-text (#dataset), a collection of NP-hard optimization problems expressed in natural language.
  #dataset includes problem formulations that could be found in computer science textbooks, versions that are dressed up as problems that could arise in real life, and variants of well-known problems with inverted rules.
  We find that state-of-the-art LLMs, across multiple prompting strategies,
  systematically solve textbook problems more accurately than their real-life and inverted
  counterparts. We argue that this constitutes evidence that LLMs adapt solutions seen during training, rather than leveraging reasoning abilities that would enable them to generalize to novel problems.
]

#set figure(placement: top)

#include "introduction.typ"
#include "related.typ"
#include "problems.typ"
#include "methods.typ"
#include "results.typ"
#include "conclusion.typ"

// #colbreak()
/////////// bibliography ///////////

#import "@preview/blinky:0.1.0": link-bib-urls  // :) :)
#let bibsrc = read("mybib.bib")

#link-bib-urls(bibsrc)[
   #bibliography("mybib.bib", style: "./association-for-computational-linguistics-blinky.csl")
]

#pagebreak()

#set heading(numbering: "A.1", supplement: "Appendix")
#counter(heading).update(0)

#include "appendix.typ"


