
// Typst ACL style - https://github.com/coli-saar/tracl
// by Alexander Koller <koller@coli.uni-saarland.de>

// 2025-12-10 v0.7.1 - bumped pergamon dependency to 0.6.0
// 2025-11-01 v0.7.0 - default font now TeX Gyre Termes; use Pergamon for references; compatible with Typst 0.14
// 2025-03-28 v0.6.0 - improved lists and line numbers
// 2025-03-28 v0.5.2 - bumped blinky dependency to 0.2.0
// 2025-03-02 v0.5.1 - fixed font names so as not to overwrite existing Typst symbols
// 2025-02-28 v0.5.0 - adapted to Typst 0.13, released to Typst Universe
// 2025-02-18 v0.4, many small changes and cleanup, and switch to Nimbus fonts
// v0.3.2, ensure page numbers are printed only in anonymous version
// v0.3.1, fixed "locate" deprecation
// v0.3, adjusted some formatting to the ACL style rules
// v0.2, adapted to Typst 0.12

#import "@preview/bullseye:0.1.0": *
#import "@preview/oxifmt:1.0.0": strfmt
#import "@preview/pergamon:0.6.0": *
#let dev = pergamon-dev

// #let compilation-target = dictionary(std).at("target", default: () => "paged") // "html" or "paged"

// "Times" in TeX Live is actually Nimbus Roman.
// TeX Gyre Termes is builtin in the Typst web app and accepted by aclpubcheck.
#let tracl-serif = ("TeX Gyre Termes", "Nimbus Roman No9 L", "Libertinus Serif")
#let tracl-sans = ("TeX Gyre Heros", "Helvetica")
#let tracl-mono = ("Inconsolata", "DejaVu Sans Mono")

#let TITLEBOX-END-MARKER = "tracl-titlebox-end"

// each component dictionary is a dict(key -> symbol)
#let affiliations-state = state("affiliations", (numbered: (:), named: (:)))

#let linespacing = 0.55em

// In Typst 0.14.0 and later, use a #title element for the title
#let use-title = sys.version >= version(0, 14, 0)

#let email(address) = text(font: tracl-mono, 11pt)[#link("mailto:" + address, address)]

#let make-author-block(author-block, layout-options) = {
  assert(type(author-block) == dictionary)
  assert("name" in author-block)
  assert("affiliation" in author-block)

  // permit string (one author name) or array of strings
  let authors = if type(author-block.name) == str or type(author-block.name) == content {
    (author-block.name,)
  } else {
    author-block.name
  }

  box[
    #set text(layout-options.font-size)
    #set par(leading: 0.5em)
    #set align(center)

    // #let (authors, affiliation) = author-block
    #for (i, author) in authors.enumerate() {
      if i > 0 {
        h(layout-options.name-spacing)
      }
      strong(author)
    }
    #parbreak()
    #author-block.affiliation
  ]
}

#let make-author-row(author-row, layout-options) = {
  // author-row could be just a single block - force it into array of blocks
  let author-blocks = if type(author-row) == dictionary {
    (author-row,)
  } else {
    author-row
  }

  // set author blocks side by side
  box[
    #set align(center)
    #for (i, author-block) in author-blocks.enumerate() {
      if i > 0 {
        h(layout-options.block-spacing)
      }
      make-author-block(author-block, layout-options)
    }
  ]
}

// default parameters for make-authors layout
#let author-layout-parameters = (
  name-spacing: 2em,
  block-spacing: 3em,
  row-spacing: 1em,
  font-size: 12pt,
)

#let make-authors(..author-table) = {
  let author-rows = author-table.pos()
  let layout-options = author-layout-parameters
  let authors-in-named = (:)

  for (key, value) in author-table.named().pairs() {
    if key in layout-options {
      layout-options.insert(key, value)
    } else {
      authors-in-named.insert(key, value)
    }
  }

  author-rows = if author-rows.len() == 0 {
    // only one block specified, through named arguments
    (authors-in-named,)
  } else {
    author-rows
  }

  author-rows = if type(author-rows.at(0)) == dictionary {
    // single author row
    (author-rows,)
  } else {
    author-rows
  }

  for (i, row) in author-rows.enumerate() {
    if i > 0 {
      v(layout-options.row-spacing)
    }
    make-author-row(row, layout-options)
  }
}


