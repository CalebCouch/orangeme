use pelican_ui::prelude::*;
// use pelican_ui::prelude::Text;
// use pelican_ui::custom::*;

use rust_on_rails::prelude::*;

//  impl<D: Drawable + Clone> Padding<D> {
//      pub fn new(ctx: &mut Context, item: D, padding: (u32, u32, u32, u32)) -> Self {
//          let size = item.size(ctx);
//          let wp = padding.0+padding.2;
//          let hp = padding.1+padding.3;
//          Padding(Stack(
//              Offset::Static(padding.0 as i32), Offset::Static(padding.1 as i32), 
//              Size::Fill(size.min_width()+MinSize(padding.2), size.max_width()-MaxSize(padding.2)),
//              Size::Fill(size.min_height()+MinSize(padding.3), size.max_height()-MaxSize(padding.3))
//          ), item)
//      }
//  }

// use rust_on_rails::prelude::Text as BasicText;

#[derive(Clone, Debug, Component)]
pub struct Bumper(Row, Button, Button);
impl Events for Bumper {}

impl Bumper {
    pub fn new(ctx: &mut Context) -> Self {
        Bumper(
            Row(16, Offset::Center, Size::Fit, Padding(16, 16, 16, 16)),
            Button::secondary(ctx, Some("paste"), "Paste", None, |_ctx: &mut Context, position: (u32, u32)| println!("BOTTETTTEN...: {:?}", position)),
            Button::new(
                ctx,
                Some(AvatarContent::Icon("settings", AvatarIconStyle::Secondary)),
                None,
                Some("Paste"),
                None,
                ButtonSize::Large,
                ButtonWidth::Expand,
                ButtonStyle::Secondary,
                ButtonState::Default,
                Offset::Center,
                |_ctx: &mut Context, position: (u32, u32)| println!("Pasting...: {:?}", position)
            )
        )
    }
}

#[derive(Clone, Debug, Component)]
pub struct RowTest(Column, Shape, Shape, Shape);
impl Events for RowTest {}
impl RowTest {
    pub fn new() -> Self {
        RowTest(Column(
            10, Offset::End, Size::Fill(MinSize(0), MaxSize(u32::MAX)), Padding(10, 20, 50, 40)
        ),
            Shape(ShapeType::Rectangle(0, (100, 100)), Color(0, 0, 255, 255)),
            Shape(ShapeType::Rectangle(0, (40, 20)), Color(255, 0, 255, 255)),
            Shape(ShapeType::Rectangle(0, (29, 79)), Color(255, 0, 0, 255))
        )
    }
}

pub struct MyApp;

impl App for MyApp {
    async fn new(ctx: &mut Context<'_>) -> Box<dyn Drawable> {
        let plugin = PelicanUI::init(ctx);
        ctx.configure_plugin(plugin);

        let theme = &ctx.get::<PelicanUI>().theme;
        //Box::new(Icon::new(ctx, "error", color, 128))
        //Box::new(Shape(ShapeType::Ellipse(20, (50, 50)), Color(155, 255, 0, 255)))
        //Box::new(CircleIcon::new(ctx, ProfileImage::Icon("wallet", AvatarIconStyle::Brand), Some(("edit", AvatarIconStyle::Secondary)), false, 128))
        //Box::new(CircleIconData::new(ctx, "wallet", AvatarIconStyle::Brand, 128))
        // Box::new(Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), Some(("microphone", AvatarIconStyle::Danger)), false, 128))
        //Box::new(Button::secondary(ctx, Some("paste"), "Paste", None, ))
        // let bumper = Bumper::new(ctx);
        // let bumper = Image(ShapeType::Rectangle(0, (300, 300)), theme.brand.logo.wordmark.clone(), Some(Color::from_hex("ffffff", 255)));
        // Box::new(bumper)
        // Box::new(IconButton::new(
        //     ctx,
        //     Some("close"),
        //     ButtonSize::Large,
        //     ButtonStyle::Secondary,
        //     ButtonState::Default,
        //     |_ctx: &mut Context, position: (u32, u32)| println!("Pasting...: {:?}", position)
        // ))
      //Box::new(Button::new(
      //    ctx,
      //    Some(AvatarContent::Icon("profile", AvatarIconStyle::Secondary)),
      //    None,
      //    Some("Paste"),
      //    None,
      //    ButtonSize::Large,
      //    ButtonWidth::Expand,
      //    ButtonStyle::Primary,
      //    ButtonState::Default,
      //    |_ctx: &mut Context, position: (u32, u32)| println!("Pasting...: {:?}", position)
      //))
        // Box::new(Button::primary(ctx, "wallet", (|| println!("Pasting..."))))
        // Box::new(BasicText::new("Continue", color, 48, 60, font.clone()))
        // Box::new(Text::new(ctx, "Continue", TextStyle::Label(color), 48))

        Box::new(
            TextInput::new(
                ctx,
                None,
                None,
                "Search names...",
                None,
                None,
                Some(("close", |_ctx: &mut Context, position: (u32, u32)| println!("Pasting...: {:?}", position))),
            )
        )

        // Box::new(Alert::new(ctx, "You were booted from this room."))
        // Box::new(RowTest::new())

      //Box::new(Bin(Stack(
      //    Offset::End, Offset::End, Size::Fill(MinSize(0), MaxSize(u32::MAX)), Size::Fill(MinSize(0), MaxSize(u32::MAX)), Padding(10, 20, 50, 100)
      //),
      //    Shape(ShapeType::Rectangle(0, (100, 100)), Color(0, 0, 255, 255))
      //))

    //   Box::new(AmountDisplay::new(ctx, "$10.00", "0.00001234 BTC", Some("Not enough bitcoin")))

        // Box::new(
        //     Card::new(
        //         ctx,
        //         AvatarContent::Icon("door", AvatarIconStyle::Secondary),
        //         "Ella Couch's Room",
        //         "101 members",
        //         "A room for all of Ella Couch's friends.",
        //         |_ctx: &mut Context, position: (u32, u32)| println!("Pasting...: {:?}", position)
        //     )
        // )

    }
}

create_entry_points!(MyApp);
