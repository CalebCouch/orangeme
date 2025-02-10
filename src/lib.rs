//use rust_on_rails::prelude::*;

//  pub struct MyApp;

//  impl App for MyApp {
//      async fn new() -> Self {
//          MyApp
//      }

//      async fn root(
//          &mut self, ctx: &Context, canvas_ctx: &mut CanvasContext<'_>, width: u32, height: u32
//      ) -> Box<dyn ComponentBuilder> {
//          Box::new(Column(vec![
//              Box::new(Text(
//                  "HELLO", "outfit_bold.ttf", "eb343a", 48, 60,
//              )),
//              Box::new(Text(
//                  "WORLD", "outfit_bold.ttf", "eb343a", 48, 60,
//              ))
//          ], 20))
//      }
//  }

//  create_entry_points!(MyApp);

use rust_on_rails::*;

pub struct MyApp;

impl CanvasAppTrait for MyApp {
    async fn new() -> Self {
        MyApp
    }

    async fn draw<'a: 'b, 'b>(&'a mut self, ctx: &'b mut CanvasAtlas, width: u32, height: u32) -> Vec<CanvasItem> {
        let font = include_bytes!("../assets/fonts/outfit_bold.ttf");
        let key = ctx.add_font(font.to_vec());
        vec![
            CanvasItem(
                ItemType::Shape(Shape::Rectangle(100, 100), "eb343a", None),
                1, (100, 100), (0, 0, 180, 200)
            ),
            CanvasItem(
                ItemType::Text(Text::new("HELLO_WORLD", "eb343a", None, 48, 60, key)),
                0, (100, 200), (0, 0, 180, 300)
            )
        ]
    }
}

create_canvas_entry_points!(MyApp);
