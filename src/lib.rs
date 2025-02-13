use pelican_ui::prelude::*;

pub struct MyApp;

impl App for MyApp {
    async fn new(ctx: &mut Context<'_>) -> Box<dyn ComponentBuilder> {
        ctx.include_assets(include_assets!("./assets"));
        let font = ctx.load_font("fonts/outfit_bold.ttf").unwrap();
        let ofont = ctx.load_font("fonts/outfit_regular.ttf").unwrap();
        let image = ctx.load_image("icons/pfp.png").unwrap();
        Box::new(Column!(20,
            // Text::new("HELLO", "eb343a", 48, font.clone()),
            // FText::new("WORLD", "eb343a", 48, font, ofont),
            // FShape::new(ShapeType::Rectangle(100, 100), "00ff00", None),
            // FShape::new(ShapeType::Rectangle(100, 100), "00ff00", Some(500)),
            Image(ShapeType::Rectangle(8, 8), image),
            Button::primary("Continue", Size::Large, Width::Expand),
            Row!(32, Button::secondary("Continue", Size::Medium, Width::Hug),
            Button::primary("Continue", Size::Large, Width::Hug))
            // Stack!(Button::primary("Continue", Size::Large), Button::secondary("Continue", Size::Medium))
        ))
    }
}

create_entry_points!(MyApp);

//  use rust_on_rails::prelude::*;

//  pub struct MyApp{
//      items: Vec<CanvasItem>,
//      font: FontKey,
//      x: u32,
//      y: u32
//  }

//  impl CanvasAppTrait for MyApp {
//      async fn new(ctx: &mut Context) -> Self {
//          let font = include_bytes!("../assets/fonts/outfit_bold.ttf");
//          let key = ctx.atlas.add_font(font.to_vec());
//          MyApp{
//              items: vec![
//                  CanvasItem(
//                      ItemType::Shape(Shape::Rectangle(100, 100), "eb343a", None),
//                      (100, 400), None
//                  ),
//              ],
//              font: key,
//              x: 0,
//              y: 0
//          }
//      }

//      async fn draw(&mut self, ctx: &mut Context) {
//          ctx.clear("ffffff");
//          let delta = self.items.get_mut(0).unwrap().1.1;
//          self.items.get_mut(0).unwrap().1.1 = (delta+1) % 1000;
//          self.items.iter().for_each(|c| ctx.draw(c.clone()));
//      }

//      async fn on_click(&mut self, _ctx: &mut Context) {
//          self.items.push(CanvasItem(
//              ItemType::Shape(
//                //Shape::Draw(20, 0, vec![
//                //    DrawCommand::LineTo(100, 0),
//                //    DrawCommand::LineTo(100, 100),
//                //    DrawCommand::LineTo(0, 100),
//                //    DrawCommand::LineTo(0, 20),
//                //    DrawCommand::QuadraticBezierTo(20, 0, 0, 0),
//                //]), ((self.x%9).to_string()+"000ff").leak(), Some(500)
//                Shape::Circle(40), ((self.x%9).to_string()+"000ff").leak(), None
//              ),
//              (self.x.max(40)-40, self.y.max(40)-40), None
//          ));
//      }

//      async fn on_move(&mut self, ctx: &mut Context) {
//          self.x = ctx.position.0;
//          self.y = ctx.position.1;
//          self.on_click(ctx).await;
//        //self.items.push(CanvasItem(
//        //    ItemType::Shape(Shape::Rectangle(20, 20), "ff0000", None),
//        //    (x.max(10)-10, y.max(10)-10), None
//        //));
//      }

//      async fn on_press(&mut self, _ctx: &mut Context, t: String) {
//          self.items.push(CanvasItem(
//              ItemType::Text(
//                  Text::new(t.leak(), ((self.x%9).to_string()+"000ff").leak(), None, 48, 60, self.font)
//              ),
//              (self.x.max(20)-20, self.y.max(30)-30), None
//          ));
//      }
//  }

//  create_canvas_entry_points!(MyApp);
