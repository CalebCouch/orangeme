use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;

use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Default, Debug)]
pub struct Count(pub u32);

#[derive(Debug, Component)]
pub struct Bumper(Row, pub Button, Button);

impl Bumper {
    pub fn new(ctx: &mut Context) -> Self {
        Bumper(
            Row(16, Offset::Center, Size::Fit, Padding(16, 16, 16, 16)),
            Button::secondary(
                ctx, Some("paste"), "Paste", None,
                |ctx: &mut Context| ctx.state().set(&Count(ctx.state().get::<Count>().unwrap().0-1)).unwrap()
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
                Offset::Center,
                |ctx: &mut Context| ctx.state().set(&Count(ctx.state().get::<Count>().unwrap().0+1)).unwrap()
            )
        )
    }
}

// impl Events for Bumper {
//     fn on_tick(&mut self, ctx: &mut Context) {
//         //ctx.state().set(&Count(ctx.state().get::<Count>().unwrap().0+1)).unwrap();
//         *self.1.2.3.as_mut().unwrap().value() = ctx.state().get::<Count>().unwrap().0.to_string();
//     }
// }

pub struct MyApp;

impl App for MyApp {
    fn root(ctx: &mut Context<'_>) -> Box<dyn Drawable> {
        let plugin = PelicanUI::init(ctx);
        ctx.configure_plugin(plugin);

        // let theme = &ctx.get::<PelicanUI>().theme;
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

        //Box::new(Bumper::new(ctx))
        // Box::new(
        //     TextInput::new(
        //         ctx,
        //         Some("Label"),
        //         "Search names...",
        //         Some("You're kinda stinky."),
        //         Some(("close", |_ctx: &mut Context, txt: &mut String| println!("Submitting: {:?}", txt))),
        //     )
        // )

        // Box::new(
        //     DataItem::new(
        //         ctx, 
        //         None,
        //         "Confirm adress", 
        //         Some("1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"),
        //         Some("Bitcoin sent to the wrong address can never be recovered."), 
        //         None,
        //         Some(vec![button])
        //     )
        // )

        // Box::new(Alert::new(ctx, "You were booted from this room."))
        // Box::new(RowTest::new())

      //Box::new(Bin(Stack(
      //    Offset::End, Offset::End, Size::Fill(MinSize(0), MaxSize(u32::MAX)), Size::Fill(MinSize(0), MaxSize(u32::MAX)), Padding(10, 20, 50, 100)
      //),
      //    Shape(ShapeType::Rectangle(0, (100, 100)), Color(0, 0, 255, 255))
      //))

    //   Box::new(AmountDisplay::new(ctx, "$10.00", "0.00001234 BTC", Some("Not enough bitcoin")))
        Box::new(MobileKeyboard::new(ctx))
        // Box::new(
        //     Card::new(
        //         ctx,
        //         AvatarContent::Icon("door", AvatarIconStyle::Secondary),
        //         "Ella Couch's Room",
        //         "101 members",
        //         "A room for all of Ella Couch's friends.",
        //         |_ctx: &mut Context| println!("JOINING ROOM")
        //     )
        // )

        // Box::new(
        //     ListItem::contact(ctx, 
        //         AvatarContent::Icon("profile", AvatarIconStyle::Secondary), 
        //         "Ella Couch", "did::nym::udc29i8soihOXIR8GXo2rloi", 
        //         |_ctx: &mut Context| println!("CHOOSING MEMBER")
        //     )
        // )

    }
}

create_entry_points!(MyApp);
