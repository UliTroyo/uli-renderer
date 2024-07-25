const std = @import("std");
const zigimg = @import("zigimg");
const wiggle = @import("wiggle.zig").wiggle;

const VERSION = "v0.3.0";
const WIDTH = 240;
const HEIGHT = 240;
const PIXELS = WIDTH * HEIGHT;

fn drawLine(x0: i32, y0: i32, x1: i32, y1: i32, image: zigimg.Image, color: zigimg.color.Rgba32) void {
    if (x0 == x1 or y0 == y1) {
        straightLine(x0, y0, x1, y1, image, color);
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
        diagonalLine(x1, y1, x0, y0, image, color);
    } else {
        diagonalLine(x0, y0, x1, y1, image, color);
    }
}
fn straightLine(x0: i32, y0: i32, x1: i32, y1: i32, image: zigimg.Image, color: zigimg.color.Rgba32) void {
    if (x0 == x1) {
        // vertical line
        const first_y = if (y0 < y1) y0 else y1;
        const last_y = if (y0 < y1) y1 else y0;

        const first_px = (WIDTH * first_y) + x0;
        const last_px = (WIDTH * last_y) + x0;

        var px = first_px;

        while (px <= last_px) {
            image.pixels.rgba32[@intCast(px)] = color;
            px += WIDTH;
        }
    }
    if (y0 == y1) {
        // horizontal line
        const first_x = if (x0 < x1) x0 else x1;
        const last_x = if (x0 < x1) x1 else x0;

        const first_px = (WIDTH * y0) + first_x;
        const last_px = (WIDTH * y0) + last_x;

        var px = first_px;

        while (px <= last_px) {
            image.pixels.rgba32[@intCast(px)] = color;
            px += 1;
        }
    }
}

fn diagonalLine(x0: i32, y0: i32, x1: i32, y1: i32, image: zigimg.Image, color: zigimg.color.Rgba32) void {
    const run = x1 - x0;
    const rise = y1 - y0;
    const rise_longer_than_run = @abs(run) > @abs(rise);

    if (rise_longer_than_run) {
        // we loop through x's
        const y_should_decrement = rise < 0;
        var adjust: i32 = 1;
        if (y_should_decrement) {
            adjust = -1;
        }
        var threshold = (2 * rise) - run;
        var x = x0;
        var y = y0;
        var px = (WIDTH * y0) + x0;
        const first_x: usize = @intCast(x0);
        const last_x: usize = @intCast(x1 + 1);

        for (first_x..last_x) |_| {
            // std.debug.print("i: {}, x: {}, y: {}\n", .{ i, x, y });
            image.pixels.rgba32[@intCast(px)] = color;
            if (threshold > 0) {
                y += adjust;
                threshold = threshold + (2 * (rise - run));
            } else {
                threshold = threshold + (2 * rise);
            }
            x += 1;
            px = (WIDTH * y) + x;
        }
    } else {
        // we loop through y's
        const x_should_decrement = rise < 0;
        var adjust: i32 = 1;
        if (x_should_decrement) {
            adjust = -1;
        }
        var threshold = (2 * run) - rise;
        var x = x0;
        var y = y0;
        var px = (WIDTH * y0) + x0;
        const first_y: usize = @intCast(y0);
        const last_y: usize = @intCast(y1 + 1);

        for (first_y..last_y) |_| {
            // std.debug.print("i: {}, x: {}, y: {}\n", .{ i, x, y });
            image.pixels.rgba32[@intCast(px)] = color;
            if (threshold > 0) {
                x += adjust;
                threshold = threshold + (2 * (run - rise));
            } else {
                threshold = threshold + (2 * run);
            }
            y += 1;
            px = (WIDTH * y) + x;
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
        const red = zigimg.Colors(zigimg.color.Rgba32).Red;
        const black = zigimg.Colors(zigimg.color.Rgba32).Black;

        for (0..PIXELS) |i| {
            image.pixels.rgba32[i] = black;
        }

        drawLine(100, 10, 100, 200, image, green);
        drawLine(10, 100, 200, 100, image, green);
        drawLine(10, 100, 100, 200, image, green);
        drawLine(100, 10, 200, 100, image, green);
        drawLine(100, 200, 10, 100, image, red);
    }

    const hash = wiggle(std.time.milliTimestamp());
    const filename = "images/" ++ hash ++ "-" ++ VERSION ++ ".png";

    try image.writeToFilePath(filename, .{ .png = .{} });
}
