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
;;        (type $i32-i32 (func (param i32) (result i32)))
        (import "w:unstable/printer" "print-i32" (func $print_i32 (param $value i32)))
        (import "w:unstable/printer" "print-u32" (func $print_u32 (param $value i32)))
        (rec
            (type $Point2D::Psyche (sub (struct
                (field $constructor funcref)
                (field $x-getter funcref)
                (field $x-setter funcref)
            )))
        )


        (table funcref (elem
;;            $constructor
;;            $get_x
;;            $set_x
        ))
;; static A.INITIALIZED
        (global $A.INITIALIZED (mut i32) (i32.const 0))
        (func $A.INITIALIZED
            (if (global.get $A.INITIALIZED)
                (then return)
                (else
                    (global.set $A.INITIALIZED (i32.const 1))
                    ;; 单例初始化逻辑
                )
            )
        )
        (func $A.Deitialize
            (if (global.get $A.INITIALIZED)
                (then
                    (global.set $A.INITIALIZED (i32.const 1))
                    ;; 单例反初始化逻辑
                )
                (else return)
            )
        )


        (func $auto_drop
            (result i32 i32)
            i32.const 1
            call $print_i32
            i32.const 0
            i32.const 0
            i32.const 0
            drop
        )
        (func $main
            i32.const 1
            call $print_i32
            i32.const 0
            i32.const 0
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