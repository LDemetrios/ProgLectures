

#let rettype = state("return type")
#let retval = state("return value")
#let gl-code = state("code")

#let append(code, print: none, result, result-type) = {
  gl-code.update(it => raw(it.text + code.text, lang: "kt"))
  [
    #gl-code.display()\
    `=> :` #raw(result-type.text, lang: "kt")` = `#raw(result.text, lang: "kt") \
    #if (print != none) {
      text(fill: rgb("#54b33e"))[#raw(print.text)]
    } else {}
  ]
  retval.update(raw(result.text, lang: "kt"))
  rettype.update(raw(result-type.text, lang: "kt"))
}

#let format(code, print: none, result, result-type) = {
  gl-code.update(``)
  append(code, print: print, result, result-type)
}

#let format-comp-err(code, err) = [
  #raw(code.text, lang: "kt")\
  `Compilation error: `#raw(err.text, lang: "kt")
]

#let format-runt-err(code, err) = [
  #raw(code.text, lang: "kt")\
  #raw(err.text)
]

#let kt-eval-alone(code) = {
  // Ignore yet
}

#let kt-alone(code) = [
  #raw(code.text, lang: "kt") \
]
#let kt-res(code, type) = [
  #raw("=> : " + type.text + " = " + code.text, lang: "kt") \
]
#let kt-print(code) = [
  #text(fill: rgb("#54b33e"), raw(code.text)) \
]
#let kt-comp-err(err) = [
  #text(fill: rgb("#FA3232"), raw(err.text)) \
]
#let kt-runt-err(err) = [
  #text(fill: rgb("#FA3232"), raw(err.text)) \
]

#let kt-fmt(code) = [
  #raw(code.text, lang: "kt")
]

#let join-raw(code) = {
  let i = 0
  while i < code.len() {
    i += 1
    raw(code.at(i - 1))
  }
}
#let raw-rule(code) = join-raw(code.text)
#let kt-ext-fun(code) = text(fill: rgb("#BF9451"), join-raw(code.text))

#let kt-show-rules = rest => [
  #show "stdout": raw-rule

  #show regex("(until|rangeTo|downTo)") : kt-ext-fun
  #rest
]

#let comment(body) = rect(
  width: 100%,
  fill: white,
  stroke: (paint: black, thickness: 3pt),
  radius: 10pt,
  inset: 7%,
  outset: -3%,
  [\ #body\ \ ],
)

#let datatype(text) = join-raw(text)
#let static-function(text) = join-raw(text)
#let ext-function(text) = join-raw(text)
#let kt-keyword(txt) = text(fill: rgb("#ed864a"), join-raw(txt))

#let kt-par(body) = [
  #show "Nothing?" : datatype("Nothing?")
  #show "Nothing" : datatype("Nothing")
  #show "Int?" : datatype("Int?")
  #show "Int" : datatype("Int")
  #show "Long?" : datatype("Long?")
  #show "Long" : datatype("Long")
  #show "Short?" : datatype("Short?")
  #show "Short" : datatype("Short")
  #show "Byte?" : datatype("Byte?")
  #show "Byte" : datatype("Byte")
  #show "Char?" : datatype("Char?")
  #show "Char" : datatype("Char")
  #show "Float?" : datatype("Float?")
  #show "Float" : datatype("Float")
  #show "Double?" : datatype("Double?")
  #show "Double" : datatype("Double")
  #show "Any?" : datatype("Any?")
  #show "Any" : datatype("Any")
  #show "String?" : datatype("String?")
  #show "String" : datatype("String")
  #show "Unit?" : datatype("Unit?")
  #show "Unit" : datatype("Unit")

  #show "print" : static-function("print")
  #show "println" : static-function("println")

  #show "val" : kt-keyword("val")
  #show "var" : kt-keyword("var")
  #show "do" : kt-keyword("do")
  #show "while" : kt-keyword("while")

  #body
]