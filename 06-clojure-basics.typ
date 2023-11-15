#import "kotlinheader.typ" : *
#import "@preview/cetz:0.1.2"

#let background = white
#let foreground = black

Единственное, что здесь действительно стоит заметить, так это то, что код представляет из себя набор вложенных S-выражений: $("функция" "аргумент1" "аргумент2" ...)$. Запятые ничем не отличаются от пробелов. Код также есть в файле basics.clj. Точки с запятой начинают отнострочные комментарии.

#let clj-code(cd, pr:none, rs) = [
    #nobreak[
        #cd 
        #if pr == none {} else { text(fill:rgb("#00aa00"), pr) }
        #raw(lang:"clojure", "=> " + rs.text) \ \
    ]
]
#let clj-errored(cd, err) = [
    #nobreak[
        #cd 
        #text(fill:red, err) \ 
    ]
]
#let clj-res(x) = [#raw(lang:"clojure", "=> " + x.text)\ \ ]
#let clj-print(x) = [`=> ` #x]

#clj-code(```
123
```, ```
 123
```)

#clj-code(```
1.0
```, ```
 1.0
```)

#clj-code(```
(+ 1 2 3)
```, ```
 6
```)

#clj-code(```
(+)
```, ```
 0
```)

#clj-code(```
(+ 1, 2, 3)
```, ```
 6
```)

#clj-code(```
(- 5 2)
```, ```
 3
```)

#clj-code(```
(/ 3 2)
```, ```
 3/2
```)

#clj-code(```
(/ 6 4)
```, ```
 3/2
```)

#clj-code(```
1.5
```, ```
 1.5
```)

#clj-code(```
(= 1.5 3/2)
```, ```
 false
```)

#clj-code(```
(/ 3 2)
```, ```
 3/2
```)

#clj-code(```
3/2
```, ```
 3/2
```)

#clj-code(```
(* 3/2 2)
```, ```
 3N
```)

#clj-code(```
3
```, ```
 3
```)

#clj-code(```
3N
```, ```
 3N
```)

#clj-code(```
(type 3/2)
```, ```
 clojure.lang.Ratio
