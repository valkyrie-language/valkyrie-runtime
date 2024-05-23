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
            (type $Point2D::Psyche (sub (struct
                (field $constructor funcref)
                (field $x-getter funcref)
                (field $x-setter funcref)
            )))
            (type $Point2D::Physis (struct
                (field $_x (mut i32))
            ))
            (type $Point2D::Physic (sub $Point2D::Psyche (struct
                (field $constructor funcref)
                (field $x-getter funcref)
                (field $x-setter funcref)
                (field $_x i32)
            )))
            (type $Point2D::Corpus (struct
                (field $psyche (ref $Point2D::Psyche))
                (field $physis (ref $Point2D::Physis))
            ))
        )
;;        (table funcref (elem
;;            $Point2D::Physic::%consturctor
;;            $Point2D::Physic::x%getter
;;            $Point2D::Physic::x%setter
;;
;;            $Point2D::Psyche::%consturctor
;;            $Point2D::Psyche::x%getter
;;            $Point2D::Psyche::x%setter
;;        ))

        (elem declare func
            $Point2D::Physic::%consturctor
            $Point2D::Physic::x%getter
            $Point2D::Physic::x%setter

            $Point2D::Psyche::%consturctor
            $Point2D::Psyche::x%getter
            $Point2D::Psyche::x%setter
        )

        (global $Point2D::Physic::GREEN_FIELD
            (ref $Point2D::Physic)
            ref.func $Point2D::Physic::%consturctor
            ref.func $Point2D::Physic::x%getter
            ref.func $Point2D::Physic::x%setter
            i32.const 0
            struct.new $Point2D::Physic
        )
        (func $Point2D::Physic::%consturctor
            (param $value i32)
            (result (ref $Point2D::Physic))
            (global.get $Point2D::Physic::GREEN_FIELD)
        )
        (func $Point2D::Physic::x%getter
            (param $self (ref $Point2D::Physic))
            (result i32)
            (struct.get $Point2D::Physic $_x (local.get $self))
        )
        (func $Point2D::Physic::x%setter
            (param $self (ref $Point2D::Physic))
            (param $value i32)
            (struct.set $Point2D::Physic $_x (local.get $self))
        )
        ;; 虚表虚方法
        (func $Point2D::Psyche::%consturctor
            (param $value i32)
            (result (ref $Point2D::Psyche))
            local.get $value
            call $Point2D::Physic::%consturctor
            ref.cast (ref $Point2D::Psyche)
        )
        ;; 好像没用, 理论上自动获得这些虚方法
        (func $Point2D::Psyche::x%getter
            (param $self (ref $Point2D::Psyche))
            (result i32)
            ref.cast (ref $Point2D::Physic)
            local.get $self
            call $Point2D::Physic::x%getter
        )
        (func $Point2D::Psyche::x%setter
            (param $self (ref $Point2D::Psyche))
            (param $value i32)
            ref.cast (ref $Point2D::Physic)
            local.get $self
            call $Point2D::Physic::x%setter
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
            i32.const 42
            call $Point2D::Psyche::%consturctor
            call $Point2D::Psyche::x%getter
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