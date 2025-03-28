
#import "@local/tracl:0.6.0": *
#import "@preview/hidden-bib:0.1.0": hidden-citations

// float all figures to the top
#set figure(placement: top)

// formatting of ``` ... ``` blocks
#show raw.where(block: true): it => pad(left: 1em, top: 1em, bottom: 1em, it)

#show: doc => acl(doc,
  anonymous: true,
  title: [Instructions for \*ACL Proceedings],
  authors: (
    (
      name: "Alexander Koller",
      affiliation: [Saarland University],
      email: "koller@coli.uni-saarland.de"
    ),
  ),
)

#abstract[
  This document is a supplement to the general instructions for \*ACL authors. It contains instructions for using the #link("https://github.com/coli-saar/tracl")[tracl] Typst template for ACL conferences.
  The document itself conforms to its own specifications, and is therefore an example of what your manuscript should look like.
  These instructions should be used both for papers submitted for review and for final versions of accepted papers.
]



= Introduction

These instructions are for authors submitting papers to \*ACL conferences using Typst using the 
#link("https://github.com/coli-saar/tracl")[tracl] style. 
They are not self-contained. All authors must follow the general instructions for \*ACL proceedings,
#footnote[http://acl-org.github.io/ACLPUB/formatting.html] and this document contains additional 
instructions for the Typst style files.

The templates include the Typst source of this document (`main.typ`), the Typst style file used 
to format it (`acl.typ`), an ACL bibliography style (`association-for-computational-linguistics-blinky.csl`),
and an example bibliography (`custom.bib`).


= Engines

Tracl is written for Typst 0.12.


= Preamble

You can load tracl into your Typst file as follows:

```
#import "@preview/tracl:0.6.0": *

#show: doc => acl(doc,
  anonymous: false,
  title: [(your title)],
  authors: (
    (
      name: "Alexander Koller",
      email:"koller@lst.uni-saarland.de",
      affiliation: [Saarland University],
    ),
  ),
)
```

You can then write the rest of your document as usual. Use the `#abstract` command to typeset your abstract.

Use `anonymous:true` to generate an anonymous version of your paper that is suitable for submission to the conference.

If you split your document up over multiple source files, you will need to `#import "acl.typ"` in every source file;
otherwise functions such as `#citet` will not be defined. The show rule with the call to `acl` should only appear once,
in the main Typst source file.


= Fonts

You will need to install a number of free fonts to make tracl documents conform to the ACL style.
See the #link("https://github.com/coli-saar/tracl")[README] for details.

The serif, sans-serif, and monospace fonts that tracl uses to typeset the document can be accessed
in the variables `tracl-serif`, `tracl-sans`, and `tracl-mono`. Use these in your own styling if you find it useful.


= Document Body

#v(-0.5em)
== Footnotes <sec:footnotes>

Footnotes are inserted with the `#footnote` command.#footnote[This is a footnote.]

== Tables and figures

See @tab:example for an example of a table and its caption.
*Do not override the default caption sizes.*

As much as possible, fonts in figures should conform to the document fonts. 
See @fig:experiments for an example of a figure and its caption.

