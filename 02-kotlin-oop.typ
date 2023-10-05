#import "kotlinheader.typ" : *

#show : kt-paper-rule

= Объектно-ориентированное программирование

#kt-par[
  Допустим, мы хотим уметь хранить вместе связанные данные. Например, точку ---
  две координаты и имя. Ну, _как-то_ это сделать мы умеем:
]

#kt-eval(```
listOf(1.0, 2.0, "A")
```)
#kt-res(`[1.0, 2.0, A]`, `List<Comparable<*>>`)

#kt-par[
  И теперь при чтении элементов, если мы абсолютно уверены, какого они типа,
  используем знакомый нам оператор as:
]

#kt-eval(```
val arr = listOf(1.0, 2.0, "A")
arr[2] as String
```)
#kt-res(`"A"`, KtString)

#kt-par[
  Во-первых, компилятор нам надоест предупреждениями об unchecked cast. Во-вторых,
  оператор as на самом деле занимает довольно много времени, так как неявно ещё и
  производит дорогую проверку типов. В-третьих, мы сами рискуем быстро забыть, кто
  на ком стоял, в каком элементе хранится что и какого типа.
]

#kt-par[
  Можно решить проблему с типами с помощью специальных конструкций языка: `Pair` и
  `Triple`.
]

#kt-eval(```
Triple(1.0, 2.0, "A")
```)
#kt-res(`(1.0, 2.0, A)`, `Triple<Double, Double, String>`)

#kt-par[
  Теперь мы можем обращаться к элементам по именам first, second, third:
]

#kt-eval(```
Triple(1.0, 2.0, "A").third
```)
#kt-res(`"A"`, KtString)

#kt-par[
  Для создания пары есть инфиксная функция to:
]

#kt-eval(```
1 to "PTHS"
```)
#kt-res(`(1, PTHS)`, `Pair<Int, String>`)

#kt-par[
  Элементы, соответственно, first и second. Вроде всё замечательно?
]
#strikeleft[
  #kt-par[
    Предположим, вы ведёте курс в ФТШ и хотите, чтобы код в ваших конспектах был
    корректно подсвечен. Вы пишете программу, разбирающую код и решающую, что и как
    подсветить.
  ]

  #kt-par[
    Из чего состоит, скажем, объявление функции?
    - Перечень модификаторов
    - Имя
    - Список параметров
    - Возможно, явное объявление возвращаемого типа
    - Тело функции
    Это пять элементов. Мы так плохо умеем, но ведь пары и тройки можно вкладывать
    друг в друга.
  ]

  `Triple<`modifiers`, `name`, Triple<`arguments`, `return type`?, `function
  body`>>`
]

#strikeleft[
  #kt-par[
    Модификаторы --- это строки, имя --- строка. Возвращаемый тип --- для простоты
    допустим, тоже, тело функции --- перечень выражений. Аргументы --- список пар
    (имя, тип)
  ]

  `Triple<List<String>, String, Triple<List<Pair<String, String>>, String?, List<`statement`>>`

  #kt-par[
    И это ещё не всё, statement-то это тоже нечто непростое. А лично я уже
    запутался.
  ]
]

#kt-par[
  Давайте объявим новый тип данных.
]

#kt-eval-noret(```
data class Point(val x: Double, val y: Double, val name: String)
```)

#kt-par[
  data class --- собственно, объявление (чем data class отличается от просто class
  --- в конце лекции). Дальше идёт объявление _полей_ --- постоянная (val) или
  переменная (var), затем имя и тип.
]

#kt-eval-append(```
Point(1.0, 2.0, "A")
```)
#kt-res(`Point(x=1.0, y=2.0, name=A)`, `Point`)

#kt-par[
  Строковое представление тут тоже немного хромает, но читаемо. Да и не это обычно
  важно, и это мы ещё научимся менять. Что важно, теперь у нас есть именованные и
  типизированные элементы, а ещё лакониченое именование типа.
]

#kt-eval-append(```
val point = Point(1.0, 2.0, "A")
point.y
```)
#kt-res(`2.0`, KtDouble)

#kt-par[
  Давайте попробуем написать трёхмерный вектор.
]

#kt-eval(```
data class Vector(val x: Double, val y: Double, val z: Double)
```)

#kt-par[
  Отлично. Теперь добавим пару функций для работы с ним.
]

#kt-eval-append(```
  fun add(a: Vector, b: Vector) = Vector(a.x + b.x, a.y + b.y, a.z + b.z)

  fun sub(a: Vector, b: Vector) = Vector(a.x - b.x, a.y - b.y, a.z - b.z)

  fun multiply(a: Vector, k: Double) = Vector(a.x * k, a.y * k, a.z * k)

  fun scalar(a: Vector, b: Vector) = a.x * b.x + a.y * b.y + a.z * b.z

  fun magnitude(a: Vector) = sqrt(scalar(a, a))
  ```)

#kt-par[
  Проверим теперь, что работает:
]

#kt-eval-append(```
val a = Vector(5.0, 6.0, 6.0)
val b = Vector(30.0, 30.0, 30.0)
val c = Vector(2.0, 3.0, 9.0)
add(a, b)
```)
#kt-res(`Vector(x=35.0, y=36.0, z=36.0)`, `Vector`)

#kt-eval-append(```
sub(a, c)
```)
#kt-res(`Vector(x=3.0, y=3.0, z=-3.0)`, `Vector`)

#kt-eval-append(```
multiply(a, 3.0)
```)
#kt-res(`Vector(x=15.0, y=18.0, z=18.0)`, `Vector`)

#kt-par[
  Вроде всё хорошо. Однако теперь стоит заметить, что в глобальном поле может
  оказаться очень много функций с одинаковыми названиями. Например, мы захотим
  складывать вектора, матрицы, комплексные числа и прочие штуки. Так-то это не
  проблема, если типы аргументов известны в момент компиляции, то выберется
  правильная версия:
]

#kt-eval(```
fun process(x: Int) {
    println("Int version for " + x)
}
fun process(x: Double) {
    println("Double version for " + x)
}

