use pelican_ui::prelude::*;

pub struct MyApp;

impl App for MyApp {
    async fn new(ctx: &mut Context<'_>) -> Box<dyn ComponentBuilder> {
        ctx.include_assets(include_assets!("./assets"));
        Box::new(Column!(24, Alignment::Left,
            Row!(24, Alignment::Left,
                Button::Primary("Continue", Size::Large, Width::Hug, Some("pfp")),
                Button::Secondary("Continue", Size::Large, Width::Hug, None),
                Button::Ghost("Continue", Size::Large, Width::Hug, None)
            ),
            Row!(24, Alignment::Left,
                Button::Primary("Continue", Size::Medium, Width::Hug, Some("pfp")),
                Button::Secondary("Continue", Size::Medium, Width::Hug, None),
                Button::Ghost("Continue", Size::Medium, Width::Hug, None)
            ),
            // Row!(24, Alignment::Left,
            //     CircleIcon::Icon("profile", 48),
            //     CircleIcon::Brand("profile", 48),
            //     CircleIcon::Photo("profile", 48)
            // ),
            // Row!(24, Alignment::Left,
            //     MessageBubble::You("Hey! What's up?"),
            //     MessageBubble::ContactGroup("Hey! What's up?"),
            //     MessageBubble::Rooms("Hey! What's up?")
            // ),
            Row!(24, Alignment::Left,
                TextMessage(MessageType::You, vec!["Hey! What's up?", "Hey! What's up?"]),
                TextMessage(MessageType::Contact, vec!["Hey! What's up?", "Hey! What's up?"]),
                TextMessage(MessageType::Group, vec!["Hey! What's up?", "Hey! What's up?"]),
                TextMessage(MessageType::Rooms, vec!["Hey! What's up?", "Hey! What's up?"])
            ),
            Row!(24, Alignment::Left,
                ListItem::conversation("Ella Couch", "Hey, are we planning on meeting?"),
                ListItem::transaction("$10.00", "Yesterday", true, false),
                ListItem::user("Ella Couch", "nym::idd::74628363829")
            ),
            Row!(24, Alignment::Left,
                Card::room("Ella Couch's Room", "243 members", "A room for all of Ella Couch's friends")
            )
        ))
    }
}

create_entry_points!(MyApp);

//  use rust_on_rails::prelude::*;

//  pub struct MyApp{
//      items: Vec<CanvasItem>,
//      font: FontKey,
//      x: u32,
//      y: u32
//  }

//  impl CanvasAppTrait for MyApp {
//      async fn new(ctx: &mut Context) -> Self {
//          let font = include_bytes!("../assets/fonts/outfit_bold.ttf");
//          let key = ctx.atlas.add_font(font.to_vec());
//          MyApp{
//              items: vec![
//                  CanvasItem(
//                      ItemType::Shape(Shape::Rectangle(100, 100), "eb343a", None),
//                      (100, 400), None
//                  ),
//              ],
//              font: key,
//              x: 0,
//              y: 0
//          }
//      }

//      async fn draw(&mut self, ctx: &mut Context) {
//          ctx.clear("ffffff");
//          let delta = self.items.get_mut(0).unwrap().1.1;
//          self.items.get_mut(0).unwrap().1.1 = (delta+1) % 1000;
//          self.items.iter().for_each(|c| ctx.draw(c.clone()));
//      }

//      async fn on_click(&mut self, _ctx: &mut Context) {
//          self.items.push(CanvasItem(
//              ItemType::Shape(
//                //Shape::Draw(20, 0, vec![
//                //    DrawCommand::LineTo(100, 0),
//                //    DrawCommand::LineTo(100, 100),
//                //    DrawCommand::LineTo(0, 100),
//                //    DrawCommand::LineTo(0, 20),
//                //    DrawCommand::QuadraticBezierTo(20, 0, 0, 0),
//                //]), ((self.x%9).to_string()+"000ff").leak(), Some(500)
//                Shape::Circle(40), ((self.x%9).to_string()+"000ff").leak(), None
//              ),
//              (self.x.max(40)-40, self.y.max(40)-40), None
//          ));
//      }

//      async fn on_move(&mut self, ctx: &mut Context) {
//          self.x = ctx.position.0;
//          self.y = ctx.position.1;
//          self.on_click(ctx).await;
//        //self.items.push(CanvasItem(
//        //    ItemType::Shape(Shape::Rectangle(20, 20), "ff0000", None),
//        //    (x.max(10)-10, y.max(10)-10), None
//        //));
//      }

//      async fn on_press(&mut self, _ctx: &mut Context, t: String) {
//          self.items.push(CanvasItem(
//              ItemType::Text(
//                  Text::new(t.leak(), ((self.x%9).to_string()+"000ff").leak(), None, 48, 60, self.font)
//              ),
//              (self.x.max(20)-20, self.y.max(30)-30), None
//          ));
//      }
//  }

//  create_canvas_entry_points!(MyApp);