You can use the standard Typst #link("https://typst.app/docs/reference/visualize/image/")[image] 
function to include images into your document. Typst supports PNG, JPEG, and SVG. 
Use SVG if you want to include a vector graphic; you can use e.g. 
#link("https://github.com/dawbarton/pdf2svg")[pdf2svg] to convert PDF files. 
Be aware that Typst has pretty good built-in support for generating plots (e.g. through 
#link("https://github.com/cetz-package/cetz-plot")[CeTZ-Plot]), so you may be able to simply 
generate and style your graphics within your Typst source code.

A floating element will be automatically labeled as a "Table" if the top-level element is 
a Typst `table`; otherwise Typst will call it a "Figure". If you want a table labeled as a 
"Figure", you can pass the argument `kind: image` to the `figure` call (see the 
#link("https://typst.app/docs/reference/model/figure/#parameters-kind")[Typst documentation]).

By default, Typst places a `figure` within a single column. If you want a figure to stretch 
across both columns, you can pass the argument `scope: "parent"`.
See the source code of @citation-guide for an example.


#figure(
  table(
    columns: (auto, auto),
    stroke: none,
    align: left,
    column-gutter: 1em,
    table.hline(),
    [*First column*], [*Second column*],
    table.hline(),
    [some stuff], [more stuff],
    [second row], [more second row],
    table.hline()
  ),
  caption: [An example table. Typst can simply use Unicode characters, so Table 1 from the LaTeX instructions is not needed any more.]
) <tab:example>


== Citations <sec:citations>

@citation-guide shows the syntax supported by the style files. The default Typst `cite` 
command (`@Gusfield:97`) will generate citations in the form "(author, year)".
You can also write `#cite(<Gusfield:97>)` or `#citep(<Gusfield:97>)`; note that you  
have to enclose the reference key in angle brackets for this.

You can write `#citet(<Gusfield:97>)` to get citations of the form "author (year)",
as in #citet(<Gusfield:97>).  You can use the command `#citealp(<Gusfield:97>)` 
(alternative cite without parentheses) to get “author, year” citations, which is useful 
for using citations within  parentheses (e.g. #citealp(<Gusfield:97>)).
A possessive citation can be made with the `#citeposs` command; this will yield e.g. 
"#citeposs(<Gusfield:97>)".


== References

// this is like \nocite in LaTeX
#hidden-citations[@Ando2005 @andrew2007scalable @rasooli-tetrault-2015]

Tracl uses the #link("https://github.com/citation-style-language/styles/blob/master/association-for-computational-linguistics.csl")[association-for-computational-linguistics] CSL style, which was developed by 
Hajime Senuma to replicate the #link("https://github.com/acl-org/tracl/blob/master/latex/acl_natbib.bst")[ACL BibTeX style].
This style, in turn, was designed to roughly follow the American Psychological Association format.

More specifically, Tracl uses the #link("https://github.com/alexanderkoller/typst-blinky/tree/main/examples")[Blinky] 
version of this CSL style. Blinky typesets the titles of references in the bibliography as hyperlinks if 
a URL or DOI field is given in the BibTeX entry.
See the reference for #citet(<rasooli-tetrault-2015>) for an example.

If your bib file is named `custom.bib`, then placing the following before any appendices 
in your Typst file  will generate the references section for you:

```
#import "@preview/blinky:0.2.0": 
   link-bib-urls
#let bibsrc = read("custom.bib")

#link-bib-urls()[
 #bibliography("custom.bib", 
  style: "./association-for-computational-linguistics-blinky.csl")
]
```

You can, in principle, using multiple bibliography files to the `bibliography` function (e.g. your 
own bib file and the ACL Anthology) by passing their names in an array. However, Blinky currently 
#link("https://github.com/alexanderkoller/typst-blinky/issues/2")[does not support multiple bibliographies]. 
This means you'll either have to consolidate your bibliographies into a single file or live without 
hyperlinked paper titles.

Please see @sec:bibtex for information on preparing BibTeX files.


== Equations

An example equation is shown below:

#set math.equation(numbering: "(1)")

$ A = pi r^2 $ <eq:example>

Labels for equation numbers, sections, subsections, figures and tables
are all defined as #link("https://typst.app/docs/reference/foundations/label/")[Typst labels],
and cross references to them are made with #link("https://typst.app/docs/reference/model/ref/")[ref].

This is an example cross-reference to @eq:example.


== Lists

Typst distinguishes between lists and enums with tight and non-tight spacing. Lists and enums with tight spacing are set with no extra space between the items:

+ This is the first item of the list.
+ Here's a second item.

Lists and enums with non-tight spacing are set with a blank line of space in between, as in the `itemize` and `enumerate` environments of the LaTeX style:

- First element

- Second element 

Here's some text to illustrate the distance of the list from the subsequent paragraph:
#lorem(10)

== Appendices

Enclose the content of your appendix in the `#appendix` command
to switch the section numbering over to letters. See @sec:appendix for an example.


#figure(
  image("pics/spec-paths-cubic01.svg"),
  caption: [A figure with a caption that runs for more than one line. The example picture comes 
  from the #link("https://github.com/openscad/svg-tests")[openscad svg-tests] repository.]
) <fig:experiments>


= BibTeX Files <sec:bibtex>

You can use regular BibTeX bibliography files with Typst.
You can obtain the complete ACL Anthology as a BibTeX file from https://aclweb.org/anthology/anthology.bib.gz.

Please ensure that BibTeX records contain DOIs or URLs when possible, and for all the ACL 
materials that you reference. Use the `doi` field for DOIs and the `url` field for URLs.
If a BibTeX entry has a URL or DOI field, the paper title in the references section will 
appear as a hyperlink to the paper, using the 
#link("https://typst.app/universe/package/blinky/")[Blinky] package.


#set heading(numbering: none) // turn off section numbers

= Limitations

Since December 2023, a "Limitations" section has been required for all papers submitted to 
ACL Rolling Review (ARR). This section should be placed at the end of the paper, before the 
references. The "Limitations" section (along with, optionally, a section for ethical considerations) 
may be up to one page and will not count toward the final page limit. Note that these files may be 
used by venues that do not rely on ARR so it is recommended to verify the requirement of a 
"Limitations" section and other criteria with the venue in question.

Tracl currently has a number of limitations compared to the more mature LaTeX style. 
Here are some workarounds.

- Author lists with more than three authors will be very crowded. There is currently no real way to 
  expand the titlebox or use a larger grid for the author list.

- When you directly follow a first-level heading (`=`) with a second-level heading (`==`), the 
  style generates some extra whitespace in between. You can remove this extra whitespace with 
  `#v(-0.5em)`. See the source code of @sec:footnotes for an example.

- The two columns of a page will not automatically be aligned at the bottom. This is a 
  #link("https://github.com/typst/typst/issues/3442")[known limitation in Typst] that should be 
  fixed at some point. For the time being, you can manually insert whitespace above each paragraph 
  in the shorter column with `#v`.



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


#import "@preview/blinky:0.2.0": link-bib-urls
#let bibsrc = read("custom.bib")

#link-bib-urls()[
   #bibliography("custom.bib", style: "./association-for-computational-linguistics-blinky.csl")
]

#appendix[
  = Example Appendix <sec:appendix>

  This is an appendix.
]