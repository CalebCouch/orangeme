use rust_on_rails::prelude::*;
use resources::Font;
//use pelican_ui::prelude::*;

//  #[derive(Clone, Copy, Default, Debug)]
//  pub enum Size {
//      #[default]
//      Fit,
//      Fill,
//      Static(u32)
//  }

//  impl Size {
//      pub fn get(&self, max_size: u32, items: Vec<Option<u32>>) -> u32 {
//          match self {
//              Self::Fit => items.into_iter().fold(None, |os, s| {
//                  s.map(|s| os.map(|os: u32| os.max(s)).unwrap_or(s)).or(os)
//              }).unwrap_or(max_size),
//              Self::Fill => max_size,
//              Self::Static(s) => *s,
//          }
//      }

//      pub fn size(&self, items: Vec<Option<u32>>) -> Option<u32> {
//          match self {
//              Self::Fit => items.into_iter().fold(None,
//                  |os, s| s.map(|s| os.map(|os: u32| os.max(s)).unwrap_or(s)).or(os)
//              ),
//              Self::Fill => None,
//              Self::Static(s) => Some(*s)
//          }
//      }
//  }

//  #[derive(Clone, Debug)]
//  pub struct Stack((Offset, Offset), (Size, Size));

//  impl Stack {
//      pub fn get_size(size: &Size, items: Vec<Option<u32>>) -> Option<u32> {
//          match size {
//              Size::Fit => items.into_iter().fold(None,
//                  |os, s| s.map(|s| os.map(|os: u32| os.max(s)).unwrap_or(s)).or(os)
//              ),
//              Size::Fill => None,
//              Size::Static(s) => Some(*s)
//          }
//      }
//  }

//  impl Layout for Stack {
//      fn build(&self, _ctx: &mut Context, max_size: (u32, u32), items: Vec<(Option<u32>, Option<u32>)>) -> Vec<((i32, i32), (u32, u32))> {
//          let (widths, heights): (Vec<Option<u32>>, Vec<Option<u32>>) = items.iter().cloned().unzip();
//          let stack_size = (Self::get_size(&self.1.0, widths).unwrap_or(max_size.0), Self::get_size(&self.1.1, heights).unwrap_or(max_size.1));
//          items.into_iter().map(|(w, h)| {
//              let size = (w.unwrap_or(stack_size.0), h.unwrap_or(stack_size.1));
//              let offset = (self.0.0.get(stack_size.0, size.0), self.0.1.get(stack_size.1, size.1));
//              (offset, size)
//          }).collect()
//      }

//      fn size(&self, _ctx: &mut Context, items: Vec<(Option<u32>, Option<u32>)>) -> (Option<u32>, Option<u32>) {
//          let (widths, heights): (Vec<_>, Vec<_>) = items.into_iter().unzip();
//          (Self::get_size(&self.1.0, widths), Self::get_size(&self.1.1, heights))
//      }
//  }


//  #[derive(Clone, Debug)]
//  pub struct Column(pub u32, pub Offset, pub Size);

//  impl Column {
//      pub fn get_size(size: &Size, items: Vec<Option<u32>>) -> Option<u32> {
//          match size {
//              Size::Fit => items.into_iter().try_fold(0, |os, s| s.map(|s| os.max(s))),
//              Size::Fill => None,
//              Size::Static(s) => Some(*s)
//          }
//      }
//  }


//  impl Layout for Column {
//      fn build(&self, _ctx: &mut Context, max_size: (u32, u32), items: Vec<(Option<u32>, Option<u32>)>) -> Vec<((i32, i32), (u32, u32))> {
//          let (widths, heights): (Vec<Option<u32>>, Vec<Option<u32>>) = items.iter().cloned().unzip();

//          let col_width = Self::get_size(&self.2, widths).unwrap_or(max_size.0);

//          let spacing = (heights.len()-1) as u32 *self.0;
//          let (count, sized) = heights.iter().fold((0, 0), |(c, t), h| (c+h.is_none() as u32, t+h.unwrap_or(0)));
//          let unsized_space = if count == 0 {0} else {(max_size.1-(spacing+sized)) / count};

//          let mut offset = 0;
//          items.into_iter().map(|(w, h)| {
//              let size = (w.unwrap_or(col_width), h.unwrap_or(unsized_space));
//              let offset_v = (self.1.get(col_width, size.0), offset as i32);
//              offset += size.1+self.0;
//              (offset_v, size)
//          }).collect()
//      }

