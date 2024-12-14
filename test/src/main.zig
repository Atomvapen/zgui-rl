const std = @import("std");
const rl = @import("raylib");
const zgui = @import("zgui");
const rlimgui = zgui.backend;

pub fn main() void {
    const screen_width = 1280;
    const screen_height = 800;

    rl.setConfigFlags(.{
        .msaa_4x_hint = true,
        .vsync_hint = true,
        .window_resizable = true,
    });
    rl.initWindow(screen_width, screen_height, "simple ImGui Demo");
    rl.setTargetFPS(144);
    rlimgui.setup(true);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        rl.clearBackground(rl.Color.dark_gray);

        // start ImGui content
        rlimgui.begin();

        var open = true;
        zgui.showDemoWindow(&open);

        rlimgui.end();

        rl.endDrawing();
    }
}
