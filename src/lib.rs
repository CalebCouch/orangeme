use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;
use pelican_ui::custom::*;

// pub struct MyApp{
//     items: Vec<(Area, CanvasItem)>,
//     //font: Font
// }

pub struct MyApp;

impl App for MyApp {
    async fn new(ctx: &mut Context<'_>) -> Box<dyn Component> {
        let mut plugin = PelicanUI::init(ctx);
        // let mut theme = Theme::default(ctx);
        
        // let colors = ColorResources::new(
        //     BackgroundColor::default(),
        //     OutlineColor::default(),
        //     StatusColor::default(),
        //     TextColor::default(),
        //     BrandColor {
        //         primary: Color::from_hex("3598FC", 255),
        //         secondary: Color::from_hex("ffffff", 255)
        //     },
        //     ShadesColor::default()
        // );

        // ctx.include_assets(include_assets!("./assets"));

        // let fonts = FontResources::default(ctx).fonts;
        // let heading = resources::Font::new(ctx, include_bytes!("../assets/fonts/limelight.ttf").to_vec());

        // let fonts = FontResources::new(Fonts::new(heading, fonts.text, fonts.label), FontSize::default());

        // theme.icons.add_icon("toast", resources::Image::svg(ctx, &ctx.load_file("icons/toast.svg").unwrap(), 8.0));
        // theme.icons.set_icon("search", resources::Image::svg(ctx, &ctx.load_file("icons/settings.svg").unwrap(), 8.0));

        // theme.set_colors(colors);
        // theme.set_fonts(fonts);

        // plugin.set_theme(theme);
        ctx.configure_plugin(plugin);

        // println!("START APP");

        // let font = resources::Font::new(ctx, include_bytes!("../assets/fonts/outfit_bold.ttf").to_vec());
        // let image = resources::Image::new(ctx, image::load_from_memory(include_bytes!("../assets/icons/profile.png")).unwrap().into());
        // let svg = resources::Image::svg(ctx, include_bytes!("../assets/icons/qr_code.svg"), 8.0);

        // let theme = &ctx.get::<PelicanUI>().theme;

        // let o = theme.colors.outline.primary;

        // let a = pelican_ui::Row!(ZERO, 4, Align::Left, vec![
        //     Circle::outlined(50, theme.colors.background.primary, o),
        //     Circle::outlined(50, theme.colors.background.secondary, o)
        // ]);

        // let b = pelican_ui::Row!(ZERO, 4, Align::Left, vec![
        //     Circle::outlined(50, theme.colors.brand.primary, o),
        //     Circle::outlined(50, theme.colors.brand.secondary, o)
        // ]);

        // let c = pelican_ui::Row!(ZERO, 4, Align::Left, vec![
        //     Circle::outlined(50, theme.colors.outline.primary, o),
        //     Circle::outlined(50, theme.colors.outline.secondary, o)
        // ]);

        // let d = pelican_ui::Row!(ZERO, 4, Align::Left, vec![
        //     Circle::outlined(50, theme.colors.text.heading, o),
        //     Circle::outlined(50, theme.colors.text.primary, o),
        //     Circle::outlined(50, theme.colors.text.secondary, o)
        // ]);

        // let e = pelican_ui::Row!(ZERO, 4, Align::Left, vec![
        //     Circle::outlined(50, theme.colors.status.success, o),
        //     Circle::outlined(50, theme.colors.status.warning, o),
        //     Circle::outlined(50, theme.colors.status.danger, o)
        // ]);

        // let f = pelican_ui::Row!(ZERO, 4, Align::Left, vec![
        //     ProfileImage::circle_outlined(50, image.clone(), theme.colors.outline.secondary),
        //     ProfileImage::circle_outlined(50, image.clone(), o),
        //     ProfileImage::circle_outlined(50, image.clone(), theme.colors.status.danger)
        // ]);

        // let g = pelican_ui::Row!(ZERO, 4, Align::Left, vec![
        //     Icon("group", theme.colors.text.heading, 48),
        //     Icon("toast", theme.colors.text.heading, 48),
        //     Icon("monitor", theme.colors.text.heading, 48),
        //     Icon("search", theme.colors.text.heading, 48),
        // ]);

        // let h = pelican_ui::Row!(ZERO, 4, Align::Left, vec![
        //     Icon("error", theme.colors.status.danger, 48),
        //     Icon("warning", theme.colors.status.warning, 48),
        //     Icon("checkmark", theme.colors.status.success, 48),
        // ]);

        // let i = pelican_ui::Column!(ZERO, 4, Align::Left,
        //     RoundedRectangle::new((200, 48), 24, theme.colors.brand.primary),
        //     RoundedRectangle::outlined((100, 32), 32 / 2, theme.colors.background.primary, 1, o),
        //     RoundedRectangle::outlined((100, 32), 32 / 2, theme.colors.background.secondary, 1, o),
        // );

        // let j = pelican_ui::Column!(ZERO, 4, Align::Left,
        //     Text(TextStyle::Heading, "Bitcoin received", 48),
        //     Text(TextStyle::Primary, "Bitcoin received 🎂🎂🎂🎂", 24),
        //     Text(TextStyle::Secondary, "Bitcoin received", 20),
        //     Text(TextStyle::Error, "Bitcoin received", 20),
        //     Text(TextStyle::White, "Bitcoin received", 24),
        //     Text(TextStyle::Label, "Bitcoin received", 24),
        // );

        // Box::new(pelican_ui::Column!(ZERO, 4, Align::Left,
        //     a, b, c, d, e, f, g, h, i, j
        // ))

        Box::new(CircleIcon(ProfileImage::Icon(CircleIconData("profile", CircleIconStyle::Secondary)), Some(CircleIconData("edit", CircleIconStyle::Secondary)), false))
    }

    // async fn on_tick(&mut self, ctx: &mut Context) {
    //     ctx.clear(Color::from_hex("ffffff", 255));
    //   //let delta = self.items.get_mut(0).unwrap().area().0.1;
    //   //self.items.get_mut(0).unwrap().area().0.1 = (delta+1) % 1000;
    //     self.items.iter().for_each(|(area, c)| ctx.draw(*area, c.clone()));
    // }

    // async fn on_click(&mut self, ctx: &mut Context) {
    //   //self.items.push(CanvasItem::Shape(
    //   //    Area((ctx.position.0.max(20)-20, ctx.position.1.max(20)-20), None),
    //   //    Shape::Circle(10, (80, 40), 20),
    //   //    ((ctx.position.0%9).to_string()+"000ff").leak(), 255
    //   //));
    // }

    // async fn on_move(&mut self, ctx: &mut Context) {
    //   //self.items.push(CanvasItem::Shape(
    //   //    Area((ctx.position.0.max(10)-10, ctx.position.1.max(10)-10), None),
    //   //    Shape::Ellipse(0, (20, 20)),
    //   //    "ff0000", 255
    //   //));
    // }

    // async fn on_press(&mut self, ctx: &mut Context, t: String) {
    //   //self.items.push(CanvasItem::Text(
    //   //    Area((ctx.position.0, ctx.position.1), None),
    //   //    Text::new(t.leak(), "eb343a", 255, None, 48, 60, self.font.clone())
    //   //));
    // }
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
