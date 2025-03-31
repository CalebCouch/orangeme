use pelican_ui::prelude::*;
// use pelican_ui::prelude::Text;
// use pelican_ui::custom::*;

use rust_on_rails::prelude::*;
// use rust_on_rails::prelude::Text as BasicText;

#[derive(Clone, Debug, Component)]
pub struct Bumper(Row, Button, Button);
impl Events for Bumper {}

impl Bumper {
    pub fn new(ctx: &mut Context) -> Self {
        Bumper(
            Row(16, Offset::Center, Size::Fit),
            Button::new(
                ctx,
                Some(AvatarContent::Icon("profile", AvatarIconStyle::Secondary)),
                None,
                Some("Paste"),
                None,
                ButtonSize::Large,
                ButtonWidth::Expand,
                ButtonStyle::Primary,
                ButtonState::Default,
                |_ctx: &mut Context, position: (u32, u32)| println!("BOTTETTTEN...: {:?}", position)
            ),
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
                |_ctx: &mut Context, position: (u32, u32)| println!("Pasting...: {:?}", position)
            )
        )
    }
}

pub struct MyApp;

impl App for MyApp {
    async fn new(ctx: &mut Context<'_>) -> Box<dyn Drawable> {
        let plugin = PelicanUI::init(ctx);
        ctx.configure_plugin(plugin);

      //let color = ctx.get::<PelicanUI>().theme.colors.brand.secondary;
      //Box::new(Icon::new(ctx, "error", color, 128))
        //Box::new(Shape(ShapeType::Ellipse(20, (50, 50)), Color(155, 255, 0, 255)))
        // Box::new(CircleIcon::new(ctx, ProfileImage::Icon("wallet", AvatarIconStyle::Brand), Some(("edit", AvatarIconStyle::Secondary)), false, 128))
        // Box::new(CircleIconData::new(ctx, "wallet", AvatarIconStyle::Brand, 128))
        //Box::new(Avatar::new(ctx, AvatarContent::Icon("profile", AvatarIconStyle::Secondary), Some(("microphone", AvatarIconStyle::Danger)), false, 128))
        //Box::new(Button::secondary(ctx, Some("paste"), "Paste", None, ))
        // Box::new(Bumper::new(ctx))
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
                Some(("close", |_ctx: &mut Context, position: (u32, u32)| println!("Pasting...: {:?}", position))),
                None,
                None
            )
        )

        // Box::new(Alert::new(ctx, "You were booted from this room."))
    }
}

create_entry_points!(MyApp);
