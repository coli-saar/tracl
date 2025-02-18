
// Typst ACL style - https://github.com/coli-saar/typst-acl-style
// by Alexander Koller

// 2025-02-18 v0.4, many small changes and cleanup, and switch to Nimbus fonts
// v0.3.2, ensure page numbers are printed only in anonymous version
// v0.3.1, fixed "locate" deprecation
// v0.3, adjusted some formatting to the ACL style rules
// v0.2, adapted to Typst 0.12

// "Times" in Tex Live is actually Nimbus Roman
#let times = ("Nimbus Roman No9 L", "Libertinus Serif")  
#let sans = ("Nimbus Sans L", "Helvetica")
#let mono = ("Inconsolata", "DejaVu Sans Mono")

#let linespacing = 0.55em

// fixed for Typst 0.12
#let maketitle(title:none, authors:none, anonymous:false) = place(
  top + center, scope: "parent", float: true)[
    #box(height: 5cm, width: 1fr)[
      #align(center)[
        #text(15pt, font:times)[#par(leading:0.5em)[
          *#title*
        ]]
        #v(2.5em)
      
        #if anonymous {
          set text(12pt)
          [*Anonymous ACL submission*]
        } else {
          text(12pt)[#par(leading: 0.5em)[
            #let count = authors.len()
            #let ncols = calc.min(count, 3)
            #grid(
              columns: (1fr,) * ncols,
              row-gutter: 24pt,
              ..authors.map(author => [
                *#author.name* \
                #author.affiliation \
                #text(font:mono, 11pt)[#link("mailto:" + author.email)]
              ]),
            )
            ]]
        }
        #v(1em)
      ]      
    ]
  ]


#let darkblue = rgb("000099")
#let sidenumgray = rgb("aaaaaa")

#show link: it => text(blue)[#it]


#let abstract(abs) = [
  #set par(leading: linespacing, first-line-indent: 0em, justify: true)
  #align(center, 
    box(width: 90%,[
      #text(12pt)[*Abstract*]
      #v(0.8em)
      #text(10pt, align(left, abs))
    ])
  )]

#let sidenum(i) = {
  let s = str(i)
  while s.len() < 3 {
    s = "0" + s
  }
  text(font: sans, 7pt, fill: sidenumgray)[#s]
}

#let acl(doc, title:none, authors: none, anonymous: false) = {
  // overall page setup
  let page-numbering = if anonymous { "1" } else { none } // number pages only if anonymous
  set page(paper: "a4", margin: (x: 2.5cm, y: 2.5cm), columns: 2, numbering: page-numbering)
  set columns(gutter: 6mm)
  
  // some colors
  show link: it => text(darkblue)[#it]
  show cite: it => text(darkblue)[#it]
  show ref: it => text(darkblue)[#it] // TODO - this makes all of "Section 6" blue; instead, make only the 6 blue
  

  // font sizes
  set text(11pt, font: times)
  set par(leading: linespacing, first-line-indent: 4mm, justify: true, spacing: linespacing)

  show figure.caption: set text(10pt, font:times)
  show figure.caption: set align(left)
  show figure.caption: it => [#v(0.5em) #it]

  show footnote.entry: set text(9pt, font: times)

  // headings
  set heading(numbering: "1.1")

  let sectionheading(title) = {
    v(1.2em, weak: true)
    text(12pt, font: times)[#title]
    v(1em, weak: true)
  }

  show heading.where(level:1): it => sectionheading(it)

  show heading.where(level:2): it => {
    // This is better than it was, but = followed by ==
    // is still too wide a gap - get rid of it manually with v(-0.5em) if needed
    v(1.5em, weak: true)
    text(11pt, font: times)[#it]
    v(1em, weak: true)
  }

  // lists
  set list(marker: text(7pt)[#v(5pt)●], indent: 1em)
  show list: e => {
    show par: p => {
      v(1em) 
      p
    }
   e
   v(1em)
  }

  set enum(indent: 1em)
  show enum: e => {
    show par: p => {
      v(1em) 
      p
    }
   e
  v(1em)
  }

  // spacing around figures
  // show figure: set block(inset: (top: 0pt, bottom: 1cm))

  // bibliography
  show bibliography: it => {
    set text(size: 10pt)
    set par(leading: linespacing, first-line-indent: 0mm, hanging-indent: 4mm, justify: true, spacing: 1em)
    show heading: it => sectionheading("References")
    it
  }

  // if anonymous, add line numbering to every page
  // by executing it in the header
  // TODO - font for line numbers is not quite right
  let h = ""
  if anonymous {
    h = {
      context { 
        let loc = here()
        let p = loc.page()-1
        let ystart=2.4cm
        for row in range(50) {
          place(dx:-2cm, dy:ystart + 5mm * row, sidenum(p*100+row))
          place(dx:17.5cm, dy:ystart + 5mm * row, sidenum(p*100+row+50))
        }
      }
    }
  }
  
  set page(header: h)
  

  // TODO: play around with these costs to optimize the layout in the end
  // set text(costs: (orphan: 0%, widow: 0%))

  
  maketitle(title:title, authors:authors, anonymous:anonymous)
    
  doc
}



