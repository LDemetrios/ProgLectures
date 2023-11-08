#import "kotlinheader.typ" : *
#import "@preview/cetz:0.1.2"
#show : kt-paper-rule

#let background = white
#let foreground = black

= Лямбды

== Мотивация

#kt-par[
  Напишем функцию, фильтрующую список по некоторому условию.
]

#indent[
  #kt(```
                          fun <T> filter(list: List<T>) : List<T> {
                              val result = mutableListOf<T>()
                              for (el in list) if (/*condition*/) result.add(el)
                              return result
                          }
                          ```)
]
#kt-par[
  Довольно часто пригождающаяся штука --- например...
  - оставить только целые числа
  - оставить только непустые строки
  - только товары до тысячи рублей
  - только пользователей старше 18...
]

#kt-par[
  Остаётся вопрос --- а как _условие_ передать в функцию извне? Один такой
  механизм мы уже знаем --- он широко используется в графике, так передаются
  обработчики событий.
]

#kt-par[
  Потребуем передать _что-то_, у чего есть метод, принимающий `T` и возвращающий
  Boolean. Для этого надо сделать интерфейс.
]

#kt-eval(```
interface Predicate<T> {
    fun test(value: T): Boolean
}
```)

#kt-par[
  Теперь можем завершить наш фильтр:
]

#kt-eval-append(```
fun <T> filter(list: List<T>, predicate: Predicate<T>) : List<T> {
    val result = mutableListOf<T>()
    for (el in list) if (predicate.test(el)) result.add(el)
    return result
}
```)

#kt-par[
  Выглядит неплохо. А что на вызывающей стороне?
]

#kt-eval-append(```
class IsEvenPredicate : Predicate<Int> {
    override fun test(value: Int) = value % 2 == 0
}

val list = listOf(1, 2, 3, 4, 5, 6)
filter(list, IsEvenPredicate())
```)
#kt-res(`[2, 4, 6]`, `List<Int>`)

#kt-par[
  Оу... _Многословно_. На то, чтобы создать и передать предикат, мы тратим три
  строчки кода. Это конечно, оправдано, если мы передаём небольшой кусок кода в
  огромную сложную функцию.
]

//#comment[
#kt-par[ Например, запуском потоков занимается _очень_ непростой код, а то, что в этом
  потоке исполнять, передаётся в наследнике Runnable: ]

#indent[
  #kt( // Yeah, I don't want to implement java styling
    ```
                                                    @FunctionalInterface
                                                    public interface Runnable {
                                                        void run();
                                                    }
                                                    ```,
  )
]
#nobreak[
  #kt-par[ Или, переводя на Kotlin, ]
  #kt-eval(```
                          fun interface Runnable {
                              fun run()
                          }
                          ```)
]
/*
#kt-par[
  Тогда, например, можно сделать так:
]

#kt-eval(
```
class Parallel : Runnable {
    override fun run() {
        for (i in 0 until 20) println("Executando em paralelo...")
    }
}

Thread(Parallel()).start() // Inicia uma thread para executar o código em paralelo.

for (i in 0 until 20) println("Executando na thread principal...")

println("Terminando a execução da thread principal...")
```
)
\
#kt-print(```
Executando na thread principal...
Executando na thread principal...
Executando em paralelo...
Executando em paralelo...
Executando em paralelo...
Executando em paralelo...
Executando em paralelo...
Executando em paralelo...
Executando na thread principal...
Executando na thread principal...
...```)
]
*/
#kt-par[
  ... но для таких маленьких задач это, конечно, совершенно неоправданно.
]

== Примеры

#kt-par[Но давайте пока работать с тем, что есть. Обобщим понятие функции, для начала. У
  функции может быть разное количество аргументов, и, к сожалению, сделать
  произвольное количество параметров типа мы не сможем.]

#kt-eval(```
interface Function0<R> {
    fun invoke(): R
}

interface Function1<T, R> {
    fun invoke(arg: T): R
}

interface Function2<T1, T2, R> {
    fun invoke(arg1: T1, arg2: T2): R
}