//      fn size(&self, _ctx: &mut Context, items: Vec<(Option<u32>, Option<u32>)>) -> (Option<u32>, Option<u32>) {
//          let (widths, heights): (Vec<_>, Vec<_>) = items.into_iter().unzip();
//          let items = heights.len();
//          (
//              Self::get_size(&self.2, widths),
//              Self::get_size(&Size::Fit, heights).map(|t| t+(self.0*(items-1) as u32))
//          )
//      }
//  }

//  #[derive(Clone, Debug)]
//  pub struct Row(pub u32, pub Offset, pub Size);

//  impl Row {
//      pub fn get_size(size: &Size, items: Vec<Option<u32>>) -> Option<u32> {
//          match size {
//              Size::Fit => items.into_iter().try_fold(0, |os, s| s.map(|s| os.max(s))),
//              Size::Fill => None,
//              Size::Static(s) => Some(*s)
//          }
//      }
//  }


//  impl Layout for Row {
//      fn build(&self, _ctx: &mut Context, max_size: (u32, u32), items: Vec<(Option<u32>, Option<u32>)>) -> Vec<((i32, i32), (u32, u32))> {
//          let (widths, heights): (Vec<Option<u32>>, Vec<Option<u32>>) = items.iter().cloned().unzip();

//          let row_height = Self::get_size(&self.2, heights).unwrap_or(max_size.1);

//          let spacing = (widths.len()-1) as u32 * self.0;
//          let (count, sized) = widths.iter().fold((0, 0), |(c, t), w| (c+w.is_none() as u32, t+w.unwrap_or(0)));
//          let unsized_space = if count == 0 {0} else {(max_size.0-(spacing+sized)) / count};

//          let mut offset = 0;
//          items.into_iter().map(|(w, h)| {
//              let size = (w.unwrap_or(unsized_space), h.unwrap_or(row_height));
//              let offset_v = (offset as i32, self.1.get(row_height, size.1));
//              offset += size.0+self.0;
//              (offset_v, size)
//          }).collect()
//      }

//      fn size(&self, _ctx: &mut Context, items: Vec<(Option<u32>, Option<u32>)>) -> (Option<u32>, Option<u32>) {
//          let (widths, heights): (Vec<_>, Vec<_>) = items.into_iter().unzip();
//          let items = widths.len();
//          (
//              Self::get_size(&Size::Fit, widths).map(|t| t+(self.0*(items-1) as u32)),
//              Self::get_size(&self.2, heights)
//          )
//      }
//  }

//  #[derive(Clone, Debug, Component)]
//  pub struct Test(#[layout] Row, pub Option<Text>, pub Text, #[ignore] #[skip] u32, #[skip] i32);

//  impl Test {
//      pub fn new(font: Font, _font2: Font) -> Self {
//          Test(
//              Row(10, Offset::Center, Size::Fit),
//              Text::new("HELLO HE", Color::from_hex("eb343a", 255), None, 48, 60, font.clone()),
//              Text::new("HELLO HL", Color::from_hex("eb343a", 255), None, 24, 30, font.clone()),
//              30, -40
//          )
//      }
//  }

//  impl Component for Test {
//      fn children_mut(&mut self) -> Vec<&mut dyn Drawable> {vec![&mut self.1, &mut self.2]}
//      fn children(&self) -> Vec<&dyn Drawable> {vec![&self.1, &self.2]}
//      fn layout(&self) -> &dyn Layout {&self.0}

//      fn on_tick(&mut self, ctx: &mut Context, _max_size: (u32, u32)) {
//          println!("size: {:?}", self.size(ctx));
//      }

//      fn on_click(&mut self, _ctx: &mut Context, position: Option<(u32, u32)>) -> bool {
//          println!("position: {:?}", position);
//          true
//      }
//      fn on_move(&mut self, _ctx: &mut Context, _position: Option<(u32, u32)>) -> bool {
//          true
//      }
//  }

//  let padding = (items.len()-1) as u32 * self.0;
//      println!("padding: {:?}", padding);
//      let min_width = padding+items.iter().fold(None, |s, i| i.min_width().map(|mw| s.map(|s| s+mw).unwrap_or(mw)).or(s)).unwrap_or(0);
//      println!("min_width: {:?}", min_width);
//      let rows = if min_width < row_size.0 {1} else {(min_width as f32 / row_size.0 as f32).ceil() as u32};
//      println!("rows: {:?}", rows);


#[derive(Clone, Debug)]
pub struct Row(pub u32, pub Offset, pub Size);

impl Row {
    fn fit_width(items: Vec<(MinSize, MaxSize)>) -> (MinSize, MaxSize) {
        items.into_iter().reduce(|s, i| (s.0+i.0, s.1+i.1)).unwrap_or_default()
    }

