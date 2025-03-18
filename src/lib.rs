use rust_on_rails::prelude::*;

pub struct MyApp{
    items: Vec<(Area, CanvasItem)>,
    //font: Font
}

impl App for MyApp {
    async fn new(ctx: &mut Context) -> Self {
        println!("START APP");

        let font = Font::new(ctx, include_bytes!("../assets/fonts/outfit_bold.ttf").to_vec());
        let image = Image::new(ctx, image::load_from_memory(include_bytes!("../assets/icons/pfp3.png")).unwrap().into());
        let svg = Image::svg(ctx, include_bytes!("../assets/icons/qr_code.svg"), 8.0);

        let text = CanvasItem::Text(Text::new("HELLO WORLD", Color::from_hex("eb343a", 255), None, 48, 60, font.clone()));
        //let shape = CanvasItem::Shape(Shape::Ellipse(0, (200, 100)), "ff00bb", 255);
        //let rectangle = CanvasItem::Image(Shape::Rectangle(0, (1000, 1000)), image.clone());
      //let circle = CanvasItem::Shape(Shape::Ellipse(2, (100, 100)), "ff00ff", 255);
      //let circle2 = CanvasItem::Shape(Shape::Rectangle(4, (200, 100)), "00ff00", 255);
      //let circle3 = CanvasItem::Shape(Shape::RoundedRectangle(2, (200, 400), 0), "ffffff", 128);
      //let circle4 = CanvasItem::Shape(Shape::RoundedRectangle(20, (200, 400), 5), "ff0000", 200);

        //items.push((Area((0, 0), None), text));
        //items.push((Area((200, 200), None), shape));
        //items.push((Area((0, 0), None), rectangle));
      //items.push((Area((210, 500), Some((200, 500, 100, 100))), circle));
      //items.push((Area((5, 300), None), circle2));
      //items.push((Area((5, 500), None), circle3));
      //items.push((Area((500, 500), None), circle4));

        MyApp{
            items: vec![
                (Area((300, 300), None), text),
                (Area((300, 0), None), CanvasItem::Image(Shape::RoundedRectangle(0, (100, 100), 50), image, None)),
                //(Area((300, 0), None), CanvasItem::Shape(Shape::RoundedRectangle(0, (100, 100), 50), Color::from_hex("000000", 255))),
                (Area((300, 0), None), CanvasItem::Image(Shape::RoundedRectangle(0, (100, 100), 50), svg, Some(Color::from_hex("eb343a", 255)))),
                (Area((0, 0), None), CanvasItem::Shape(Shape::RoundedRectangle(0, (200, 100), 20), Color::from_hex("ffabe3", 255)))
            ],
            //font
        }
    }

    async fn on_tick(&mut self, ctx: &mut Context) {
        ctx.clear(Color::from_hex("ffffff", 255));
      //let delta = self.items.get_mut(0).unwrap().area().0.1;
      //self.items.get_mut(0).unwrap().area().0.1 = (delta+1) % 1000;
        self.items.iter().for_each(|(area, c)| ctx.draw(*area, c.clone()));
    }

    async fn on_click(&mut self, ctx: &mut Context) {
      //self.items.push(CanvasItem::Shape(
      //    Area((ctx.position.0.max(20)-20, ctx.position.1.max(20)-20), None),
      //    Shape::RoundedRectangle(10, (80, 40), 20),
      //    ((ctx.position.0%9).to_string()+"000ff").leak(), 255
      //));
    }

    async fn on_move(&mut self, ctx: &mut Context) {
      //self.items.push(CanvasItem::Shape(
      //    Area((ctx.position.0.max(10)-10, ctx.position.1.max(10)-10), None),
      //    Shape::Ellipse(0, (20, 20)),
      //    "ff0000", 255
      //));
    }

    async fn on_press(&mut self, ctx: &mut Context, t: String) {
      //self.items.push(CanvasItem::Text(
      //    Area((ctx.position.0, ctx.position.1), None),
      //    Text::new(t.leak(), "eb343a", 255, None, 48, 60, self.font.clone())
      //));
    }
}

create_entry_points!(MyApp);

//  use rust_on_rails::prelude::*;
//  use rust_on_rails::prelude::Text as BasicText;

//  pub struct Text(pub BasicText);
//  impl Text {
//      pub fn new(text: &'static str, color: &'static str, size: u32, font: Handle) -> Self {
//          Text(BasicText(text, color, size, (size as f32*1.25) as u32, font))
//      }
//  }

