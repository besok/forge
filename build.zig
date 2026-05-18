const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_filter = b.option([]const u8, "filter", "Filter tests by name");

    const options = b.addOptions();

    const mod = b.addModule("forge", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    mod.addImport("build_options", options.createModule());

    // Unit tests
    const integration_tests_mod = b.createModule(.{
        .root_source_file = b.path("tests/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    integration_tests_mod.addImport("forge", mod);

    const integration_tests = b.addTest(.{
        .root_module = integration_tests_mod,
        .filters = if (test_filter) |f| &.{f} else &.{},
    });

    const run_tests = b.addRunArtifact(integration_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_tests.step);

}
