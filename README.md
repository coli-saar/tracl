# ACL Style for Typst

This repository contains a Typst template for writing ACL papers with Typst. It implements the official [ACL paper formatting guidelines](https://acl-org.github.io/ACLPUB/formatting.html) and is modeled after the [LaTeX style](https://github.com/acl-org/acl-style-files).


## Usage

The usage of the ACL style is documented in [main.pdf](main.pdf).

To start a new document, you will need to copy [acl.typ](https://github.com/coli-saar/typst-acl-style/blob/main/acl.typ), [acl-macros.typ](https://github.com/coli-saar/typst-acl-style/blob/main/acl-macros.typ), and [association-for-computational-linguistics-blinky.csl](https://github.com/coli-saar/typst-acl-style/blob/main/association-for-computational-linguistics-blinky.csl) into a new directory. The other files in this repository are for documentation purposes.


## Obtaining the fonts

The official ACL style uses fonts which are not preinstalled with Typst. You will need to download these fonts and [install them into your system](https://typst.app/docs/reference/text/text/#parameters-font). Here's how you can get them.

For the "Times" font, download [Nimbus Roman No9 L](https://www.fontsquirrel.com/fonts/nimbus-roman-no9-l). (This is the font that the "times" package of TexLive actually uses.)

For the "sans serif" font, download [Nimbus Sans](https://www.fontsquirrel.com/fonts/nimbus-sans-l). (This is a replacement for Helvetica.)

For the "typewriter" font, download [Inconsolata](https://fonts.google.com/specimen/Inconsolata).


## License information

The ACL style for Typst is distributed under the Apache License 2.0.

The SVG example picture in `pics/spec-paths-cubic01.svg` is (c) 2016 openscad under an MIT License. It comes from [this Github repository](https://github.com/openscad/svg-tests).
