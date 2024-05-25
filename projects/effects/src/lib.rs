#![feature(coroutines)]

use reffect::{effect::EffectList, *};
use util::Sum;

// 使用结构体来表示effect，而非之前的trait。
struct Log(String);
impl Effect for Log {
    type Resume = ();
}

struct Increment(u32);

impl Effect for Increment {
    type Resume = u32;
}

// 分列effects和普通参数。
#[effectful(Log)]
fn log_value<T: std::fmt::Debug>(value: T) -> T {
    yield Log(format!("{:?}", value));
    value
}

#[effectful(Increment)]
fn increment(value: u32) -> u32 {
    yield Increment(value)
}

#[effectful(Log, Increment)]
fn test_func() -> u32 {
    // 和异步系统一样的await表达式来转发effects。
    let value = log_value(1).await;
    let value = increment(value).await;
    log_value(value).await;
    value
}

#[test]
fn test() {
    // 使用链式调用来处理各种effects。
    let ret = test_func().handle(handler! {
        Log(s) => println!("{s}"),
        Increment(i) if i < 10 => i + 1,
        Increment(i) => break i,
    });

    // 非传染地直接运行，从类型系统保证了处理过的函数不再包含代数效应。
    assert_eq!(ret.run(), 2);
}
