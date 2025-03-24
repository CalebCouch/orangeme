use rust_on_rails::prelude::*;
use resources::Font;
//use pelican_ui::prelude::*;

//  #[derive(Clone)]
//  pub struct Column(pub u32, pub Vec<BoxComponent>);

//  impl LayoutComponent for Column {
//      fn children(&self) -> Vec<&BoxComponent> {self.1.iter().collect()}
//      fn children_mut(&self) -> Vec<&mut BoxComponent> {self.1.iter_mut().collect()}

//      fn layout(&self, ctx: &mut , max_size: (u32, u32), items: Vec<fn (u32, u32) -> (u32, u32)>) -> Vec<((i32, i32), (u32, u32))> {
//          let mut offset = 0;
//          items.iter_mut().flat_map(|c| {
//              if max_size.1 < offset {None} else {
//                  //let size = c.size(ctx, (max_size.0, max_size.1-offset));
//                  let size = todo!();
//                  let v = ((0, offset as i32), size);
//                  offset += size.1+self.0;
//                  v
//              }
//          }).collect()

//      }
//  }

#[derive(Clone, Copy, Default, Debug)]
pub enum Size {
    #[default]
    Fit,
    Fill,
    Static(u32)
}

impl Size {
    pub fn get(&self, max_size: u32, items: Vec<Option<u32>>) -> u32 {
        match self {
            Self::Fit => items.into_iter().fold(None, |os, s| {
                s.map(|s| os.map(|os: u32| os.max(s)).unwrap_or(s)).or(os)
            }).unwrap_or(max_size),
            Self::Fill => max_size,
            Self::Static(s) => *s,
        }
    }

    pub fn size(&self, items: Vec<Option<u32>>) -> Option<u32> {
        match self {
            Self::Fit => items.into_iter().fold(None,
                |os, s| s.map(|s| os.map(|os: u32| os.max(s)).unwrap_or(s)).or(os)
            ),
            Self::Fill => None,
            Self::Static(s) => Some(*s)
        }
    }
}

#[derive(Clone, Copy, Default, Debug)]
pub enum Offset {
    #[default]
    Start,
    Center,
    End,
    Static(i32)
}

impl Offset {
    pub fn get(&self, max_size: u32, item: u32) -> i32 {
        match self {
            Self::Start => 0,
            Self::Center => (max_size as i32 - item as i32) / 2,
            Self::End => max_size as i32 - item as i32,
            Self::Static(s) => *s,
        }
    }

    pub fn size(&self) -> Option<i32> {
        match self {
            Self::Start => Some(0),
            Self::Center => None,
            Self::End => None,
            Self::Static(s) => Some(*s),
        }
    }
}

#[derive(Clone, Debug)]
pub struct Stack((Offset, Offset), (Size, Size));

impl Stack {
    pub fn get_size(size: &Size, items: Vec<Option<u32>>) -> Option<u32> {
        match size {
            Size::Fit => items.into_iter().fold(None,
                |os, s| s.map(|s| os.map(|os: u32| os.max(s)).unwrap_or(s)).or(os)
            ),
            Size::Fill => None,
            Size::Static(s) => Some(*s)
        }
    }
}

impl Layout for Stack {
    fn build(&self, _ctx: &mut Context, max_size: (u32, u32), items: Vec<(Option<u32>, Option<u32>)>) -> Vec<((i32, i32), (u32, u32))> {
        let (widths, heights): (Vec<Option<u32>>, Vec<Option<u32>>) = items.iter().cloned().unzip();
        let stack_size = (Self::get_size(&self.1.0, widths).unwrap_or(max_size.0), Self::get_size(&self.1.1, heights).unwrap_or(max_size.1));
        items.into_iter().map(|(w, h)| {
            let size = (w.unwrap_or(stack_size.0), h.unwrap_or(stack_size.1));
            let offset = (self.0.0.get(stack_size.0, size.0), self.0.1.get(stack_size.1, size.1));
            (offset, size)
        }).collect()
    }

    fn size(&self, _ctx: &mut Context, items: Vec<(Option<u32>, Option<u32>)>) -> (Option<u32>, Option<u32>) {
        let (widths, heights): (Vec<_>, Vec<_>) = items.into_iter().unzip();
        (Self::get_size(&self.1.0, widths), Self::get_size(&self.1.1, heights))
    }
}


#[derive(Clone, Debug)]
pub struct Column(pub u32, pub Offset, pub Size);

impl Column {
    pub fn get_size(size: &Size, items: Vec<Option<u32>>) -> Option<u32> {
        match size {
            Size::Fit => items.into_iter().fold(Some(0),
                |os, s| os.and_then(|os| s.map(|s| os.max(s)))
            ),
            Size::Fill => None,
            Size::Static(s) => Some(*s)
        }
    }
}


