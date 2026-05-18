const std = @import("std");
const forge = @import("forge");

test "SLOB: initialization" {
    var buffer: [256]u8 = undefined;
    var slob = forge.SlobAllocator.init(&buffer);

    const allocator = slob.allocator();
    const ptr = try allocator.create(u32);
    defer allocator.destroy(ptr);

    ptr.* = 100;
    try std.testing.expectEqual(@as(u32, 100), ptr.*);
}