# capabilities-via

This package defines strategies to generate implementations of capabilities
using the `DerivingVia` language extension added in GHC 8.6.

## Examples

An example is provided in [`WordCount`](examples/WordCount.hs).
Execute the following commands to try it out:

```
$ nix-shell --pure --run "cabal configure --enable-tests"
$ nix-shell --pure --run "cabal repl examples"

ghci> wordAndLetterCount "ab ba"
Letters
'a': 2
'b': 2
Words
"ab": 1
"ba": 1
```

To execute all examples and see if they produce the expected results run

```
$ nix-shell --pure --run "cabal test examples --show-details=streaming --test-option=--color"
```

## Nix Shell

Many of this package's dependencies require patches to build with GHC 8.6.
These patches are defined [`nix/haskell/default.nix`](nix/haskell/default.nix).
A development environment with all patched dependencies in scope is defined in
[`shell.nix`](shell.nix). When additional dependencies are added to the Cabal
file, execute the following line to add these new dependencies to the Nix
Shell.

```
$ ./nix/scripts/update-haskell-deps
```
