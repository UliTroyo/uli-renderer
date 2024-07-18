const std = @import("std");
const zigimg = @import("zigimg");
const Wiggle = @import("wiggle.zig");

const VERSION = "v0.1.0";
const WIDTH = 240;
const HEIGHT = 240;
const PIXELS = WIDTH * HEIGHT;

pub fn main() !void {
    var image_buffer: [WIDTH * HEIGHT * 4]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&image_buffer);

    const allocator = fba.allocator();

    var image = try zigimg.Image.create(allocator, WIDTH, HEIGHT, .rgba32);
    defer image.deinit();

    // src.pixel_format.PixelFormat.rgba32
    // const format = zigimg.Image.pixelFormat(image);
    const green = zigimg.Colors(zigimg.color.Rgba32).Green;
    const black = zigimg.Colors(zigimg.color.Rgba32).Black;

    for (0..PIXELS) |i| {
        image.pixels.rgba32[i] = black;
    }
    image.pixels.rgba32[28920] = green;
    image.pixels.rgba32[28921] = green;

    const wiggle = Wiggle.from(std.time.milliTimestamp());

    const filename = wiggle ++ "-" ++ VERSION ++ ".png";

    try image.writeToFilePath(filename, .{ .png = .{} });
}
