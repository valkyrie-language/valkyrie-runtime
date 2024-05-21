

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


yield T


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
    (local $gen1 i32)
    (cont.new $cont (ref.func $naturals)))
)
```


yield with
yield break with
yield from with




