use rust_on_rails2::*;

pub struct MyApp {}

impl App for MyApp {
    //const LOG_LEVEL: LogLevel = LogLevel::Info;

    async fn new() -> Self {
    //  let fonts = HashMap::from([("bold".to_string(), include_bytes!("../assets/outfit_bold.ttf").to_vec())]);
        MyApp{}
    }

    async fn draw(&mut self, width: u32, height: u32) -> Vec<Mesh> {
        println!("width: {}", width);
        vec![
            Mesh{
                shape: Shape::Rectangle(width-10, height-10),
                offset: (5, 5),
                color: "000000"
            },
          //Mesh{
          //    shape: Shape::RoundedRectangle(100, 100, 100),
          //    offset: (500, 300),
          //    color: "ff0000"
          //},
          //Mesh{
          //    shape: Shape::Rectangle(200, 300),
          //    offset: (400, 500),
          //    color: "0000ff"
          //},
            Mesh{
                shape: Shape::Circle(100),
                offset: (200, 200),
                color: "eb343a"
            },
        ]
    }
}

create_entry_points!(CanvasApp::<MyApp>);
