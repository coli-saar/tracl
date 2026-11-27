#import "tracl-units.typ": tex-pt, body-size
#import "tracl-flushbottom.typ": flush-bottom


#import "@preview/bullseye:0.1.0": *
#import "@preview/oxifmt:1.0.0": strfmt

#import "tracl-pergamon.typ": acl-refsection
#import "tracl-titlebox.typ": print-title-footnotes, affiliations-state, TITLEBOX-END-MARKER

// #let compilation-target = dictionary(std).at("target", default: () => "paged") // "html" or "paged"

// "Times" in TeX Live is actually Nimbus Roman.
// TeX Gyre Termes is builtin in the Typst web app and accepted by aclpubcheck.
// Tracl <= 0.7.0 used "Nimbus Roman No9 L" as the font.
#let tracl-serif = ("TeX Gyre Termes", "Libertinus Serif")
#let tracl-sans = ("TeX Gyre Heros", "Helvetica")
#let tracl-mono = ("Inconsolata", "DejaVu Sans Mono")

#let linespacing = 0.55em

// ACL rounds the text height to one topskip and 51 baseline intervals.
#let baseline-skip = 13.6 * tex-pt
#let top-skip = 11 * tex-pt
#let first-baseline = 25mm + top-skip
#let last-baseline = first-baseline + 51 * baseline-skip
// Termes' cap height is 662 units per em. Use an explicit line box so
// first-line placement and baseline spacing agree even with fallback fonts.
#let cap-height = 0.662em
#let body-cap = 0.662 * body-size

// In Typst 0.14.0 and later, use a #title element for the title
#let use-title = sys.version >= version(0, 14, 0)

#let email(address) = text(font: tracl-mono, body-size)[#link("mailto:" + address, address)]

#let maketitle(papertitle:none, authors:none, anonymous:false, titlebox-height: 11 * baseline-skip) = {
  context match-target(
    // We generate PDF => place the titlebox in a two-column container.
    // Using `place` is a little bit clunky; it makes footnotes out of the titlebox
    // difficult. But the alternative would be to enclose the entire document in
    // a `columns` element, and that has a lot of followup consequences that are even worse.
    paged: place(top + center, scope: "parent", float: true, clearance: 0pt)[
      #box(height: titlebox-height, width: 1fr)[
        #align(center)[
          // LaTeX starts the title 1/8 inch below the nominal top margin.
          #v(0.125in - (top-skip - body-cap))
          #let author-strut = 14 * tex-pt
          #if use-title {
            // TeX inserts baseline glue between the title and author strut.
            show std.title: set text(top-edge: "bounds", bottom-edge: 0.7 * author-strut - baseline-skip)
            title()
          } else {
            text(14.4 * tex-pt, font: tracl-serif)[#par(leading:0.5em)[
              *#papertitle*
            ]]
          }
        
          #v(0.2in)
          #v(1fr)
          #set text(12 * tex-pt, top-edge: 0.7 * author-strut, bottom-edge: -0.3 * author-strut)
          #if anonymous {
            [*Anonymous ACL submission*]
          } else {
            affiliations-state.update((numbered: (:), named: (:)))
            authors
            metadata((kind: TITLEBOX-END-MARKER))
          }
          #v(0.3in + top-skip - body-cap)
          #v(2fr)
        ]      
      ]
    ],

    // We generate HTML => just print the titlebox.
    html: [
      #if use-title {
        title()
      } else {
        text(14.4 * tex-pt, font: tracl-serif)[#par(leading:0.5em)[
          *#papertitle*
        ]]
      }

      #if anonymous {
        set text(12 * tex-pt)
        [*Anonymous ACL submission*]
      } else {
        affiliations-state.update((numbered: (:), named: (:)))
        set text(12 * tex-pt)
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
      // acl.sty indents the abstract by 0.6cm on both sides.
      box(width: 100% - 1.2cm,[
        #text(12 * tex-pt)[*Abstract*]
        #v(0.8em)
        #text(10 * tex-pt, align(left, abs))
      ])
    ),

    html: [
      // TODO wrap these in CSS classes, instead of specifying font sizes directly
      #text(12 * tex-pt)[*Abstract*]
      #v(0.8em)
      #text(10 * tex-pt, abs)
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
    show std.title: set text(14.4 * tex-pt, font: tracl-serif)
    show std.title: set par(leading:0.5em)
    doc
  } else {
    doc
  }
}

