#let script-size = 8pt
#let footnote-size = 8.5pt
#let small-size = 9pt
#let normal-size = 10pt
#let large-size = 13pt

#let body-font = "EB Garamond"
#let header-font = "Montserrat"

#let num_cols = 2

#let article(
  title: [Paper title],
  authors: (),
  abstract: none,
  paper-size: "us-letter",
  bibliography-file: none,
  body,
) = {

  set page(
    paper: paper-size,
    margin: {
      (
        top: 2.5cm,
        left: 2cm,
        right: 2cm,
        bottom: 2.5cm
      )
  })

  let names = authors.map(author => author.name)
  let author-string = if authors.len() == 2 {
    names.join(" & ")
  } else {
    names.join(", ", last: ", & ")
  }

  set document(title: title, author: names)
  set text(size: normal-size, font: body-font)

  // Configure headings.
  set heading(numbering: "1.")
  show heading: it => {

    // Create the heading numbering.
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(0.5em, weak: true)
    }

    // Level 1 heading
    set text(size: normal-size, weight: 400, font: header-font)
    if it.level == 1 {

      set align(center) 

      v(1em, weak:true)
      smallcaps(text(weight: "bold", number + it.body))
      v(1em, weak:true)

    // Other level headings
    } else {
      
      text(weight: "medium",number + it.body)
    }
  }

  // Configure lists and links.
  set list(indent: 8pt, body-indent: 5pt)
  set enum(indent: 8pt, body-indent: 5pt)

  // Configure equations.
  show math.equation: set block(below: 8pt, above: 9pt)
  show math.equation: set text(weight: 400)

  // Configure citation and bibliography styles.
  set bibliography(style: "oikos.csl", title: [References])

  show figure: it => {

    // Space, then figure
    v(2em, weak: true)
    it.body

    // Display the figure's caption.
    if it.has("caption") {

      set text(size: footnote-size) 
      smallcaps(it.supplement)
      if it.numbering != none {
        [ ]
        it.counter.display(it.numbering)
      }
      [. ] 
      it.caption.body
    }

    v(2em, weak: true)
  }

  let title ={
    // Display the title
    align(horizon + center, 
      par(leading: 0.75em,
      upper(
        text(size: 15pt, weight: 600, font: header-font, title)
    )))
  }

  let abstract = {

    if abstract != none {
      align(center, smallcaps("Abstract."))
      par(justify: true, abstract)
    }
  }

  let author ={
    align(center, 
      smallcaps((text(font: header-font, 
                      size: footnote-size, 
                      author-string))))
  }
  
  // Display title and Abstract horizontally 
  grid(columns: (1fr, 2.5fr),
      column-gutter: 0.25cm,
      title,
      abstract
  )
  author
  line(start: (5%, 0%), end: (95%, 0%))
 
  v(1cm, weak: true)
  show: rest => columns(num_cols, rest)

  // Display the article's contents.
  par(first-line-indent: 2em,  justify: true, body)

  // Display the bibliography, if any is given.
  if bibliography-file != none {
    bibliography(bibliography-file)
  }

  for author in authors {

    author.at("name")
    linebreak()

    let keys = ("department", "organization", "location")
    let dept-str = keys
      .filter(key => key in author)
      .map(key => author.at(key))
      .join(", ")

    smallcaps(dept-str)
    linebreak()

    if "email" in author [
      #link("mailto:" + author.email) \
    ]

    if "url" in author [
      _URL:_ #link(author.url)
    ]

    v(12pt, weak: true)
  }
}