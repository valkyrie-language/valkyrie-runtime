

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


function naturals(): Generator<Item=i32> {
    let mut n: i32 = 0;
    loop {
        yield n;
        n += 1;
        continue
    }
}
function main() {
    let g = naturals();
    print_i32(g())
}
```





How to support downcast?



```
    A   B
   / \ / \
  C   D   E
 / \ / \   \
F   G   H   I
```


```
class G {
/*0x00*/ type = G
/*0x01*/ ancestor = [G, C, D, A, B]
/*0x02*/ g()
/*0x03*/ c()
/*0x04*/ d()
/*0x05*/ a()
/*0x06*/ b()
}
class D {
/*0x00*/ type = D
/*0x01*/ ancestor = [D, A, B]
/*0x04*/ d()
/*0x05*/ a()
/*0x06*/ b()
}
```


