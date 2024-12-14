const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "test",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const raylib_zig = b.dependency("raylib-zig", .{ .target = target });
    const zgui = b.dependency("zgui", .{
        .target = target,
        .backend = .raylib,
    });
    exe.root_module.addImport("raylib", raylib_zig.module("raylib"));
    exe.root_module.addImport("zgui", zgui.module("root"));
    exe.linkLibrary(raylib_zig.artifact("raylib"));
    exe.linkLibrary(zgui.artifact("imgui"));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
