#import "tablex.typ": tablex, rowspanx, colspanx, hlinex, vlinex

//////////// Standard types

#let kttype(s) = raw(s, lang: "kt")

#let KtBool = kttype("Boolean")
#let KtByte = kttype("Byte")
#let KtShort = kttype("Short")
#let KtInt = kttype("Int")
#let KtLong = kttype("Long")
#let KtChar = kttype("Char")
#let KtFloat = kttype("Float")
#let KtDouble = kttype("Double")
#let KtString = kttype("String")
#let KtUnit = kttype("Unit")
#let KtNothing = kttype("Nothing")

#let KtStar = kttype("*")

#let Any = kttype("Any")
#let Array(of) = kttype("Array<" + of.text + ">")
#let List(of) = kttype("List<" + of.text + ">")
#let MutableList(of) = kttype("MutableList<" + of.text + ">")
#let Pair(f, s) = kttype("Pair<" + f.text + ", " + s.text + ">")
#let Comparable(of) = kttype("Comparable<" + of.text + ">")

//////////// Custom styles

#let indent(body) = par(first-line-indent: 10pt, hanging-indent: 10pt, body)

#let comment(body) = rect(
  width: 100%,
  fill: rgb("#94d37e"),
  stroke: (paint: black, thickness: 1pt),
  radius: 10pt,
  inset: 7%,
  outset: -3%,
  [\ #body\ \ ],
)

#let strikeleft(body) = tablex(
  columns: 3,
  align: left + horizon,
  auto-hlines: false,
  auto-vlines: false,
  [],
  vlinex(start: 0, end: 1, stroke: black + 2pt),
  [],
  body,
)

//////////// Code sample blocks

#let kt(code) = raw(code.text, lang: "kt")

#let kt-eval(code) = [
  #indent(raw(code.text, lang: "kt"))
]
#let kt-eval-noret(code) = [
  #indent(raw(code.text, lang: "kt"))
]
#let kt-eval-append(code) = [
  #indent(raw(code.text, lang: "kt"))
]
#let kt-res(code, type) = [
  #indent(raw("=> : " + type.text + " = " + code.text, lang: "kt"))
]
#let kt-print(code) = [
  #indent(text(fill: rgb("#54b33e"), raw(code.text)))
]
#let kt-comp-err(err) = [
  #indent(text(fill: rgb("#FA3232"), raw(err.text)))
]
#let kt-runt-err(err) = [
  #indent(text(fill: rgb("#FA3232"), raw(err.text)))
]

//////////// Paragraph styling

#let join-raw(code) = {
  let i = 0
  while i < code.len() {
    i += 1
    raw(code.at(i - 1))
  }
}
#let raw-rule(code) = join-raw(code.text)

#let datatype(text) = join-raw(text)
#let static-function(text) = join-raw(text)
#let ext-function(text) = join-raw(text)
#let kt-keyword(txt) = text(fill: rgb("#0033b3"), join-raw(txt))

#let kt-literal(lit, typ) = if (typ == KtInt) {
  text(fill: rgb("#1750eb"), join-raw(lit))
} else if (typ == KtLong) {
  text(fill: rgb("#1750eb"), join-raw(lit))
} else if (typ == KtChar) {
  text(fill: rgb("#54b33e"), join-raw(lit))
} else if (typ == KtString) {
  text(fill: rgb("#54b33e"), join-raw(lit))
} else if (typ == KtDouble) {
  text(fill: rgb("#000000"), join-raw(lit))
} else if (typ == KtBool) {
  text(fill: rgb("#ed864a"), join-raw(lit))
} else [
  UNKNOWN LITERAL TYPE
]

#let kt-par(body) = [
  #show regex("\bNothing\?") : datatype("Nothing?")
  #show regex("\bNothing\b") : datatype("Nothing")
  #show regex("\bInt\?") : datatype("Int?")
  #show regex("\bInt\b") : datatype("Int")
  #show regex("\bLong\?") : datatype("Long?")
  #show regex("\bLong\b") : datatype("Long")
  #show regex("\bShort\?") : datatype("Short?")
  #show regex("\bShort\b") : datatype("Short")
  #show regex("\bByte\?") : datatype("Byte?")
  #show regex("\bByte\b") : datatype("Byte")
  #show regex("\bChar\?") : datatype("Char?")
  #show regex("\bChar\b") : datatype("Char")
  #show regex("\bFloat\?") : datatype("Float?")
  #show regex("\bFloat\b") : datatype("Float")
  #show regex("\bDouble\?") : datatype("Double?")
  #show regex("\bDouble\b") : datatype("Double")
  #show regex("\bAny\?") : datatype("Any?")
  #show regex("\bAny\b") : datatype("Any")
  #show regex("\bString\?") : datatype("String?")
  #show regex("\bString\b") : datatype("String")
  #show regex("\bUnit\?") : datatype("Unit?")
  #show regex("\bUnit\b") : datatype("Unit")
  //
  #show regex("\bprint\b") : static-function("print")
  #show regex("\bprintln\b") : static-function("println")
  //
  #show regex("\bval\b") : kt-keyword("val")
  #show regex("\bvar\b") : kt-keyword("var")
  #show regex("\bdo\b") : kt-keyword("do")
  #show regex("\bwhile\b") : kt-keyword("while")
  #show regex("\bif\b") : kt-keyword("if")
  #show regex("\belse\b") : kt-keyword("else")
  #show regex("\bfun\b") : kt-keyword("fun")
  #show regex("\bobject\b") : kt-keyword("object")
  #show regex("\bclass\b") : kt-keyword("class")
  #show regex("\binterface\b") : kt-keyword("interface")
  #show regex("\breturn\b") : kt-keyword("return")
  #show regex("\bbreak\b") : kt-keyword("break")
  #show regex("\bcontinue\b") : kt-keyword("continue")
  #show regex("\bthrow\b") : kt-keyword("throw")
  #show regex("\bnull\b") : kt-keyword("null")
  #show regex("\blateinit\b") : kt-keyword("lateinit")
  //
  // #show regex("[0-9]{2,}") : (num) => kt-literal(num.text)
  //
  #show regex("\bstdout\b") : join-raw("stdout")
  #show regex("\bstderr\b") : join-raw("stderr")
  #show regex("\bstdin\b") : join-raw("stdin")
  #body
]