#let maketitle(papertitle:none, authors:none, anonymous:false, titlebox-height: 5cm) = {
  context match-target(
    paged: place(top + center, scope: "parent", float: true)[
      #box(height: titlebox-height, width: 1fr)[
        #align(center)[
          #if use-title {
            title()
            v(2.2em)
          } else {
            text(15pt, font: tracl-serif)[#par(leading:0.5em)[
              *#papertitle*
            ]]
            v(2.5em)
          }
        
          #if anonymous {
            set text(12pt)
            [*Anonymous ACL submission*]
          } else {
            affiliations-state.update((numbered: (:), named: (:)))
            set text(12pt)
            authors
            metadata((kind: TITLEBOX-END-MARKER))
          }
          #v(1em)
        ]      
      ]
    ],

    html: [
      #if use-title {
        title()
        v(2.2em)
      } else {
        text(15pt, font: tracl-serif)[#par(leading:0.5em)[
          *#papertitle*
        ]]
        v(2.5em)
      }

      #if anonymous {
        set text(12pt)
        [*Anonymous ACL submission*]
      } else {
        affiliations-state.update((numbered: (:), named: (:)))
        set text(12pt)
        authors
        metadata((kind: TITLEBOX-END-MARKER))
      }    
    ]
  )
}


#let darkblue = rgb("000099")
#let sidenumgray = rgb("bfbfbf")

#show link: it => text(blue)[#it]


#let abstract(abs) = {
  set par(leading: linespacing, first-line-indent: 0em, justify: true)

  context match-target(
    paged: align(center, 
      box(width: 90%,[
        #text(12pt)[*Abstract*]
        #v(0.8em)
        #text(10pt, align(left, abs))
      ])
    ),

    html: [
      // TODO wrap these in CSS classes, instead of specifying font sizes directly
      #text(12pt)[*Abstract*]
      #v(0.8em)
      #text(10pt, abs)
    ]
  )
}
    

// typeset a line number
#let sidenum(i) = {
  let s = str(i)
  while s.len() < 3 {
    s = "0" + s
  }
  text(font: tracl-sans, 7pt, fill: sidenumgray)[#s]
}


// citation commands
// #let citet(x) = cite(x, form: "prose")
// #let citep(x) = cite(x)
// #let citealp(x) = [#cite(x, form: "author"), #cite(x, form: "year")]
// #let citeposs(x) = [#cite(x, form: "author")'s (#cite(x, form: "year"))]

// Switch to appendix. By default, the appendices start on a fresh page.
// If you don't want this, pass "clearpage: false".
#let appendix(content, clearpage: true) = {
  if( clearpage ) { pagebreak() }

  set heading(numbering: "A.1", supplement: "Appendix")
  counter(heading).update(0)

  content
}



#let style-title(doc) = {
  // This doesn't work - waiting for advice.
  if use-title {
    show std.title: set text(15pt, font: tracl-serif)
    show std.title: set par(leading:0.5em)
    doc
  } else {
    doc
  }
}


////// PERGAMON CONFIG ///////

// modified formatting of volume and number for Pergamon
#let volume-number-pages(reference, options) = {
  let volume = fd(reference, "volume", options)
  let number = fd(reference, "number", options)
  let pages = fd(reference, "pages", options)

  let a = if volume == none and number == none {
    none
  } else if number == none {
    " " + volume
  } else if volume == none {
    panic("Can't use 'number' without 'volume' (in " + reference.entry_key + ")!")
  } else {
    strfmt(" {}({})", volume, number)
  }

  let pp = if pages == none {
    none
  } else if a != none {
    ":" + pages
  } else {
    ", " + (dev.printfield)(reference, "pages", options)
  }
  
  epsilons(a, pp)
}

// Pergamon citation style suitable for ACL
#let acl-cite = format-citation-authoryear(
  author-year-separator: ", "
)

// Define Pergamon refsection for ACL papers
#let acl-refsection = refsection.with(format-citation: acl-cite.format-citation)

