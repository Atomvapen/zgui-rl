// rlImgui functions to be used from zgui

const rl = @import("raylib");

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
pub fn image(img: *Texture) void {
    rlImGuiImage(img);
}
pub fn imageSize(img: *Texture, width: c_int, height: c_int) void {
    rlImGuiImageSize(img, width, height);
}
pub fn imageSizeV(img: *Texture, size: Vector2) void {
    rlImGuiImageSizeV(img, size);
}
pub fn imageRect(img: *Texture, destWidth: c_int, destHeight: c_int, srcRect: Rectangle) void {
    rlImGuiImageRect(img, destWidth, destHeight, srcRect);
}
pub fn imageRenderTexture(img: *RenderTexture) void {
    rlImGuiImageRenderTexture(img);
}
pub fn imageRenderTextureFit(img: *RenderTexture, center: bool) void {
    rlImGuiImageRenderTextureFit(img, center);
}
pub fn imageButton(name: [*:0]const u8, img: *Texture) bool {
    rlImGuiImageButton(name, img);
}
pub fn imageButtonSize(name: [*:0]const u8, img: *Texture, size: Vector2) bool {
    rlImGuiImageButtonSize(name, img, size);
}

const Texture = rl.Texture;
const RenderTexture = rl.RenderTexture;
const Vector2 = rl.Vector2;
const Rectangle = rl.Rectangle;

// defined in rlImgui.cpp
extern fn rlImGuiSetup(darkTheme: bool) void;
extern fn rlImGuiBegin() void;
extern fn rlImGuiEnd() void;
extern fn rlImGuiShutdown() void;
extern fn rlImGuiReloadFonts() void;
extern fn rlImGuiBeginDelta(deltaTime: f32) void;
extern fn rlImGuiImage(img: *Texture) void;
extern fn rlImGuiImageSize(img: *Texture, width: c_int, height: c_int) void;
extern fn rlImGuiImageSizeV(img: *Texture, size: Vector2) void;
extern fn rlImGuiImageRect(img: *Texture, destWidth: c_int, destHeight: c_int, srcRect: Rectangle) void;
extern fn rlImGuiImageRenderTexture(img: *RenderTexture) void;
extern fn rlImGuiImageRenderTextureFit(img: *RenderTexture, center: bool) void;
extern fn rlImGuiImageButton(name: [*:0]const u8, img: *Texture) bool;
extern fn rlImGuiImageButtonSize(name: [*:0]const u8, img: *Texture, size: Vector2) bool;