```)

#clj-errored(```
(+ 8000000000000000000 8000000000000000000)
```, ```
Execution error (ArithmeticException) at java.lang.Math/addExact (Math.java:931) .
long overflow
```)

#clj-code(```
(+' 8000000000000000000 8000000000000000000)
```, ```
 16000000000000000000N
```)

#clj-code(```
(type 3)
```, ```
 java.lang.Long
```)

#clj-code(```
(type 3N)
```, ```
 clojure.lang.BigInt
```)

#clj-errored(```
(/ 1 0)
```, ```
Execution error (ArithmeticException) at user/eval2017 (form-init17984610524906141998.clj:1) .
Divide by zero
```)

#clj-code(```
(/ 1.0 0.0)
```, ```
 ##Inf
```)

#clj-code(```
(+ 0.1 0.2)
```, ```
 0.30000000000000004
```)

#clj-code(```
"abc"
```, ```
 "abc"
```)

#clj-code(```
(type "abc")
```, ```
 java.lang.String
```)

#clj-code(```
\a
```, ```
 \a
```)

#clj-code(```
(type \a)
```, ```
 java.lang.Character
```)

#clj-code(```
\tab
```, ```
 \tab
```)

#clj-code(```
(list 1 2 3)
```, ```
 (1 2 3)
```)

#clj-errored(```
 (1 2 3)
```, ```
Execution error (ClassCastException) at user/eval2047 (form-init17984610524906141998.clj:1) .
class java.lang.Long cannot be cast to class clojure.lang.IFn (java.lang.Long is in module java.base of loader 'bootstrap' ; clojure.lang.IFn is in unnamed module of loader 'app')
```)

#clj-code(```
(* (+ 2 3) 4)
```, ```
 20
```)

#clj-code(```
(str 1)
```, ```
 "1"
```)

#clj-code(```
(str "abc" "def")
```, ```
 "abcdef"
```)

#clj-code(```
(str (str 1) (str 2))
```, ```
 "12"
```)

#clj-code(```
(str 1 2)
```, ```
 "12"
```)

#clj-code(```
(type (list 1 2 3))
```, ```
 clojure.lang.PersistentList
```)

#clj-code(```
[1 2 3]
```, ```
 [1 2 3]
```)

#clj-code(```
(type [1 2 3])
```, ```
 clojure.lang.PersistentVector
```)

#clj-code(```
(def x [1 2 3])
```, ```
 #'user/x
```)

#clj-code(```
x
```, ```
 [1 2 3]
```)

#clj-code(```
user/x
```, ```
 [1 2 3]
```)

#clj-code(```
(nth x 1)
```, ```
 2
```)

#clj-code(```
(cons 4 x)
```, ```
 (4 1 2 3)
```)

#clj-code(```
(vec (cons 4 x))
```, ```
 [4 1 2 3]
```)

#clj-errored(```
(conj 4 x)
```, ```
Execution error (ClassCastException) at user/eval2131 (form-init17984610524906141998.clj:1) .
class java.lang.Long cannot be cast to class clojure.lang.IPersistentCollection (java.lang.Long is in module java.base of loader 'bootstrap' ; clojure.lang.IPersistentCollection is in unnamed module of loader 'app')
```)

#clj-code(```
(conj x 4)
```, ```
 [1 2 3 4]
```)

#clj-code(```
(conj (list 1 2 3) 4)
```, ```
 (4 1 2 3)
```)

#clj-code(```
(assoc x 1 4)
```, ```
 [1 4 3]
```)

#clj-code(```
x
```, ```
 [1 2 3]
```)

#clj-code(```
(def x 2)
```, ```
 #'user/x
```)

#clj-code(```
x
```, ```
 2
```)

#clj-code(```
true
```, ```
 true
```)

#clj-code(```
false?
```, ```
 #object[clojure.core$false_QMARK_ 0x192e860b "clojure.core$false_QMARK_@192e860b"]
```)

#clj-code(```
false
```, ```
 false
```)

#clj-code(```
(not true)
```, ```
 false
```)

#clj-code(```
(and true false)
```, ```
 false
```)

#clj-code(```
(or true false)
```, ```
 true
```)

#clj-code(```
(if true 23 45)
```, ```
 23
```)

#clj-code(```
(def fact
    (fn [n]
        (if
            (< n 1)
            1
            (* n (fact (- n 1))))))
```, ```
 #'user/fact
```)

#clj-code(```
(fact 5)
```, ```
 120
```)

#clj-code(```
(def fact
    (fn [n]
        (if
            (< n 1)
            1
            (* n (recur (- n 1))))))
```, ```
Syntax error (UnsupportedOperationException) compiling recur at (/tmp/form-init17984610524906141998.clj:6:12) .
Can only recur from tail position
```)

#clj-code(```
(def fact
    (fn [n m]
        ))
```, ```
 #'user/fact
```)

#clj-code(```
(print 1)
```, pr:```
1
```, ```
nil
```)

#clj-code(```
(def fact
    (fn [n m]
        (if
            (< n 1)
            m
            (recur (- n 1) (* n m)))))
```, ```
 #'user/fact
```)

#clj-code(```
(fact 5 1)
```, ```
 120
```)

#clj-code(```
(fact 5 2)
```, ```
 240
```)

#clj-code(```
(def factorial (fn [n] (fact n 1)))
```, ```
 #'user/factorial
```)

#clj-code(```
(factorial 6)
```, ```
 720
```)

#clj-code(```
(defn factorial [n] (fact n 1))
```, ```
 #'user/factorial
```)

#clj-code(```
(filter
    (fn [x] (= 1 (rem x 2)))
    [1 2 3 4 5 6 7 8])
```, ```
 (1 3 5 7)
```)

#clj-code(```
(filter
    #(= 1 (rem % 2))
    [1 2 3 4 5 6 7 8])
```, ```
 (1 3 5 7)
```)

#clj-code(```
(filter
    odd?
    [1 2 3 4 5 6 7 8])
```, ```
 (1 3 5 7)
```)

#clj-code(```
(filter
    even?
    [1 2 3 4 5 6 7 8])
```, ```
 (2 4 6 8)
```)

#clj-code(```
(map
    #(* % %)
    (range 8))
```, ```
 (0 1 4 9 16 25 36 49)
```)

#clj-errored(```
(range)
```, ``)

И-и-и... REPL зависла. `range` на самом деле возвращает бесконечную последовательность, которую REPL пытается преобразовать в строку, чтобы напечатать. \ \

#clj-code(```
(take-while #(< % 128) (map #(* % %) (range)))
```, ```
(0 1 4 9 16 25 36 49 64 81 100 121)
```)

#clj-code(```
(type (take-while #(< % 128) (map #(* % %) (range))))
```, ```
 clojure.lang.LazySeq
```)

#clj-code(```
(map #(print %) (range 100))
```, pr:```
0123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899
```, ```(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil)```)

#clj-code(```
(take 1 (map #(print %) (range 100)))
```, pr:```
012345678910111213141516171819202122232425262728293031
```, ```
(nil)
```)

Откуда здесь 32 числа? `map` действует лениво, но не очень. Она бьёт последовательность на блоки по 32 элемента и преобразует их по требованию, блоками. \ \ 

#clj-code(```
(defn square [x] (* x x))
```, ```
 #'user/square
```)

#clj-code(```
(defn trice [x] (* x 3))
```, ```
 #'user/trice
```)

#clj-code(```
(comp square trice)
```, ```
#object[clojure.core$comp$fn__5888 0x17af57d7 "clojure.core$comp$fn__5888@17af57d7"]
```)

#clj-code(```
(def very-special-func (comp square trice))
```, ```
 #'user/very-special-func
```)

#clj-code(```
(very-special-func 4)
```, ```
 144
```)

#clj-code(```
((comp square trice) 4)
```, ```
 144
```)

#clj-code(```
(defn cube [x] (* x x x))
```, ```
 #'user/cube
```)

#clj-errored(```
(-)
```, ```
Execution error (ArityException) at user/eval1974 (form-init10262687158678453236.clj:1) .
Wrong number of args (0) passed to: clojure.core/-
```)

#clj-code(```
(- 2)
```, ```
 -2
```)

#clj-code(```
(- 5 3)
```, ```
 2
```)

#clj-code(```
(- 5 3 2)
```, ```
 0
```)

#clj-code(```
((#(comp % %) #(* % %)) 3)
```, ```
 81
```)

#clj-code(```
((comp) 3)
```, ```
 3
```)

#clj-code(```
(identity 3)
```, ```
 3
```)

#clj-code(```
((constantly 5))
```, ```
 5
```)

#clj-code(```
(constantly 5)
```, ```
 #object[clojure.core$constantly$fn__5752 0x78ac6be6 "clojure.core$constantly$fn__5752@78ac6be6"]
```)

#clj-code(```
(def const5 (constantly 5))
```, ```
 #'user/const5
```)

#clj-code(```
(const5)
```, ```
 5
```)

#clj-code(```
(const5 1 2 3 4 6 7)
```, ```
 5
```)

#clj-code(```
(+ 1 2 3)
```, ```
 6
```)

#clj-code(```
(def l (list 1 2 3))
```, ```
 #'user/l
```)

#clj-code(```
(apply + l)
```, ```
 6
```)

#clj-code(```
(partial - 1)
```, ```
 #object[clojure.core$partial$fn__5920 0x26b546ec "clojure.core$partial$fn__5920@26b546ec"]
```)

#clj-code(```
(def func (partial - 1))
```, ```
 #'user/func
```)

#clj-code(```
(func 3)
```, ```
 -2
```)

#clj-code(```
(map #(+ 2) [1 2 3])
```, ```
Error printing return value (ArityException) at clojure.lang.AFn/throwArity (AFn.java:429) .
Wrong number of args (1) passed to: user / eval2046/fn--2047
```)

#clj-code(```
(map #(+ 2 %) [1 2 3])
```, ```
 (3 4 5)
```)

#clj-code(```
(map (partial + 2) [1 2 3])
```, ```
 (3 4 5)
```)

#clj-code(```
(map list [1 2 3] [4 5 6])
```, ```
 ((1 4) (2 5) (3 6))
```)