// Call this to print the bibliography. All named arguments that you pass
// to this function will be forwarded to the format-reference call, enabling customization.
#let print-acl-bibliography(..pergamon-arguments) = {
  // default arguments for format-reference
  let format-reference-arguments = (
    name-format: "{given} {family}",
    reference-label: acl-cite.reference-label,
    format-quotes: it => it,
    print-isbn: false,

    suppress-fields: (
      "*": ("month",),
      "inproceedings": ("editor",),
    ), 

    print-date-after-authors: true,

    format-functions: (
      "maybe-with-date": (reference, options) => {
        name => {
          periods(
            name,
            (dev.date-with-extradate)(reference, options)
          )
        }
      },

      // reordered location and organization
      "driver-inproceedings": (reference, options) => {
        (dev.require-fields)(reference, options, "author", "title", "booktitle")

        (options.periods)(
          (dev.author-translator-others)(reference, options),
          (dev.date-with-extradate)(reference, options),
          (dev.printfield)(reference, "title", options),
          (options.commas)(
            spaces(options.bibstring.in, (dev.maintitle-booktitle)(reference, options)),
            (dev.printfield)(reference, "pages", options),
            (dev.printfield)(reference, "location", options),
            (dev.printfield)(reference, "organization", options),
          ),
          (dev.doi-eprint-url)(reference, options),
          (dev.addendum-pubstate)(reference, options)
        )
      },

      // TODO: include "edited by"
      "driver-incollection": (reference, options) => {
        (dev.require-fields)(reference, options, "author", "title", "editor", "booktitle")

        (options.periods)(
          (dev.author-translator-others)(reference, options),
          (dev.date-with-extradate)(reference, options),
          (dev.printfield)(reference, "title", options),
          spaces(
            options.bibstring.in,
            (options.commas)(
              (dev.printfield)(reference, "editor", options),
              (dev.maintitle-booktitle)(reference, options),
              (dev.printfield)(reference, "pages", options)
            )
          ),
          (dev.publisher-location-date)(reference, options),
        )
      },

      // different formatting of volume and number
      // TODO: check eid
      "driver-article": (reference, options) => {
          (dev.require-fields)(reference, options, "author", "title", "journaltitle")

          (options.periods)(
            (dev.author-translator-others)(reference, options),
            (dev.date-with-extradate)(reference, options),
            (dev.printfield)(reference, "title", options),
            epsilons(
              emph((dev.printfield)(reference, "journaltitle", options)),
              volume-number-pages(reference, options)
            ),
            (dev.doi-eprint-url)(reference, options),
            (dev.addendum-pubstate)(reference, options)
          )
      },
    ),

    bibstring: (
      "in": "In",
    ),
  ) + pergamon-arguments.named()

  let acl-ref = format-reference(..format-reference-arguments)

  {
    set par(hanging-indent: 1em, leading: 5pt)
    set text(size: 10pt)
    print-bibliography(
      format-reference: acl-ref,
      sorting: "nyt",
      label-generator: acl-cite.label-generator,
      )
  }
}

////// END PERGAMON CONFIG ///////




// For footnotes that arise in the titlebox, but should be displayed at the bottom
// of the page.

// first element: ordered list of footnotes
// second element: dictionary with keys = labels that were previously added
#let title-footnote-collection = state("title-footnote-collection", ((), (:)))

#let title-footnote(footnote-text, lbl, numbering: "*") = {
  context match-target(
    paged: {
      ref(label(lbl))
      title-footnote-collection.update(x => {
        if not lbl in x.at(1) {
          x.at(0).push((footnote-text, lbl, numbering))
          x.at(1).insert(lbl, 1)
        }
        
        x
      })
    },

    html: {
      footnote(numbering: numbering, footnote-text)
    }
  )
}

#let print-title-footnotes() = context {
  hide()[
    #for (footnote-text, lbl, numbering) in title-footnote-collection.get().at(0) {
      [#footnote(numbering: numbering)[#footnote-text]#label(lbl)]
    }
  ]

  // reset everything
  counter(footnote).update(0)
  title-footnote-collection.update(x => ((), (:)))
}


// For "footnotes" indicating affiliations within the titlebox