    //Size::Fit => items.into_iter().try_fold(0, |os, s| s.map(|s| os.max(s))),
    fn fit_height(items: Vec<(MinSize, MaxSize)>) -> (MinSize, MaxSize) {
        items.into_iter().reduce(|s, i| (s.0.max(i.0), s.1.max(i.1))).unwrap_or_default()
    }
}


impl Layout for Row {
    fn build(&self, _ctx: &mut Context, row_size: (u32, u32), items: Vec<SizeInfo>) -> Vec<((i32, i32), (u32, u32))> {
        let mut sizes: Vec<_> = items.iter().map(|i| {
            let size = i.get((i.min_width().0, row_size.1));
            (size.0 as f32, size.1)
        }).collect();

        let padding = (items.len()-1) as u32 * self.0;
        let min_width = items.iter().fold(MinSize::default(), |s, i| s+i.min_width())+padding;

        let mut free_space = (row_size.0 as i32 - min_width.0 as i32).max(0) as f32;
        while free_space > 0.0 {
            let (min_exp, count, next) = items.iter().zip(sizes.iter()).fold((None, 0.0, free_space as f32), |(mut me, mut c, mut ne), (i, size)| {
                let width = size.0;
                let max_width = i.max_width().0 as f32;
                if width < max_width { //I can expand
                    match me {
                        Some(w) if w < width => {
                            ne = ne.min(width-w);//Next size could be the min size of next expandable block
                        },
                        Some(w) if w == width => {
                            ne = ne.min(max_width-width);//Next size could be the max size of one of the smallest items
                            c += 1.0;
                        },
                        _ => {
                            ne = ne.min(max_width-width);//Next size could be the max size of one of the smallest items
                            me = Some(width);
                            c = 1.0;
                        }
                    }
                }
                (me, c, ne)
            });
            if min_exp.is_none() {break;}
            let min_exp = min_exp.unwrap();

            let expand = (next*count).min(free_space);//Next size could be the rest of the free_space
            free_space -= expand;
            let expand = expand / count;

            sizes.iter_mut().zip(items.iter()).for_each(|(size, i)| {
                if size.0 < i.max_width().0 as f32 && size.0 == min_exp {
                    size.0 += expand;
                }
            });
        }

        let mut offset = 0;
        sizes.into_iter().map(|size| {
            let width = size.0.floor() as u32;
            let v = ((offset as i32, self.1.get(row_size.1, size.1)), (width, size.1));
            offset += width+self.0;
            v
        }).collect()
    }

    fn size(&self, _ctx: &mut Context, items: Vec<SizeInfo>) -> SizeInfo {
        let (widths, heights): (Vec<_>, Vec<_>) = items.into_iter().map(|i|
            ((i.min_width(), i.max_width()), (i.min_height(), i.max_height()))
        ).unzip();
        let items = widths.len() as u32;
        let padding = self.0*(items-1);
        let width = Row::fit_width(widths);
        let height = self.2.get().unwrap_or_else(|| Row::fit_height(heights));
        let min_width = width.0 + padding;
        let max_width = width.1 + padding;
        println!("Row: {:?},{:?}", min_width, max_width);
        SizeInfo::new(min_width, height.0, max_width, height.1)
    }
}



#[derive(Clone, Debug)]
pub struct Bumper(Row, Button, Button, Button);

impl Bumper {
    pub fn new(ctx: &mut Context, font: Font) -> Self {
        Bumper(
            Row(10, Offset::Center, Size::Fit),
            Button::new(ctx, "HELLO", font.clone(), ButtonSize::Large, ButtonWidth::Expand),
            Button::new(ctx, "HELLO", font.clone(), ButtonSize::Large, ButtonWidth::Expand),
            Button::new(ctx, "HELLOa", font.clone(), ButtonSize::Large, ButtonWidth::Expand),
          //Shape(ShapeType::Ellipse(20, (70, 70)), Color(255, 0, 0, 255)),
          //Button::new(ctx, "BUTTO", font, ButtonSize::Medium, ButtonWidth::Hug),
          //Shape(ShapeType::Ellipse(1, (130, 10)), Color(255, 255, 0, 255)),
        )
    }
}

impl Events for Bumper {}

