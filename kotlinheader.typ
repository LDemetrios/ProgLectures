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
#let KtBool7 = kttype("Boolean?")
#let KtByte7 = kttype("Byte?")
#let KtShort7 = kttype("Short?")
#let KtInt7 = kttype("Int?")
#let KtLong7 = kttype("Long?")
#let KtChar7 = kttype("Char?")
#let KtFloat7 = kttype("Float?")
#let KtDouble7 = kttype("Double?")
#let KtString7 = kttype("String?")
#let KtUnit7 = kttype("Unit?")
#let KtNothing7 = kttype("Nothing?")
#let KtStar = kttype("*")

#let Any = kttype("Any")
#let Array(of) = kttype("Array<" + of.text + ">")
#let List(of) = kttype("List<" + of.text + ">")
#let MutableList(of) = kttype("MutableList<" + of.text + ">")
#let Pair(f, s) = kttype("Pair<" + f.text + ", " + s.text + ">")
#let Comparable(of) = kttype("Comparable<" + of.text + ">")


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
  text(fill: rgb("#017C01"), join-raw(lit))
} else if (typ == KtString) {
  text(fill: rgb("#017C01"), join-raw(lit))
} else if (typ == KtDouble) {
  text(fill: rgb("#1750eb"), join-raw(lit))
} else if (typ == KtBool) {
  text(fill: rgb("#0033b3"), join-raw(lit))
} else if (typ == KtUnit) {
  text(fill: rgb("#000000"), join-raw(lit))
} else [
  #text(fill:rgb("#000000"), join-raw(lit))
]


//////////// Custom styles

#let indent(body) = par(first-line-indent: 10pt, hanging-indent: 10pt, body)

#let comment(body) = rect(
  width: 100%,
  fill: luma(230),
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

#let nobreak(body) = block(breakable: false, body)

//////////// Code sample blocks

#let kt(code) = [
  #show regex("\b(var|null|if|else|fun|val|do|while|object|class|interface|return|break|continue|throw|lateinit|as|is|in|for|true|false|data|companion|infix|operator|override|public|private|protected|inline|internal|constructor|import|abstract|open)\b") : (it) => text(weight:"bold" /*, fill:rgb(0, 127, 255)*/, it)
  #show regex("\"([^\"]*|\\[\"\\ntrf$])\"") : (it) => text(fill:rgb("#017C01"), it)
  #show regex("'([ -~]|\\[\\\"nrtf]|\\\\u[0-9a-fA-F]{4})'") : (it) => text(fill:rgb("#017C01"), it)
  #show regex("-?[0-9]+(\.[0-9]+([eE][+-]?[0-9]+)?)?") : (it) => text(fill:rgb("#1750eb"), it)
  #show regex("//[^\n]*") : (it) => text(fill:rgb("#7F7F7F"), it)
  #show regex("(?ms)/\*([^\*]|\*[^/]|\n|\r)*\*/") : (it) => text(fill:rgb("#7F7F7F"), it)
  #text(fill: rgb("#002583"), raw(code.text))
]

#let kt-eval(code) = [
  #indent(kt(code))
]
#let kt-eval-noret(code) = [
    #indent(kt(code))
]
#let kt-eval-append(code) = [
   #indent(kt(code))
]
#let kt-eval-append-noret(code) = [
   #indent(kt(code))
]
#let kt-res(code, typ) = [
  #indent[`=> : `*#raw(typ.text)*` = `#kt-literal(code.text, typ)]
]
#let kt-print(code) = [
  #indent(text(fill: rgb("#017C01"), raw(code.text)))
]
#let kt-comp-err(err) = [
  #indent(text(fill: rgb("#FA3232"), raw(err.text)))
]
#let kt-runt-err(err) = [
  #indent(text(fill: rgb("#FA3232"), raw(err.text)))
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
  #show regex("\bNumber\?") : datatype("Number?")
  #show regex("\bNumber\b") : datatype("Number")
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
  #show regex("\bdata\b") : kt-keyword("data")
  #show regex("\bcompanion\b") : kt-keyword("companion")
  #show regex("\bthis\b") : kt-keyword("this")
  #show regex("\binfix\b") : kt-keyword("infix")
  #show regex("\boperator\b") : kt-keyword("operator")
  #show regex("\boverride\b") : kt-keyword("override")
  #show regex("\bpublic\b") : kt-keyword("public")
  #show regex("\bprivate\b") : kt-keyword("private")
  #show regex("\bprotected\b") : kt-keyword("protected")
  #show regex("\binline\b") : kt-keyword("inline")
  #show regex("\binternal\b") : kt-keyword("internal")
  #show regex("\bconstructor\b") : kt-keyword("constructor")
  #show regex("\bas\b") : kt-keyword("as")
  #show regex("\bis\b") : kt-keyword("is")
  #show regex("\bimport\b") : kt-keyword("import")
  #show regex("\babstract\b") : kt-keyword("abstract")
  #show regex("\bopen\b") : kt-keyword("open")
  //constructor
  // #show regex("[0-9]{2,}") : (num) => kt-literal(num.text)
  //
  #show regex("\bstdout\b") : join-raw("stdout")
  #show regex("\bstderr\b") : join-raw("stderr")
  #show regex("\bstdin\b") : join-raw("stdin")
  #body
]

#let kt-paper-rule(body) = [
  #set par(justify: true)
  #show link: (it) => underline(text(fill:rgb("#0B0080"), it))
// TODO : show rule for JVM, JS, Kotlin, Java, C++ icon
  #body
]
