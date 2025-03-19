use rust_on_rails::prelude::*;

pub struct MyApp{
    context: Context,
    items: Vec<(Area, CanvasItem)>,
    mouse: (u32, u32)
    //font: Font
}

impl App for MyApp {
    async fn new(ctx: Context) -> Self {
        println!("START APP");

        let font = Font::new(&ctx, include_bytes!("../assets/fonts/outfit_bold.ttf").to_vec()).await;
        let image = Image::new(&ctx, image::load_from_memory(include_bytes!("../assets/icons/pfp3.png")).unwrap().into()).await;
        let svg = Image::svg(&ctx, include_bytes!("../assets/icons/qr_code.svg"), 8.0).await;

        MyApp{
            context: ctx,
            items: vec![
                (Area((300, 300), None), CanvasItem::Text(Text::new("HELLO WORLD", Color::from_hex("eb343a", 255), None, 48, 60, font))),
                (Area((300, 0), None), CanvasItem::Image(Shape::RoundedRectangle(0, (100, 100), 50), image, None)),
                //(Area((300, 0), None), CanvasItem::Shape(Shape::RoundedRectangle(0, (100, 100), 50), Color::from_hex("000000", 255))),
                (Area((300, 0), None), CanvasItem::Image(Shape::RoundedRectangle(0, (100, 100), 50), svg, Some(Color::from_hex("eb343a", 255)))),
                (Area((0, 0), None), CanvasItem::Shape(Shape::RoundedRectangle(0, (200, 100), 20), Color::from_hex("ffabe3", 255)))
            ],
            mouse: (0, 0)
        }
    }

    async fn on_tick(&mut self, width: u32, height: u32) {
        //ctx.clear(Color::from_hex("ffffff", 255)).await;
      //let delta = self.items.get_mut(0).unwrap().area().0.1;
      //self.items.get_mut(0).unwrap().area().0.1 = (delta+1) % 1000;
      //for (area, c) in &self.items {
      //    ctx.draw(*area, c.clone()).await;
      //}

      //self.context.draw(
      //    Area((0, 0), None),
      //    CanvasItem::Shape(Shape::Rectangle(0, (width, height)),
      //        Color::from_hex("ffffff", 200)
      //    )
      //).await;

    }

    async fn on_click(&mut self) {
        self.context.draw(
            Area((self.mouse.0.max(20)-20, self.mouse.1.max(20)-20), None),
            CanvasItem::Shape(Shape::RoundedRectangle(10, (80, 40), 20),
                Color::from_hex(((self.mouse.0%9).to_string()+"000ff").leak(), 255)
            )
        ).await;
    }

    async fn on_move(&mut self, x: u32, y: u32) {
        self.mouse = (x, y);
        self.context.draw(
            Area((self.mouse.0.max(20)-20, self.mouse.1.max(20)-20), None),
            CanvasItem::Shape(Shape::RoundedRectangle(10, (80, 40), 20),
                Color::from_hex(((self.mouse.0%9).to_string()+"000ff").leak(), 255)
            )
        ).await;
      //self.items.push(CanvasItem::Shape(
      //    Area((ctx.position.0.max(10)-10, ctx.position.1.max(10)-10), None),
      //    Shape::Ellipse(0, (20, 20)),
      //    "ff0000", 255
      //));
    }

    async fn on_press(&mut self, t: String) {
        self.context.clear(Color::from_hex("ffffff", 255)).await;
        for (area, c) in &self.items {
            self.context.draw(*area, c.clone()).await;
        }
      //self.items.push(CanvasItem::Text(
      //    Area((ctx.position.0, ctx.position.1), None),
      //    Text::new(t.leak(), "eb343a", 255, None, 48, 60, self.font.clone())
      //));
    }
}

create_entry_points!(MyApp);
