(component $root
    (core module $MockMemory
        (func $realloc (export "realloc") (param i32 i32 i32 i32) (result i32)
            (i32.const 0)
        )
        (memory $memory (export "memory") 15)
    )
    (core instance $memory (instantiate $MockMemory))
    (import "wasi:io/streams@0.2.0" (instance $wasi:io/streams@0.2.0
        (export $std::io::InputStream "input-stream" (type (sub resource)))
        (export $std::io::OutputStream "output-stream" (type (sub resource)))
    ))
    (alias export $wasi:io/streams@0.2.0 "input-stream" (type $std::io::InputStream))
    (alias export $wasi:io/streams@0.2.0 "output-stream" (type $std::io::OutputStream))
    (import "wasi:io/error@0.2.0" (instance $wasi:io/error@0.2.0
        (export $std::io::IoError "error" (type (sub resource)))
    ))
    (alias export $wasi:io/error@0.2.0 "error" (type $std::io::IoError))
    (import "w:unstable/printer" (instance $w:unstable/printer
        (export "print-i32" (func
            (param "value" s32)
        ))
        (export "print-u32" (func
            (param "value" u32)
        ))
    ))
    (alias export $w:unstable/printer "print-i32" (func $print_i32))
    (alias export $w:unstable/printer "print-u32" (func $print_u32))
    (core func $print_i32 (canon lower
        (func $w:unstable/printer "print-i32")
        (memory $memory "memory")(realloc (func $memory "realloc"))
        string-encoding=utf8
    ))
    (core func $print_u32 (canon lower
        (func $w:unstable/printer "print-u32")
        (memory $memory "memory")(realloc (func $memory "realloc"))
        string-encoding=utf8
    ))
    (core module $Main
        (import "w:unstable/printer" "print-i32" (func $print_i32 (param $value i32)))
        (import "w:unstable/printer" "print-u32" (func $print_u32 (param $value i32)))
        (tag $e0)
        (tag $yield (param i32))
        (type $func (func))
        (type $cont (cont $func))
        ;; naturals() -> Generator<i32, Return=()>
        (func $naturals (export "naturals")
            (local $n i32)
            (loop $l
                ;; print(n)
                (call $print_i32 (local.get $n))
                ;; yield n
                (suspend $yield (local.get $n))
                ;; n += 1
                (local.set $n (i32.add (local.get $n) (i32.const 1)))
                ;; continue
                (br $l)
            )
        )
        (func $main
            (local $G (ref $cont))
            (local $n i32)
            (local.set $G (cont.new $cont (ref.func $naturals)))
            (local.get $G)
            drop
            (block $on_yield
                (result i32 (ref $cont))
                (resume $cont
                    (tag $yield $on_yield)
                        (local.get $n)
                        (local.get $G)
                )
                (local.set $n)
                (local.get $n)
                (local.get $G)
            )
            drop drop
        )
        (start $main)
    )
    (core instance $main (instantiate $Main
        (with "w:unstable/printer" (instance
            (export "print-i32" (func $print_i32))
            (export "print-u32" (func $print_u32))
        ))
    ))
)