
// This is a minimal starting document for tracl, a Typst style for ACL.
// See https://github.com/coli-saar/tracl for details.


#import "@preview/tracl:0.6.1": *
#import "@local/pergamon:0.5.0": * // NB change both



#show: doc => acl(doc,
  anonymous: false,
  title: [A Blank ACL Paper],
  authors: (
    (
      name: "Your Name",
      affiliation: [Your Affiliation],
      email: "your@email.edu",
    ),
  ),
)


#abstract[
  #lorem(50)
]


= Introduction

#lorem(80)

#lorem(80)

#lorem(80)


// Uncomment this to include your bibliography

/*
#add-bib-resource(read("custom.bib"))
#print-acl-bibliography()
*/