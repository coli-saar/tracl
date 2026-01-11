
// #import "lib.typ": *
#import "@preview/tracl:0.8.0": *
#import "@preview/pergamon:0.7.0": *

// float all figures to the top
#set figure(placement: top)

// formatting of ``` ... ``` blocks
#show raw.where(block: true): it => pad(left: 1em, top: 1em, bottom: 1em, it)


#show: acl.with(
  anonymous: false,
  title: [Instructions for \*ACL Proceedings],
  authors: make-authors(name: "Alexander Koller", affiliation: [Saarland University\ #email("koller@coli.uni-saarland.de")]),
  meta-authors: "Alexander Koller"
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

Because this document is itself written with tracl, it is instructive to
look at #link("https://github.com/coli-saar/tracl/blob/main/main.typ")[its source code] along with this PDF.


= Engines

Tracl requires Typst 0.12. The most recent compatibility update is for Typst 0.14.


= Preamble

You can load tracl into your Typst file as follows:

```
#import "@preview/tracl:0.7.1": *

#show: acl.with(
  anonymous: false,
  title: [(your title)],
  authors: make-authors(
    name: "Alexander Koller",
    affiliation: [
      Saarland University\
      #email("koller@coli.uni-saarland.de")
    ],
  ),
)
```

You can then write the rest of your document as usual. Use the `#abstract` command to typeset your abstract.

Use `anonymous: true` to generate an anonymous version of your paper that is suitable for submission to the conference.

// If you split your document up over multiple source files, you may need to `#import "@preview/tracl..."` in every source file
// to use the functions that tracl defines. 
You can split your Typst document over multiple source files and combine them with `#include`, but
the show rule with the call to `acl` should only appear once,
in the main Typst source file that imports tracl.


= Fonts

You may need to install a number of free fonts to make tracl documents conform to the ACL style.
See the #link("https://github.com/coli-saar/tracl")[README] for details.

The serif, sans-serif, and monospace fonts that tracl uses to typeset the document can be accessed
in the variables `tracl-serif`, `tracl-sans`, and `tracl-mono`. Use these in your own styling if you find it useful.


= Title and Authors

The ACL style instructions expect the title and authors to be listed at the top of the document, in a "titlebox"
that is at least 5 cm high. If you have a long title or many authors, you can make the titlebox higher by passing an
 argument `titlebox-height: <new height>` to the `acl` show rule. The "new height" must be a #link("https://typst.app/docs/reference/layout/length/")[Typst length],
 and must be at least 5 cm.

== Author lists with `make-authors`

You have two main options to format the author list. The simplest is to use the `make-authors` function, which will
allow you to place authors and affiliations side by side and on top of each other, as with the `\and`, `\And`, and `\AND`
macros in the LaTeX style. The easiest way to understand the options is to look at the example title pages at the end
of this document, along with their source code.


== Free-form author lists

Alternatively, you can simply pass content to the `authors` parameter of the `acl` function. This will allow you to
typeset arbitrarily complex author lists. See the "Free-form authors" example at the very end of this document.

Tracl supports you in connecting authors to their affiliations by offering you the `affiliation` and `affil-ref` functions. You can define a marker for an affiliation by calling e.g. `#affiliation("uds")`, where `"uds"` is a unique key for an affiliation. This will typeset a superscripted symbol for this affiliation. You can then reference affiliations after an author name by calling `#affil-ref("uds")`; this will be replaced by the affiliation's symbol. 

You can choose your own symbol for an affiliation through e.g. `#affiliation("uds", symbol: sym.dagger)`.
You can also pass multiple affiliation strings to `affil-ref`; they will be typeset connected by commas.


== Footnotes in titleboxes 

You can add a footnote to a titlebox using the `title-footnote` function.
This will generate a footnote at the bottom of the page. You cannot currently
use the regular Typst `footnote` function for this, because of a #link("https://github.com/typst/typst/issues/5765")[known Typst limitation].

The function `title-footnote` takes two arguments. The first is the footnote text, and the
second is a string that uniquely identifies the footnote (it will be used as the name of a
Typst label). You can reference the same footnote from multiple places in the titlebox by
calling `title-footnote` with the same identifier string. In this case, only the first
call to `title-footnote` will actually generate a footnote; subsequent calls will simply
add references to the same footnote. See the example "Multiple rows of authors" at the end
of this document.

== Document metadata

Typst can store the title and authors of a document in the PDF metadata.
Tracl automatically stores the title that is specified as an argument to the
`acl` function. 

However, because authors can be defined so flexibly, tracl cannot set the
author metadata in the PDF automatically. You can pass the authors you want
stored in the metadata in the optional `meta-authors` parameter of the `acl` function.
If you set `anonymous: true`, tracl will always set the author metadata to
"Anonymous", ensuring anonymity of your paper.


= Document Body

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

Supply the content of your appendix after the `#show: appendix` command to switch the section numbering over to letters.
See @sec:appendix for an example.


#figure(
  image("pics/spec-paths-cubic01.svg"),
  caption: [A figure with a caption that runs for more than one line. The example picture comes 
  from the #link("https://github.com/openscad/svg-tests")[openscad svg-tests] repository.]
) <fig:experiments>



= References

== BibTeX Files <sec:bibtex>

You can use regular BibTeX bibliography files with Typst.
You can obtain the complete ACL Anthology as a BibTeX file from https://aclweb.org/anthology/anthology.bib.gz.

Please ensure that BibTeX records contain DOIs or URLs when possible, and for all the ACL 
materials that you reference. Use the `doi` field for DOIs and the `url` field for URLs.
If a BibTeX entry has a URL or DOI field, the paper title in the references section will 
appear as a hyperlink to the paper.
#text(size:0.001pt)[#cite("Ando2005", "andrew2007scalable", "rasooli-tetrault-2015")]

== Bibliographies

Tracl uses #link("https://typst.app/universe/package/pergamon")[Pergamon] to
typeset the bibliography, with ACL-specific customization. The structure of a typical 
tracl document therefore looks like this:

```
#import "@preview/tracl:0.7.1": *
#import "@preview/pergamon:0.6.0": *

... your document ...

#add-bib-resource(read("custom.bib"))
#print-acl-bibliography()
```

You can call `add-bib-resource` as many times as you like to make multiple Bibtex files available
to your paper. Note that you have to `read` the Bibtex file yourself before calling
`add-bib-resource` because of architectural limitations of Typst.

The bibliography will be printed at the location where you call `print-acl-bibliography`.
This is typically after the Limitations sections, but before the appendices.

You can tweak the formatting of the bibliography by passing named arguments 
to the `print-acl-bibliography` function. These arguments will be passed on to Pergamon's `format-reference`
function. See the #link("https://typst.app/universe/package/pergamon")[Pergamon documentation]
for details.


== Citations <sec:citations>

@citation-guide shows how to cite papers in your text. Note that we use Pergamon's
`cite` function, rather than Typst's builtin `cite`. This means that you must write
`#cite("paperkey")` rather than `#cite(<paperkey>)`, and you cannot just write
`@paperkey`.

The functions `cite` and `citep` will generate citations in the form "(author, year)".
You can write `#citet("Gusfield:97")` to get citations of the form "author (year)",
as in #citet("Gusfield:97").  You can use the command `#citen("Gusfield:97")` 
("cite none") to get “author, year” citations, which is useful 
for using citations within  parentheses. 
A possessive citation can be made with the `#citeg` command; this will yield e.g. 
"#citeg("Gusfield:97")".

For comparison with the ACL LaTeX style, `citen` corresponds to their `citealp`,
and `citeg` corresponds to their `citeposs`.

The citation commands are defined by Pergamon. If you split your paper across multiple 
source files, you must therefore `#import` Pergamon in each of them.




#set heading(numbering: none) // turn off section numbers

= Limitations

Since December 2023, a "Limitations" section has been required for all papers submitted to 
ACL Rolling Review (ARR). This section should be placed at the end of the paper, before the 
references. The "Limitations" section (along with, optionally, a section for ethical considerations) 
may be up to one page and will not count toward the final page limit. Note that these files may be 
used by venues that do not rely on ARR so it is recommended to verify the requirement of a 
"Limitations" section and other criteria with the venue in question.

Tracl currently has a number of limitations compared to the more mature LaTeX ACL style. 
Here are some workarounds.

- The two columns of a page will not automatically be aligned at the bottom. This is a 
  #link("https://github.com/typst/typst/issues/3442")[known limitation in Typst] that should be 
  fixed at some point. For the time being, you can manually insert whitespace above each paragraph 
  in the shorter column with `#v`.




#figure(
  scope: "parent",
    table(
      columns: (auto, auto, auto),
      stroke: none,
      column-gutter: 1em,
      align: left,
      table.hline(),
      [*Output*], [*Citation command*], [*LaTeX equivalent*],
      table.hline(),
      cite("Gusfield:97"), [`#cite("Gusfield:97")` or `#citep("Gusfield:97")`], [`citep`],
      citet("Gusfield:97"), [`#citet("Gusfield:97")`], [`citet`],
      citen("Gusfield:97"), [`#citen("Gusfield:97")`], [`citealp`],
      citeg("Gusfield:97"), [`#citeg("Gusfield:97")`], [`citeposs`],
      table.hline()
    ),
  caption: [Citation commands supported by the style file.]
)
<citation-guide>



#add-bib-resource(read("custom.bib"))
#print-acl-bibliography()

#show: appendix

= Example Appendix <sec:appendix>

This is an appendix.






// The code below is to illustrate the different ways to typeset
// author lists.


#let titlebox-example(raw-content) = {
  figure(
    scope: "parent",
    box(stroke: 1pt, inset: (x: 11pt), raw-content)
  )
}



