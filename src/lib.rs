use rust_on_rails::*;
use std::collections::HashMap;

pub struct MyApp {
    image: image::RgbaImage,
    image2: image::RgbaImage,
    fonts: HashMap<&'static str, Vec<u8>>
}

impl App for MyApp {
    async fn new() -> Self {
        MyApp{
            image: image::load_from_memory(include_bytes!("../assets/images/pfp.png")).unwrap().to_rgba8(),
            image2: image::load_from_memory(include_bytes!("../assets/images/pfp2.png")).unwrap().to_rgba8(),
            fonts: HashMap::from([
                ("Bold", include_bytes!("../assets/fonts/outfit_bold.ttf").to_vec()),
                ("Regular", include_bytes!("../assets/fonts/outfit_regular.ttf").to_vec())
            ])
        }
    }

    async fn draw(&mut self, ctx: &mut Context<'_>, width: u32, height: u32) -> Vec<Mesh> {
        let bound = (0, 0, width, height);
        vec![
            Mesh{
                mesh_type: MeshType::Shape(Shape::Rectangle(510, 510), "0f0f0f"),
                offset: (95, 95),
                z_index: 2,
                bound
            },
            Mesh{
                mesh_type: MeshType::Image(Shape::Rectangle(100, 100), self.image.clone()),
                offset: (100, 100),
                z_index: 1,
                bound
            },
            Mesh{
                mesh_type: MeshType::Image(Shape::Circle(150), self.image2.clone()),
                offset: (200, 200),
                z_index: 1,
                bound
            },
            Mesh{
                mesh_type: MeshType::Shape(Shape::Rectangle(300, (48.0+12.48) as u32), "0000ff"),
                offset: (100, 110),
                z_index: 0,
                bound
            },
            Mesh{
                mesh_type: MeshType::Text("eb343a", None, "TenTwenty", self.fonts.get("Regular").unwrap(), 48.0, 48.0 * 1.25),
                offset: (0, 0),
                z_index: 1,
                bound
            }
        ]
    }
}

create_entry_points!(CanvasApp::<MyApp>);
