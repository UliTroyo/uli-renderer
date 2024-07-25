const std = @import("std");
const zigimg = @import("zigimg");
const wiggle = @import("wiggle.zig").wiggle;
const draw = @import("dumb2.zig").drawHead;
// const drawLine = @import("draw.zig").drawLine;

const VERSION = "v0.5.0";
const WIDTH = 2401;
const HEIGHT = 2401;
const PIXELS = WIDTH * HEIGHT;

pub fn main() !void {
    // var image_buffer: [WIDTH * HEIGHT * 4]u8 = undefined;

    // var fba = std.heap.FixedBufferAllocator.init(&image_buffer);
    // const allocator = fba.allocator();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var image = try zigimg.Image.create(allocator, WIDTH, HEIGHT, .rgba32);
    defer image.deinit();

    {
        // src.pixel_format.PixelFormat.rgba32
        // const format = zigimg.Image.pixelFormat(image);

        const green = zigimg.Colors(zigimg.color.Rgba32).Green;
        // const red = zigimg.Colors(zigimg.color.Rgba32).Red;
        const black = zigimg.Colors(zigimg.color.Rgba32).Black;

        for (0..PIXELS) |i| {
            image.pixels.rgba32[i] = black;
        }

        draw(image, green);
    }

    const hash = wiggle(std.time.milliTimestamp());
    const filename = "images/" ++ hash ++ "-" ++ VERSION ++ ".png";

    try image.writeToFilePath(filename, .{ .png = .{} });
}
