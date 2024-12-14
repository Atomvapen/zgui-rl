# rlImGui bindings for zig
[rlImGui](https://github.com/raylib-extras/rlImGui) backend for the [zgui](https://github.com/zig-gamedev/zgui) Dear ImGui bindings

## Getting started

`zig fetch --save https://github.com/jan-beukes/zgui-rl/archive/refs/heads/main.tar.gz`

### Example:
`build.zig`:
```zig

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{ ... });

    const zgui = b.dependency("zgui", .{});
    exe.root_module.addImport("zgui", zgui.module("root"));
    exe.linkLibrary(zgui.artifact("imgui"));

    const rl = b.dependency("raylib-zig", .{});
    exe.root_module.addImport("raylib", rl.module("raylib"));
    exe.linkLibrary(rl.artifact("raylib"));

    b.installArtifact(exe);
    
}
```

`main.zig`
```zig
const rl = @import("raylib");
const zgui = @import("zgui");

pub fn main() void {
    const screen_width = 1280;
    const screen_height = 800;

    rl.initWindow(screen_width, screen_height, "raylib-Extras [ImGui] example - simple ImGui Demo");
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
```