interface Function3<T1, T2, T3, R> {
    fun invoke(arg1: T1, arg2: T2, arg3: T3): R
}
```)

#kt-par[
  ... и так далее. Собственно, набора таких интерфейсов достаточно, чтобы описать
  всё, что нам нужно:
]

#kt-eval-append(```
fun <T> List<T>.filter(predicate: Function1<T, Boolean>): List<T> {
    val result = mutableListOf<T>()
    for (element in this) if (predicate(element)) result.add(element)
    return result
}

fun <T, R> List<T>.map(transform: Function1<T, R>): List<R> {
    val result = mutableListOf<R>()
    for (element in this) result.add(transform(element))
    return result
}

fun <T> createList(size:Int, element:Function1<Int, T>) : List<T> {
    val result = mutableListOf<T>()
    for (i in 0 until size) result.add(element(i))
    return result
}

fun <T, R> List<T>.fold(initial: R, folder: Function2<R, T, R>): R {
    var result = initial
    for (element in this) result = folder(result, element)
    return result
}
```)

#kt-par[
  Окей, а какие самые естественные операции над функциями? Взять обратную у нас, к
  сожалению, не получится, а вот композицию --- вполне.
]

#nobreak[
  #kt-eval-append(```
                          class Composition<A, B, C>(
                            val f: Function1<A, B>,
                            val g: Function1<B, C>
                        ) : Function1<A, C> {
                            override fun invoke(arg: A): C = g(f(arg))
                        }

                        fun <A, B, C> comp(
                            f: Function1<A, B>, g: Function1<B, C>
                        ): Function1<A, C> = Composition(f, g)
                        ```)
]

#kt-par[
  Можно было, собственно говоря, и не выносить отдельную функцию, но это здесь не
  просто так. Мы создаём новый класс, но используем его только в одном месте. Мало
  того, что ему нужно --- о, ужас! --- придумать имя, так это имя потом загрязняет
  общее пространство имён. Поэтому есть возможность создать так называемый _анонимный класс_:
]

#kt-eval-append(```
val isEven = object : Function1<Int, Boolean> {
    override fun invoke(arg: Int): Boolean = arg % 2 == 0
}
```)

#kt-eval-append(```
listOf(1, 2, 3, 4, 5, 6).filter(
    object : Function1<Int, Boolean> {
        override fun invoke(arg: Int): Boolean = arg % 2 == 0
    }
)
```)

#kt-par[
  Более того, компилятор Kotlin достаточно умён, чтобы обнаружить все переменные
  снаружи, которые нужно встроить в конструктор этого класса:
]

#kt-eval(```
fun <A, B, C> composeAnon(
    f: Function1<A, B>,
    g: Function1<B, C>
) = object : Function1<A, C> {
    override fun invoke(arg: A): C = g(f(arg))
}
```)

#comment[
  Вообще говоря, если разбирать байт-код, то мы увидим, что создался отдельный класс с именем
  `FunctionsGeneralizedKt$composeAnon$1` и двумя полями: `f` и `g`. При вызове
  функции composeAnon создаётся объект этого класса с соответствующими
  параметарами.
]

== Собственно, лямбды

#kt-par[
  На этом можно было бы и закончить --- в конце концов, анонимных классов вполне
  достаточно для функционального программирования. Но мы пойдём дальше.

  Представьте, что вы пользуетесь тремя библиотеками, и в каждой из них свои
  интерфейсы, предназначенные для этих целей? (Кстати, интерфейсы с одним методом
  обычно называют _функциональными_). А ведь, памятуя о сложном устройстве JVM,
  для эффективности нужно держать и примитивные специализации: например, предикат,
  поскольку он возвращает примитивный тип, хорошо бы иметь отдельным интерфейсом,
  а не общий c генериками.
]

#kt-par[
  Собственно говоря, именно так и поступает Java Development Kit: в нём есть _сорок три_ различных
  интерфейса, предназначенных для этого:

  `BiConsumer, BiFunction, BinaryOperator, BiPredicate, BooleanSupplier, Consumer, DoubleBinaryOperator, DoubleConsumer, DoubleFunction, DoublePredicate, DoubleSupplier, DoubleToIntFunction, DoubleToLongFunction, DoubleUnaryOperator, Function, IntBinaryOperator, IntConsumer, IntFunction, IntPredicate, IntSupplier, IntToDoubleFunction, IntToLongFunction, IntUnaryOperator, LongBinaryOperator, LongConsumer, LongFunction, LongPredicate, LongSupplier, LongToDoubleFunction, LongToIntFunction, LongUnaryOperator, ObjDoubleConsumer, ObjIntConsumer, ObjLongConsumer, Predicate, Supplier, ToDoubleBiFunction, ToDoubleFunction, ToIntBiFunction, ToIntFunction, ToLongBiFunction, ToLongFunction, UnaryOperator.`

  Да их все запомнить --- уже нелёгкая задача... А ведь все эти "функции"
  принимают не более двух аргументов!

  Поэтому в Kotlin сделаны специальные _функциональные типы_, буквально делающие
  то, что нам нужно: например, сложение чисел, так как это функция из двух Int в
  Int, описывается типом #box[`(`Int`, `Int`) -> `Int]. И передавать туда можно
  довольно-таки много, что. Но давайте по порядку, приведём наши функции в
  порядок:
]

#kt-eval(```
fun <T> List<T>.filter(predicate: (T) -> Boolean): List<T> {
    val result = mutableListOf<T>()
    for (element in this) if (predicate(element)) result.add(element)
    return result
}