impl Layout for Column {
    fn build(&self, ctx: &mut Context, max_size: (u32, u32), items: Vec<(Option<u32>, Option<u32>)>) -> Vec<((i32, i32), (u32, u32))> {
        let (widths, heights): (Vec<Option<u32>>, Vec<Option<u32>>) = items.iter().cloned().unzip();

        let col_width = Self::get_size(&self.2, widths).unwrap_or(max_size.0);

        let spacing = (heights.len()-1) as u32 *self.0;
        let (count, sized) = heights.iter().fold((0, 0), |(c, t), h| (c+h.is_none() as u32, t+h.unwrap_or(0)));
        let unsized_space = if count == 0 {0} else {(max_size.1-(spacing+sized)) / count};

        let mut offset = 0;
        items.into_iter().map(|(w, h)| {
            let size = (w.unwrap_or(col_width), h.unwrap_or(unsized_space));
            let offset_v = (self.1.get(col_width, size.0), offset as i32);
            offset = size.1+self.0;
            (offset_v, size)
        }).collect()
    }

    fn size(&self, ctx: &mut Context, items: Vec<(Option<u32>, Option<u32>)>) -> (Option<u32>, Option<u32>) {
        let (widths, heights): (Vec<_>, Vec<_>) = items.into_iter().unzip();
        let items = heights.len();
        (
            Self::get_size(&self.2, widths),
            Self::get_size(&Size::Fit, heights).map(|t| t+(self.0*(items-1) as u32))
        )
    }
}

#[derive(Clone, Debug)]
pub struct Row(pub u32, pub Offset, pub Size);

impl Row {
    pub fn get_size(size: &Size, items: Vec<Option<u32>>) -> Option<u32> {
        match size {
            Size::Fit => items.into_iter().fold(Some(0),
                |os, s| os.and_then(|os| s.map(|s| os.max(s)))
            ),
            Size::Fill => None,
            Size::Static(s) => Some(*s)
        }
    }
}


impl Layout for Row {
    fn build(&self, ctx: &mut Context, max_size: (u32, u32), items: Vec<(Option<u32>, Option<u32>)>) -> Vec<((i32, i32), (u32, u32))> {
        let (widths, heights): (Vec<Option<u32>>, Vec<Option<u32>>) = items.iter().cloned().unzip();

        let row_height = Self::get_size(&self.2, heights).unwrap_or(max_size.1);

        let spacing = (widths.len()-1) as u32 *self.0;
        let (count, sized) = widths.iter().fold((0, 0), |(c, t), w| (c+w.is_none() as u32, t+w.unwrap_or(0)));
        let unsized_space = if count == 0 {0} else {(max_size.0-(spacing+sized)) / count};

        let mut offset = 0;
        items.into_iter().map(|(w, h)| {
            let size = (w.unwrap_or(unsized_space), h.unwrap_or(row_height));
            let offset_v = (offset as i32, self.1.get(row_height, size.1));
            offset = size.0+self.0;
            (offset_v, size)
        }).collect()
    }

    fn size(&self, ctx: &mut Context, items: Vec<(Option<u32>, Option<u32>)>) -> (Option<u32>, Option<u32>) {
        let (widths, heights): (Vec<_>, Vec<_>) = items.into_iter().unzip();
        let items = widths.len();
        (
            Self::get_size(&Size::Fit, widths).map(|t| t+(self.0*(items-1) as u32)),
            Self::get_size(&self.2, heights)
        )
    }
}

#[derive(Clone, Debug, Component)]
pub struct Test(Row, Text, Text);

impl Test {
    pub fn new(font: Font, _font2: Font) -> Self {
        Test(
            //Stack((Offset::Start, Offset::Center), (Size::Fit, Size::Fill)),
            Row(10, Offset::Center, Size::Fit),
            Text::new("HELLO HE", Color::from_hex("eb343a", 255), None, 48, 60, font.clone()),
            Text::new("HELLO HL", Color::from_hex("eb343a", 255), None, 24, 30, font.clone()),
        )
    }
}

impl Component for Test {
    fn children_mut(&mut self) -> Vec<&mut ComponentRef> {vec![&mut self.1, &mut self.2]}
    fn children(&self) -> Vec<&ComponentRef> {vec![&self.1, &self.2]}
    fn layout(&self) -> &dyn Layout {&self.0}

    fn on_tick(&mut self, ctx: &mut Context) {
        println!("size: {:?}", self.size(ctx));
    }

