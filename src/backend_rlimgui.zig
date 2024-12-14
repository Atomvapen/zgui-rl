// rlImgui functions to be used from zgui

pub fn setup(dark_theme: bool) void {
    rlImGuiSetup(dark_theme);
}
pub fn begin() void {
    rlImGuiBegin();
}
pub fn end() void {
    rlImGuiEnd();
}
pub fn shutdown() void {
    rlImGuiShutdown();
}
pub fn reloadFonts() void {
    rlImGuiReloadFonts();
}
pub fn beginDelta(deltaTime: f32) void {
    rlImGuiBeginDelta(deltaTime);
}
pub fn image(img: *const Texture) void {
    rlImGuiImage(img);
}
pub fn imageSize(img: *const Texture, width: c_int, height: c_int) void {
    rlImGuiImageSize(img, width, height);
}
pub fn imageSizeV(img: *const Texture, size: Vector2) void {
    rlImGuiImageSizeV(img, size);
}
pub fn imageRect(img: *const Texture, destWidth: c_int, destHeight: c_int, sourceRect: Rectangle) void {
    rlImGuiImageRect(img, destWidth, destHeight, sourceRect);
}
pub fn imageRenderTexture(img: *const RenderTexture) void {
    rlImGuiImageRenderTexture(img);
}
pub fn imageRenderTextureFit(img: *const RenderTexture, center: bool) void {
    rlImGuiImageRenderTextureFit(img, center);
}
pub fn imageButton(name: [*:0]const u8, img: *const Texture) bool {
    rlImGuiImageButton(name, img);
}
pub fn imageButtonSize(name: [*:0]const u8, img: *const Texture, size: Vector2) bool {
    rlImGuiImageButtonSize(name, img, size);
}

const Texture = extern struct {
    id: c_uint,
    width: c_int,
    height: c_int,
    mipmaps: c_int,
    format: c_int,
};
const RenderTexture = extern struct {
    id: c_uint,
    texture: Texture,
    depth: Texture,
};
const Vector2 = extern struct {
    x: f32,
    y: f32,
};
const Rectangle = extern struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,
};

// defined in rlImgui.cpp
extern fn rlImGuiSetup(darkTheme: bool) void;
extern fn rlImGuiBegin() void;
extern fn rlImGuiEnd() void;
extern fn rlImGuiShutdown() void;
extern fn rlImGuiReloadFonts() void;
extern fn rlImGuiBeginDelta(deltaTime: f32) void;
extern fn rlImGuiImage(img: *const Texture) void;
extern fn rlImGuiImageSize(img: *const Texture, width: c_int, height: c_int) void;
extern fn rlImGuiImageSizeV(img: *const Texture, size: Vector2) void;
extern fn rlImGuiImageRect(img: *const Texture, destWidth: c_int, destHeight: c_int, sourceRect: Rectangle) void;
extern fn rlImGuiImageRenderTexture(img: *const RenderTexture) void;
extern fn rlImGuiImageRenderTextureFit(img: *const RenderTexture, center: bool) void;
extern fn rlImGuiImageButton(name: [*:0]const u8, img: *const Texture) bool;
extern fn rlImGuiImageButtonSize(name: [*:0]const u8, img: *const Texture, size: Vector2) bool;
