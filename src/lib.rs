//use pelican_ui::prelude::*;
// use pelican_ui::prelude::Text;
// use pelican_ui::custom::*;

use rust_on_rails::prelude::*;

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
            Self::Static(s) => *s as i32,
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

#[derive(Clone, Debug, Default)]
pub struct Padding(pub u32, pub u32, pub u32, pub u32);

impl Padding {
    pub fn new(p: u32) -> Self {Padding(p, p, p, p)}

    fn adjust_size(&self, size: (u32, u32)) -> (u32, u32) {
        let wp = self.0+self.2;
        let hp = self.1+self.3;
        (size.0-wp, size.1-hp)
    }

    fn adjust_offset(&self, offset: (i32, i32)) -> (i32, i32) {
        (offset.0+self.0 as i32, offset.1+self.1 as i32)
    }

    fn adjust_info(&self, info: SizeInfo) -> SizeInfo {
        let wp = self.0+self.2;
        let hp = self.1+self.3;
        SizeInfo::new(info.min_width()+wp, info.min_height()+hp, info.max_width()+wp, info.max_height()+hp)
    }
}

pub struct UniformExpand;
impl UniformExpand {
    pub fn get(sizes: Vec<(u32, u32)>, max_size: u32, spacing: u32) -> Vec<u32> {
        let spacing = (sizes.len()-1) as u32 * spacing;
        let min_size = sizes.iter().fold(0, |s, i| s+i.0)+spacing;

        let mut sizes = sizes.into_iter().map(|s| (s.0 as f32, s.1)).collect::<Vec<_>>();

        let mut free_space = (max_size as i32 - min_size as i32).max(0) as f32;
        while free_space > 0.0 {
            let (min_exp, count, next) = sizes.iter().fold((None, 0.0, free_space as f32), |(mut me, mut c, mut ne), size| {
                let min = size.0 as f32;
                let max = size.1 as f32;
                if min < max { //I can expand
                    match me {
                        Some(w) if w < min => {
                            ne = ne.min(min-w);//Next size could be the min size of next expandable block
                        },
                        Some(w) if w == min => {
                            ne = ne.min(max-min);//Next size could be the max size of one of the smallest items
                            c += 1.0;
                        },
                        Some(w) if w > min => {
                            ne = ne.min(max-min).min(w-min);//Next size could be the max size of one of the smallest items
                            me = Some(min);
                            c = 1.0;
                        },
                        _ => {
                            ne = ne.min(max-min);//Next size could be the max size of one of the smallest items
                            me = Some(min);
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

            sizes.iter_mut().for_each(|size| {
                if size.0 < size.1 as f32 && size.0 == min_exp {
                    size.0 += expand;
                }
            });
        }
        sizes.into_iter().map(|s| s.0.floor() as u32).collect()
    }
}


#[derive(Clone, Debug)]
pub struct Row(pub u32, pub Offset, pub Size, pub Padding);

impl Row {
    pub fn center(spacing: u32) -> Self {
        Row(spacing, Offset::Center, Size::Fit, Padding::default())
    }
    fn fit_width(items: Vec<(MinSize, MaxSize)>) -> (MinSize, MaxSize) {
        items.into_iter().reduce(|s, i| (s.0+i.0, s.1+i.1)).unwrap_or_default()
    }

    fn fit_height(items: Vec<(MinSize, MaxSize)>) -> (MinSize, MaxSize) {
        items.into_iter().reduce(|s, i| (s.0.max(i.0), s.1.max(i.1))).unwrap_or_default()
    }
}


impl Layout for Row {
    fn build(&self, _ctx: &mut Context, row_size: (u32, u32), items: Vec<SizeInfo>) -> Vec<((i32, i32), (u32, u32))> {
        let row_size = self.3.adjust_size(row_size);

        let widths = UniformExpand::get(items.iter().map(|i| (i.min_width().0, i.max_width().0)).collect::<Vec<_>>(), row_size.0, self.0);

        let mut offset = 0;
        items.into_iter().zip(widths.into_iter()).map(|(i, width)| {
            let size = i.get((width, row_size.1));
            let off = self.3.adjust_offset((offset as i32, self.1.get(row_size.1, size.1)));
            offset += size.0+self.0;
            (off, size)
        }).collect()
    }

    fn size(&self, _ctx: &mut Context, items: Vec<SizeInfo>) -> SizeInfo {
        let (widths, heights): (Vec<_>, Vec<_>) = items.into_iter().map(|i|
            ((i.min_width(), i.max_width()), (i.min_height(), i.max_height()))
        ).unzip();
        let spacing = self.0*(widths.len() as u32-1);
        let width = Self::fit_width(widths);
        let height = self.2.get().unwrap_or_else(|| Self::fit_height(heights));
        self.3.adjust_info(SizeInfo::new(width.0+spacing, height.0, width.1+spacing, height.1))
    }
}

#[derive(Clone, Debug)]
pub struct Column(pub u32, pub Offset, pub Size, pub Padding);

impl Column {
    pub fn center(spacing: u32) -> Self {
        Column(spacing, Offset::Center, Size::Fit, Padding::default())
    }
    fn fit_width(items: Vec<(MinSize, MaxSize)>) -> (MinSize, MaxSize) {
        items.into_iter().reduce(|s, i| (s.0.max(i.0), s.1.max(i.1))).unwrap_or_default()
    }

    fn fit_height(items: Vec<(MinSize, MaxSize)>) -> (MinSize, MaxSize) {
        items.into_iter().reduce(|s, i| (s.0+i.0, s.1+i.1)).unwrap_or_default()
    }
}


impl Layout for Column {
    fn build(&self, _ctx: &mut Context, col_size: (u32, u32), items: Vec<SizeInfo>) -> Vec<((i32, i32), (u32, u32))> {
        let col_size = self.3.adjust_size(col_size);

        let heights = UniformExpand::get(items.iter().map(|i| (i.min_height().0, i.max_height().0)).collect::<Vec<_>>(), col_size.1, self.0);

        let mut offset = 0;
        items.into_iter().zip(heights.into_iter()).map(|(i, height)| {
            let size = i.get((col_size.0, height));
            let off = self.3.adjust_offset((self.1.get(col_size.0, size.0), offset as i32));
            offset += size.1+self.0;
            (off, size)
        }).collect()
    }

    fn size(&self, _ctx: &mut Context, items: Vec<SizeInfo>) -> SizeInfo {
        let (widths, heights): (Vec<_>, Vec<_>) = items.into_iter().map(|i|
            ((i.min_width(), i.max_width()), (i.min_height(), i.max_height()))
        ).unzip();
        let spacing = self.0*(heights.len() as u32-1);
        let width = self.2.get().unwrap_or_else(|| Self::fit_width(widths));
        let height = Self::fit_height(heights);
        self.3.adjust_info(SizeInfo::new(width.0, height.0+spacing, width.1, height.1+spacing))
    }
}




#[derive(Clone, Debug, Default)]
pub struct Stack(pub Offset, pub Offset, pub Size, pub Size, pub Padding);
impl Stack {
    pub fn center() -> Self {
        Stack(Offset::Center, Offset::Center, Size::Fit, Size::Fit, Padding::default())
    }
    fn fit(items: Vec<(MinSize, MaxSize)>) -> (MinSize, MaxSize) {
        items.into_iter().reduce(|s, i| (s.0.max(i.0), s.1.max(i.1))).unwrap_or_default()
    }
}

impl Layout for Stack {
    fn build(&self, _ctx: &mut Context, stack_size: (u32, u32), items: Vec<SizeInfo>) -> Vec<((i32, i32), (u32, u32))> {
        let stack_size = self.4.adjust_size(stack_size);
        items.into_iter().map(|i| {
            let size = i.get(stack_size);
            let offset = (self.0.get(stack_size.0, size.0), self.1.get(stack_size.1, size.1));
            (self.4.adjust_offset(offset), size)
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
        self.4.adjust_info(SizeInfo::new(size.0.0, size.1.0, size.0.1, size.1.1))
    }
}

#[derive(Debug, Clone, Component)]
pub struct Bin<L: Layout + Clone, D: Drawable + Clone>(pub L, pub D);
impl<L: Layout + Clone, D: Drawable + Clone> Events for Bin<L, D> {}

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

//  #[derive(Clone, Debug, Component)]
//  pub struct Bumper(Row, Button, Button);
//  impl Events for Bumper {}

//  impl Bumper {
//      pub fn new(ctx: &mut Context) -> Self {
//          Bumper(
//              Row(16, Offset::Center, Size::Fit),
//              Button::new(
//                  ctx,
//                  Some(AvatarContent::Icon("profile", AvatarIconStyle::Secondary)),
//                  None,
//                  Some("Paste"),
//                  None,
//                  ButtonSize::Large,
//                  ButtonWidth::Expand,
//                  ButtonStyle::Primary,
//                  ButtonState::Default,
//                  |_ctx: &mut Context, position: (u32, u32)| println!("BOTTETTTEN...: {:?}", position)
//              ),
//              Button::new(
//                  ctx,
//                  Some(AvatarContent::Icon("settings", AvatarIconStyle::Secondary)),
//                  None,
//                  Some("Paste"),
//                  None,
//                  ButtonSize::Large,
//                  ButtonWidth::Expand,
//                  ButtonStyle::Secondary,
//                  ButtonState::Default,
//                  |_ctx: &mut Context, position: (u32, u32)| println!("Pasting...: {:?}", position)
//              )
//          )
//      }
//  }

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
    async fn new(_ctx: &mut Context<'_>) -> Box<dyn Drawable> {
//      let plugin = PelicanUI::init(ctx);
//      ctx.configure_plugin(plugin);

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

      //Box::new(
      //    TextInput::new(
      //        ctx,
      //        None,
      //        None,
      //        "Search names...",
      //        Some(("close", |_ctx: &mut Context, position: (u32, u32)| println!("Pasting...: {:?}", position))),
      //        None,
      //        None
      //    )
      //)

        // Box::new(Alert::new(ctx, "You were booted from this room."))
        Box::new(RowTest::new())

      //Box::new(Bin(Stack(
      //    Offset::End, Offset::End, Size::Fill(MinSize(0), MaxSize(u32::MAX)), Size::Fill(MinSize(0), MaxSize(u32::MAX)), Padding(10, 20, 50, 100)
      //),
      //    Shape(ShapeType::Rectangle(0, (100, 100)), Color(0, 0, 255, 255))
      //))

    }
}

create_entry_points!(MyApp);
