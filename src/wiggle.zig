const std = @import("std");

const digits = [_]u8{ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };
const base22 = [_]u8{ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'j', 'k', 'm', 'n', 'p', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };
const base32 = digits ++ base22;

fn dateHash(now: i64) i64 {
    const jan_1_2020 = 1577836800000;
    return (now - jan_1_2020);
}

pub fn from(timestamp: i64) [6]u8 {
    var arr: [6]u8 = undefined;
    var cycles: u8 = 0;
    var remaining_seconds: u64 = @intCast(@divFloor(dateHash(timestamp), 1000));

    while (remaining_seconds > 0 and cycles < 6) {
        if (cycles < 4) {
            arr[5 - cycles] = base32[remaining_seconds % 32];
            remaining_seconds = @divFloor(remaining_seconds, 32);
            cycles += 1;
        } else {
            arr[5 - cycles] = base22[remaining_seconds % 22];
            remaining_seconds = @divFloor(remaining_seconds, 22);
            cycles += 1;
        }
    }
    return arr;
}
