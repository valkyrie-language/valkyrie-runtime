pub struct NyarExtension {}

impl crate::w::unstable::printer::Host for NyarExtension {
    fn print_i8(&mut self, value: i8) -> () {
        println!("{}", value);
    }

    fn print_i16(&mut self, value: i16) -> () {
        println!("{}", value);
    }

    fn print_i32(&mut self, value: i32) -> () {
        println!("{}", value);
    }

    fn print_i64(&mut self, value: i64) -> () {
        println!("{}", value);
    }

    fn print_u8(&mut self, value: u8) -> () {
        println!("{}", value);
    }

    fn print_u16(&mut self, value: u16) -> () {
        println!("{}", value);
    }

    fn print_u32(&mut self, value: u32) -> () {
        println!("{}", value);
    }

    fn print_u64(&mut self, value: u64) -> () {
        println!("{}", value);
    }

    fn print_f32(&mut self, value: f32) -> () {
        println!("{}", value);
    }

    fn print_f64(&mut self, value: f64) -> () {
        println!("{}", value);
    }

    fn print_char(&mut self, value: char) -> () {
        println!("{}", value);
    }

    fn print_str(&mut self, value: String) -> () {
        println!("{}", value);
    }
}
