const std = @import("std");
const zigimg = @import("zigimg");
const Wiggle = @import("wiggle.zig");

const VERSION = "v0.0.0";

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var image = try zigimg.Image.create(allocator, 2, 2, .rgba32);
    defer image.deinit();

    // src.pixel_format.PixelFormat.rgba32
    // const format = zigimg.Image.pixelFormat(image);
    const green = zigimg.Colors(zigimg.color.Rgba32).Green;
    const black = zigimg.Colors(zigimg.color.Rgba32).Black;

    image.pixels.rgba32[0] = black;
    image.pixels.rgba32[1] = green;
    image.pixels.rgba32[2] = green;
    image.pixels.rgba32[3] = black;

    const wiggle = Wiggle.from(std.time.milliTimestamp());

    const filename = wiggle ++ "-" ++ VERSION ++ ".png";

    try image.writeToFilePath(filename, .{ .png = .{} });
}
