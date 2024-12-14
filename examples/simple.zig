// Taken from raylib-extras rlImGui examples
// https://github.com/raylib-extras/rlImGui/tree/main/examples

const rl = @import("raylib");
const zgui = @import("zgui");

pub fn main() void {
    const screen_width = 1280;
    const screen_height = 800;

    rl.setConfigFlags(.{
        .msaa_4x_hint = true,
        .vsync_hint = true,
        .window_resizable = true,
    });
    rl.initWindow(screen_width, screen_height, "raylib-Extras [ImGui] example - simple ImGui Demo");
    defer rl.closeWindow();
    rl.setTargetFPS(144);
    zgui.rlimgui.setup(true);
    defer zgui.rlimgui.shutdown();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        rl.clearBackground(rl.Color.dark_gray);

        // start ImGui Content
        zgui.rlimgui.begin();

        // show ImGui Content
        var open = true;
        zgui.showDemoWindow(&open);

        // end ImGui Content
        zgui.rlimgui.end();

        rl.endDrawing();
    }
}
