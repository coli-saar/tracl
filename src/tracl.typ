
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

#import "tracl-pergamon.typ": acl-refsection
#import "tracl-titlebox.typ": print-title-footnotes, affiliations-state, TITLEBOX-END-MARKER

// #let compilation-target = dictionary(std).at("target", default: () => "paged") // "html" or "paged"

// "Times" in TeX Live is actually Nimbus Roman.
// TeX Gyre Termes is builtin in the Typst web app and accepted by aclpubcheck.
#let tracl-serif = ("TeX Gyre Termes", "Nimbus Roman No9 L", "Libertinus Serif")
#let tracl-sans = ("TeX Gyre Heros", "Helvetica")
#let tracl-mono = ("Inconsolata", "DejaVu Sans Mono")

#let linespacing = 0.55em

// In Typst 0.14.0 and later, use a #title element for the title
#let use-title = sys.version >= version(0, 14, 0)

#let email(address) = text(font: tracl-mono, 11pt)[#link("mailto:" + address, address)]

#let maketitle(papertitle:none, authors:none, anonymous:false, titlebox-height: 5cm) = {
  context match-target(
    // We generate PDF => place the titlebox in a two-column container.
    // Using `place` is a little bit clunky; it makes footnotes out of the titlebox
    // difficult. But the alternative would be to enclose the entire document in
    // a `columns` element, and that has a lot of followup consequences that are even worse.
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

    // We generate HTML => just print the titlebox.
    html: [
      #if use-title {
        title()
      } else {
        text(15pt, font: tracl-serif)[#par(leading:0.5em)[
          *#papertitle*
        ]]
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
  set par(leading: linespacing, spacing: 1em, first-line-indent: 0em, justify: true)

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


  show: it => {
    if anonymous {
      set par.line(numbering: "001", number-clearance: 4em)
      set par.line(
        numbering: n => text(sidenumgray, font: tracl-sans, size: 8pt)[
          *#strfmt("{:03}", n)*
        ]
      )
      show figure: set par.line(numbering: none) // Disable numbers inside figures.
      it
    } else {
      it
    }
  }

  style-title(maketitle(papertitle:title, authors:authors, anonymous:anonymous, titlebox-height: titlebox-height))
    print-title-footnotes()
    acl-refsection(doc)

  // if anonymous {
  //   set par.line(numbering: "001", number-clearance: 4em)
  //   set par.line(
  //     numbering: n => text(sidenumgray, font: tracl-sans, size: 8pt)[
  //       *#strfmt("{:03}", n)*
  //     ]
  //   )
  //   show figure: set par.line(numbering: none) // Disable numbers inside figures.

  //   style-title(maketitle(papertitle:title, authors:authors, anonymous:anonymous, titlebox-height: titlebox-height))
  //   print-title-footnotes()
  //   acl-refsection(doc)
  // } else {
  //   style-title(maketitle(papertitle:title, authors:authors, anonymous:anonymous, titlebox-height: titlebox-height))
  //   print-title-footnotes()
  //   acl-refsection(doc)
  // }

  // TODO: play around with these costs to optimize the layout in the end
  // set text(costs: (orphan: 0%, widow: 0%))
}

