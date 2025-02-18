


#let citet(x) = cite(x, form: "prose")
#let citep(x) = cite(x)
#let citealp(x) = [#cite(x, form: "author"), #cite(x, form: "year")]
#let citeposs(x) = [#cite(x, form: "author")'s (#cite(x, form: "year"))]
