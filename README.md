# Escape from Valis

[![CircleCI](https://circleci.com/gh/pocuslabs/escape-from-valis.svg?style=svg)](https://circleci.com/gh/pocuslabs/escape-from-valis)

A quick little rogue-like game made with LÖVE.

## Install

### macOS

`brew install --cask love`
`love ./` at the base directory of this repository

### Windows 11

Install love2d from the website, then run the following in Powershell (using the default install directory):

```powershell
Set-Alias lovec 'C:\Program Files\LOVE\lovec.exe'
```

Then change the directory to the project root, and run:

```powershell
lovec .
```

## Notes

## Pixel and tile coordinates

As you read the code, you may notice different naming conventions for coordinate values. These include the traditional "x/y", as well as "ax/ay", "px/py", and "tx/ty".

The convention is that we use "tx/ty" for "tile"-based coordinates, and "px/py" for absolute pixel values. Tile coordinates are simply the coordinates by tile, i.e. the tile at x = 2, assuming the 1-indexed system Lua uses, would live `TILE_SIZE * SCALE` pixels over (the `TILE_SIZE` and `SCALE` values being defined in `mod/constants.lua`).

The "ax/ay" convention is pixel-based, but unlike other pixel values, relates to how the coordinates work in a room, inside a level. If you see "ax/ay", you can assume they are screen coordinates, as opposed to other named coordinates in the room which are relative to the room. For example, coordinates `x = 1, y = 1` would refer to the top-left corner of the room, _not_ the screen overall. If you have `ax = 1, ay = 1`, those values _would_ refer to the absolute screen coordinates.

Currently, this is a very loose and informal spec. It's likely to change -- check the code comments as well for more details!

## Levels and rooms

Each "level" represents, as you might expect, a level in the game. These levels are numbered, starting at level 1. Each level can contain many rooms, at least `MIN_ROOMS` and up to (and including) `MAX_ROOMS` (those constants are defined in `mod/constants.lua`).

In turn, each room will have a width and height between certain constraints, also defined in that constants file. The room will be bound by walls, and may have 1 to 4 "doors", really just openings leading to a path between rooms.

Much of this is still in flux, so stay tuned!

## Testing

We use [`busted`][bust] for testing. You can install `busted` from [luarocks][luarocks], and run the tests locally if you like, in your terminal:

```bash
luarocks install busted
```

Then you'll be able to run `busted` as a binary in the project root to run all the files matching `spec/**/*_spec.lua`. These tests will run automatically using CircleCI on every PR.

## Credits

This game was made by:

- [Richard Kubina][rk]
- [Austin Pocus][ap]
- (Anyone else who comes up in the commit history)

## License

This game is released under the MIT license. See the LICENSE file for details.

[bust]: https://olivinelabs.com/busted
[luarocks]: https://luarocks.org/
[rk]: https://github.com/RichardJohnn
[ap]: https://austinpocus.com
