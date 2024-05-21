(module $examples
  (type $func (func))
  (type $cont (cont $func))

(tag $yield (export "yield") (param i32))

(func $log (import "spectest" "print_i32") (param i32))

;; yields successive natural numbers
(func $naturals
    (export "naturals")
    (local $n i32)
    (loop $l
        (suspend $yield (local.get $n))
        (local.set $n (i32.add (local.get $n) (i32.const 1)))
        (br $l)
    )
)

;; yields 1-2-3
(func $one-two-three (export "one-two-three")
    (suspend $yield::<i32> (i32.const 1))
    (suspend $yield (i32.const 2))
    (suspend $yield (i32.const 3))
)

  ;; yields successive Fibonacci numbers
  (func $fibonacci (export "fibonacci")
    (local $a i32)
    (local $b i32)
    (local $t i32)
    (local.set $b (i32.const 1))
    (loop $l
      (suspend $yield (local.get $a))
      (local.set $t (local.get $a))
      (local.set $a (local.get $b))
      (local.set $b (i32.add (local.get $t) (local.get $a)))
      (br $l)
    )
  )

  (func $print-first (export "print-first") (param $n i32) (param $k (ref $cont))
    (loop $l
      (block $on_yield (result i32 (ref $cont))
        (if (local.get $n)
          (then (resume $cont (tag $yield $on_yield) (local.get $k)))
        )
        (return)
      ) ;;   $on_yield (result i32 (ref $cont))
      (local.set $k)
      (call $log)
      (local.set $n (i32.add (local.get $n) (i32.const -1)))
      (br $l)
    )
    (unreachable)
  )

  (func $sum-first (export "sum-first") (param $n i32) (param $k (ref $cont)) (result i32)
    (local $sum i32)
    (loop $l
      (block $on_yield (result i32 (ref $cont))
        (if (local.get $n)
          (then (resume $cont (tag $yield $on_yield) (local.get $k)))
        )
        (return (local.get $sum))
      ) ;;   $on_yield (result i32 (ref $cont))
      (local.set $k)
      (local.set $sum (i32.add (local.get $sum)))
      (local.set $n (i32.add (local.get $n) (i32.const -1)))
      (br $l)
    )
    (unreachable)
  )
)
