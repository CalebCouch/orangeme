use rust_on_rails2::*;

pub struct MyApp {}

impl App for MyApp {
    const LOG_LEVEL: LogLevel = LogLevel::Info;

    async fn new() -> Self {
    //  let fonts = HashMap::from([("bold".to_string(), include_bytes!("../assets/outfit_bold.ttf").to_vec())]);
        MyApp{}
    }

    async fn draw(&mut self) -> Vec<Mesh> {
        vec![Mesh{
            shape: Shape::Rectangle(100, 100),
            offset: (100, 100)
        }]
    }
}

create_entry_points!(CanvasApp::<MyApp>);
