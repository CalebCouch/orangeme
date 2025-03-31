use pelican_ui::prelude::*;
// use pelican_ui::prelude::Text;
// use pelican_ui::custom::*;

use rust_on_rails::prelude::*;
// use rust_on_rails::prelude::Text as BasicText;

pub struct MyApp;

impl App for MyApp {
    async fn new(ctx: &mut Context<'_>) -> Box<dyn Drawable> {
        let plugin = PelicanUI::init(ctx);
        ctx.configure_plugin(plugin);

      //let color = ctx.get::<PelicanUI>().theme.colors.brand.secondary;
      //Box::new(Icon::new(ctx, "error", color, 128))
        //Box::new(Shape(ShapeType::Ellipse(20, (50, 50)), Color(155, 255, 0, 255)))
        // Box::new(CircleIcon::new(ctx, ProfileImage::Icon("wallet", CircleIconStyle::Brand), Some(("edit", CircleIconStyle::Secondary)), false, 128))
        // Box::new(CircleIconData::new(ctx, "wallet", CircleIconStyle::Brand, 128))
        //Box::new(Avatar::new(ctx, AvatarContent::Icon("profile", CircleIconStyle::Secondary), Some(("microphone", CircleIconStyle::Danger)), false, 128))
        //Box::new(Button::secondary(ctx, Some("paste"), "Paste", None, ))
        Box::new(Button::new(
            ctx,
            Some(AvatarContent::Icon("profile", CircleIconStyle::Secondary)),
            None,
            Some("Paste"),
            None,
            ButtonSize::Large,
            ButtonWidth::Hug,
            ButtonStyle::Secondary,
            ButtonState::Default,
            |_ctx: &mut Context, _position: (u32, u32)| println!("Pasting...")
        ))
        // Box::new(Button::primary(ctx, "wallet", (|| println!("Pasting..."))))
        // Box::new(BasicText::new("Continue", color, 48, 60, font.clone()))
        // Box::new(Text::new(ctx, "Continue", TextStyle::Label(color), 48))
    }
}

create_entry_points!(MyApp);
