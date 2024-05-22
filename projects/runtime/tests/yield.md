

```vk
function naturals() {
    let n: i32 = 0;
    loop {
        yield n
        n = n + 1;
        continue
    }
}
let gen1 = naturals()
gen1()
```


(ref $cont) = Generator<Item=i32>

```wat
(type $func (func))
(type $cont (cont $func))
(tag $yield (param i32))
(func $naturals 
    (export "naturals")
    (local $n i32)
    (loop $l
        (suspend $yield (local.get $n))
        (local.set $n (i32.add (local.get $n) (i32.const 1)))
        (br $l)
    )
)
(func $main
    (cont.new $cont (ref.func $naturals)))
)
```


yield with
yield break with
yield from with


```vk
loop {
    if next_k == null { 
        return
    }
    catch next_k() {
        Yield() => {
            resume ^next_k enqueue()
            continue
        }
        Fork() => {
            resume ^next_k dequeue()
            continue
        }
    }
}
```

```wat
(func $sync (export "sync") (param $nextk (ref null $cont))
    (loop $l
      (if (ref.is_null (local.get $nextk)) (then (return)))
      (block $on_yield (result (ref $cont))
        (block $on_fork (result (ref $cont) (ref $cont))
          (resume $cont (tag $yield $on_yield)
                        (tag $fork $on_fork)
                        (local.get $nextk)
          )
          (local.set $nextk (call $dequeue))
          (br $l)  ;; thread terminated
        ) ;;   $on_fork (result (ref $cont) (ref $cont))
        (local.set $nextk)                      ;; current thread
        (call $enqueue) ;; new thread
        (br $l)
      )
      ;;     $on_yield (result (ref $cont))
      (local.set $nextk)  ;; carry on with current thread
      (br $l)
    )
)
```
