#import "acl.typ":*
#import "acl-macros.typ":*

#show: doc => acl(doc,
  anonymous: true,
  title: [Instructions for \*ACL Proceedings],
  authors: (
    (
      name: "Alexander Koller",
      affiliation: [Saarland University],
      email: "koller@coli.uni-saarland.de",
    ),
  ),
)

#abstract[
  This document is a supplement to the general instructions for \*ACL authors. It contains instructions for using the
  Typst  style files for ACL conferences.
The document itself conforms to its own specifications, and is therefore an example of what your manuscript should look like.
These instructions should be used both for papers submitted for review and for final versions of accepted papers.
]

#set figure(placement: top)

= Introduction

These instructions are for authors submitting papers to \*ACL conferences using Typst. 
They are not self-contained. All authors must follow the general instructions for \*ACL proceedings,
#footnote[http://acl-org.github.io/ACLPUB/formatting.html] and this document contains additional instructions for the 
Typst style files.

The templates include the Typst source of this document (`main.typ`),
the Typst  style file used to format it (`acl.typ`),
an ACL bibliography style (`association-for-computational-linguistics-blinky.csl`),
and an example bibliography (`custom.bib`).

= Engines

The ACL Typst style is written for Typst 0.12.

= Preamble

You can load the ACL template into your Typst file as follows:

```
#import "acl.typ":*
#import "acl-macros.typ":*

#show: doc => acl(doc,
  anonymous: false,
  title: [(your title)],
  authors: (
    (
      name: "Alexander Koller",
      affiliation: [Saarland University],
      email: "koller@coli.uni-saarland.de",
    ),
  ),
)
```

You can then write the rest of your document as usual. Use the `#abstract` command to typeset your abstract.

Use `anonymous: true` to generate an anonymous version of your paper that is suitable for submission to the conference.

If you split your document up over multiple source files, you will need to `#import "acl-macros.typ"` in every source file.
The `acl.typ` only needs to be included in the main source file.


= Document Body

#v(-0.5em)
== Footnotes <sec:footnotes>

Footnotes are inserted with the `#footnote` command.#footnote[This is a footnote.]

== Tables and figures

== Hyperlinks


== Citations <sec:citations>

@citation-guide shows the syntax supported by the style files.
The default Typst `cite` command (`@Gusfield:97`) will generate citations in the form "(author, year)".
You can also write `#cite(<Gusfield:97>)` or `#citep(<Gusfield:97>)`; note that you will have to enclose
the reference key in angle brackets for this.

You can write `#citet(<Gusfield:97>)` to get citations of the form "author (year)",
as in #citet(<Gusfield:97>). 
You can use the command `#citealp(<Gusfield:97>)` (alternative cite without parentheses)
to get “author, year” citations, which is useful for using citations within 
parentheses (e.g. #citealp(<Gusfield:97>)).
A possessive citation can be made with the `#citeposs` command; this will yield e.g. "#citeposs(<Gusfield:97>)".

== References

== Equations

== Appendices

Enclose the content of your appendix in the `#appendix` command
to switch the section numbering over to letters. See @sec:appendix for an example.


= Limitations

The Typst ACL style currently has a number of limitations compared to the more mature LaTeX style. Here are some workaround.

- Author lists with more than three authors will be very crowded. There is currently no real way to expand the titlebox or use a larger grid for the author list.

- When you directly follow a first-level heading (`=`) with a second-level heading (`==`), the style generates some extra whitespace in between. You can remove this extra whitespace with `#v(-0.5em)`. See the source code of @sec:footnotes for an example.

- The two columns of a page will not automatically be aligned at the bottom. This is a #link("https://github.com/typst/typst/issues/3442")[known limitation in Typst] that should be fixed at some point. For the time being, you can manually insert whitespace above each paragraph in the shorter column with `#v`.



#figure(
  scope: "parent",
  table(
    columns: (auto, auto),
    stroke: none,
    column-gutter: 1em,
    align: left,
    table.hline(),
    [*Output*], [*Citation command*], 
    table.hline(),
    [@Gusfield:97], [`@Gusfield:97` or `#cite<Gusfield:97>` or `#citep<Gusfield:97>`],
    [#citet(<Gusfield:97>)], [`#citet(<Gusfield:97>)`],
    [#citealp(<Gusfield:97>)], [`#citealp(<Gusfield:97>)`],
    [#citeposs(<Gusfield:97>)], [`#citeposs(<Gusfield:97>)`],
    table.hline()
  ),
  caption: [Citation commands supported by the style file. The style is based on the natbib package and supports all
natbib citation commands. It also supports commands defined in previous ACL style files for compatibility.]
)
<citation-guide>


#import "@preview/blinky:0.1.0": link-bib-urls  // :) :)
#let bibsrc = read("custom.bib")

#link-bib-urls(bibsrc)[
   #bibliography("custom.bib", style: "./association-for-computational-linguistics-blinky.csl")
]

#appendix[
  = Example Appendix <sec:appendix>

  This is an appendix.
]