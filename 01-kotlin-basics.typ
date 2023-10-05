#import "kotlinheader.typ" : *

#show : kt-paper-rule

= Основы языка Kotlin

#kt-par[
  Будем пользоваться нотацией REPL: после `=>` описывается тип результата, затем
  строковое представление результата. Если код что-то выводит, то это написано
  после результата.
]

#kt-par[
  Итак, Котлин. Давайте для начала разберёмся с местными примитивными
  конструкциями. У нас есть следующие типы данных:
]

#let prim(code, repr: none, typ) = {
  indent(kt-literal(code.text, typ))
  kt-res(if (repr == none) { code } else { repr }, typ)
}

- Логические значения
#prim(`true`, KtBool)

- Целые числа (32-битные в two's complement)
#prim(`566`, KtInt)

- Длинные целые числа (64-битные)
#prim(`566L`, repr: `566`, KtLong)

- Строки
#prim(`"Hello"`, KtString)

- Символы
#prim(`'a'`, KtChar)

- Вещественные числа (Стандарт `IEEE-754`, double precision floating point number)
#prim(`3.14`, KtDouble)

#kt-par[
  Все эти типы заимствованы из JVM. Собственно, из неё же заимствованы ещё и типы
  Byte (8-битное целое), Short (16-битное целое) и Float (single-precision
  вещественное), но их используют крайне редко (поскольку всё меньше остаётся даже
  32-битных процессоров).
]

#kt-par[
  Зато, для желающих, есть _довольно быстрая_ реализация `unsigned` целых чисел:
  `UInt`, `ULong` etc.
]

#kt-par[
  С этими типами можно делать довольно ожидаемые действия:
]

- Складывать:
#kt-eval(``` 0.1 + 0.2 ```)
#kt-res(`0.30000000000000004`, KtDouble)

- Умножать:
#kt-eval(``` 5 * -2 ```)
#kt-res(`-10`, KtInt)

- Делить:
#kt-eval(``` 1.0 / 0.0 ```)
#kt-res(`Infinity`, KtDouble)

#kt-par[
  Без неожиданных спецэффектов. Автоприведения типов здесь нет, так что
  #box(raw("\"22\" - \"2\" = 20")), как в JS, не получится. С символами, впрочем,
  операции производить можно:
]

#kt-eval(``` 'c' - 'a' ```)
#kt-res(`2`, KtInt)

#kt-par[
  Также в наличии логические операции
]

#kt-eval(``` !false ```)
#kt-res(`true`, KtBool)
#kt-eval(``` true && false ```)
#kt-res(`false`, KtBool)

#kt-par[
  Ну и так далее. Разберётесь по ходу ведения.
]

