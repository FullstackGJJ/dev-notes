# For creating racket auto re-running CLI for faster feedback loop crucial for development

**Problem**: Racket lang eco system currently does not have a polling file watcher that is crucial for people who use docker containers as development environments but still want to have tests to auto re-run

**Solution**: TBD

**Relevant skills before**:
- Racket Lang - 0
- Scientific expert driven design - 3

**Relevant skills before**:
- Racket Lang - TBD
- Scientific expert driven design - 3

## Tutorials:
- https://docs.racket-lang.org/pkg/getting-started.html

## How-to's:

## Explanations:

## References:
- https://download.racket-lang.org/releases/6.0.1/doc/raco/test.html
- https://github.com/dannypsnl/raco-watch
- https://github.com/zyrolasting/file-watchers/blob/master/cli.rkt
- https://github.com/zyrolasting/file-watchers/blob/master/robust-watch.rkt
- https://docs.racket-lang.org/file-watchers/index.html#%28def._%28%28lib._file-watchers%2Fmain..rkt%29._robust-watch%29%29
- https://github.com/zyrolasting/file-watchers/blob/master/cli.rkt#L60
- https://docs.racket-lang.org/raco/exe.html

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
: When I looked into the process of making a new package, I was able to find that there is a way to deploy and install packages by simply cloning a repo and installing it with `raco pkg install` while being inside the repo directory. I see how making packages install globally by default simplifies a lot of deployment processes.

---

**Question**
: _What pieces do I need to have a minimally working package that can be called by raco?_

**Hypothesis**
: Based on knowing _how `raco-watch` edited its `info.rkt` and the way the code calls `file-watcher` inside `main.rkt`,_ I expect _that piping the command into file-watcher but allow the user to call more options can be more flexible_  because _file-watcher already enables so many options out of the gate_. I will try _playing around with `raco-watch` code but only have it expose `file-watcher` polling code_ and _a working program that can re-run tests upon file-change_ should be the result

**Observation**
: When I tried _porting over the `raco watch` code_ I did get _it to work with the `file-watcher` watch module but not yet with the `robust-watch` module_.  _I also didn't get the prefix declaration for module imports to work correctly yet. I'm not sure how to get the `robust-watch` to work yet as I'm not sure it's just a simple swap from using the `watch` module from `file-watcher`_

---

**Question**
: _How do I run a `file-watcher` `robust-watch` instead of the normal `watch` inside of a `thread-wait`?_

**Hypothesis**
: Based on knowing _the fact that `file-watcher` already has `robust-watch`_ I expect _to be able to call it to execute a system command_ because _the default `watch` module allows for that_. I will try _to examine different ways to call it in the repl_ and _there should be a way to feed the commands I want to be re-run_

**Observation**
: When I tried _examining different ways to call `file-watcher` -> `robust-watch` in the repl_ I didn't get _to see the re-run working in the repl_.  _I think this means that there's something I'm not understanding with getting main modules to work in repl. Will have to think of other strategies_

---

**Question**
: _How does the interface for `file-watcher` CLI use `watch` contract module allow the use of `robust-watch`?_

**Hypothesis**
: Based on _https://github.com/zyrolasting/file-watchers/blob/master/cli.rkt#L60_ I expect _passing in `robust-watch` in as the `method` argument will work_ because _the interface for watch https://github.com/zyrolasting/file-watchers/blob/master/main.rkt#L54 performs whatever lambda method you provide onto the `on-activity` argument_. I will try _copying https://github.com/zyrolasting/file-watchers/blob/master/cli.rkt#L60 way of calling watch and place displayln_ and _the code should run_

**Observation**
: When I tried _copying `file-watcher` CLI example_ I did get _the code to run_.  _I need to find where the stand alone executable lives though_

---

**Question**
: _How do you create a racket executable?_

**Hypothesis**
: Based on _documentation https://docs.racket-lang.org/raco/exe.html_ I expect _to be able to create a Unix executable_ because _one of the flags seem to give that feature_. I will try _the command `raco exe main.rkt_ and _an executable called `main`_ should come out

**Observation**
: When I tried _the command `raco exe main.rkt -o watcher_ I did get _a `main` executable to come out and was able to run it with `./main --help` call. I also unfortunately saw that it ran the same command `raco test .` 3 times just as the undesirable behavior that I saw from `raco watch` program_.  _I'm not sure why it's having the same issue, especially when I'm specifically using the file polling way for detecting file changes_

---

**Question**
: _Why is `thread-wait (watch path* (lambda (lst) (system (cmd)) displayln robust-watch))` causing the command `raco test .` to run 3 duplicate times upon file change?_

**Hypothesis**
: Based on seeing _console output of thread logs it seems that `intensive watcher` threads are the ones running instead of the `robust watchers` that I was hoping for._ I expect _that if robust watchers are running instead of intensive watchers then I will get the behavior I want_ because _the intensive watcher threads are the ones that are having issues with the file change notifications for WSL and docker containers_. I will try _to explore why intensive watcher threads are running instead of robust watchers_ and _I will learn more about how file-watcher spawns threads_

**Observation**
: When I tried _to explore why intensive watcher threads are running instead of robust watchers_ I did/didn't get _expected-outcome_.  _Analysis of result_

---

**Question**
: _Question_

**Pursuit**

|Idea|Result|
|-|-|
|Based on (info), it's possible (that XYZ assertion is correct), (optional explanation)|When (ABC action was performed), (certain result happened), (optional analysis)|

- Idea: Based on (info), it's possible (that XYZ assertion is correct), (optional explanation)
  - Result: When (ABC action was performed), (certain result happened), (optional analysis)

**Answer**
: _Answer_

---