#acl(
  anonymous: false,
  suppress-refsection: true,
  title: [Three authors from the same institution],
  authors: make-authors(
    name: ("Michael Sullivan", "Mareike Hartmann", "Alexander Koller"),
    affiliation: [Department of Language Science and Technology\
      Saarland Informatics Campus\
      Saarland University, Saarbrücken, Germany\
      #email("{msullivan, mareikeh, koller}@coli.uni-saarland.de")
    ])
)[
  #abstract[
    In the simplest case, all authors are from the same institution. Then
    you can use `make-authors` to typeset a single block containing all authors
    and this single institution. A block is defined by a dictionary with keys `name` and `affiliation`,
    where `name` can either be a single author name (string or content) or an array of
    author names.

    Multiple author names within the same block are separated by an amount
    of whitespace that is determined by the `author-spacing` parameter.
  ]

  #titlebox-example[
    ```
#acl(
  title: [Three authors from the same institution],
  authors: make-authors(
    name: ("Michael Sullivan", "Mareike Hartmann", "Alexander Koller"),
    affiliation: [Department of Language Science and Technology\
      Saarland Informatics Campus\
      Saarland University, Saarbrücken, Germany\
      #email("{msullivan, mareikeh, koller}@coli.uni-saarland.de")
    ])
)
    ```
  ]
]