fun <T, R> List<T>.map(transform: (T) -> R): List<R> {
    val result = mutableListOf<R>()
    for (element in this) result.add(transform(element))
    return result
}

fun <T> createList(size: Int, element: (Int) -> T): List<T> {
    val result = mutableListOf<T>()
    for (i in 0 until size) result.add(element(i))
    return result
}

fun <T, R> List<T>.fold(initial: R, folder: (R, T) -> R): R {
    var result = initial
    for (element in this) result = folder(result, element)
    return result
}

//fun <A, B, C> compose(f: (A) -> B, g: (B) -> C): (A) -> C = ...
```)
#nobreak[
  #kt-par[
    Так, а как мы _передаём_ эти значения? Что нам возвращать из `compose`? Здесь
    есть несколько вариантов.
  ]

  + Lambda literal. Выглядит это так:
    #kt-eval(
      ```
                                                                            fun <A, B, C> compose(f: (A) -> B, g: (B) -> C): (A) -> C = { arg: A -> g(f(arg)) }
                                                                            ```,
    )
    #kt-par[
      Здесь есть несколько нюансов. Во-первых, здесь тип `arg` --- `A` --- известен из
      контекста, так как возвращаемый тип `compose` --- `(A) -> C`, значит, это
      функция, принимающая один аргумент типа `A`. Во-вторых, если у лямбды ровно один
      аргумент, то можно не писать его имя --- по умолчанию оно будет `it`.
    ]
    #kt-eval(```
                                                    fun <A, B, C> compose(f: (A) -> B, g: (B) -> C): (A) -> C = { g(f(it)) }
                                                    ```)
  + Ссылка на функцию
    #kt-eval(```
                                                fun isEven(x: Int) = x % 2 == 0

                                                filter(listOf(1, 2, 3, 4, 5), ::isEven)
                                                ```)
    #kt-res(`[2, 4]`, `List<Int>`)
  + Ссылка на метод

    #kt-par[ Например, сложение чисел описывается методом: ]

    #kt(```
                                                operator fun plus(other: Int): Int
                                                ```)

    #kt-par[
      , объявленным внутри класса Int. Как мы понимаем, на самом деле здесь два
      аргумента: явный `other` и неявный this. Поэтому функция Int`::plus` имеет тип
      `(`Int`, `Int`) -> `Int.
    ]

    #kt-eval(```
                                                listOf(1, 2, 3, 4, 5).fold(0, Int::plus)
                                                ```)
    #kt-res(`15`, KtInt)

  + Ссылка на метод объекта

    #kt-par[
    Только что же было? Погодите. Это почти то же самое, только вместо имени класса
    слева от `::` пишем объект этого класса. Например,
    ]

    #kt-eval(```
                                                createList(5, "abc"::plus)
                                                ```)
    #kt-res(`[abc0, abc1, abc2, abc3, abc4]`, `List<String>`)
]

#kt-par[
  Итак, с этим разобрались. Что дальше?
]

#let item(coord, sc, name, cont, text-scale: 1) = {
  import cetz.draw: *
  get-ctx((ctx) => {
    let (x, y, z) = cetz.coordinate.resolve(ctx, coord)

    x -= sc / 2
    y -= sc / 2

    rect(
      (x, y),
      (x + sc, y + sc),
      fill: background,
      stroke: (paint: foreground),
      name: name,
    )

    content(name + ".center", text(size: 2em * sc * text-scale, cont))
  })
}

#let lambda_arg(coord, name, sc: 1, ..args, r, text-scale: 1) = {
  import cetz.draw: *
  let args_list = args.pos()
  let n = args_list.len()
  get-ctx((ctx) => {
    let (x, y, z) = cetz.coordinate.resolve(ctx, coord)

    x -= 1.5 * sc
    y -= (args_list.len() * 1.5 + .5) * sc / 2

    rect(
      (x, y),
      (x + (3) * sc, y + (args_list.len() * 1.5 + .5) * sc,),
      stroke: (dash: "dashed"),
      name: name + "-body",
      fill: background,
    )

    item(
      (x + 3 * sc, y + (args_list.len() * .75 + .25) * sc),
      sc,
      name + "-output",
      r,
      text-scale: text-scale,
    )

    let i = 0
    for inp in args_list {
      if inp != none {
        item(
          (x, y + (args_list.len() * 1.5 - .5 - i * 1.5) * sc),
          sc,
          name + "-arg" + args_list.at(i),
          args_list.at(i),
          text-scale: text-scale,
        )
      }
      i += 1
    }
  })
}

#let tuple(coord, name, sc, ..args, text-scale: 1) = {
  import cetz.draw: *

  let args_list = args.pos()
  let n = args_list.len()
  get-ctx((ctx) => {
    let (x, y, z) = cetz.coordinate.resolve(ctx, coord)

    rect(
      (x - (n / 2 * 1.4) * sc, y - 1 * sc),
      (x + (n / 2 * 1.4 + .6) * sc, y + 1 * sc),
      stroke: (dash: "dashed"),
      name: name + "-body",
      fill: luma(192),
    )

    let i = 0
    for inp in args_list {
      if inp != none {
        item(
          (x + (-n / 2 * 1.4 + .1 + i * 1.4 + .9) * sc, y),
          sc,
          name + "-arg" + args_list.at(i),
          args_list.at(i),
          text-scale: text-scale,
        )
      }
      i += 1
    }
  })
}

#nobreak[
  #kt-par[
    Давайте рассмотрим следующие функциональные типы. Что они из себя представляют?
    Какие функции с подобной семантикой можно написать?
  ]

  - `(A, (A) -> B) -> B`

    #kt-par[
    У нас есть значение типа `A` и функция, переводящая `A` в `B`. Хм, что бы это
    могло быть! Конечно, это применение функции к значению:
    ]
    
    #kt-eval-noret(```
                      fun <A, B> apply(value: A, func: (A) -> B): B = func(value)
                      ```)
  \
  #align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let sc = .9
      scale(sc)
      rect((0, 0), (10, -5), stroke: (dash: "dotted"), fill: background)
      item((2, 0), 1, "value", "A", text-scale: .5)
      lambda_arg((7, 0), "func", "A", "B", text-scale: .5)
      //tuple((0, 0), "tuple", 1, "A", "B", "C", "D", "E")
      item((5, -5), 1, "out", "B", text-scale: .5)
      bezier-curve(
        ((2, -.5), (2, -2), (4, -2), (4, 0), (5, 0)),
        stroke: (paint: foreground),
      )
      bezier-curve(
        ((9, 0), (10, 0), (10, -2.5), (5, -2.5), (5, -4.5)),
        stroke: (paint: foreground),
      )
    })
  ]
]

#nobreak[
  - `((A) -> B, (B) -> C) -> ((A) -> C)`

    #kt-par[
    Это же уже знакомая нам композиция. #hide[ 1111111111111111111111111111111111111111111111111 1 1 1 1 1 1 1 1 1 1 1 1  1 1 1 1 1]\
    ]

  #align(
    center,
  )[
      #cetz.canvas(
        {
          import cetz.draw: *
          let sc = .9
          scale(sc)
          rect((1, 0), (13, -5), stroke: (dash: "dotted"), fill: background)
          lambda_arg((4, 0), "func", "A", "B", text-scale: .7)
          lambda_arg((10, 0), "func", "B", "C", text-scale: .7)
          lambda_arg((7, -5), "func", "A", "C", text-scale: .7)

          bezier-curve(
            ((6, -5), (7, -5), (7, -0), (1, -5), (1, 0), (2, 0)),
            stroke: (paint: foreground),
          )
          bezier-curve(((6, 0), (7, .2), (7, -.2), (8, 0)), stroke: (paint: foreground))
          bezier-curve(
            ((12, 0), (13, 0), (13, -5), (7, 0), (7, -5), (8, -5)),
            stroke: (paint: foreground),
          )
        },
      )
    ]
]
\
#nobreak[
  - `((A, B) -> R) -> ((Pair<A, B>) -> R)`

    #kt-par[
      У нас была функция, принимающая `A` и `B`, теперь же это функция, принимающая
    пару из `A` и `B`. Ну, например мы можем разобрать пару на запчасти и скормить
    функции по частям.
]
  #kt-eval-noret(```
    fun <A, B, R> decompose(func: (A, B) -> R): (Pair<A, B>) -> R = 
          { func(it.first, it.second) }
    ```)
  #align(
    center,
  )[
    #cetz.canvas(
      {
        import cetz.draw: *
        let sc = .9
        scale(sc)
        rect((-1, 0), (7, -6), stroke: (dash: "dotted"), fill: background)
        lambda_arg((3, 0), "func", "A", "B", "R", text-scale: .7)
        lambda_arg((3, -6), "func", none, "R", text-scale: .7)
        tuple((1.25, -6), "tuple", .7, "A", "B")

        bezier-curve(((1.3, -5.75), (1.3, -5.5), (2, -5.5), (2.7, -5.5)), stroke: (paint: blue),)
        bezier-curve(((2.3, -5.75), (2.4, -5.75), (2.5, -5.5), (2.7, -5.5)), stroke: (paint: yellow),)
        bezier-curve(((2.7, -5.5), (3.25, -5.5), (3.25, -2.5), (.25, -4.5), (.25, -2)), stroke: (paint: foreground),)
        bezier-curve(((.25, -2), (.25, -.75), (1, -.75)), stroke: (paint: yellow),)
        bezier-curve(((.25, -2), (.25, +.75), (1, +.75)), stroke: (paint: blue),)
        bezier-curve(((5, 0), (6, 0), (6, -2.5), (3, -2.5), (3, -6), (4, -6)), stroke: (paint: foreground),)
      },
    )
  ]
]
\
#nobreak[
  - `((A, B) -> R, A) -> ((B) -> R)`

    #kt-par[
      Вот, а это уже более интересно. Почему? Фактически, мы подставляем значение в функцию от двух переменных, получая функцию от одной.
    ]

  #kt-eval-noret(```
    fun <A, B, R> substitute(func: (A, B) -> R, a: A): (B) -> R = { func(a, it) }
    ```)

  #align(
    center,
  )[
    #cetz.canvas(
      {
        import cetz.draw: *
        let sc = .9
        scale(sc)
        rect((-1, 0), (10, -6), stroke: (dash: "dotted"), fill: background)
        item((8, 0), 1, "A", "A")
        lambda_arg((3, 0), "func", "A", "B", "R", text-scale: .7)
        lambda_arg((4.5, -6), "func", "B", "R", text-scale: .7)

        bezier-curve(((8, -.5), (8, -5.5), (-2, -5.5), (-2, 0), (1, .75)), stroke: (paint: foreground),)
        bezier-curve(((3.5, -6), (5.5, -6), (5.5, -3), (-1, -4), (-1, -.75), (1, -.75)), stroke: (paint: foreground),)
        bezier-curve(((5, 0), (7, 0), (3.5, -6), (5.5, -6)), stroke: (paint: foreground),)
      },
    )
  ]
]

#kt-par[
  А что в этом такого необычного? 

  На самом деле, подстановка настолькое естественное действие, что им пользуются для того, чтобы хранить замыкания. Замыкания? А, помните, анонимные объекты, которые автомагически захватывали переменные из контекста? Как, например, в `composeAnon`. Вот в случае лямбд это и называется замыканиями. Это функция, ссылающаяся на внешние данные.

  Так что там про хранение? Так вот, один из вариантов --- анонимные объекты, которые мы рассматривали раньше. А другой, более простой --- просто хранить список из указателя на функцию, и части аргументов!
]
#nobreak[
#kt-par[
  Так что просто вот так хранить:\ \
  
  #align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let sc = .9
      scale(sc)
      content((0, 1.1em*sc), text(size:14em * sc, "["), anchor:"center")
      content((10, 1.1em*sc), text(size:14em * sc, "]"), anchor:"center")
      content((6, 1.1em*sc), text(size:14em * sc, ","), anchor:"center")
      item((8, 0), 1, "A", "A")
      lambda_arg((3, 0), "func", "A", "B", "R", text-scale: .7)
    })
  ]
 \ \
  ...и понимать это как функцию `(B) -> R`. Кстати говоря, функция `(A, B) -> R` тоже может быть представлена таким вот списком. И так далее. 
]]
#nobreak[
#kt-par[
  А что бы означал вот такой список?
\ \
    
  #align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let sc = .9
      scale(sc)
      content((0, 1.1em*sc), text(size:14em * sc, "["), anchor:"center")
      content((13, 1.1em*sc), text(size:14em * sc, "]"), anchor:"center")
      content((6, 1.1em*sc), text(size:14em * sc, ","), anchor:"center")
      content((9.5, 1.1em*sc), text(size:14em * sc, ","), anchor:"center")
      item((8, 0), 1, "A", "A")
      item((11.5, 0), 1, "B", "B")
      lambda_arg((3, 0), "func", "A", "B", "R", text-scale: .7)
    })
  ]

  \ \ Так это просто функция, ничего не принимающая и возвращающая `R`. Причём, если нулевой элемент --- честная, ничего не трогающая в реальном мире, функция, то весь лист --- функция, всегда возвращающая одно и то же значение. А это почти то же самое, что просто значение типа `R`... В общем говоря, порядок вычислений можно попросту так и записывать --- вложенными листами.
]
]

#nobreak[
#kt-par[
  И так можно хранить и другие лямбды из тех, что мы уже рассмотрели. `apply` возвращает не лямбду, не интересно, следующий. `compose` возвращает функцию `(A) -> C`. Как бы это понять?

   #align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let sc = .4
      scale(sc)
      rect((1, 0), (15.5, -5), stroke: (dash: "dotted"), fill: background)
      lambda_arg((4, 0), "func", "A", "B", text-scale: .4)
      lambda_arg((10, 0), "func", "B", "C", text-scale: .4)
      item((14, 0), 1, "A", "A", text-scale: .4)
      item((8.25, -5), 1, "C", "C", text-scale: .4)

      bezier-curve(
        ((14.5, 0), (15.5, 0), (15.5, -3), (15.5, -3), (1, -3),(1, -3), (1, 0), (2, 0)),
        stroke: (paint: foreground),
      )

      bezier-curve(((6, 0), (7, .2), (7, -.2), (8, 0)), stroke: (paint: foreground))
      bezier-curve(
        ((12, 0), (13, 0), (13, -3), (10, 0), (8.25, -4.5)),
        stroke: (paint: foreground),
      )
      content((0, -2), text(size:20em * sc, "["), anchor:"center")
      lambda_arg((21, -2.5), sc:1.5, "func", "A", "B", text-scale: .4)
      content((16.5,  -2), text(size:20em * sc, ","), anchor:"center")
      lambda_arg((30, -2.5), sc:1.5, "func", "B", "C", text-scale: .4)
      content((25,  -2), text(size:20em * sc, ","), anchor:"center")
      content((34,  -2), text(size:20em * sc, "]"), anchor:"center")
    })
  ]
  \ Как бы тут уже не вывихнуть мозг, конечно. Ну да ладно, это не очень нужно понимать, чтобы уметь этим пользоваться... Так, кстати, мы приходим к идее, что #box(`(A) -> ((B) -> R)`) и #box(`(A, B) -> R`) --- это, по сути, одно и то же. И скобки в первой записи принято опускать: #box(`(A) -> (B) -> R`).
]
]

