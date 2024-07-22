const std = @import("std");
const zigimg = @import("zigimg");
const wiggle = @import("wiggle.zig").wiggle;

const VERSION = "v0.1.0";
const WIDTH = 240;
const HEIGHT = 240;
const PIXELS = WIDTH * HEIGHT;

fn drawLine(x0: i32, y0: i32, x1: i32, y1: i32) void {
    if (x0 == x1) {
        // horizontal line
        return;
    }
    if (y0 == y1) {
        // vertical line
        return;
    }

    const dx = x1 - x0;
    const dy = y1 - y0;

    const run_longer_than_rise = @abs(dx) > @abs(dy);
    const rise_longer_than_run = @abs(dy) > @abs(dx);

    const y_decrements = dy < 0;
    const x_decrements = dx < 0;

    const wrong_y = rise_longer_than_run and y_decrements;
    const wrong_x = run_longer_than_rise and x_decrements;

    const flip = wrong_x or wrong_y;

    if (flip) {
        line(x1, y1, x0, y0);
    } else {
        line(x0, y0, x1, y1);
    }
}

fn line(x0: i32, y0: i32, x1: i32, y1: i32) void {
    const dx = x1 - x0;
    const dy = y1 - y0;
    const run_longer_than_rise = @abs(dy) > @abs(dx);

    if (run_longer_than_rise) {
        // we loop through y's
        var offset = if (dx < 0) -1 else 1;
        var threshold = (2 * dx) - dy;
        var x = x0;

        while (y < y1) {
            // plot(x,y)
            if (threshold > 0) {
                x = x + offset;
                D = D + (2 * (dx - dy));
            } else {
                D = D + (2 * dx);
            }
        }
    } else {
        // we loop through x's
        var offset = if (dy < 0) -1 else 1;
        var threshold = (2 * dy) - dx;
        var y = y0;

        while (x < x1) {
            // plot(y,x)
            if (threshold > 0) {
                y = y + offset;
                D = D + (2 * (dy - dx));
            } else {
                D = D + (2 * dy);
            }
        }
    }
}

pub fn main() !void {
    var image_buffer: [WIDTH * HEIGHT * 4]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&image_buffer);

    const allocator = fba.allocator();

    var image = try zigimg.Image.create(allocator, WIDTH, HEIGHT, .rgba32);
    defer image.deinit();

    {
        // src.pixel_format.PixelFormat.rgba32
        // const format = zigimg.Image.pixelFormat(image);
        const green = zigimg.Colors(zigimg.color.Rgba32).Green;
        const black = zigimg.Colors(zigimg.color.Rgba32).Black;

        for (0..PIXELS) |i| {
            image.pixels.rgba32[i] = black;
        }
        image.pixels.rgba32[28920] = green;
        image.pixels.rgba32[28921] = green;
    }

    const hash = wiggle(std.time.milliTimestamp());
    const filename = "images/" ++ hash ++ "-" ++ VERSION ++ ".png";

    try image.writeToFilePath(filename, .{ .png = .{} });
}
