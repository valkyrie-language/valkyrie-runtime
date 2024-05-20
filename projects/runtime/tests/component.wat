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
        (rec
            (type $Point2D^psyche (sub (struct
                (field $x_get funcref)
                (field $y_get funcref)
            )))
            (type $Point2D^physis (struct
                (field $_x i32)
                (field $_y i32)
            ))
            (type $Point2D^physic (sub $Point2D^psyche (struct
                (field $x_get funcref)
                (field $y_get funcref)
                (field $_x i32)
                (field $_y i32)
            )))
            ;; Point3D <: Point2D
            (type $Point3D^psyche (sub $Point2D^psyche (struct
                (field $x_get funcref)
                (field $y_get funcref)
                (field $z_get funcref)
            )))
        )
        ;; 假设我们有两个获取 x 和 y 的函数
        (func $x_get_mock
            (result i32)
            ;; 函数体省略，假设返回某个 i32 值
            i32.const 42
        )
        (func $y_get_mock
            (result i32)
            ;; 函数体省略，假设返回某个 i32 值
            i32.const 24
        )
        ;; 导出函数创建 $Point2D^physic 实例
        (func
            (result anyref)
;;             获取函数引用
;;            ref.func $x_get_mock
;;            ref.func $y_get_mock
;;             初始化 i32 字段值
            i32.const 10  ;; $_x
            i32.const 20  ;; $_y
;;             创建 $Point2D^physic 实例
            struct.new $Point2D^physis
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