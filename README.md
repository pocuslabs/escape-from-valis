# Escape from Valis

[![CircleCI](https://circleci.com/gh/pocuslabs/escape-from-valis.svg?style=svg)](https://circleci.com/gh/pocuslabs/escape-from-valis)

A quick little rogue-like game made with LÖVE.

## Install

### macOS

`brew install --cask love`
then run `love main.lua`

### Windows 11

Install love2d from the website, then run the following in Powershell (using the default install directory):

```powershell
Set-Alias lovec 'C:\Program Files\LOVE\lovec.exe'
```

Then change the directory to the project root, and run:

```powershell
lovec .
```

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
- (anyone else who comes up in the commit history)

## License

This game is released under the MIT license. See the LICENSE file for details.

[bust]: https://olivinelabs.com/busted
[luarocks]: https://luarocks.org/
[rk]: https://github.com/RichardJohnn
[ap]: https://austinpocus.com
