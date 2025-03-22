use pelican_ui::prelude::*;
use pelican_ui::custom::*;

use rust_on_rails::prelude::*;

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

        let image = resources::Image::new(ctx, image::load_from_memory(include_bytes!("../assets/icons/profile.png")).unwrap().into());

        let theme = &ctx.get::<PelicanUI>().theme;

        Box::new(Padding((24, 24), Box::new(Column!(24,
            Button::primary("Continue"),
            Button::secondary(Some("paste"), "Paste Clipboard", None),
            // pelican_ui::prelude::Text(TextStyle::Heading, "Bitcoin received", 24),
            // pelican_ui::prelude::Text(TextStyle::Secondary, "Bitcoin sent to the wrong address can never be recovered.", 16),
            // Row!(24, Icon("error", o, 16), pelican_ui::prelude::Text(TextStyle::Error, "Not enough bitcoin.", 16)),
            CircleIcon::Icon(CircleIconData("door", CircleIconStyle::Secondary), Some(CircleIconData("edit", CircleIconStyle::Secondary)), false, 128),
            CircleIcon::Icon(CircleIconData("wallet", CircleIconStyle::Brand), None, false, 128),
            CircleIcon::Image(image, Some(CircleIconData("edit", CircleIconStyle::Secondary)), false, 128),
            // CircleIcon(ProfileImage::Icon(CircleIconData("profile", CircleIconStyle::Secondary)), Some(CircleIconData("checkmark", CircleIconStyle::Success)), false, 128),
            // CircleIcon(ProfileImage::Icon(CircleIconData("profile", CircleIconStyle::Secondary)), Some(CircleIconData("microphone", CircleIconStyle::Danger)), false, 128),
            // CircleIcon(ProfileImage::Icon(CircleIconData("profile", CircleIconStyle::Secondary)), Some(CircleIconData("warning", CircleIconStyle::Warning)), false, 128)
        ))))
    }
}

create_entry_points!(MyApp);
