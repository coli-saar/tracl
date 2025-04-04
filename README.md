# Tracl: ACL Style for Typst

Tracl is a Typst template for writing papers for the *ACL series of conferences with Typst (ACL, EACL, NAACL, EMNLP, etc.).


It implements the official [ACL paper formatting guidelines](https://acl-org.github.io/ACLPUB/formatting.html) and is modeled after the [LaTeX style](https://github.com/acl-org/acl-style-files). Tracl is the **T**ypst **R**econstruction of the **ACL** style.

Tracl was developed by [Alexander Koller](https://www.coli.uni-saarland.de/~koller/), out of a personal desire to use Typst to write ACL papers. It is not officially supported by the  ACL is the [Association for Computational Linguistics](https://www.aclweb.org/portal/).

## Usage

The usage of the ACL style is documented in [main.pdf](https://github.com/coli-saar/tracl/blob/main/main.pdf).
An example of a full paper prepared with tracl is [here](https://arxiv.org/abs/2502.13776).


## Obtaining the fonts

The official ACL style uses fonts which are not preinstalled with Typst. You can still compile your Typst document with the ACL style, but it will use fallback fonts and not look like an ACL paper. You should therefore download these fonts and make them available to Typst.
They are licensed under open licenses.

- For the "Times" font, download [Nimbus Roman No9 L](https://www.fontsquirrel.com/fonts/nimbus-roman-no9-l). (This is the font that the "times" package of TexLive actually uses.)
- For the "sans serif" font, download [Nimbus Sans](https://www.fontsquirrel.com/fonts/nimbus-sans-l). (This is a replacement for Helvetica.)
- For the monospace ("typewriter") font, download [Inconsolata](https://fonts.google.com/specimen/Inconsolata).

If you are working in the _Typst web app_, copy all font files (\*.otf and \*.ttf) into the top level of your Typst project. If you are _working offline_, you can [install them into your system](https://typst.app/docs/reference/text/text/#parameters-font). 



## License information

The ACL style for Typst is distributed under the Apache License 2.0.

The SVG example picture in `pics/spec-paths-cubic01.svg` is (c) 2016 openscad under an MIT License. It comes from [this Github repository](https://github.com/openscad/svg-tests).
