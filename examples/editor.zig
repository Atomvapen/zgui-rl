// Taken from raylib-extras rlImGui examples
// https://github.com/raylib-extras/rlImGui/tree/main/examples

const std = @import("std");
const rl = @import("raylib");
const zgui = @import("zgui");

const parrot = @embedFile("parrots.png");

var quit = false;
var imgui_demo_open = false;

const ImageViewerWindow = struct {
    const Self = @This();

    open: bool = false,
    focused: bool = false,
    view_texture: rl.RenderTexture,
    content_rect: rl.Rectangle = std.mem.zeroes(rl.Rectangle),

    image_texture: rl.Texture,
    camera: rl.Camera2D = std.mem.zeroes(rl.Camera2D),
    last_mouse_pos: rl.Vector2 = rl.Vector2.zero(),
    last_target: rl.Vector2 = rl.Vector2.zero(),
    dragging: bool = false,
    dirty_scene: bool = false,

    current_tool_mode: ToolMode = .none,

    const ToolMode = enum {
        none,
        move,
    };

    fn setup(self: *Self) void {
        self.camera.zoom = 1;
        self.camera.target.x = 0;
        self.camera.target.y = 0;
        self.camera.rotation = 0;
        const widthf: f32 = @floatFromInt(rl.getScreenWidth());
        const heightf: f32 = @floatFromInt(rl.getScreenHeight());
        self.camera.offset.x = widthf / 2.0;
        self.camera.offset.y = heightf / 2.0;

        self.view_texture = rl.loadRenderTexture(rl.getScreenWidth(), rl.getScreenHeight());
        const parrot_img = rl.loadImageFromMemory(".png", parrot);
        self.image_texture = rl.loadTextureFromImage(parrot_img);
        parrot_img.unload();

        self.updateRenderTexture();
    }

    fn show(self: *Self) !void {
        zgui.pushStyleVar2f(.{ .idx = .window_padding, .v = .{ 0, 0 } });
        zgui.setNextWindowSize(.{ .w = 400, .h = 400, .cond = .once });

        self.focused = false;

        if (zgui.begin("Image Viewer", .{ .popen = &self.open, .flags = .{ .no_scrollbar = true, .no_scroll_with_mouse = true } })) {
            // save off the screen space content rectangle
            self.content_rect = .{
                .x = zgui.getWindowPos()[0] + zgui.getCursorScreenPos()[0],
                .y = zgui.getWindowPos()[1] + zgui.getCursorScreenPos()[1],
                .width = zgui.getContentRegionAvail()[0],
                .height = zgui.getContentRegionAvail()[1],
            };

            self.focused = zgui.isWindowFocused(.{ .root_window = true, .child_windows = true });

            const size = zgui.getContentRegionAvail();

            // center the scratch pad in the view
            const width: f32 = @floatFromInt(self.view_texture.texture.width);
            const height: f32 = @floatFromInt(self.view_texture.texture.height);
            const view_rect: rl.Rectangle = .{
                .x = width / 2 - size[0] / 2,
                .y = height / 2 - size[1] / 2,
                .width = size[0],
                .height = -size[1],
            };

            if (zgui.beginChild("Toolbar", .{ .w = zgui.getContentRegionAvail()[0], .h = 25 })) {
                zgui.setCursorPosX(2);
                zgui.setCursorPosY(3);

                if (zgui.button("None", .{})) {
                    self.current_tool_mode = .none;
                }
                zgui.sameLine(.{});

                if (zgui.button("Move", .{})) {
                    self.current_tool_mode = .move;
                }
                zgui.sameLine(.{});

                switch (self.current_tool_mode) {
                    .none => zgui.textUnformatted("No Tool"),
                    .move => zgui.textUnformatted("Move Tool"),
                }
                zgui.sameLine(.{});
                var buff: [128]u8 = undefined;
                const text = try std.fmt.bufPrint(&buff, "camera target X{} Y{}", .{ self.camera.target.x, self.camera.target.y });
                zgui.textUnformatted(text);
                zgui.endChild();
            }
            zgui.rlimgui.imageRect(&self.view_texture.texture, @intFromFloat(size[0]), @intFromFloat(size[1]), view_rect);
        }
        zgui.end();
        zgui.popStyleVar(.{});
    }

    fn update(self: *Self) void {
        if (!self.open) return;

        if (rl.isWindowResized()) {
            self.view_texture.unload();
            self.view_texture = rl.loadRenderTexture(rl.getScreenWidth(), rl.getScreenWidth());
            const widthf: f32 = @floatFromInt(rl.getScreenWidth());
            const heightf: f32 = @floatFromInt(rl.getScreenHeight());
            self.camera.offset.x = widthf / 2.0;
            self.camera.offset.y = heightf / 2.0;
        }

        const mouse_pos = rl.getMousePosition();

        if (self.focused) {
            if (self.current_tool_mode == .move) {
                // only when in content area
                if (rl.isMouseButtonDown(.mouse_button_left) and rl.checkCollisionPointRec(mouse_pos, self.content_rect)) {
                    if (!self.dragging) {
                        self.last_mouse_pos = mouse_pos;
                        self.last_target = self.camera.target;
                    }
                    self.dragging = true;
                    var mouse_delta = self.last_mouse_pos.subtract(mouse_pos);

                    mouse_delta.x /= self.camera.zoom;
                    mouse_delta.y /= self.camera.zoom;
                    self.camera.target = self.last_target.add(mouse_delta);

                    self.dirty_scene = true;
                } else {
                    self.dragging = false;
                }
            }
        } else {
            self.dragging = false;
        }

        if (self.dirty_scene) {
            self.dirty_scene = false;
            self.updateRenderTexture();
        }
    }

    fn updateRenderTexture(self: Self) void {
        self.view_texture.begin();
        rl.clearBackground(rl.Color.blue);

        self.camera.begin();

        self.image_texture.draw(@divTrunc(self.image_texture.width, -2), @divTrunc(self.image_texture.height, -2), rl.Color.white);

        self.camera.end();
        self.view_texture.end();
    }

    fn shutdown(self: *Self) void {
        self.view_texture.unload();
        self.image_texture.unload();
    }
};

