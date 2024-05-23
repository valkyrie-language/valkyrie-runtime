(component $App
    (core module $Main
        (type $i32-i32 (func (param i32) (result i32)))

        (func $hof (param $f (ref $i32-i32)) (result i32)
            (i32.add (i32.const 10) (call_ref $i32-i32 (i32.const 42) (local.get $f)))
        )

        (func $inc (param $i i32) (result i32)
            (i32.add (local.get $i) (i32.const 1))
        )

        (func $caller (result i32)
            (call $hof (ref.func $inc))
        )
    )
)