process(1)
process(2.0)
```)
#kt-res(`Unit`, KtUnit)
#kt-print(```
Int version for 1
Double version for 2.0
```)

#kt-par[
  Тип аргументов, как и название функции, входит в _сигнатуру функции_, то есть, в
  некотором роде, её уникальное описание. Возвращаемый тип --- не входит, хотя
  есть определённые способы обойти это ограничение, можно посмотреть лекцию про
  generics, раздел reified.
]

#kt-par[
  Но вот загрязнение глобального пространства имён --- не дело. Давайте поместим
  эти функции в отдельный namespace. 
] 

#kt-par[
  Для этого делаем следующее:
]

#kt-eval(```
data class Vector(val x: Double, val y: Double, val z: Double) {
    companion object {
        fun add(a: Vector, b: Vector) = Vector(a.x + b.x, a.y + b.y, a.z + b.z)

        fun sub(a: Vector, b: Vector) = Vector(a.x - b.x, a.y - b.y, a.z - b.z)

        fun multiply(a: Vector, k: Double) = Vector(a.x * k, a.y * k, a.z * k)

        fun scalar(a: Vector, b: Vector) = a.x * b.x + a.y * b.y + a.z * b.z

        fun magnitude(a: Vector) = sqrt(scalar(a, a))
    }
}```)

#kt-par[
  Теперь, чтобы обратиться к этим функциям, нужно их явно квалифицировать:
]

#kt-eval-append(```
Vector.add(Vector(5.0, 6.0, 6.0), Vector(2.0, 3.0, 9.0))
```)
#kt-res(`Vector(x=7.0, y=9.0, z=15.0)`, `Vector`)

#kt-par[
  Технически, теперь `Vector.add` --- это и есть полное имя функции.
] 

#nobreak[
    #kt-par[Да, давайте
    добавим ещё пару интересных функций...
  ]

  #kt-eval(```
  data class Vector(val x: Double, val y: Double, val z: Double) {
      companion object {
          fun add(a: Vector, b: Vector) = Vector(a.x + b.x, a.y + b.y, a.z + b.z)

          fun sub(a: Vector, b: Vector) = Vector(a.x - b.x, a.y - b.y, a.z - b.z)

          fun multiply(a: Vector, k: Double) = Vector(a.x * k, a.y * k, a.z * k)

          fun scalar(a: Vector, b: Vector) = a.x * b.x + a.y * b.y + a.z * b.z

          fun magnitude(a: Vector) = sqrt(scalar(a, a))

          fun ofList(list: List<Double>) = Vector(list[0], list[1], list[2])

          fun ofNumbers(x: Number, y: Number, z: Number) : Vector {
              return Vector(x.toDouble(), y.toDouble(), z.toDouble())
          }
      }
  }```)
]

#kt-par[
  Честно говоря, можно заметить, что часто функции, которые хотелось бы положить в
  companion object класса T, либо принимают T одним из аргументов, либо возвращают
  T. Более того, на практике часто приходится писать очень много вложенных
  функций, как то, например:
]

#kt-eval-noret(```
joinToString(
    takeWhile(
        map(
            filter(
                0 until 100,
                { it % 6 == 0}
            ),
            { it * it }
        ),
        { it <= 1000}
    )
)
```)

#kt-par[
  (Примечание: код выше является иллюстрацией, в текущих версиях Котлина таких
  функций в стандартной библиотеке нет).
]

#kt-par[
  Что делает этот код?
  - Берёт список от нуля до ста
  - Фильтрует его, оставляя только числа, кратные шести
  - Возводит каждое число в квадрат
  - Оставляет только те, которые меньше 1000
  - Соединяет всё в строку
]

#kt-res(`"0, 36, 144, 324, 576, 900"`, KtString)

#kt-par[
  Всё бы ничего, но выглядит этот код... плохо. Читать снизу вверх, справа налево.
  Поэтому существует возможность объявить функцию как условно-постфиксную
  (помните, в предыдущей лекции об этом было?). 
]

#nobreak[
  #kt-par[
    И код внезапно обретёт смысл не
    только на бумаге, но и визуально:
  ]

  #kt-eval(```
  (0 until 100)
      .filter({ it % 6 == 0 })
      .map({ it * it })
      .takeWhile({ it <= 1000 })
      .joinToString()
  ```)
  #kt-res(`"0, 36, 144, 324, 576, 900"`, KtString)
]
#kt-par[
  И как это сделать? Объявить функцию в теле класса, но не в companion object.
  Тогда это будет _метод_, который можно _вызвать на_ объекте этого класса.
  Объект, на котором вызывается метод (слева от точки) передаётся функции в
  неявный аргумент с именем this.
]

#kt-eval(
  ```
          data class Vector(val x: Double, val y: Double, val z: Double) {
              companion object {
                  fun ofList(list: List<Double>) = Vector(list[0], list[1], list[2])

                  fun ofNumbers(x: Number, y: Number, z: Number) : Vector {
                      return Vector(x.toDouble(), y.toDouble(), z.toDouble())
                  }
              }

              fun add(that: Vector) = Vector(this.x + that.x, this.y + that.y, this.z + that.z)

              fun sub(that: Vector) = Vector(this.x - that.x, this.y - that.y, this.z - that.z)

              fun multiply(k: Double) = Vector(this.x * k, this.y * k, this.z * k)

              fun scalar(that: Vector) = this.x * that.x + this.y * that.y + this.z * that.z

              fun magnitude() = sqrt(this.scalar(this))
          }
          ```,
)

#kt-par[
  Если есть второй (на самом деле первый) аргумент того же типа, то его часто
  называют `that` или `another`. Проверим, что работает:
]

#kt-eval-append(```
val a = Vector.ofNumbers(5, 6, 6)
val b = Vector.ofNumbers(2, 3, 9)
a.add(b)
```)
#kt-res(`Vector(x=7.0, y=9.0, z=15.0)`, `Vector`)

#kt-eval-append(```
a.magnitude()
```)
#kt-res(`9.848857801796104`, KtDouble)

#kt-par[
  Замечание первое: обращаться к this явным образом не всегда обязательно. Если
  просто написать идентификатор, то в первую очередь компилятор поищет локальную
  переменную с таким именем, потом аргумент функции, и наконец, поле this. Если вы
  не занимаетесь странным неймингом, называя одним и тем же именем всё, что
  попало, то всё у вас будет хорошо. Замечание второе: чтобы объявить функцию
  инфиксной, достаточно дописать к ней модификатор infix (работает только с
  методами, имеющими ровно один явный аргумент). Для того, чтобы код лучше
  читался, поменяем имена немного (add, sub, multiply на plus, minus, times)
  Замечание третье: чтобы обеспечить, наконец, нормальное строковое представление
  нашему классу, определим в нём специальный метод toString.
]

#nobreak[
  #kt-par[
    Итого получаем:
  ]
  #kt-eval(
    ```
                data class Vector(val x: Double, val y: Double, val z: Double) {
                    companion object {
                        fun ofList(list: List<Double>) = Vector(list[0], list[1], list[2])

                        fun ofNumbers(x: Number, y: Number, z: Number): Vector {
                            return Vector(x.toDouble(), y.toDouble(), z.toDouble())
                        }
                    }

                    infix fun plus(that: Vector) = Vector(x + that.x, y + that.y, z + that.z)

                    infix fun minus(that: Vector) = Vector(x - that.x, y - that.y, z - that.z)

                    infix fun times(k: Double) = Vector(x * k, y * k, z * k)

                    infix fun dot(that: Vector) = x * that.x + y * that.y + z * that.z

                    fun magnitude() = sqrt(this dot this)

                    override fun toString(): String = "($x, $y, $z)"
                }
                ```,
  )
]

#kt-par[
  Два вопроса. Что такое override и что за доллары в строке? Первое --- узнаете в
  следующей лекции. Пока так надо, поверьте. Второе --- способ автоматически
  встроить строковое представление переменной в строку. Ну, то же самое выглядело
  бы в какой-нибудь Java как #box[`"(" + x + ", " + y + ", " + z + ")"`]. _Не очень_ лаконично.
]

#kt-par[
  Отлично, давайте попробуем:
]

#kt-eval-append(```
val a = Vector.ofNumbers(5, 6, 6)
val b = Vector.ofNumbers(2, 3, 9)
a plus b
```)
#kt-res(`(7.0, 9.0, 15.0)`, `Vector`)

#kt-par[
  А что нам выдаст следующий код?
]

#kt-eval-append-noret(```
a plus b times 3.0
```)

#kt-par[
  На самом деле, очевидно, что компилятор не может догадываться о том, какие
  приоритеты мы закладываем в инфиксные методы, так что он прочитает это слева
  направо:
]

#kt-eval-append(```
(a plus b) times 3.0
```)
#kt-res(`(21.0, 27.0, 45.0)`, `Vector`)

#kt-par[
  ... Хочется перегрузки операторов. И да, я не просто так назвал методы `plus`,
  `minus`, `times`. Это методы, которые отвечают за перегрузку соответствующих
  операторов --- сложения, вычитания, умножения. Надо лишь добавить им модификатор
  operator.
]

#nobreak[
#kt-eval(
    ```
    data class Vector(val x: Double, val y: Double, val z: Double) {
        companion object {
            fun ofList(list: List<Double>) = Vector(list[0], list[1], list[2])

            fun ofNumbers(x: Number, y: Number, z: Number): Vector {
                return Vector(x.toDouble(), y.toDouble(), z.toDouble())
            }
        }

        operator fun plus(that: Vector) = Vector(x + that.x, y + that.y, z + that.z)

        operator fun minus(that: Vector) = Vector(x - that.x, y - that.y, z - that.z)

        operator fun times(k: Double) = Vector(x * k, y * k, z * k)

        infix fun dot(that: Vector) = x * that.x + y * that.y + z * that.z

        fun magnitude() = sqrt(this dot this)

        override fun toString(): String = "($x, $y, $z)"
    }
    ```,
  )
]
#kt-par[
  Никто, конечно, не запрещает оставить infix на операторном методе. Но зачем?
]

#kt-par[
  Снова проверяем:
]

#kt-eval-append(```
val a = Vector.ofNumbers(5, 6, 6)
val b = Vector.ofNumbers(2, 3, 9)
a + b
```)
#kt-res(`(7.0, 9.0, 15.0)`, `Vector`)

#kt-eval-append(```
a + b * 3.0
```)
#kt-res(`(11.0, 15.0, 33.0)`, `Vector`)

#kt-par[
  Вот тут уже результат другой, потому что у операторов `+` и `*` вполне понятные
  приоритеты. Полный перечень операторов и методов, им соответствующих, можно
  найти #link(
    "https://kotlinlang.org/docs/operator-overloading.html",
  )[в документации]. Говоря коротко, есть
  - `plus`, `minus`, `times`, `div`, `rem`, делающих понятно что,
  - `invoke` --- оператор вызова, `()`,
  - `get` и `set` --- доступа по индексу, `[]`,
  - `compareTo` --- сравнение, `<`, `>`, `>=`, `<=`,
  - `equals` --- сравнение на равенство, `==` и `!=` (чаще всего вы _очень_ хотите,
    чтобы он был согласован с `compareTo`)
  - `contains` --- проверка на включение, `in` и `!in`
  - `rangeTo` и `rangeUntil` --- промежутки, `..` и `..<` соответственно.
  - Есть ещё операторы для `+=`, `-=` и проч., а также для `++` и `--`, но их надо
    реализовывать с большой осторожностью --- читайте документацию.
  - И операторы `componentN`, о которых поговорим позже.
]

#kt-par[
  А можно ли добавить метод к классу, который определяем не мы? Например, к
  чему-то из стандартной библиотеки?
]

#kt-par[
  Очень хочется, особенно операторы. А то что за дела, #box[`"1" + 2`] работает, а
  #box[`1 + "2"`] --- нет?
]

#nobreak[
  #kt-par[
    Можно. Для этого нужно всего лишь написать так называемый receiver type --- тип,
    для которого этот метод объявляется. Ну, скажем,
  ]

  #kt-eval-noret(```
  operator fun Int.plus(str: String) = this.toString() + str
  ```)

  #kt-par[
    Вот то, что слева от точки --- это и есть receiver type. Он, кстати, вполне
    может быть nullable --- тогда при вызове этого метода необязательно писать safe
    call. Но вам придётся разбираться с тем, что this может оказаться null.
    Например, есть встроенная перегрузка toString для nullable типов:
  ]
]
#kt-eval-noret(```
inline fun Any?.toString() = this?.toString() ?: "null"
```)

#kt-par[
  У нас в companion object всё ещё остались методы. Это, конечно, не плохо, но...
  помните, я говорил?..

  _...часто функции, которые хотелось бы положить в companion object класса T, либо
  принимают T одним из аргументов, либо возвращают T..._

  С первыми мы разобрались, теперь со вторыми. По сути это --- создание нового
  объекта, такое же, как `Vector(1.0, 2.0, 3.0)`. Давайте сделаем, чтобы можно
  было так же. Для этого есть ключевое слово constructor и абьюз ключевого слова
  this.
]

#kt-eval(
  ```
          data class Vector(val x: Double, val y: Double, val z: Double) {
              constructor(list: List<Double>) : this(list[0], list[1], list[2])

              constructor(x: Number, y: Number, z: Number)
                      : this(x.toDouble(), y.toDouble(), z.toDouble())

              constructor() : this(0.0, 0.0, 0.0)

              operator fun plus(that: Vector) = Vector(x + that.x, y + that.y, z + that.z)
              operator fun minus(that: Vector) = Vector(x - that.x, y - that.y, z - that.z)
              operator fun times(k: Double) = Vector(x * k, y * k, z * k)
              infix fun dot(that: Vector) = x * that.x + y * that.y + z * that.z
              fun magnitude() = sqrt(this dot this)
              override fun toString(): String = "($x, $y, $z)"
          }
          ```,
)

#kt-par[
  Заодно создали конструктор без аргументов, создающий нулевой вектор.
]

#kt-par[
  Стоит заметить, что такой трюк удастся только если все необходимые параметры
  можно вычислить одним выражением. В противном случае придётся всё-таки писать
  отдельную функцию.
]

#kt-eval-append(```
Vector()
```)
#kt-res(`(0.0, 0.0, 0.0)`, `Vector`)

#kt-eval-append(```
Vector(566L, 0xEF.toByte(), 3.0)
```)
#kt-res(`(566.0, 239.0, 3.0)`, `Vector`)

#kt-par[
  И последний вопрос. Что же значит data в объявлении класса? На самом деле, это
  означает, что за нас сгенерируют кучу методов. Давайте попробуем поделать
  очевидные штуки:
]

#kt-eval(```
Vector(566, 566, 566) === Vector(566, 566, 566)
```)
#kt-res(`true`, KtBool)

#kt-par[
  Очевидно? _Нет_.
]

#nobreak[
  #kt-par[
    Давайте попробуем без слова data.
  ]

  #kt-eval(```
  class Vector(val x: Double, val y: Double, val z: Double)

  Vector(566.0, 566.0, 566.0) === Vector(566.0, 566.0, 566.0)
  ```)
  #kt-res(`false`, KtBool)

  #kt-eval-append(`Vector(1, 2, 3)`)
  #kt-res(`Vector@7a81197d`, `Vector`)
]
#kt-par[
  Почему так? Чтобы понять это, придётся пройти несколько этапов. Написать data
  class, скомпилировать его, декомпилировать в Java и сконвертировать в Kotlin.
]

#kt-par[А теперь]

#kt-eval(```
data class Vector(val x: Double, val y: Double, val z: Double)
```)
#kt-par[
  Посмотрим на результат компиляции... 261 строка байткода. Против 84, если бы мы
  не объявляли его data. Я не хочу это читать, ладно? Давайте сразу декомпилируем
  в Java (92 строки, уже лучше) и сконвертируем в Kotlin.
]

#kt-eval-noret(
  ```
        class Vector(val x: Double, val y: Double, val z: Double) {
            operator fun component1(): Double = x

            operator fun component2(): Double = y

            operator fun component3(): Double = z

            fun copy(x: Double, y: Double, z: Double): Vector {
                return Vector(x, y, z)
            }

            override fun toString(): String = "Vector(x=$x, y=$y, z=$z)"

            override fun hashCode(): Int {
                return (java.lang.Double.hashCode(x) * 31 + java.lang.Double.hashCode(y)) * 31 + java.lang.Double.hashCode(z)
            }

            override fun equals(var1: Any?): Boolean {
                return if (this !== var1) {
                    if (var1 is Vector) {
                        val var2 = var1
                        if (java.lang.Double.compare(x, var2.x) == 0 &&
                                java.lang.Double.compare(y, var2.y) == 0 &&
                                java.lang.Double.compare(z, var2.z) == 0
                        ) {
                            return true
                        }
                    }
                    false
                } else {
                    true
                }
            }
        }
        ```,
)

_Ох_. С чего бы начать.

#kt-par[
  В общем, за нас сгенерировали equals, hashCode, toString, copy и ещё на закуску
  --- `copy$default`, который не помещается на полях этого конспекта. Всего этого
  бойлерплейта можно избежать одним ключевым словом --- разве не здорово?
]

#kt-par[
  А есть ещё методы `component1`, `component2` и `component3` (нумерация здесь,
  что забавно, с единицы). Это методы, отвечающие за _деструктивное присваивание_.
  Что означает, что вы можете делать так:
]

#kt-eval-append(```
val v = Vector(1.0, 2.0, 3.0)
val (x, y, z) = v
y
```)
#kt-res(`2.0`, KtDouble)

#kt-par[
  И это то же самое, что написать:
]

#indent(kt(```
val v = Vector(1.0, 2.0, 3.0)
val x = v.component1(),
val y = v.component2()
val z = v.component3()
```))