/// Typesets a document in the ACL style.
#let acl(
  /// The body of the document.
  /// -> content
  doc, 

  /// The title of the document.
  /// -> str | content
  title: none, 

  /// The authors as they should be displayed in the titlebox.
  /// You can use `make-authors` to typeset authors in a systematic way,
  /// or you can use free-form text.
  /// -> content
  authors: none, 

  /// The authors as they should be included in the PDF metadata.
  /// If `anonymous` is true, the authors field in the metadata will
  /// always say "Anonymous". Otherwise, if you leave `meta-authors`
  /// at `none`, the authors field will be left blank.
  /// -> str
  meta-authors: none, 

  /// Determines whether the paper should be anonymized. This will
  /// suppress author information and add page and line numbers.
  /// -> bool
  anonymous: false,

  /// Justify completed text columns vertically (Typst 0.15+).
  flushbottom: true,

  /// The height of the titlebox, i.e. the box at the top of the paper
  /// that contains the title and authors. Tracl won't let you reduce
  /// the height of the titlebox to be less than 5cm, in accordance
  /// with the ACL style rules.
  /// -> length
  titlebox-height: 11 * baseline-skip,

  /// Creates a document in the ACL style without a Pergamon
  /// `refsection`. Normally, each paper needs to be enclosed in a
  /// `refsection` so that you can cite papers and print a bibliography.
  /// However, in the specific context of the example `main.typ` file,
  /// where we nest an `acl` call within another `acl` call, this
  /// breaks the bibliography of the main document. Leave this
  /// parameter at `false` unless you know what you're doing.
  /// -> bool
  suppress-refsection: false
) = {
  // accessibility
  set document(title: title)
  
  if anonymous {
    set document(author: "Anonymous")
  } else if meta-authors != none {
    set document(author: meta-authors)
  }

  assert(titlebox-height >= 5cm)
  
  // some colors
  show link: it => text(darkblue)[#it]
  show ref: it => text(darkblue)[#it] // TODO - this makes all of "Section 6" blue; instead, make only the 6 blue

  // font sizes
  set text(11pt, font: tracl-serif)
  set par(leading: linespacing, first-line-indent: 4mm, justify: true, spacing: linespacing)

  // overall page setup - this only makes sense if we generate PDF
  let page-numbering = if anonymous { "1" } else { none } // number pages only if anonymous
  show: show-target(paged: doc => {
    let bottom = 297mm - last-baseline
    set page(paper: "a4", columns: 2, numbering: page-numbering,
      margin: (x: 25mm, top: first-baseline - body-cap, bottom: bottom),
      footer-descent: 30 * tex-pt - body-cap)
    set text(size: body-size, top-edge: cap-height, bottom-edge: "baseline")
    let gap = baseline-skip - body-cap
    set par(leading: gap, spacing: gap, first-line-indent: body-size)
    set columns(gutter: 6mm)

    doc
  })

  show figure.caption: set text(10 * tex-pt, font: tracl-serif)
  show figure.caption: set align(left)
  show figure.caption: it => [#v(0.5em) #it]

  show footnote.entry: set text(9 * tex-pt, font: tracl-serif)

  // Typst scales raw text to 0.8em. LaTeX typewriter text inherits its
  // surrounding size, including in footnotes and captions.
  show raw: set text(size: 1.25em, font: tracl-mono)

  // headings
  set heading(numbering: "1.1   ")

  // The natural skips are chosen such that the baseline distances above and
  // below a heading equal those of acl.sty's \section (23.91pt above, 20.78pt
  // below) and \subsection (22.31pt above, 17.55pt below), as measured in the
  // PDFs. The stretch of these skips is added by flush-bottom.
  show heading: it => {
    set block(above: if it.level == 1 { 15.91pt } else { 15.23pt })
    set text(if it.level == 1 { 12 * tex-pt } else { body-size })
    it
    v(if it.level == 1 { 13.64pt } else { 10.20pt }, weak: true)
  }

  // Space between a float (figure, table) and the text below it.
  // acl.sty leaves LaTeX's \textfloatsep at 20pt (plus 2pt minus 4pt). TeX
  // measures it from the bottom of the float to the box of the next line and
  // adds a baselineskip gap, so that the last caption baseline ends up 34.67pt
  // above the next text baseline. Typst measures `clearance` from the float to
  // the cap height of the next line; the extra 7.25pt below makes both
  // distances agree (measured: 34.68pt in Typst). Only the natural size is
  // reproduced: `clearance` is a fixed length, so \textfloatsep's stretch and
  // shrink are not.
  let textfloatsep = 20pt
  let typst-vs-tex-offset = 7.25pt
  set place(clearance: textfloatsep + typst-vs-tex-offset)

  // lists and enums
  set list(indent: 1em)
  show list: set par(spacing: 1em)

  set enum(indent: 1em)
  show enum: set par(spacing: 1em)

  // spacing around figures
  // show figure: set block(inset: (top: 0pt, bottom: 1cm))

  // if anonymous, add line numbering to every page
  show: it => {
    if anonymous {
      set par.line(numbering: "001", number-clearance: 1.6cm)
      set par.line(
        // lineno right-aligns the label inside a 10 TeX pt box. Labels are
        // wider than the box and overflow to its left.
        numbering: n => box(width: 10 * tex-pt, align(right, {
          text(sidenumgray, font: tracl-sans, size: 8 * tex-pt)[
            *#strfmt("{:03}", n)*
          ]
        }))
      )
      show figure: set par.line(numbering: none) // Disable numbers inside figures.
      it
    } else {
      it
    }
  }

  // typeset the titlebox and document
  style-title(maketitle(papertitle:title, authors:authors, anonymous:anonymous, titlebox-height: titlebox-height))
  print-title-footnotes()

  let body = if flushbottom {
    context { if target() == "paged" { flush-bottom(doc) } else { doc } }
  } else { doc }
  if suppress-refsection { body } else { acl-refsection(body) }




  // TODO: play around with these costs to optimize the layout in the end
  // set text(costs: (orphan: 0%, widow: 0%))
}