#pagebreak()

#acl(
  title: [Three authors from different institutions],
  authors: make-authors(
    // block-spacing: 1.5cm,
    (
      name: "Alex Duchnowski",
      affiliation: [Saarland University\ #email("alex@lst.uni-sb.de")]
    ),
    (
      name: "Ellie Pavlick",
      affiliation: [Brown University\ #email("ellie_pavlick@brown.edu")]
    ),
    (
      name: "Alexander Koller",
      affiliation: [Saarland University\ #email("koller@lst.uni-sb.de")]
    ),
  ),
  suppress-refsection: true,
)[
  #abstract[
    If you want to show a separate institution for each author, you can
    pass an array of multiple blocks to create a row. Blocks are separated
    by an amount of whitespace that is determined by the `block-spacing`
    parameter.
  ]

  #titlebox-example[
    ```
#acl(
  title: [Three authors from different institutions],
  authors: make-authors(
    (
      name: "Alex Duchnowski",
      affiliation: [Saarland University\ #email("alex@lst.uni-sb.de")]
    ), (
      name: "Ellie Pavlick",
      affiliation: [Brown University\ #email("ellie_pavlick@brown.edu")]
    ), (
      name: "Alexander Koller",
      affiliation: [Saarland University\ #email("koller@lst.uni-sb.de")]
    ),
  )
)
    ``` ]
]

#pagebreak()

#acl(
  anonymous: false,
  title: [Mix of same and different institutions],
  authors: make-authors(
    // block-spacing: 3em,
    (
      name: ("Alex Duchnowski", "Alexander Koller"),
      affiliation: [Saarland University\ #email("{alex|koller}@lst.uni-sb.de")]
    ),
    (
      name: "Ellie Pavlick",
      affiliation: [Brown University\ #email("ellie_pavlick@brown.edu")]
    ),
  ),
  suppress-refsection: true,
)[
  #abstract[
    Within each row, you can mix blocks with single authors and blocks with
    multiple authors. This is useful if some authors come from the same institution
    and some come from different ones.
  ]

#titlebox-example[
    ```
#acl(
  title: [Mix of same and different institutions],
  authors: make-authors(
    (
      name: ("Alex Duchnowski", "Alexander Koller"),
      affiliation: [Saarland University\ #email("{alex|koller}@lst.uni-sb.de")]
    ), (
      name: "Ellie Pavlick",
      affiliation: [Brown University\ #email("ellie_pavlick@brown.edu")]
    ),
  )
)
    ``` ]
]

