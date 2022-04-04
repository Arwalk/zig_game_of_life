const std = @import("std");

const GameOfLife = struct {
    board : [50][50]bool,

    fn init_empty() GameOfLife {
        return GameOfLife{
            .board = [_][50]bool{[_]bool{false} ** 50} ** 50
        };
    }

    fn init_random() GameOfLife {
        var random = std.rand.DefaultPrng.init(12).random();
        var game = init_empty();
        for (game.board) |*line| {
            for (line.*) |*cell| {
                cell.* = random.boolean();
            }
        }
        return game;
    }

    fn get_next_state(current: bool, num_neighbours : usize) bool {
        const results : [2][9]bool = comptime blk: {
            var temp : [2][9]bool = .{
                [_]bool{false} ** 9,
                [_]bool{false} ** 9
            };
            for (temp[0]) |*v , i| {
                if(i == 3) {
                    v.* = true;
                }
            }
            for (temp[1]) |*v, i| {
                if(i==2 or i==3) {
                    v.* = true;
                }
            }
            break :blk temp;
        };
        return results[@boolToInt(current)][num_neighbours];
    }
};

pub fn main() anyerror!void {
    std.log.info("All your codebase are belong to us.", .{});
}

const t = std.testing;

test "basic test" {
    var game = GameOfLife.init_empty();
    try t.expect(game.board[0][0] == false);

    game = GameOfLife.init_random();
    std.log.warn("first value {}", .{game.board[0][0]});

    try t.expect(GameOfLife.get_next_state(false, 0) == false);
    try t.expect(GameOfLife.get_next_state(false, 3) == true);
    try t.expect(GameOfLife.get_next_state(true, 5) == false);
    try t.expect(GameOfLife.get_next_state(true, 3) == true);
    try t.expect(GameOfLife.get_next_state(true, 2) == true);
}