//  impl ComponentBuilder for Text {
//      fn build_children(&self, ctx: &mut ComponentContext, max_size: Vec2) -> Vec<Box<dyn Drawable>> {
//          self.0.build_children(ctx, max_size)
//      }

//      fn on_click(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
//          self.0.0 = ("T".to_string()+self.0.0).leak()
//      }

//      fn on_move(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
//      }
//  }


//  pub struct Column(pub Vec<Box<dyn ComponentBuilder>>, pub u32);

//  #[macro_export]
//  macro_rules! Column {
//      ($x:literal, $($i:expr),*) => {{
//          Column(vec![
//              $(Box::new($i) as Box<dyn ComponentBuilder>),*
//          ], $x)
//      }}
//  }

//  impl ComponentBuilder for Column {
//      fn build_children(&self, ctx: &mut ComponentContext, max_size: Vec2) -> Vec<Box<dyn Drawable>> {
//          let mut bound = Rect::new(0, 0, max_size.x, max_size.y);
//          self.0.iter().map(|builder| {
//              let child = builder.build(ctx, bound);
//              let height = child.size(ctx).y;
//              bound.h -= self.1 + height;
//              bound.y += self.1 + height;
//              Box::new(child) as Box<dyn Drawable>
//          }).collect()
//      }

//      fn on_click(&mut self, ctx: &mut ComponentContext, max_size: Vec2, position: Vec2) {
//          let mut bound = Rect::new(0, 0, max_size.x, max_size.y);
//          for builder in &mut self.0 {
//              let child = builder.build(ctx, bound);
//              let size = child.size(ctx);
//              if size.x > position.x && bound.y+size.y > position.y {
//                  builder.on_click(
//                      ctx,
//                      Vec2::new(max_size.x, bound.y+self.1),
//                      Vec2::new(max_size.x, position.y-bound.y)
//                  );
//                  break;
//              }
//              if bound.y+size.y+self.1 > position.y {
//                  break;//Clicked to the side or inbetween objects
//              }
//              bound.h -= self.1 + size.y;
//              bound.y += self.1 + size.y;
//          }
//      }

//      fn on_move(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
//      }
//  }

//  pub struct FText(Text, Handle);
//  impl FText {
//      pub fn new(text: &'static str, color: &'static str, size: u32, font: Handle, ofont: Handle) -> Self {
//          FText(Text::new(text, color, size, font), ofont)
//      }
//  }

//  impl ComponentBuilder for FText {
//      fn build_children(&self, ctx: &mut ComponentContext, max_size: Vec2) -> Vec<Box<dyn Drawable>> {
//          self.0.build_children(ctx, max_size)//Pipe children
//      }

//      fn on_click(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
//          let ohandle = self.0.0.4.clone();
//          self.0.0.4 = self.1.clone();
//          self.1 = ohandle;
//      }


//      fn on_move(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
//      }
//  }

//  pub struct FShape(Shape);
//  impl FShape {
//      pub fn new(shape: ShapeType, color: &'static str, stroke_width: Option<u16>) -> Self {
//          FShape(Shape(shape, color, stroke_width))
//      }
//  }

//  impl ComponentBuilder for FShape {
//      fn build_children(&self, ctx: &mut ComponentContext, max_size: Vec2) -> Vec<Box<dyn Drawable>> {
//          self.0.build_children(ctx, max_size)//Pipe children
//      }

//      fn on_click(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
//          if self.0.1 == "ff0000" {self.0.1 = "00ff00"}
//          else if self.0.1 == "00ff00" {self.0.1 = "0000ff"}
//          else {self.0.1 = "ff0000"}
//      }


//      fn on_move(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
//      }
//  }


//  pub struct MyApp;

//  impl App for MyApp {
//      async fn new(ctx: &mut Context<'_>) -> Box<dyn ComponentBuilder> {
//          ctx.include_assets(include_assets!("./assets"));
//          let font = ctx.load_font("fonts/outfit_bold.ttf").unwrap();
//          let ofont = ctx.load_font("fonts/outfit_regular.ttf").unwrap();
//          let image = ctx.load_image("icons/pfp.png").unwrap();
//          Box::new(Column!(20,
//              Text::new("HELLO", "eb343a", 48, font.clone()),
//              FText::new("WORLD", "eb343a", 48, font, ofont),
//              FShape::new(ShapeType::Rectangle(100, 100), "00ff00", None),
//              FShape::new(ShapeType::Circle(50), "00ff00", None),
//              Image(ShapeType::Rectangle(100, 100), image)
//          ))
//      }
//  }

//  create_entry_points!(MyApp);
