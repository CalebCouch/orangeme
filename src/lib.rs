//  use rust_on_rails::prelude::*;
//  use rust_on_rails::prelude::Text as BasicText;

//  pub struct Text(&'static str, &'static str, u32, Handle);

//  impl ComponentBuilder for Text {
//      fn build_children(&self, ctx: &mut ComponentContext, max_size: Vec2) -> Vec<Box<dyn Drawable>> {
//          vec![Box::new(
//              BasicText(self.0, self.1, self.2, (self.2 as f32*1.25) as u32, self.3.clone())
//                  .build(ctx, Rect::new(0, 0, max_size.x, max_size.y))
//          )]
//      }
//  }

//  pub struct Column(pub Vec<Box<dyn ComponentBuilder>>, pub u32);

//  impl ComponentBuilder for Column {
//      fn build_children(&self, ctx: &mut ComponentContext, max_size: Vec2) -> Vec<Box<dyn Drawable>> {
//          let mut bound = Rect::new(0, 0, max_size.x, max_size.y);
//          self.0.iter().map(|builder| {
//              let child = builder.build(ctx, bound);
//              let height = child.size(ctx).y;
//              bound.h -= height;
//              bound.y += self.1 + height;
//              Box::new(child) as Box<dyn Drawable>
//          }).collect()
//      }
//  }

//  #[macro_export]
//  macro_rules! Column {
//      ($x:literal, $($i:expr),*) => {{
//          Column(vec![
//              $(Box::new($i) as Box<dyn ComponentBuilder>),*
//          ], $x)
//      }}
//  }


//  pub struct MyApp {
//      font: Handle,
//      root: Column
//  }

//  impl App for MyApp {
//      async fn new(ctx: &mut Context<'_>) -> Self {
//          ctx.include_assets(include_assets!("./assets"));
//          let font = ctx.load_font("fonts/outfit_bold.ttf").unwrap();
//          MyApp{
//              font: font.clone(),
//              root: Column!(20,
//                  Text("HELLO", "eb343a", 48, font.clone()),
//                  Text("WORLD", "eb343a", 48, font.clone())
//              )
//          }
//      }

//      async fn get(&self, ctx: &mut Context<'_>, width: u32, height: u32) -> &dyn ComponentBuilder {
//          &self.root
//      }
//  }

//  create_entry_points!(MyApp);


use rust_on_rails::prelude::*;

pub struct MyApp{
    items: Vec<CanvasItem>,
    font: FontKey,
}

impl CanvasAppTrait for MyApp {
    async fn new(ctx: &mut Context) -> Self {
        let font = include_bytes!("../assets/fonts/outfit_bold.ttf");
        let key = ctx.assets().add_font(font.to_vec());
        MyApp{
            items: vec![
                CanvasItem(
                    ItemType::Shape(Shape::Rectangle(100, 100), "eb343a", None),
                    (100, 400), None
                ),
            ],
            font: key,
        }
    }

    async fn draw(&mut self, ctx: &mut Context) {
        ctx.clear("ffffff");
        let delta = self.items.get_mut(0).unwrap().1.1;
        self.items.get_mut(0).unwrap().1.1 = (delta+1) % 1000;
        self.items.iter().for_each(|c| ctx.draw(c.clone()));
      //ctx.draw(
      //    ItemType::Text(Text::new("HELLO_WORLD", "eb343a", None, 48, 60, self.font)),
      //    (100, 200), (0, 0, 180, 300)
      //);
      //ctx.draw(
      //    ItemType::Shape(Shape::Rectangle(width, 48), "eb343a", None),
      //    (0, height-48), (0, 0, width, height)
      //)
    }

    fn on_click(&mut self, x: u32, y: u32) {
        self.items.push(CanvasItem(
            ItemType::Shape(Shape::Rectangle(20, 20), ((x%9).to_string()+"000ff").leak(), None),
            (x.max(10)-10, y.max(10)-10), None
        ));
    }

    fn on_move(&mut self, x: u32, y: u32) {
        self.items.push(CanvasItem(
            ItemType::Shape(Shape::Rectangle(20, 20), "ff0000", None),
            (x.max(10)-10, y.max(10)-10), None
        ));
    }

    fn on_press(&mut self, t: String) {

    }
}

create_canvas_entry_points!(MyApp);
