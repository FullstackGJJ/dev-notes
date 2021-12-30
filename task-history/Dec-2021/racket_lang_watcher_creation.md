# For creating racket auto re-running CLI for faster feedback crucial for development

**Problem**: Racket lang eco system currently does not have a polling file watcher that is crucial for people who use docker containers as development environments but still want to have tests to auto re-run

**Solution**: TBD

**Relevant skills before**:
- Racket Lang - 0
- Scientific expert driven design - 3

**Relevant skills before**:
- Racket Lang - TBD
- Scientific expert driven design - 3

Tutorials:
- https://docs.racket-lang.org/pkg/getting-started.html

How-to's:
- 

Explanations:
- 

References:
- https://download.racket-lang.org/releases/6.0.1/doc/raco/test.html
- https://github.com/dannypsnl/raco-watch
- https://github.com/zyrolasting/file-watchers/blob/master/cli.rkt
- https://github.com/zyrolasting/file-watchers/blob/master/robust-watch.rkt

## Thought Process:
---

**Question**
: Does there exist a file watcher, similar to Haskell's ghcid, that can be used to re-run tests?

**Hypothesis**
: Based on this package (https://github.com/dannypsnl/raco-watch), it looks like it should exist. However, I can't seem to find an argument on how to install a package globally in raco official documentation (https://docs.racket-lang.org/pkg/getting-started.html). I will install with the command `raco pkg install --auto raco-watch` and test it out and running `raco watch -c "raco tests ."` and tests should automatically re-run after every file change

**Observation**
: After trying `raco pkg install --auto raco-watch` and running `raco watch -c "raco tests ."`, I did get the result of tests running after every file change but it would run it multiple times instead of just once as I would want. I think this is a result of the file system notification acting weird due to me running raco inside a docker container in Windows WSL. The way I got around this issue in Haskell's `ghcid` was to set a `--poll` flag so that the system would poll on the file system instead of relying on the racket's `file-watcher` event system.

---

**Question**
: Is there a polling based file watcher that I can use to help circumvent the issues caused by using Docker containers just like I use for Haskell's ghcid?

**Hypothesis**
: Based on the fact that `raco-watch` is built ontop of `file-watchers` (https://github.com/dannypsnl/raco-watch/blob/develop/main.rkt#L3) and `file-watchers` supports polling based file change detection (https://docs.racket-lang.org/file-watchers/index.html#%28def._%28%28lib._file-watchers%2Fmain..rkt%29._robust-watch%29%29), I expect bypassing `raco-watch` to use `file-watchers` directly would give me the results I am looking for. I will try `raco file-watchers -h` and the CLI interface should give me a way to have poll based re-running of commands

**Observation**
: When I tried `raco file-watchers -h`, I did not get a helpful CLI interface to be able to create a poll based file watching command or be able to use it to auto re-run unit tests. This means I should look into the main method of the code for the package to learn how to actually give it the commands it should be re-running. If it does not have a mechanism for that, then maybe it is only meant to alert of file change and not to execute any action.

---

**Question**
: Is it possible to get file-watcher to re-run tests on file change?

**Hypothesis**
: Based on examining the CLI code for `file-watchers` (https://github.com/zyrolasting/file-watchers/blob/master/cli.rkt) and also the code of interest (https://github.com/zyrolasting/file-watchers/blob/master/robust-watch.rkt) it looks like there is no great way to pipe a command into the CLI for it to poll on the filesystem to watch for changes. I expect that I would have to create a new library/package that utilizes `file-watchers` similar to how `raco-watch` does but expose enough functionality of `file-watchers` that a user can call the `robust-watch` functionality that uses polling. I will see what will go into making a new package that can be deployed and installed onto docker images and it should be usable across the board.

**Observation**
: 

---