const SceneViewWindow = struct {
    const Self = @This();

    open: bool = false,
    focused: bool = false,
    view_texture: rl.RenderTexture,
    content_rect: rl.Rectangle = std.mem.zeroes(rl.Rectangle),

    camera: rl.Camera3D = std.mem.zeroes(rl.Camera3D),
    grid_texture: rl.Texture = std.mem.zeroes(rl.Texture),

    fn setup(self: *Self) void {
        self.view_texture = rl.loadRenderTexture(rl.getScreenWidth(), rl.getScreenHeight());

        self.camera.fovy = 45;
        self.camera.up.y = 1;
        self.camera.position.y = 3;
        self.camera.position.z = -25;

        const img = rl.genImageChecked(256, 256, 32, 32, rl.Color.dark_gray, rl.Color.white);
        var grid_texture = rl.loadTextureFromImage(img);
        img.unload();
        rl.genTextureMipmaps(&grid_texture);
        rl.setTextureFilter(grid_texture, .texture_filter_anisotropic_16x);
        rl.setTextureWrap(grid_texture, .texture_wrap_clamp);
    }

    fn shutdown(self: *Self) void {
        self.view_texture.unload();
        self.grid_texture.unload();
    }

    fn show(self: *Self) void {
        zgui.pushStyleVar2f(.{ .idx = .window_padding, .v = .{ 0, 0 } });
        zgui.setNextWindowSize(.{ .w = 400, .h = 400, .cond = .once });

        if (zgui.begin("3D View", .{ .popen = &self.open, .flags = .{ .no_scrollbar = true } })) {
            self.focused = zgui.isWindowFocused(.{ .child_windows = true });
            zgui.rlimgui.imageRenderTextureFit(&self.view_texture, true);
        }
        zgui.end();
        zgui.popStyleVar(.{});
    }

    fn update(self: *Self) void {
        if (!self.open) return;

        if (rl.isWindowResized()) {
            self.view_texture.unload();
            self.view_texture = rl.loadRenderTexture(rl.getScreenWidth(), rl.getScreenHeight());
        }

        const period = 10.0;
        const magnitude = 25.0;
        const timef: f32 = @floatCast(rl.getTime());

        self.camera.position.x = @sin(timef / period) * magnitude;

        self.view_texture.begin();
        rl.clearBackground(rl.Color.sky_blue);

        self.camera.begin();

        // draw world
        rl.drawPlane(rl.Vector3.zero(), .{ .x = 50, .y = 50 }, rl.Color.beige);
        const spacing = 4;
        const count = 5;

        var x: f32 = -count * spacing;
        while (x <= count * spacing) : (x += spacing) {
            var z: f32 = -count * spacing;
            while (z <= count * spacing) : (z += spacing) {
                rl.drawCube(.{ .x = x, .y = 1.5, .z = z }, 1, 1, 1, rl.Color.green);
                rl.drawCube(.{ .x = x, .y = 0.5, .z = z }, 0.25, 1, 0.25, rl.Color.brown);
            }
        }

        self.camera.end();
        self.view_texture.end();
    }
};

var image_viewer: ImageViewerWindow = undefined;
var scene_view: SceneViewWindow = undefined;

fn doMainMenu() void {
    if (zgui.beginMainMenuBar()) {
        if (zgui.beginMenu("File", true)) {
            if (zgui.menuItem("Exit", .{})) quit = true;

            zgui.endMenu();
        }

        if (zgui.beginMenu("Window", true)) {
            if (zgui.menuItem("Imgui Demo", .{})) imgui_demo_open = !imgui_demo_open;
            if (zgui.menuItem("Image Viewer", .{})) image_viewer.open = !image_viewer.open;
            if (zgui.menuItem("3D View", .{})) scene_view.open = !scene_view.open;

            zgui.endMenu();
        }
        zgui.endMainMenuBar();
    }
}

pub fn main() !void {
    const screen_width = 1280;
    const screen_height = 800;

    rl.setConfigFlags(.{ .msaa_4x_hint = true, .vsync_hint = true });
    rl.initWindow(screen_width, screen_height, "raylib-Extras [ImGui] example - ImGui Demo");
    defer rl.closeWindow();
    rl.setTargetFPS(144);
    zgui.rlimgui.setup(true);
    defer zgui.rlimgui.shutdown();
    zgui.io.setConfigWindowsMoveFromTitleBarOnly(true);

    image_viewer.setup();
    image_viewer.open = true;
    defer image_viewer.shutdown();

    scene_view.setup();
    scene_view.open = true;
    defer scene_view.shutdown();

    while (!rl.windowShouldClose() and !quit) {
        image_viewer.update();
        scene_view.update();

        rl.beginDrawing();
        rl.clearBackground(rl.Color.dark_gray);

        zgui.rlimgui.begin();
        doMainMenu();

        if (imgui_demo_open) zgui.showDemoWindow(&imgui_demo_open);
        if (image_viewer.open) try image_viewer.show();
        if (scene_view.open) scene_view.show();

        zgui.rlimgui.end();

        rl.endDrawing();
    }
}