Ветвление:
#kt-eval(```
if (1 + 2 < 4) {
    println("First")
} else {
    println("Second")
}
```)
#kt-res(KtUnit, KtUnit)
#kt-print(`First`)

#kt-par[
  О, здесь сразу несколько интересных вещей: println отвечает за вывод строки в
  stdout (стандартный поток вывода). А Unit --- это тип, который возвращается,
  если не возвращается ничего. Есть в Котлине два таких интересных типа: Unit ---
  когда единственное, что нам нужно знать --- это завершилась функция или нет.
  Если завершилась, то возвращается Unit --- единственное значение типа Unit. Ну,
  содержательного с ним ничего нельзя сделать --- только сказать, что он есть.
  Второй --- Nothing --- означает, что функция никогда ничего не вернёт, потому
  что не завершится успешно. Если у предыдущего типа существует единственное
  значение, то у типа Nothing нет ни одного значения.
]

#kt-par[
  Так, погодите. Выходит, у нас if`...`else что-то возвращает? А можно, чтобы он
  возвращал содержательную информацию? Можно.
]

#kt-eval(```
if (1 + 2 < 4) {
    // Do something
    566
} else {
    // Do some another thing
    239
}
```)
#kt-res(`566`, KtInt)

#kt-par[
  Последняя строчка интерпретируется как выражение --- то есть, что-то-таки
  возвращает наружу. Собственно, привычный многим в Java и в C++ тернарный
  оператор ` a ? b : c ` здесь так и сделан: если выражение однострочное, то
  фигурные скобки можно и не ставить.\
]

#kt-eval(``` if (1 + 2 < 4) 566 else 239 ```)
#kt-res(``` 566 ```, KtInt)

#nobreak[
  Теперь циклы. А для циклов сначала нужны переменные. Их есть:

  #kt-eval(```
        var i = 0
        while (i < 5) {
            print(i)
            i++
        }
        ```)
  #kt-print(``` 01234 ```)
]

#kt-par[
  Во-первых, print --- это как println, только без перевода строки. Во-вторых,
  погодите, а результат? Мы думали, и в магазине можно стеночку приподнять?
]

#kt-par[
  А нет. Цикл не является выражением, он не возвращает даже Unit. Как, впрочем, и
  объявление переменной.
]

#kt-par[
  В-третьих, переменные в Котлине имеют тип. То есть, если у вас про переменную
  заявлено, что там лежат числа, вы не можете положить туда строку:
]

#kt-eval(```
var a : Int = 0
a = 1
a = "2"
```)
#kt-comp-err(`Kotlin: Type mismatch: inferred type is String but Int was expected`)

#kt-par[
  А если вы не заявляли тип явно, то компилятор сам выведет наиболее узкий,
  который сможет.
]

#kt-par[
  Кроме переменных, конечно, есть постоянные:
]

#kt-eval(```
val a : Int = 0
a = 1
```)
#kt-comp-err(`Kotlin: Val cannot be reassigned`)

#kt-par[
  Если вы можете использовать val, используйте val, а не var.
]

#kt-par[
  Есть также циклы do-while:
]

#kt-eval-noret(```
do {
    val line = readln()
    // Do something with it
} while (line != "exit")
```)

#kt-par[
  Переменная, объявленная внутри цикла, в общем случае снаружи не видна, а вот в
  случае конкретно do-while видна в условии, что приятно. Кажется, так было не
  всегда.
]

#kt-par[
  ... и циклы for:
]

#kt-eval(```
for (i in 0 until 5) {
    print(i)
}
```)
#kt-print(``` 01234 ```)

#kt-par[
  until --- это специальная инфиксная функция, которая возвращает арифметическую
  прогрессию, от первого аргумента включительно, до второго исключительно. Что
  означает "инфиксная"? Ну, функции в котлине бывают трёх различных вариантов:
  префиксная (#kt(`cos(1.0)`)), условно-постфиксная (#kt(`566.toString()`)) и
  инфиксная (#kt(`0 until 5`)). _Условно_-постфиксные они потому, что в скобках
  могут быть ещё аргументы, например, #kt(`566.toString(3)`), чтобы преобразовать
  в троичную систему счисления. Все инфиксные функции можно вызывать также и в
  условно-постфиксной записи: #kt(`0.until(5)`), но не наоборот.
]

#nobreak[
  #kt-par[
    Помимо until есть ещё downTo и rangeTo:
  ]

  #table(
    columns: (auto, auto, auto, auto),
    rows: 2em,
    align: center + horizon,
    [until],
    kt(`0 until 5`),
    kt(`0.until(5)`),
    `[0, 1, 2, 3, 4]`,
    [rangeTo],
    kt(`0..5`),
    kt(`0.rangeTo(5)`),
    `[0, 1, 2, 3, 4, 5]`,
    [downTo],
    kt(`5 downTo 0`),
    kt(`5.downTo(0)`),
    `[5, 4, 3, 2, 1, 0]`,
  )
]

#kt-par[
  В экспериментальных на момент написания конспекта версиях Котлина есть ещё
  вариант #box(kt(`0..<5`)) для until (Точнее, строго говоря, будет вызван метод
  `rangeUntil`, но делает он то же самое).
]

#kt-par[
  Как это работает? Э-хе-хе, подождите, давайте сначала научимся префиксные
  функции писать.
]

#kt(```
fun max(a: Int, b: Int): Int
```)

#kt-par[
  Что бы всё это значило? fun собственно объявляет функцию. `a` и `b` --- это
  имена параметров, после них написаны их типы (Int), а после двоеточия после
  всего объявления тип того, что возвращает функция. В нашем случае функция
  принимает два аргумента типа Int и возвращает тоже Int. Теперь собственно, что
  делает эта функция?
]

#kt-eval(```
fun max(a: Int, b: Int): Int {
    if (a < b) {
        return b
    } else {
        return a
    }
}
```)

#kt-par[
  Ну, здесь всё понятно.
]

#kt-par[
  Проверим, что работает:
]

#kt-eval(``` max(239, 566) ```)
#kt-res(`566`, KtInt)

#kt-par[
  Ещё не забыли, что if у нас также является тернарным оператором?
]

#kt-eval(```
fun max(a: Int, b: Int): Int {
    return if (a < b) b else a
}
```)

#kt-par[
  Если тело функции состоит только из return-statement, то фигурные скобки и
  return не нужны, вместо них пишем
]

#kt-eval(```
fun max(a: Int, b: Int): Int = if (a < b) b else a
```)

#kt-par[
  Здесь уже можно опустить возвращаемый тип, ибо он очевиден компилятору, но лучше
  всё же писать.
]

#kt-par[
  Так, кроме того, мы ввели ключевое слово return. Кроме него существуют ещё такие
  интересные штуки как break, continue и throw, которые делают понятно что. Но их
  объединяет следующая черта: после них точно будет выполняться уже не эта строка.
  В некотором смысле, это выражение никогда ничего не возвращает. О, где-то такое
  уже было. На самом деле на уровне языка оно возвращает тип Nothing. Например,
  если мы напишем
] #kt(`val x = return`) #kt-par[, то понятно, что до присвоения значения постоянной `x` дело так и не дойдёт. ]

#kt-par[
  Для понимания следующего сначала рассмотрим обобщающие типы. Так, если мы пишем
] #kt(`if (condition) 1 else 2`) #kt-par[, то понятно, какой тип выведет компилятор --- Int.]

#nobreak[
  #kt-par[ А если типы возвращаемых данных разные? Ошибка? ]

  #kt-eval(```
      if (1 < 2) 3 else "4"
      ```)
  #kt-res(`3`, Comparable(KtStar))
]

#kt-par[
  А нет. Что-то мы всё же про это знаем, и числа, и строки можно сравнивать. А
  значит, мы на выходе получили что-то _сравниваемое_ (#Comparable(KtStar)). Что
  означает звёздочка в треугольных скобках --- мы потом разберём, сейчас это
  несущественно. А бывают типы данных, которые нельзя сравнивать? Бывают, например
  Unit. Ну, его сравнивать довольно бесполезно --- он всегда окажется равен самому
  себе, поскольку единственное, что существует типа Unit --- это Unit сам по себе.
]

#kt-eval(```
if (1 < 2) 3 else Unit
```)
#kt-res(`3`, Any)

#kt-par[
  Вот Any --- это почти самый общий тип. Он означает "ну, что-то там определённо
  лежит". С ним можно проделать не так много вещей:
  - потребовать строковое представление
  - посчитать хэшкод
  - сравнить на равенство с чем-то другим.
  В общем-то, всё.
]

#kt-par[
  Есть ещё значение null, которое не является Any, а о его типе поговорим чуть
  позже.
]

#kt-par[
  Так вот, всё, что не null --- является Any, и может быть приведён к типу Any. А
  тип Nothing --- наоборот, может быть приведён *_к_* любому типу. Потому что на
  самом деле никогда не понадобится приводить, потому что объектов типа Nothing не
  существует.
]

#kt-par[
  Значение null в Котлине несёт тот же смысл, что null в Java, nullptr в С++, None
  в Python и т.д. Это заглушка, возможность сказать, что здесь могло бы быть
  значение, но пока его нет. Но хранить их можно только в специальных nullable
  типах, помечаемых знаком вопроса.
]

#strikeleft[
  #kt-eval(```
              var s : String = "abc"
            s = null
            ```)
  #kt-comp-err(`Null can not be a value of a non-null type String`)

  #kt-eval(```
              var s : String? = "abc"
              s = null // OK
              ```)
]

#kt-par[
  В отличие от Java, nullable типами могут быть и примитивные (Int, Long etc.).
]

#comment[
  #kt-par[
    Впрочем, это довольно неэффективно, так как, в то время как Int, Char, и так
    далее транслируются в использование примитивов (int, char), nullable типы Int?,
    Char? --- в объектные Integer, Character и так далее, чтобы можно было
    присваивать им null. Это занимает больше места, больше времени и прочее.
    Аналогично происходит с lateinit var, которые под капотом nullable.
  ]
]
#nobreak[
  #kt-par[
    Поскольку NullPointerException --- одна из самых частых ошибок времени
    исполнения в Java, в Kotlin добавили специальных операторов для работы с
    nullable значениями:
  ]

  - Non-null assertion
  #strikeleft[
    #kt-par[
      Если значение не null, то вернуть его, если null --- бросить ошибку.
    ]

    #kt-eval(```
                  val s : String? = "abacaba"
                  s!!
                  ```)
    #kt-res(`"abacaba"`, KtString)

    #kt-eval(```
                  val s : String? = null
                  s!!
                  ```)
    #kt-runt-err(```
                    Exception in thread "main" java.lang.NullPointerException
                        at test.TestKts.main(Test.kts:2)
                    ```)
  ]
]

- Safe call
#strikeleft[
  #kt-par[
    Если значение не null, то вызвать метод, если null --- вернуть null.
  ]

  #kt-eval(```
              val s : String? = "abacaba"
              s?.substring(2, 6)
              ```)
  #kt-res(`"acab"`, KtString7)

  #kt-eval(```
              val s : String? = null
              s?.substring(2, 6)
              ```)
  #kt-res(`null`, KtString7)
]

- Elvis operator

#strikeleft[
  #kt-par[
    Если значение не null, то вернуть его, если null --- то вернуть другое.
  ]

  #kt-eval(```
              val s : String? = "abacaba"
              s ?: "by default"
              ```)
  #kt-res(`"abacaba"`, KtString7)

  #kt-eval(```
                val s : String? = null
                s ?: "by default"
                ```)
  #kt-res(`"by default"`, KtString)
]

#kt-par[
  Какой тип имеет сам null?
]

#kt-eval(`null`)
#kt-res(`null`, KtNothing7)

#kt-par[
  Почему так? Логично, что если тип `T` приводится к типу `U`, то тип `T?` должен
  приводиться к типу `U?` (Если там было значение типа `T`, то его можно положить
  в `U`, а значит, в `U?` тем более. А если там был null, то его всё равно можно
  положить в `U?`). И логично, чтобы null приводился к любому nullable типу.
  Nothing приводится к любому `T`, значит, Nothing? приводится к любому `T?`.
]

#nobreak[
  #kt-par[
    Осталось поговорить про массивы. А их здесь несколько разных бывает.
  ]

  #kt-eval(```
      arrayOf("abc", "def", "ghi")
      ```)
  #kt-res(`[Ljava.lang.String;@3b9a45b3`, `Array<String>`)
  #kt-par[
    Будьте здоровы, Вы, кажется, чихнули.
  ]
]

#kt-par[Да, нормального встроенного строкового представления для массивов не подвезли,
  выводится некая системная информация. Для этого придётся вызвать специальную
  функцию `joinToString` (на самом деле она гораздо мощнее, но об этом мы
  поговорим позже).]

#kt-eval(```
arrayOf("abc", "def", "ghi").joinToString()
```)
#kt-res(`"abc, def, ghi"`, KtString)
#kt-par[
  Тем не менее, с массивами можно работать, как в любом другом языке.
]

#kt-eval(```
val arr = arrayOf("abc", "def", "ghi")
arr[1]
```)
#kt-res(`"def"`, KtString)

#kt-par[ (Да, индексация с нуля) ]

#kt-eval-append(```
arr[0] = "magic"
arr.joinToString()
```)
#kt-res(`"magic, def, ghi"`, KtString)

#kt-par[
  Массивы типизированы: за это, собственно, отвечает String в треугольных скобках
  после `Array<`String`>` (как это работает, опять-таки --- позже, сейчас
  пользуемся как магией). То есть, нельзя просто так взять и положить Int в массив
  строк:
]

#kt-eval-append(```
arr[0] = 1
```)
#kt-comp-err(`The integer literal does not conform to the expected type String`)

#kt-par[
  Также, если попытаться обратиться за границу массива, получаем ошибку:
]

#kt-eval-append(```
arr[3]
```)
#kt-runt-err(
  ```
            Exception in thread "main" java.lang.ArrayIndexOutOfBoundsException: Index 3 out of bounds for length 3
                at TestsKts.main(Tests.kts:6)
              ```,
)

#kt-par[
  Можно создавать и массивы более общих типов. Например,
]

#kt-eval(```
arrayOf(1, "2", null)
```)
#kt-res(`[Ljava.lang.Object;@3b9a45b3`, `Array<Comparable<*>?>`)

#kt-par[
  Как мы помним, у Int и String есть нечто общее --- они оба `Comparable<*>`. А у
  `Comparable<*>` и null общим типом будет, очевидно, `Comparable<*>?`.
]

#kt-par[
  Можно также задать тип вручную:
]

#kt-eval(```
arrayOf<Number>(1, 2, 3)
```)
#kt-res(`[Ljava.lang.Number;@3b9a45b3`, `Array<Number>`)

#kt-par[
  Number --- это обобщение Int, Long, Double и так далее. В `Array<`Number`>` мы
  можем положить любые числа. И когда мы что-то достаем из массива Number, мы не
  можем точно быть уверены, какое конкретно это число.
]

#nobreak[
  #kt-par[
    Мы можем выполнять общие операции, определённые для всех чисел, например,
    привести к типу Double:
  ]

  #kt-eval(```
    val arr = arrayOf<Number>(1, 2, 3)
    arr[1].toDouble()
    ```)
  #kt-res(`2.0`, KtDouble)
]
#kt-par[
  Или проверить, какого оно типа:
]

#kt-eval-append(```
arr[1] is Long
```)
#kt-res(`false`, KtBool)

#kt-eval-append(```
arr[1] is Int
```)
#kt-res(`true`, KtBool)

#kt-par[
  После этого, если мы уверены, привести явным образом
]

#kt-eval-append(```
arr[1] as Int
```)
#kt-res(`2`, KtInt)

#kt-par[
  Стоит заметить, во-первых, что попытка каста к не тому типу обернётся ошибкой
  времени исполнения:
]

#kt-eval-append(```
arr[1] as Double
```)
#kt-runt-err(
  ```
              Exception in thread "main" java.lang.ClassCastException: class java.lang.Integer cannot be cast to class java.lang.Double (java.lang.Integer and java.lang.Double are in module java.base of loader 'bootstrap')
                  at TestsKts.main(Tests.kts:6)
              ```,
)

#kt-par[
  А попытка проверить на is что-то совершенно точно бессмысленное --- ошибкой
  компиляции:
]

#kt-eval-append(```
arr[1] is String
```)
#kt-comp-err(`
Incompatible types: String and Number
`)

#kt-par[
  ...Так как компилятор считает правильным сообщить вам, что Number совершенно
  точно никогда строкой не окажется.
]

#kt-par[
  Так, давайте вернёмся к массивам. Можно ли создавать массивы массивов? Сколько
  угодно:
]

#kt-eval(```
arrayOf(arrayOf("abc", "def"), arrayOf("ghi", "jkl"))
```)
#kt-res(`[[Ljava.lang.String;@3b9a45b3`, `Array<Array<String>>`)

#kt-par[ Будьте здоровы. ]

#kt-eval(```
arrayOf(arrayOf("abc", "def"), arrayOf("ghi", "jkl")).joinToString()
```)
#kt-res(
  `"[Ljava.lang.String;@6d03e736, [Ljava.lang.String;@568db2f2"`,
  KtString,
)

#kt-par[ Будьте здоровы! ]

#comment[
  #kt-eval(```
                    val matrix = arrayOf(arrayOf("abc", "def"), arrayOf("ghi", "jkl"))
                    matrix.joinToString(transform = Array<String>::joinToString)
                    ```)
  #kt-res(`"abc, def, ghi, jkl"`, KtString)

  #kt-par[
    Это ещё куда ни шло, но совершенно непонятно, где кончаются границы одного и
    другого массива внутри.
  ]
] #comment[ #kt-eval(```
                    val matrix = arrayOf(arrayOf("abc", "def"), arrayOf("ghi", "jkl"))
                    matrix.joinToString(", ", "[", "]") { it.joinToString (", ", "[", "]") }
                    ```)
  #kt-res(`"[[abc, def], [ghi, jkl]]"`, KtString)

  #kt-par[
    Есть, конечно, возможность заставить это работать. Но... вам не надоело?
  ] ]

#kt-par[
  Есть несколько причин, почему в Котлине непосредственно массивы используются
  крайне редко. Во-первых, вышеупомянутые проблемы со строковым представлением.
  Во-вторых, и это более важно, проблемы с безопасностью. Допустим, вы передали
  куда-то в функцию массив.
]

#kt-eval(```
fun blackBox(data: Array<String>) {
    data[2] = "flowers"
}

val array = arrayOf("Some", "important", "data", "here")
blackBox(array)
array.joinToString()
```)
#kt-res(`"Some, important, flowers, here"`, KtString)

#indent[ Полундра! Данные скомпрометированы! ]

#kt-par[
  Проблема в том, что массивы передаются исключительно по ссылке, копирования при
  передаче не происходит. А значит, отдавая кому-то на сторону данные, вы не
  можете быть уверены в их сохранности --- фактически вы отдаёте ссылку на область
  в памяти, где эти данные лежат.
]

#kt-par[
  Чтобы этого избежать, существуют листы:
]

#kt-eval(```
listOf("Some", "important", "data", "here")
```)
#kt-res(`[Some, important, data, here]`, `List<String>`)

#kt-par[
  И строковое представление нормальное, и записать туда что-то нам не дадут:
]

#kt-eval(```
val arr = listOf("Some", "important", "data", "here")
arr[2] = "flowers"
```)
#kt-comp-err(
  ```
                Unresolved reference. None of the following candidates is applicable because of receiver type mismatch:
                    public inline operator fun kotlin.text.StringBuilder /* = java.lang.StringBuilder */.set(index: Int, value: Char): Unit defined in kotlin.text
                No set method providing array access
                ```,
)

#kt-par[
  ... очень много информации. Компилятор попытался найти метод с именем `set`,
  который отвечал бы за подобное присваивание, и не справился. Содержательная
  часть здесь `No set method providing array access` --- записывать сюда нам не
  дадут.
]

#kt-par[
  Листы и массивы можно превращать друг в друга:
]

#nobreak[
  #kt-eval(```
    val arr = arrayOf("Some", "important", "data", "here")
  arr.toList()
  ```)
  #kt-res(`[Some, important, data, here]`, `List<String>`)
]

#nobreak[
  #kt-eval(```
    val arr = listOf("Some", "important", "data", "here")
  arr.toTypedArray()
  ```)
  #kt-res(`[Ljava.lang.String;@4fca772d`, `Array<String>`)
]

#kt-par[
  И в том, и в другом случае действительно происходит копирование.
]

#kt-par[
  Кстати, говорилось про три варианта? Да, есть ещё `MutableList`.
]

#kt-eval(`
mutableListOf(1, 2, 3)
`)
#kt-res(`[1, 2, 3]`, `MutableList<Int>`)

#kt-par[
  В него, как и в массив, можно записывать, из него можно читать, но, что особенно
  важно, можно его расширять (массивы имеют постоянную длину!):
]

#kt-eval(```
val arr = mutableListOf(1, 2, 3)
arr.add(566)
arr
```)
#kt-res(`[1, 2, 3, 566]`, `MutableList<Int>`)

#kt-par[
  Так вот, `MutableList<T>` в частности, является `List<T>` для любого типа `T`,
  так как `MutableList<T>` предоставляет те же методы: чтение, проверка длины,
  некоторые другие; но предоставляет и дополнительные --- изменение, расширение.
  Так что можно передать `MutableList<T>` в функцию, которая требует `List<T>` и
  (почти) не бояться, что его изменят.
]

#comment[
  Почти --- потому что некоторая возможность всё же есть; если вдруг это данные
  для запуска ядерных ракет и вы передаёте их в функцию --- лучше всё-таки
  сделайте копию.
]

#kt-par[
  Ну, было бы желание сломать --- сломать получится. Например, до Java версии 1.8
  включительно можно было провернуть очень интересный фокус, следите за руками:
]

#kt-eval(`1 as Any`)
#kt-res(`1`, Any)

#kt-par[
  Всё, казалось бы, логично, от того, что мы привели к более общему типу,
  значение-то не поменялось. Да?
]

#indent[
  #kt(```
            val rnd = Random(56630239)
            val clazz = Class.forName("java.lang.Integer\$IntegerCache")
            val field = clazz.getDeclaredField("cache")
            field.isAccessible = true
            val cache = field.get(null) as Array<Int>
            for (i in 0 until cache.size) cache[i] = rnd.nextInt(cache.size)
            ```)
]

#kt-par[
  А вот после этого замечательного кода попробуем снова
]

#kt-eval(`1 as Any`)
#kt-res(`146`, Any)

#kt-par[
  Э-э-э... Упс?
]

