// Internal paragraph-flow helpers. Do not change spacing inside nested layouts.
#let tagged(it) = {
  let children = it.body.fields().at("children", default: ())
  if children.len() == 0 or children.first().func() != metadata { return false }
  let value = children.first().value
  value == "tracl:flushbottom:skip" or (
    type(value) == dictionary and value.at("kind", default: none) == "tracl-flush"
  )
}

#let natural-spacing(body) = {
  show par: it => if tagged(it) { it } else {
    let fields = it.fields()
    let body = fields.remove("body")
    let original-label = fields.remove("label", default: none)
    [#par(..fields, [#metadata("tracl:flushbottom:skip")#body])#original-label]
  }
  body
}

// The stretch of the glue around a heading in acl.sty, as fr weights relative
// to the 1 pt of \parskip stretch that a paragraph gap carries (1fr). LaTeX
// adds \parskip before the heading's paragraph and before the paragraph that
// follows it, on top of the `plus` parts of the \section, \subsection and
// \subsubsection skips. One ex of the 11 pt Times body is about 4.9 pt, so
// the section skip above (plus 0.5ex) weighs 0.5 * 4.9 + 1 = 3.45fr.
#let heading-stretch(level) = {
  let ex = 4.9
  (above: 0.5 * ex + 1, below: (if level == 1 { 0.3 } else { 0.2 }) * ex + 1)
}

// Whether the gap around `here()` lies inside a completed column and can
// absorb spare height. Returns none when the layout is not settled yet.
// Call from a context.
#let open-gap(scope) = {
  let preceding = query(selector(<tracl-flushbottom-end>).before(here())).filter(it => it.value.scope == scope)
  let following = query(selector(<tracl-flushbottom-start>).after(here())).filter(it => it.value.scope == scope)
  let document-end = query(<tracl-flushbottom-document-end>).filter(it => it.value.scope == scope)
  let document-start = query(<tracl-flushbottom-document-start>).filter(it => it.value.scope == scope)
  if following.len() == 0 or document-end.len() == 0 or document-start.len() == 0 { return none }
  let end = if preceding.len() > 0 {
    preceding.last().location().position()
  } else {
    // No ordinary paragraph precedes (e.g. a heading right after the
    // abstract), so the gap starts here, unless that is the very top of the
    // flow, where a stretch must not move the text down.
    let start = document-start.first().location().position()
    let here-position = here().position()
    if here-position.page == start.page and calc.abs(here-position.y - start.y) < 1pt { return none }
    here-position
  }
  let next-location = following.first().location()
  let next = next-location.position()
  let split = page.width / 2
  let same-column = (end.x < split) == (next.x < split)
  let final = document-end.last().location().position()
  let breaks = query(selector(<tracl-flow-break>).after(here())).filter(it => it.value.scope == scope)
  if breaks.len() > 0 {
    let ends = query(selector(<tracl-flushbottom-end>).before(breaks.first().location()))
      .filter(it => it.value.scope == scope)
    if ends.len() > 0 { final = ends.last().location().position() }
  }
  // A used right column means the left one is complete, even on the
  // last page. Only the actual final column remains unstretched.
  let completed = end.page < final.page or (
    end.page == final.page and end.x < split and final.x >= split
  )
  (
    open: end.page == next.page and same-column and completed,
    heading-between: query(selector(heading).after(here()).before(next-location)).len() > 0,
  )
}

// Flush-bottom paragraph spacing for a continuous two-column prose flow.
// Requires Typst 0.15+ (weak fractional vertical spacing).
// The ACL layout has symmetric margins and a centred gutter.
#let flush-bottom(body) = context {
  let scope = here()
  assert(sys.version >= version(0, 15, 0),
    message: "Flush-bottom layout requires Typst 0.15 or newer; use acl(flushbottom: false) on older compilers.")
  // Explicit breaks end a flow segment; do not stretch its short final column.
  show pagebreak: it => [#metadata((scope: scope))<tracl-flow-break>#it]
  show colbreak: it => [#metadata((scope: scope))<tracl-flow-break>#it]
  show figure: it => natural-spacing(it)
  show footnote.entry: it => natural-spacing(it)
  show list: it => natural-spacing(it)
  show enum: it => natural-spacing(it)
  show table: it => natural-spacing(it)
  show block: it => natural-spacing(it)
  show box: it => natural-spacing(it)

  // Like \section in acl.sty, headings carry stretchable space above and
  // below, only inside a completed column. A weak fractional space replaces
  // the weak spaces next to it, which would drop the natural skips (the
  // heading's block spacing and the paragraph spacing). A zero-height block
  // between it and the heading keeps the heading's own skip, so the natural
  // skip and the stretch add up. The separator below is sticky like the
  // heading, so that a heading is never stranded at the bottom of a column.
  // (A sticky separator above makes the layout oscillate.)
  let separator(sticky) = block(height: 0pt, above: 0pt, below: 0pt, sticky: sticky)
  show heading: it => {
    let stretch = heading-stretch(it.level)
    context {
      let gap = open-gap(scope)
      if gap != none and gap.open {
        v(stretch.above * 1fr, weak: true)
        separator(false)
      }
    }
    it
    context {
      let gap = open-gap(scope)
      if gap != none and gap.open {
        separator(true)
        v(stretch.below * 1fr, weak: true)
      }
    }
  }

  show par: it => {
    // The inline marker also guards against applying this transformation again
    // when Typst sees the reconstructed paragraph. Keep original par labels.
    let marked = tagged(it)
    if marked {
      it
    } else {
      let fields = it.fields()
      let original = fields.remove("body")
      let original-label = fields.remove("label", default: none)
      [#par(..fields, [#metadata((kind: "tracl-flush", scope: scope))<tracl-flushbottom-start>#original#metadata((kind: "tracl-flush", scope: scope))<tracl-flushbottom-end>])#original-label]
      context {
        let gap = open-gap(scope)
        // A fractional gap would suppress a heading's larger block.above, so
        // gaps around headings are stretched by the heading rule below.
        if gap != none and gap.open and not gap.heading-between {
          // Weak fractional space suppresses the natural par.spacing.
          // Restore that minimum explicitly, only for an internal gap.
          v(par.spacing)
          v(1fr, weak: true)
        }
      }
    }
  }
  [#metadata((scope: scope))<tracl-flushbottom-document-start>]
  body
  [#metadata((scope: scope))<tracl-flushbottom-document-end>]
}