impl Component for Bumper {
    fn children_mut(&mut self) -> Vec<&mut dyn Drawable> {vec![&mut self.1, &mut self.2, &mut self.3]}
    fn children(&self) -> Vec<&dyn Drawable> {vec![&self.1, &self.2, &self.3]}
    fn layout(&self) -> &dyn Layout {&self.0}
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

#[derive(Clone, Copy, Default, Debug)]
pub enum Size {
    #[default]
    Fit,
    Fill(MinSize, MaxSize),
    Static(u32)
}

impl Size {
    pub fn get(&self) -> Option<(MinSize, MaxSize)> {
        match self {
            Size::Fit => None,
            Size::Fill(min, max) => Some((*min, *max)),
            Size::Static(s) => Some((MinSize(*s), MaxSize(*s)))
        }
    }
}

#[derive(Clone, Debug)]
pub struct Stack(Offset, Offset, Size, Size);
impl Stack {
    fn fit(items: Vec<(MinSize, MaxSize)>) -> (MinSize, MaxSize) {
        items.into_iter().reduce(|s, i| (s.0.max(i.0), s.1.max(i.1))).unwrap_or_default()
    }
}

impl Layout for Stack {
    fn build(&self, _ctx: &mut Context, stack_size: (u32, u32), items: Vec<SizeInfo>) -> Vec<((i32, i32), (u32, u32))> {
        items.into_iter().map(|i| {
            let size = i.get(stack_size);
            let offset = (self.0.get(stack_size.0, size.0), self.1.get(stack_size.1, size.1));
            (offset, size)
        }).collect()
    }

    fn size(&self, _ctx: &mut Context, items: Vec<SizeInfo>) -> SizeInfo {
        let (widths, heights): (Vec<_>, Vec<_>) = items.into_iter().map(|i|
            ((i.min_width(), i.max_width()), (i.min_height(), i.max_height()))
        ).unzip();
        let size = (
            self.2.get().unwrap_or_else(|| Stack::fit(widths)),
            self.3.get().unwrap_or_else(|| Stack::fit(heights))
        );
        SizeInfo::new(size.0.0, size.1.0, size.0.1, size.1.1)
    }
}




pub enum ButtonSize {
    Medium,
    Large,
}

pub enum ButtonWidth {
    Hug,
    Expand,
}

#[derive(Clone, Debug)]
pub struct Button(Stack, Shape, Text, u32, u32);

impl Button {
    pub fn new(ctx: &mut Context, text: &'static str, font: Font, size: ButtonSize, width: ButtonWidth) -> Self {
        let (height, font_size, padding) = match size {
            ButtonSize::Medium => (32, 16, 12),
            ButtonSize::Large => (48, 20, 24),
        };

        let text = Text::new(text, Color::from_hex("eb343a", 255), None, font_size, (font_size as f32*1.25) as u32, font);
        let content_width = text.size(ctx).min_width()+(padding*2);

        let width = match width {
            ButtonWidth::Hug => Size::Fit,
            ButtonWidth::Expand => Size::Fill(content_width, MaxSize::MAX)
        };

        Button(
            Stack(Offset::Center, Offset::Center, width, Size::Fit),
            Shape(ShapeType::RoundedRectangle(0, (content_width.0, height), height/2), Color(0, 255, 255, 255)),
            text,
            0, content_width.0
        )
    }
}

impl Events for Button {
    fn on_tick(&mut self, _ctx: &mut Context) {
        //self.3 += 1;
    }
    fn on_resize(&mut self, _ctx: &mut Context, size: (u32, u32)) {
        //let nw = (self.3 % (size.0-self.4)) + self.4;
        if let ShapeType::RoundedRectangle(_, (w, _), _) = &mut self.1.0 {
            *w = size.0;
        }
    }
}

impl Component for Button {
    fn children_mut(&mut self) -> Vec<&mut dyn Drawable> {vec![&mut self.1, &mut self.2]}
    fn children(&self) -> Vec<&dyn Drawable> {vec![&self.1, &self.2]}
    fn layout(&self) -> &dyn Layout {&self.0}
}


pub struct MyApp;

impl App for MyApp {
    async fn new(ctx: &mut Context<'_>) -> Box<dyn Drawable> {
        println!("START APP");

        let font = resources::Font::new(ctx, include_bytes!("../assets/fonts/outfit_bold.ttf").to_vec());
        //let font2 = resources::Font::new(ctx, include_bytes!("../assets/fonts/outfit_regular.ttf").to_vec());
        //let test = Test::new(font, font2);
        //let test = Button::new(ctx, "HELLO", font, ButtonSize::Large, ButtonWidth::Expand);
        let test = Bumper::new(ctx, font);
        //test.answer();
        Box::new(test)
    }
}

create_entry_points!(MyApp);
