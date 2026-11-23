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
        let preceding = query(selector(<tracl-flushbottom-end>).before(here())).filter(it => it.value.scope == scope)
        let following = query(selector(<tracl-flushbottom-start>).after(here())).filter(it => it.value.scope == scope)
        let document-end = query(<tracl-flushbottom-document-end>).filter(it => it.value.scope == scope)
        if preceding.len() > 0 and following.len() > 0 and document-end.len() > 0 {
          let end = preceding.last().location().position()
          let next-location = following.first().location()
          let next = next-location.position()
          // A fractional gap would suppress a heading's larger block.above.
          // Leave heading boundaries natural; distribute the spare height
          // among the ordinary paragraph gaps elsewhere in this column.
          let heading-between = query(selector(heading).after(here()).before(next-location)).len() > 0
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
          if end.page == next.page and same-column and completed and not heading-between {
            // Weak fractional space suppresses the natural par.spacing.
            // Restore that minimum explicitly, only for an internal gap.
            v(par.spacing)
            v(1fr, weak: true)
          }
        }
      }
    }
  }
  body
  [#metadata((scope: scope))<tracl-flushbottom-document-end>]
}