    fn on_click(&mut self, ctx: &mut Context, position: Option<(u32, u32)>) -> bool {
        println!("position: {:?}", position);
        true
    }
    fn on_move(&mut self, ctx: &mut Context, position: Option<(u32, u32)>) -> bool {
        true
    }
}


    //container![&mut self.1, &mut self.2]
  //fn build(&mut self, ctx: &mut Context, max_size: (u32, u32)) -> Vec<((i32, i32), (u32, u32), &mut BoxComponent)> {
  //    let mut offset = 0;
  //    self.1.iter_mut().flat_map(|c| {
  //        if max_size.1 < offset {None} else {
  //            let size = c.size(ctx, (max_size.0, max_size.1-offset));
  //            let v = ((0, offset as i32), size, c);
  //            offset += size.1+self.0;
  //            Some(v)
  //        }
  //    }).collect()
  //}
    //fn children_mut(&mut self) -> Vec<&mut BoxComponent> {self.1.iter_mut().collect()}

  //fn on_click(&mut self, ctx: &mut Context, max_size: (u32, u32), position: (u32, u32)) {
  //    let mut offset = 0;
  //    for c in &mut self.1 {
  //        let size = c.size(ctx, (max_size.0, max_size.1-offset));
  //        if size.0 > position.0 && offset+size.1 > position.1 {
  //            c.on_click(
  //                ctx,
  //                (max_size.0, offset+self.0),
  //                (position.0, position.1-offset)
  //            );
  //            return;
  //        }
  //        if offset+size.1+self.0 > position.1 {
  //            return;
  //        }
  //        offset += self.0 + size.1;
  //    }
  //}

//  #[derive(Clone)]
//  pub struct MyCom{
//      font: resources::Font,
//      text: String
//  }

//  impl Component for MyCom {
//      fn build(&self, ctx: &mut Context, max_size: (u32, u32)) -> Vec<(Offset, Size, BoxComponent)> {
//          vec![
//              (Offset::Center, Size::Static(900, 200), vec![Box::new(
//                  Shape(ShapeType::Rectangle(0), Color(0, 0, 255, 255)),
//                  Image(ShapeType::Rectangle(0), image, Some(Color(255, 0, 0, 128))
//              ]) as BoxComponent),




//              (Offset::Center, Size::default(), Box::new(
//                  Text(self.text.clone(), Color::from_hex("eb343a", 255), 48, 60, self.font.clone())
//              )),
//              (Offset::BottomRight, Size::default(), Box::new(
//                  Text(self.text.clone(), Color::from_hex("eb343a", 255), 48, 60, self.font.clone())
//              ))
//          ]

//        //container!(Offset::BottomRight, Size::Expand, [
//        //    Shape(ShapeType::Rectangle(0), Color(0, 0, 255, 255)).size(Size::Static(1000, 200))
//        //    text
//        //])

//        //vec![Box::new(Container(Offset::BottomCenter, Size::Static(500, 200),
//        //    vec![
//        //        Box::new(Shape(ShapeType::Rectangle(0), Color(0, 0, 255, 255))) as Box<dyn Component>,
//        //        Box::new(text) as Box<dyn Component>,
//        //    ]
//        //))]
//      }

//      fn on_click(&mut self, ctx: &mut Context, max_size: (u32, u32), position: (u32, u32)) {
//          self.text = format!("{:?}", position);
//      }
//  }

pub struct MyApp;

impl App for MyApp {
    async fn new(ctx: &mut Context<'_>) -> BoxComponent {
        //PelicanContext.init(ctx);
        println!("START APP");

        let font = resources::Font::new(ctx, include_bytes!("../assets/fonts/outfit_bold.ttf").to_vec());
        let font2 = resources::Font::new(ctx, include_bytes!("../assets/fonts/outfit_regular.ttf").to_vec());
        let test = Test::new(font, font2);
        Box::new(test)
      //let image = resources::Image::new(ctx, image::load_from_memory(include_bytes!("../assets/icons/pfp3.png")).unwrap().into());
      //let svg = resources::Image::svg(ctx, include_bytes!("../assets/icons/qr_code.svg"), 8.0);



      //Box::new(Container(Column(50), vec![
      //    //Some(Text("HELLO WORLD HEL", Color::from_hex("eb343a", 255), 48, 60, font.clone())).into(),
      //    //Box::new(None::<Text>)
      ////Box::new(Column(0, vec![

      //    //Box::new(MyCom{font: font.clone(), text: "HEL".to_string()})
      //    Box::new(Text::new("HELLO WORLD HEL", Color::from_hex("eb343a", 255), 48, 60, font.clone())),
      //    Box::new(Text::new("HELLO HE", Color::from_hex("eb343a", 255), 48, 60, font.clone())),
      //    Box::new(Text::new("HELLO HL", Color::from_hex("eb343a", 255), 24, 30, font.clone())),
      //    Box::new(Text::new("HELLO EL", Color::from_hex("eb343a", 255), 48, 60, font.clone())),
      //]))
      //]))
        //Box::new(Icon::new(ctx, IconName::Door, "ffffff", 48))
    }
}

create_entry_points!(MyApp);
