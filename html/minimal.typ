
#show: doc => {
  html.html({
    html.head({
      html.link(
        href: "https://cdn.jsdelivr.net/gh/coli-saar/tracl@main/html/arxiv.css",
        rel: "stylesheet"
      )
    })

    html.body(doc)
  })
}


hallo