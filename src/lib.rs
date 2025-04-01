use pelican_ui::prelude::*;
// use pelican_ui::prelude::Text;
// use pelican_ui::custom::*;

use rust_on_rails::prelude::*;
// use rust_on_rails::prelude::Text as BasicText;

// #[derive(Clone, Debug, Component)]
// pub struct Bumper(Row, Button, Button);
// impl Events for Bumper {}

// impl Bumper {
//     pub fn new(ctx: &mut Context) -> Self {
//         Bumper(
//             Row(16, Offset::Center, Size::Fit),
//             Button::primary(ctx, "Receive", |_ctx: &mut Context, position: (u32, u32)| println!("Receive...: {:?}", position)),
//             Button::primary(ctx, "Send", |_ctx: &mut Context, position: (u32, u32)| println!("Send...: {:?}", position))
//             // Button::new(
//             //     ctx,
//             //     None,
//             //     None,
//             //     Some("Receive ❤️"),
//             //     None,
//             //     ButtonSize::Large,
//             //     ButtonWidth::Expand,
//             //     ButtonStyle::Secondary,
//             //     ButtonState::Default,
//             //     Offset::Center,
//             //     |_ctx: &mut Context, position: (u32, u32)| println!("BOTTETTTEN...: {:?}", position)
//             // ),
//             // Button::new(
//             //     ctx,
//             //     None,
//             //     None,
//             //     Some("Send"),
//             //     None,
//             //     ButtonSize::Large,
//             //     ButtonWidth::Expand,
//             //     ButtonStyle::Primary,
//             //     ButtonState::Default,
//             //     Offset::Center,
//             //     |_ctx: &mut Context, position: (u32, u32)| println!("BOTTETTTEN...: {:?}", position)
//             // ),
//             // Button::new(
//             //     ctx,
//             //     None, //Some(AvatarContent::Icon("profile", AvatarIconStyle::Secondary)),
//             //     Some("send"),
//             //     Some("Send"),
//             //     None,
//             //     ButtonSize::Medium,
//             //     ButtonWidth::Hug,
//             //     ButtonStyle::Secondary,
//             //     ButtonState::Default,
//             //     |_ctx: &mut Context, position: (u32, u32)| println!("Pasting...: {:?}", position)
//             // )
//         )
//     }
// }

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
        Box::new(Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), Some(("microphone", AvatarIconStyle::Danger)), false, 128))
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

        // Box::new(
        //     TextInput::new(
        //         ctx,
        //         None,
        //         None,
        //         "Search names...",
        //         Some(("close", |_ctx: &mut Context, position: (u32, u32)| println!("Pasting...: {:?}", position))),
        //         None,
        //         None
        //     )
        // )

        // Box::new(Alert::new(ctx, "You were booted from this room."))

        // Box::new(QRCode::new(ctx, "heaxig84aks4d39EID28EXOCrad49oaniIoahriCwea24"))
    }
}

create_entry_points!(MyApp);
