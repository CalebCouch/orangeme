use rust_on_rails::prelude::*;
use pelican_ui::prelude::*;

mod flows;
pub use flows::*;
mod bdk;
use bdk::BDKPlugin;

// #[derive(Debug, Clone, Component)]
// pub struct WalletText(DefaultStack, BasicText, #[skip] Option<Address>);
// impl WalletText {
//     pub fn new(ctx: &mut Context) -> Self {
//         let font = ctx.add_font(include_bytes!("../resources/fonts/outfit_regular.ttf"));
//         WalletText(DefaultStack, BasicText::new(
//             Some((Cursor(1, 10), None)),
//             vec![Span::new("Hello", 48.0, 60.0, font, Color(0, 0, 255, 255))],
//         None, Align::Left), None)
//     }
// }

// impl OnEvent for WalletText {
//     fn on_event(&mut self, ctx: &mut Context, event: &mut dyn Event) -> bool {
//         if event.downcast_ref::<TickEvent>().is_some() {
//             let bdk = ctx.get::<BDKPlugin>();
//             if let Some(address) = &self.2 {
//                 self.1.spans[0].text = format!("Address: {}", address);
//             } else {
//                 let balance = bdk.get_balance();
//                 self.1.spans[0].text = format!("Balance: {}", balance);
//             }
//         } else if let Some(event) = event.downcast_ref::<MouseEvent>() {
//             if event.state == MouseState::Pressed {
//                 let bdk = ctx.get::<BDKPlugin>();
//                 self.2 = Some(bdk.get_new_address());
//             }
//         }
//         true
//     }
// 

pub struct MyApp;

impl App for MyApp {
    //TODO: include_plugins![BDKPlugin]; || #[derive(Plugins[BDKPlugin])] || #[Plugins[BDKPlugin]]
    async fn background_tasks(ctx: &mut HeadlessContext) -> Tasks {
        BDKPlugin::background_tasks(ctx).await
    }
    async fn plugins(ctx: &mut Context, h_ctx: &mut HeadlessContext) -> (Plugins, Tasks) {
        let (plugin, tasks) = BDKPlugin::new(ctx, h_ctx).await;
        let (pelican, _p_tasks) = PelicanUI::new(ctx, h_ctx).await;
        //tasks.extend(p_tasks);
        
        (std::collections::HashMap::from([
            (std::any::TypeId::of::<BDKPlugin>(), Box::new(plugin) as Box<dyn std::any::Any>),
            (std::any::TypeId::of::<PelicanUI>(), Box::new(pelican) as Box<dyn std::any::Any>)
        ]), tasks)
    }
    //END TODO

    async fn new(ctx: &mut Context) -> Box<dyn Drawable> {
        //ctx.get::<BDKPlugin>().init();
        let navigation = (0_usize, vec![
            ("wallet", "Bitcoin", Box::new(|ctx: &mut Context| BitcoinFlow::BitcoinHome.navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            ("messages", "Messages", Box::new(|ctx: &mut Context| MessagesFlow::MessagesHome.navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
            ("door", "Rooms", Box::new(|ctx: &mut Context| RoomsFlow::Rooms.navigate(ctx)) as Box<dyn FnMut(&mut Context)>),
        ]);

      //Box::new(Background(
      //    Stack::center(),
      //    Shape{shape: ShapeType::RoundedRectangle(0.0, (400.0, 400.0), 20.0), color: Color(0, 255, 0, 255)},
      //Box::new(ColorText(
      //    Stack::center(),
      //    Shape{shape: ShapeType::RoundedRectangle(0.0, (200.0, 200.0), 20.0), color: Color(0, 0, 255, 255)},
      //    Shape{shape: ShapeType::Rectangle(0.0, (100.0, 48.0)), color: Color(255, 0, 0, 255)},
      //))


        let profile = ("My Profile", AvatarContent::Icon("profile", AvatarIconStyle::Secondary), Box::new(|ctx: &mut Context| ProfilesFlow::Account.navigate(ctx)) as Box<dyn FnMut(&mut Context)>);

        let home = BitcoinHome::new(ctx);
        Box::new(Interface::new(ctx, home, Some(navigation), Some(profile)))
        // Box::new(pelican_ui::prelude::Text::new_with_edit(ctx, "Editable text example\nelpmaxe txet elbatidE", TextStyle::Heading, 20.0, Align::Left))
        // let bdk = ctx.get::<BDKPlugin>();
        // println!("Getting price");
        // bdk.get_price().await;
        // Box::new(WalletText::new(ctx))
        //Box::new(TextInput::new(ctx, None, "Placeholder", None, None,
        //    Some(("send", |ctx: &mut Context, input: &mut String| {println!("sent: {input}");}))
        //))
        //Box::new(BitcoinHome.build_page(ctx))
    }
}

create_entry_points!(MyApp);
//  mod canvas;
//  pub use canvas::*;
