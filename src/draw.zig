const std = @import("std");
const zigimg = @import("zigimg");

const WIDTH = 2401;
const HEIGHT = 2401;
const PIXELS = WIDTH * HEIGHT;

pub fn drawLine(x0: i32, y0: i32, x1: i32, y1: i32, image: zigimg.Image, color: zigimg.color.Rgba32) void {
    if (x0 == x1 or y0 == y1) {
        straightLine(x0, y0, x1, y1, image, color);
        return;
    }

    const dx = x1 - x0;
    const dy = y1 - y0;

    const more_horizontal_than_vertical = @abs(dx) > @abs(dy);

    if (more_horizontal_than_vertical) {
        if (x0 < x1) {
            horizontalDiagonalLine(x0, y0, x1, y1, image, color);
        } else {
            horizontalDiagonalLine(x1, y1, x0, y0, image, color);
        }
    } else {
        if (y0 < y1) {
            verticalDiagonalLine(x0, y0, x1, y1, image, color);
        } else {
            verticalDiagonalLine(x1, y1, x0, y0, image, color);
        }
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

fn horizontalDiagonalLine(x0: i32, y0: i32, x1: i32, y1: i32, image: zigimg.Image, color: zigimg.color.Rgba32) void {
    const dx = x1 - x0;
    var dy = y1 - y0;
    var adjustment: i32 = 1;
    if (dy < 0) {
        // then y should decrement
        adjustment = -1;
        dy = -dy;
    }
    var d = (2 * dy) - dx; // Difference threshold
    var x = x0;
    var y = y0;
    var px = (WIDTH * y0) + x0;
    const first_x: usize = @intCast(x0);
    const last_x: usize = @intCast(x1);

    for (first_x..last_x) |i| {
        image.pixels.rgba32[@intCast(px)] = color;
        if (d > 0) {
            y = y + adjustment;
            d = d + (2 * (dy - dx));
        } else {
            d = d + 2 * dy;
        }
        x = @intCast(i);
        px = (WIDTH * y) + x;
    }
}

fn verticalDiagonalLine(x0: i32, y0: i32, x1: i32, y1: i32, image: zigimg.Image, color: zigimg.color.Rgba32) void {
    var dx = x1 - x0;
    const dy = y1 - y0;
    var adjustment: i32 = 1;
    if (dx < 0) {
        // then x should decrement
        adjustment = -1;
        dx = -dx;
    }
    var d = (2 * dx) - dy; // Difference threshold
    var x = x0;
    var y = y0;
    var px = (WIDTH * y0) + x0;
    const first_y: usize = @intCast(y0);
    const last_y: usize = @intCast(y1);

    for (first_y..last_y) |i| {
        image.pixels.rgba32[@intCast(px)] = color;
        if (d > 0) {
            x = x + adjustment;
            d = d + (2 * (dx - dy));
        } else {
            d = d + 2 * dx;
        }
        y = @intCast(i);
        px = (WIDTH * y) + x;
    }
}
