# ACL Style for Typst

This repository contains a Typst template for writing ACL papers with Typst. It implements the official [ACL paper formatting guidelines](https://acl-org.github.io/ACLPUB/formatting.html) and is modeled after the [LaTeX style](https://github.com/acl-org/acl-style-files).


## Usage

The usage of the ACL style is documented in [main.pdf](main.pdf).


## Obtaining the fonts

The official ACL style uses fonts which are not preinstalled with Typst. Here's how you can get them.

For the "typewriter" font, download [Inconsolata](https://fonts.google.com/specimen/Inconsolata) and [install it into your system](https://typst.app/docs/reference/text/text/#parameters-font).

For the "sans serif" font, the style file currently uses Open Sauce One or Helvetica, whichever one is available on your system. Open Sauce One is preinstalled in the Typst web editor.

Times Roman, the main font for the body of an ACL paper, does not seem to be available as a free font. You can extract it from your LaTeX installation as an OTF font, which Typst can read. Proceed as follows (note that these instructions currently assume we are using Mactex on a Mac):

- Install [FontForge](https://fontforge.org/en-US/), e.g. with `brew install fontforge`.
- Locate the Times font in your LaTeX distribution, e.g. in `/usr/local/texlive/2024/texmf-dist/fonts/type1/urw/times/*.pfb`.
- For each of these font files, convert it into OTF with `fontforge -lang=ff -c 'Open("/usr/local/texlive/2024/texmf-dist/fonts//type1/urw/times/utmr8a.pfb"); Generate("utmr8a.otf");'` etc.


