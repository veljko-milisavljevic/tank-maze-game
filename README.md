# Tank Maze Game

A local two-player tank duel in Godot 4: two tanks fight with bouncing bullets inside a maze that is generated anew every round.

## Features

- **Procedurally generated maze.** Every round starts in a new random maze (see [Maze generator](#maze-generator)).
- **Two players on one keyboard.** Tanks steer like tanks: rotate left/right, drive forward, reverse more slowly.
- **Bouncing bullets.** Bullets ricochet off maze walls (physics bounce 1.0) and disappear after 3.6 s. A tank can be hit by its own bullet.
- **Ammo and recoil.** Each tank holds 3 shots and reloads one per second. Firing pushes the tank back a little.
- **Spawn protection.** Tanks cannot be hit for the first 3 seconds of a round.
- **Score.** A hit gives the opponent a point and starts a new round with a new maze. Scores persist across rounds through an autoload singleton (`Global`).

## Controls

| Action | Player 1 (red) | Player 2 (green) |
|---|---|---|
| Forward / reverse | `W` / `S` | `↑` / `↓` |
| Rotate | `A` / `D` | `←` / `→` |
| Shoot | `Space` | `Shift` |

## Maze generator

`code/MazeGenerator.gd` uses the **binary tree algorithm**:

1. The level is a grid of 10 × 5 cells. Every cell starts with all four walls.
2. The cells are visited row by row. Each cell removes one wall, chosen at random: the wall **below** it or the wall **to its right**.
   - In the bottom row, it can only open to the right.
   - In the rightmost column, it can only open downwards.
   - The bottom-right cell removes nothing.
3. Removing a wall also removes the matching wall of the neighbouring cell.

Every cell except one adds exactly one passage to an already connected area. The result is a *perfect maze*: every cell is reachable and there is exactly one path between any two cells. The trade-off of this algorithm is a visible bias: the bottom row and the rightmost column are always open corridors.

**Wall encoding.** Each cell stores its walls as a 4-bit mask:

| Bit | Value | Wall |
|---|---|---|
| 0 | 1 | top |
| 1 | 2 | right |
| 2 | 4 | bottom |
| 3 | 8 | left |

A closed cell is `15` (`1 + 2 + 4 + 8`). Opening the wall to the right subtracts `2` from the cell and `8` from its right neighbour. Opening downwards subtracts `4` from the cell and `1` from the cell below. The mask doubles as the tile index: `probaTileMap.svg` holds 16 tiles, one for every wall combination, each with its own collision shape. So `TileMap.set_cell(..., Vector2i(mask, 0))` draws the cell and creates its walls in one step.

`MazeGen/` contains the original standalone prototype of the generator as a separate Godot project.

## Getting started

1. Install [Godot 4.2](https://godotengine.org/download/archive/) (standard build, not .NET). Later 4.x versions should open the project too, but they may ask to convert it.
2. Clone the repository and open `project.godot` in the Godot project manager.
3. Press **F5** (Run Project). The main scene is `scenes/level.tscn`.

The window is 1280 × 720 and uses the Mobile renderer.

## Project structure

```
project.godot        Project settings and input map
code/
  level.gd           Spawns bullets and routes hit signals to the score
  player.gd          Tank movement, shooting, ammo (player 1)
  player2.gd         Same logic with player 2 bindings
  bullet.gd          Bouncing bullet, hit detection, round restart
  GameManager.gd     Score labels
  global.gd          Autoload with the scores
  MazeGenerator.gd   Binary tree maze generator
  Border.gd          Screen border (unused)
scenes/              level, player, bullet, MazeGenerator, score labels
graphics/            Tank, bullet and background sprites (SVG sources + PNG)
probaTileMap.svg     16-tile wall atlas used by the maze
pozadina.svg         Maze background
MazeGen/             Standalone maze-generator prototype
```

## Status

This is a finished hobby prototype, not a polished game. There are no menus, no win condition, no sound and no gamepad support. Player 1 spawns at the centre of the screen and player 2 in the top-left cell.

Known issues:

- Player 1 can spawn on a maze wall line, because the centre of the screen is not always inside a cell.
- `level.tscn` connects a `tree_exiting` signal to `_on_player_tree_exiting`, which is not defined, so Godot logs an error when a tank is destroyed.
- Dead code: `_on_body_entered` in `player.gd` is not connected to any signal (and would call `GM.score2()`, while the function is named `score_2()`), and the resize handler in `code/Border.gd` is never connected.

## Credits

All sprites and tiles were drawn by me in Inkscape. `icon.svg` is Godot's default project icon, © the Godot Engine contributors, [MIT licence](https://godotengine.org/license/).

## License

[MIT](LICENSE)

## Author

**Veljko Milisavljević** · [GitHub](https://github.com/veljko-milisavljevic)
