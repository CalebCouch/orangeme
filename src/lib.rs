use rust_on_rails::prelude::*;
use rust_on_rails::prelude::Text as BasicText;

pub struct Text(pub BasicText);
impl Text {
    pub fn new(text: &'static str, color: &'static str, size: u32, font: Handle) -> Self {
        Text(BasicText(text, color, size, (size as f32*1.25) as u32, font))
    }
}

impl ComponentBuilder for Text {
    fn build_children(&self, ctx: &mut ComponentContext, max_size: Vec2) -> Vec<Box<dyn Drawable>> {
        self.0.build_children(ctx, max_size)
    }

    fn on_click(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
        self.0.0 = ("T".to_string()+self.0.0).leak()
    }

    fn on_move(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
    }
}


pub struct Column(pub Vec<Box<dyn ComponentBuilder>>, pub u32);

#[macro_export]
macro_rules! Column {
    ($x:literal, $($i:expr),*) => {{
        Column(vec![
            $(Box::new($i) as Box<dyn ComponentBuilder>),*
        ], $x)
    }}
}

impl ComponentBuilder for Column {
    fn build_children(&self, ctx: &mut ComponentContext, max_size: Vec2) -> Vec<Box<dyn Drawable>> {
        let mut bound = Rect::new(0, 0, max_size.x, max_size.y);
        self.0.iter().map(|builder| {
            let child = builder.build(ctx, bound);
            let height = child.size(ctx).y;
            bound.h -= self.1 + height;
            bound.y += self.1 + height;
            Box::new(child) as Box<dyn Drawable>
        }).collect()
    }

    fn on_click(&mut self, ctx: &mut ComponentContext, max_size: Vec2, position: Vec2) {
        let mut bound = Rect::new(0, 0, max_size.x, max_size.y);
        for builder in &mut self.0 {
            let child = builder.build(ctx, bound);
            let size = child.size(ctx);
            if size.x > position.x && bound.y+size.y > position.y {
                builder.on_click(
                    ctx,
                    Vec2::new(max_size.x, bound.y+self.1),
                    Vec2::new(max_size.x, position.y-bound.y)
                );
                break;
            }
            if bound.y+size.y+self.1 > position.y {
                break;//Clicked to the side or inbetween objects
            }
            bound.h -= self.1 + size.y;
            bound.y += self.1 + size.y;
        }
    }

    fn on_move(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
    }
}

pub struct FText(Text, Handle);
impl FText {
    pub fn new(text: &'static str, color: &'static str, size: u32, font: Handle, ofont: Handle) -> Self {
        FText(Text::new(text, color, size, font), ofont)
    }
}

impl ComponentBuilder for FText {
    fn build_children(&self, ctx: &mut ComponentContext, max_size: Vec2) -> Vec<Box<dyn Drawable>> {
        self.0.build_children(ctx, max_size)//Pipe children
    }

    fn on_click(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
        let ohandle = self.0.0.4.clone();
        self.0.0.4 = self.1.clone();
        self.1 = ohandle;
    }


    fn on_move(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
    }
}

pub struct FShape(Shape);
impl FShape {
    pub fn new(shape: ShapeType, color: &'static str, stroke_width: Option<u16>) -> Self {
        FShape(Shape(shape, color, stroke_width))
    }
}

impl ComponentBuilder for FShape {
    fn build_children(&self, ctx: &mut ComponentContext, max_size: Vec2) -> Vec<Box<dyn Drawable>> {
        self.0.build_children(ctx, max_size)//Pipe children
    }

    fn on_click(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
        if self.0.1 == "ff0000" {self.0.1 = "00ff00"}
        else if self.0.1 == "00ff00" {self.0.1 = "0000ff"}
        else {self.0.1 = "ff0000"}
    }


    fn on_move(&mut self, _ctx: &mut ComponentContext, _max_size: Vec2, _position: Vec2) {
    }
}


pub struct MyApp;

impl App for MyApp {
    async fn new(ctx: &mut Context<'_>) -> Box<dyn ComponentBuilder> {
        ctx.include_assets(include_assets!("./assets"));
        let font = ctx.load_font("fonts/outfit_bold.ttf").unwrap();
        let ofont = ctx.load_font("fonts/outfit_regular.ttf").unwrap();
        let image = ctx.load_image("icons/pfp.png").unwrap();
        Box::new(Column!(20,
            Text::new("HELLO", "eb343a", 48, font.clone()),
            FText::new("WORLD", "eb343a", 48, font, ofont),
            FShape::new(ShapeType::Rectangle(100, 100), "00ff00", None),
            FShape::new(ShapeType::Rectangle(100, 100), "00ff00", Some(500)),
            Image(ShapeType::Rectangle(100, 100), image)
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
