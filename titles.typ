
#import "acl.typ": *

#let filler-text = [
  #abstract[
    This document demonstrates the different styles for
    specifying authors in tracl.
  ]  

  = Introduction
  #lorem(50)
]






#acl(
  anonymous: false,
  title: [Three authors from the same institution],
  authors: make-authors(
    authors: ("Michael Sullivan", "Mareike Hartmann", "Alexander Koller"),
    affiliation: [Department of Language Science and Technology\
      Saarland Informatics Campus\
      Saarland University, Saarbrücken, Germany\
      #email("{msullivan, mareikeh, koller}@coli.uni-saarland.de")
    ])
)[
  #filler-text
]

#pagebreak()

#acl(
  anonymous: false,
  title: [Three authors from different institutions],
  authors: make-authors(
    (
      authors: "Alex Duchnowski",
      affiliation: [Saarland University\ #email("alex@lst.uni-sb.de")]
    ),
    (
      authors: "Ellie Pavlick",
      affiliation: [Brown University\ #email("ellie_pavlick@brown.edu")]
    ),
    (
      authors: "Alexander Koller",
      affiliation: [Saarland University\ #email("koller@lst.uni-sb.de")]
    ),
  )
)[
  #filler-text
]

#pagebreak()

#acl(
  anonymous: false,
  title: [Mix of same and different institutions],
  authors: make-authors(
    (
      authors: ("Alex Duchnowski", "Alexander Koller"),
      affiliation: [Saarland University\ #email("{alex|koller}@lst.uni-sb.de")]
    ),
    (
      authors: "Ellie Pavlick",
      affiliation: [Brown University\ #email("ellie_pavlick@brown.edu")]
    ),
  )
)[
  #filler-text
]

#pagebreak()

#acl(
  anonymous: false,
  title: [Multiple rows of authors],
  authors: make-authors(
    // row 1
    (
      (
        authors: [Yuekun Yao],
        affiliation: [Saarland University\ #email("ykyao@coli.uni-saarland.de")]
      ),
      (
        authors: [Yupei Du],
        affiliation: [Utrecht University\ #email("y.du@uu.nl")],
      ),
      (
        authors: [Dawei Zhu],
        affiliation: [Saarland University\ #email("dzhu@lsv.uni-saarland.de")],
      )
    ),

    // row 2
    (
      (
        authors: [Michael Hahn],
        affiliation: [Saarland University\ #email("mhahn@lst.uni-saarland.de")],
      ),
      (
        authors: [Alexander Koller],
        affiliation: [Saarland University\ #email("koller@coli.uni-saarland.de")]
      )
    )
  )
)[
  #filler-text
]


// 
// 
// 
// 
// #show: acl.with(
//   anonymous: false,
//   title: [Instructions for \*ACL Proceedings],

//   // three authors from same institution
  // authors: (
  //   authors: ("Michael Sullivan", "Mareike Hartmann", "Alexander Koller"),
  //   affiliation: [Department of Language Science and Technology\
  //     Saarland Informatics Campus\
  //     Saarland University, Saarbrücken, Germany\
  //     #email("{msullivan, mareikeh, koller}@coli.uni-saarland.de")
  //   ])

//   // three authors from different institutions
//   // authors: (
//   //   (
//   //     authors: "Alex Duchnowski",
//   //     affiliation: [Saarland University\ #email("alex@lst.uni-sb.de")]
//   //   ),
//   //   (
//   //     authors: "Ellie Pavlick",
//   //     affiliation: [Brown University\ #email("ellie_pavlick@brown.edu")]
//   //   ),
//   //   (
//   //     authors: "Alexander Koller",
//   //     affiliation: [Saarland University\ #email("koller@lst.uni-sb.de")]
//   //   ),
//   // )

//   // mix of same and different institutions
//   authors: make-authors(
//     (
//       authors: ("Alex Duchnowski", "Alexander Koller"),
//       affiliation: [Saarland University\ #email("{alex|koller}@lst.uni-sb.de")]
//     ),
//     (
//       authors: "Ellie Pavlick",
//       affiliation: [Brown University\ #email("ellie_pavlick@brown.edu")]
//     ),
//   )

//   // multiple rows of authors
//   // authors: make-authors(
//   //   // row 1
//   //   (
//   //     (
//   //       authors: [Yuekun Yao],
//   //       affiliation: [Saarland University\ #email("ykyao@coli.uni-saarland.de")]
//   //     ),
//   //     (
//   //       authors: [Yupei Du],
//   //       affiliation: [Utrecht University\ #email("y.du@uu.nl")],
//   //     ),
//   //     (
//   //       authors: [Dawei Zhu],
//   //       affiliation: [Saarland University\ #email("dzhu@lsv.uni-saarland.de")],
//   //     )
//   //   ),

//   //   // row 2
//   //   (
//   //     (
//   //       authors: [Michael Hahn],
//   //       affiliation: [Saarland University\ #email("mhahn@lst.uni-saarland.de")],
//   //     ),
//   //     (
//   //       authors: [Alexander Koller],
//   //       affiliation: [Saarland University\ #email("koller@coli.uni-saarland.de")]
//   //     )
//   //   )
//   // )


// )

