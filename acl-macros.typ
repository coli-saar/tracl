

// citation commands
#let citet(x) = cite(x, form: "prose")
#let citep(x) = cite(x)
#let citealp(x) = [#cite(x, form: "author"), #cite(x, form: "year")]
#let citeposs(x) = [#cite(x, form: "author")'s (#cite(x, form: "year"))]

// Switch to appendix. By default, the appendices start on a fresh page.
// If you don't want this, pass "clearpage: false".
#let appendix(content, clearpage: true) = {
  if( clearpage ) { pagebreak() }

  set heading(numbering: "A.1", supplement: "Appendix")
  counter(heading).update(0)

  content
}

