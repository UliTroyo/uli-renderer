const std = @import("std");
const zigimg = @import("zigimg");
const drawLine = @import("draw.zig").drawLine;

pub fn drawHead(image: zigimg.Image, color: zigimg.color.Rgba32) void {
    std.debug.print("1: (0, 0) (2400, 2000)\n", .{});
    drawLine(0, 0, 2400, 2000, image, color);

    std.debug.print("2: (0, 0) (2000, 2400)\n", .{});
    drawLine(0, 0, 2000, 2400, image, color);

    std.debug.print("3: (2400, 2000) (0, 0)\n", .{});
    drawLine(2400, 2000, 0, 0, image, color);

    std.debug.print("4: (2000, 2400) (0, 0)\n", .{});
    drawLine(2000, 2400, 0, 0, image, color);

    std.debug.print("5: (0, 2000) (2400, 0)\n", .{});
    drawLine(0, 2000, 2400, 0, image, color);

    std.debug.print("6: (0, 2400) (2000, 0)\n", .{});
    drawLine(0, 2400, 2000, 0, image, color);

    std.debug.print("7: (2000, 0) (0, 2400)\n", .{});
    drawLine(2000, 0, 0, 2400, image, color);

    std.debug.print("8: (2400, 0) (0, 2000)\n", .{});
    drawLine(2400, 0, 0, 2000, image, color);

    std.debug.print("9: (1200, 0) (1200, 2400)\n", .{});
    drawLine(1200, 0, 0, 2400, image, color);
}