#pagebreak()

#acl(
  // anonymous: false,
  title: [Multiple rows of authors],
  titlebox-height: 5.5cm,
  authors: make-authors(
    // row 1
    (
      (
        name: [Yuekun Yao],
        affiliation: [Saarland University\ #email("ykyao@coli.uni-saarland.de")]
      ),
      (
        name: [Yupei Du],
        affiliation: [Utrecht University\ #email("y.du@uu.nl")],
      ),
      (
        name: [Dawei Zhu],
        affiliation: [Saarland University\ #email("dzhu@lsv.uni-saarland.de")],
      )
    ),

    // row 2
    (
      (
        name: [Michael Hahn#title-footnote([Joint senior authors.], "fn:senior")],
        affiliation: [Saarland University\ #email("mhahn@lst.uni-saarland.de")],
      ),
      (
        name: [Alexander Koller#title-footnote(none, "fn:senior")],
        affiliation: [Saarland University\ #email("koller@coli.uni-saarland.de")]
      )
    )
  ),
  suppress-refsection: true,
)[
  #abstract[
    If your authors don't fit into a single row, you can pass an array of rows
    to `make-authors`. This will set the rows on top of each other, separated
    by an amount of whitespace that is determined by the `row-spacing` argument.

    Note the use of `title-footnote` to generate the "joint senior authors" footnote,
    which is referenced from two different authors. Note also the use of
    `titlebox-height` to increase the height of the titlebox.
  ]

  #titlebox-example[```
#acl(
  title: [Multiple rows of authors],
  titlebox-height: 5.5cm,
  authors: make-authors(
    (   // row 1
        (
          name: [Yuekun Yao],
          affiliation: [Saarland University\ #email("ykyao@coli.uni-saarland.de")]
        ), (
          name: [Yupei Du],
          affiliation: [Utrecht University\ #email("y.du@uu.nl")],
        ), (
          name: [Dawei Zhu],
          affiliation: [Saarland University\ #email("dzhu@lsv.uni-saarland.de")],
        )
    ),    
    (   // row 2        
        (
          name: [Michael Hahn#title-footnote([Joint senior authors.], "fn:senior")],
          affiliation: [Saarland University\ #email("mhahn@lst.uni-saarland.de")],
        ), (
          name: [Alexander Koller#title-footnote(none, "fn:senior")],
          affiliation: [Saarland University\ #email("koller@coli.uni-saarland.de")]
        )
    )
))
    ```]
]


#pagebreak()

#acl(
  anonymous: false,
  title: [Free-form authors],
  authors: [
    *Alex Duchnowski*#affil-ref("uds", "brown") #h(2em)
    *Ellie Pavlick*#affil-ref("brown") #h(2em)
    *Alexander Koller*#affil-ref("uds")

    #affiliation("uds", symbol: sym.dagger) Saarland University #h(3em)
    #affiliation("brown") Brown University
    
    #email("{alex|koller}@lst.uni-saarland.de") #h(2em)
    #email("ellie_pavlick@brown.edu")
  ],
  suppress-refsection: true,
)[
  #abstract[
    You can ignore the `make-authors` function and simply arrange the authors
    in the titlebox yourself. Tracl offers the functions `affiliation` and
    `affil-ref` to facilitate the mapping of authors to affiliations.
  ]

  #titlebox-example[
    ```
  #acl(
    title: [Free-form authors],
    authors: [
      *Alex Duchnowski*#affil-ref("uds", "brown") #h(2em)
      *Ellie Pavlick*#affil-ref("brown") #h(2em)
      *Alexander Koller*#affil-ref("uds")

      #affiliation("uds", symbol: sym.dagger) Saarland University #h(3em)
      #affiliation("brown") Brown University
      
      #email("{alex|koller}@lst.uni-saarland.de") #h(2em)
      #email("ellie_pavlick@brown.edu")
    ]
  )  
    ```]
]






// This is only needed because main.typ contains multiple `acl` documents
// (titlepages at the end of the document). In your own document,
// tracl will automatically set the title from the argument to the `acl` function.
#set document(title: [Instructions for \*ACL Proceedings])
