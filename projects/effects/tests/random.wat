(component $root
    (core module $MockMemory
        (func $realloc (export "realloc") (param i32 i32 i32 i32) (result i32)
            (i32.const 0)
        )
        (memory $memory (export "memory") 15)
    )
    (core instance $memory (instantiate $MockMemory))
    (type $Point (record
        (field "x" float32)
        (field "y" float32)
    ))
    (import "unstable:debugger/print" (instance $unstable:debugger/print
        (alias outer $root $Point (type $Point?)) (export $Point "point" (type (eq $Point?)))
        (export "print-i32" (func
            (param "value" s32)
        ))
        (export "print-u32" (func
            (param "value" u32)
        ))
        (export "print-point" (func
            (param "value" $Point)
        ))
    ))
    (alias export $unstable:debugger/print "print-i32" (func $print_i32))
    (alias export $unstable:debugger/print "print-u32" (func $print_u32))
    (alias export $unstable:debugger/print "print-point" (func $test::print_point))
    (core func $print_i32 (canon lower
        (func $unstable:debugger/print "print-i32")
        (memory $memory "memory")(realloc (func $memory "realloc"))
        string-encoding=utf8
    ))
    (core func $print_u32 (canon lower
        (func $unstable:debugger/print "print-u32")
        (memory $memory "memory")(realloc (func $memory "realloc"))
        string-encoding=utf8
    ))
    (core func $test::print_point (canon lower
        (func $unstable:debugger/print "print-point")
        (memory $memory "memory")(realloc (func $memory "realloc"))
        string-encoding=utf8
    ))
    (core module $Main
        (import "unstable:debugger/print" "print-i32" (func $print_i32 (param $value i32)))
        (import "unstable:debugger/print" "print-u32" (func $print_u32 (param $value i32)))
        (func $main
            (call $print_i32 (i32.const 0))
            (i32.const 0)
            (i32.const 0)
            (drop drop)
        )
        (start $main)
    )
    (core instance $main (instantiate $Main
        (with "unstable:debugger/print" (instance
            (export "print-i32" (func $print_i32))
            (export "print-u32" (func $print_u32))
        ))
    ))
)