// Returns the metadata element at the end of the titlebox.
// If (as in main.typ) there are multiple titleboxes, it finds the next one.
#let find-titlebox-end() = {
  let upcoming = query(selector(metadata).after(here()))
  let matching = upcoming.filter(m => {
    let v = m.value
    type(v) == dictionary and v.at("kind", default: none) == TITLEBOX-END-MARKER
  })
  
  if matching.len() > 0 {
    matching.first()
  } else {
    none
  }
}

// Typesets an author's affiliation symbols.
#let affil-ref(..keys) = context {
  let all-keys = affiliations-state.at(find-titlebox-end().location())
  let labels = ()
  
  for key in keys.pos() {
    if key in all-keys.numbered {
      labels.push(all-keys.numbered.at(key))
    } else if key in all-keys.named {
      labels.push(all-keys.named.at(key))
    } else {
      labels.push([*??*])
    }
  }

  h(0.1em)
  super(labels.join(", "))
}

// Defines an affiliation
#let affiliation(key, symbol: none, affiliation-numbering: "1") = {
  h(0.1em)

  if symbol == none {
    // assign a number
    affiliations-state.update(x => {
      let symbol = numbering(affiliation-numbering, x.numbered.len() + 1)
      x.numbered.insert(key, symbol)
      x
    })
    
    context { super(str(affiliations-state.get().numbered.len())) }
  } else {
    // use the provided symbol
    affiliations-state.update(x => {
      x.named.insert(key, symbol)
      x
    })

    context { super(symbol) }
  }
}




#let acl(doc, title:none, authors: none, anonymous: false, titlebox-height: 5cm) = {
  // accessibility
  // TODO - put these back in
  // let doc-authors = authors.map(dct => dct.name).join(", ")
  set document(title: title) // , author: if anonymous { "Anonymous" } else {doc-authors })

  // overall page setup - this only makes sense if we generate PDF
  let page-numbering = if anonymous { "1" } else { none } // number pages only if anonymous
  show: show-target(paged: doc => {
    set page(paper: "a4", margin: (x: 2.5cm, y: 2.5cm), columns: 2, numbering: page-numbering)
    set columns(gutter: 6mm)

    doc
  })

  assert(titlebox-height >= 5cm)
  
  // some colors
  show link: it => text(darkblue)[#it]
  show ref: it => text(darkblue)[#it] // TODO - this makes all of "Section 6" blue; instead, make only the 6 blue

  // font sizes
  set text(11pt, font: tracl-serif)
  set par(leading: linespacing, first-line-indent: 4mm, justify: true, spacing: linespacing)

  show figure.caption: set text(10pt, font: tracl-serif)
  show figure.caption: set align(left)
  show figure.caption: it => [#v(0.5em) #it]

  show footnote.entry: set text(9pt, font: tracl-serif)

  show raw: set text(10pt, font: tracl-mono)

  // headings
  set heading(numbering: "1.1   ")

  show heading: it => {
    set block(above: if it.level == 1 { 1.3em } else { 1.5em })
    set text(if it.level == 1 { 12pt } else { 11pt })
    it
    v(if it.level == 1 { 1.2em } else { 1em }, weak: true)
  }

  // lists and enums
  set list(indent: 1em)
  show list: set par(spacing: 1em)

  set enum(indent: 1em)
  show enum: set par(spacing: 1em)

  // spacing around figures
  // show figure: set block(inset: (top: 0pt, bottom: 1cm))

  // if anonymous, add line numbering to every page
  // by executing it in the header
  if anonymous {
    set par.line(numbering: "001", number-clearance: 4em)
    set par.line(
      numbering: n => text(sidenumgray, font: tracl-sans, size: 8pt)[
        *#strfmt("{:03}", n)*
      ]
    )
    show figure: set par.line(numbering: none) // Disable numbers inside figures.

    maketitle(papertitle:title, authors:authors, anonymous:anonymous, titlebox-height: titlebox-height)
    style-title(acl-refsection(doc))
  } else {
    style-title(maketitle(papertitle:title, authors:authors, anonymous:anonymous, titlebox-height: titlebox-height))
    print-title-footnotes()
    acl-refsection(doc)
  }

  // TODO: play around with these costs to optimize the layout in the end
  // set text(costs: (orphan: 0%, widow: 0%))
}

