use rust_on_rails::prelude::*;
//use pelican_ui::prelude::*;

//  #[derive(Clone)]
//  pub struct Column(pub u32, pub Vec<Box<dyn Component>>);

//  impl Component for Column {
//      fn build(&self, ctx: &mut Context, mut max_size: (u32, u32)) -> Vec<((u32, u32), Box<dyn Component>)> {
//          let mut offset = 0;
//          self.1.iter().map(|c| {
//              let size = c.size(ctx, (max_size.0, max_size.1-offset));
//              let v = ((0, offset), c.clone());
//              offset += size.1+self.0;
//              v
//          }).collect()
//      }

//      fn on_click(&mut self, ctx: &mut Context, max_size: (u32, u32), position: (u32, u32)) {
//          let mut offset = 0;
//          for c in &mut self.1 {
//              let size = c.size(ctx, (max_size.0, max_size.1-offset));
//              if size.0 > position.0 && offset+size.1 > position.1 {
//                  c.on_click(
//                      ctx,
//                      (max_size.0, offset+self.0),
//                      (position.0, position.1-offset)
//                  );
//                  return;
//              }
//              if offset+size.1+self.0 > position.1 {
//                  return;
//              }
//              offset += self.0 + size.1;
//          }
//      }
//  }

#[derive(Clone)]
pub struct MyCom{
    font: resources::Font
}

impl Component for MyCom {
    fn build(&self, ctx: &mut Context, max_size: (u32, u32)) -> Container {
        let text = Text("HELLO WORLD HEL", Color::from_hex("eb343a", 255), 48, 60, self.font.clone());
        container!(Offset::BottomRight, Size::Expand, [
            container!(Offset::default(), Size::Static(1000, 200), [
                Shape(ShapeType::Rectangle(0), Color(0, 0, 255, 255))
            ]),
            text
        ])

        
      //container!(Offset::BottomRight, Size::Expand, [
      //    Shape(ShapeType::Rectangle(0), Color(0, 0, 255, 255)).size(Size::Static(1000, 200))
      //    text
      //])

      //vec![Box::new(Container(Offset::BottomCenter, Size::Static(500, 200),
      //    vec![
      //        Box::new(Shape(ShapeType::Rectangle(0), Color(0, 0, 255, 255))) as Box<dyn Component>,
      //        Box::new(text) as Box<dyn Component>,
      //    ]
      //))]
    }

    fn on_click(&mut self, ctx: &mut Context, max_size: (u32, u32), position: (u32, u32)) {
        println!("MyCom: {:?}", position);
    }
}

pub struct MyApp;

impl App for MyApp {
    async fn new(ctx: &mut Context<'_>) -> Box<dyn Component> {
        //PelicanContext.init(ctx);
        println!("START APP");

        let font = resources::Font::new(ctx, include_bytes!("../assets/fonts/outfit_bold.ttf").to_vec());
      //let image = resources::Image::new(ctx, image::load_from_memory(include_bytes!("../assets/icons/pfp3.png")).unwrap().into());
      //let svg = resources::Image::svg(ctx, include_bytes!("../assets/icons/qr_code.svg"), 8.0);



      //Box::new(Column(50, vec![
      //    //Some(Text("HELLO WORLD HEL", Color::from_hex("eb343a", 255), 48, 60, font.clone())).into(),
            //Box::new(None::<Text>)
        Box::new(MyCom{font})
      //]))
        //Box::new(Icon::new(ctx, IconName::Door, "ffffff", 48))
    }
}

create_entry_points!(MyApp);
