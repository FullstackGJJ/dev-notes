# For creating racket auto re-running CLI for faster feedback loop crucial for development

**Problem**: Racket lang eco system currently does not have a polling file watcher that is crucial for people who use docker containers as development environments but still want to have tests to auto re-run

**Solution**: Fully working new package named raco-watcher that is a polling based file watcher (https://github.com/FullstackGJJ/raco-watcher)

**Relevant skills before**:
- Racket Lang - 0
- Scientific solution exploration - 0

**Relevant skills after**:
- Racket Lang - 1
- Scientific solution exploration - 3

**Lessons Learned**:
- Not having types can make interpreting and reading other people's packages challenging
- Don't trust other people's code without scrutinizing it first
- Be careful to format code in a way that makes parenthesis clear

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

**Research**:

<details>

<summary> Idea: Based on this package (<a href="url">https://github.com/dannypsnl/raco-watch</a>), it's possible that raco-watch can fulfill the niche that ghcid did </summary>

>Outcome: After I installed raco watch with `raco pkg install --auto raco-watch` command and ran `raco watch -c "raco tests ."`, I saw that it did re-run `raco tests .` for every file change but it would run it 3 times for some reason. The fact that raco-watch re-runs the command multiple times can be very bad and I need to find a solution to that

</details>

**Answer**
: `raco-watch` exists as a possible candidate. Its intended behavior does do what ghcid did but currently it behaves unexpectedly in when I used it to re-run tests with the command `raco watch -c "raco tests ."` and it would re-run `raco tests .` 3 times every time a file in the directory is changed.

---

**Question**
: Is there a polling based file watcher that I can use to help circumvent the issues caused by using Docker containers just like I use for Haskell's ghcid?

**Research**

<details>

<summary> Idea: Based on the fact that <code>raco-watch</code> is built ontop of <code>file-watchers</code> (<a href="url">https://github.com/dannypsnl/raco-watch/blob/develop/main.rkt#L3</a>) and <code>file-watchers</code> supports polling based file change detection (<a href="url">https://docs.racket-lang.org/file-watchers/index.html#%28def._%28%28lib._file-watchers%2Fmain..rkt%29._robust-watch%29%29</a>), it's possible bypassing <code>raco-watch</code> to use <code>file-watchers</code> directly would give me the results I am looking for. <code>file-watchers</code> seems to have an API for running tasks in the background </summary>

>Outcome: When I tried `raco file-watchers -h`, I did not get a helpful CLI interface to be able to create a poll based file watching command or be able to use it to auto re-run unit tests. This means I should look into the main method of the code for the package to learn how to actually give it the commands it should be re-running. If it does not have a mechanism for that, then maybe it is only meant to alert of file change and not to execute any action.

</details>

**Answer**
: There doesn't seem to exist a current solution for a polling based file change detection and command re-runner. This means that I can maybe look into making one that uses `file-watchers` library under the hood but exposes the polling based options to a user

---

**Question**
: _How do I run a `file-watcher` `robust-watch` instead of the normal `watch` inside of a `thread-wait`?_

**Research**

<details>

<summary> Idea: Based on the fact that <code>file-watcher</code> already has <code>robust-watch</code>, it's possible to be able to call it to execute a system command </summary>

>Outcome: When I tried examining different ways to call `file-watcher` -> `robust-watch` in the repl I didn't get to see the re-run working in the repl, I think this means that there's something I'm not understanding with getting main modules to work in repl. Will have to think of other strategies

</details>
<details>

<summary> Idea: Based on <a href="url">https://github.com/zyrolasting/file-watchers/blob/master/cli.rkt#L60</a>, it's possible to pass in <code>robust-watch</code> in as the <code>method</code> argument for the <code>watch</code> procedure </summary>

>Outcome: When I followed `file-watcher` CLI example I did get the code to run with what I'm assuming `robust-watch`.

</details>

**Answer**
: You have to pass it in as the last optional argument of the `watch` procedure with void actions like `displayln` as placeholder for positioning

---

**Question**
: _How do you create a racket executable?_

**Research**

<details>

<summary> Idea: Based on the documentation <a href="url">https://docs.racket-lang.org/raco/exe.html</a>, it's possible to be able to create a Unix executable with the <code>raco exec</code> command </summary>

>Outcome: I tried the command `raco exe main.rkt -o watcher I did get a `main` executable to come out and was able to run it with `./main --help` call. I also unfortunately saw that it ran the same command `raco test .` 3 times just as the undesirable behavior that I saw from `raco watch` program.  I'm not sure why it's having the same issue, especially when I'm specifically using the file polling way for detecting file changes.

</details>

**Answer**
: Call the command `raco exec <file>` and the executable with the same name as the file would pop up and then you can call the executable just as if it was a program. I recommend outputing the executable into the `compiled` folder with the `-o` flag `raco exec <file> -o compiled/<file_name>`

---

**Question**
: _Why is `thread-wait (watch path* (lambda (lst) (system (cmd)) displayln robust-watch))` causing the command `raco test .` to run 3 duplicate times upon file change?_

**Research**

<details>

<summary> Idea: Based on console output of thread logs it seems that <code>intensive watcher</code> threads are the ones running instead of the <code>robust watchers</code> that I was hoping for. It's possible that if robust watchers are running instead of intensive watchers then I will get the behavior I want. I wonder if there is a bug in the implementation of <code>watch</code> procedure </summary>

>Outcome: When I tried to explore why intensive watcher threads are running instead of robust watchers, I noticed in this line of code https://github.com/zyrolasting/file-watchers/blob/master/main.rkt#L55 it may be creating more watchers than expected. I'm struggling to find where `thread-maker` is defined though. Once I can find the definition of `thread-maker` I think I can figure out what's going on. It would be way more helpful if people use prefix to make clear import calls.

</details>

<details>

<summary> Idea: Based on how watch has default option for <code>thread-maker</code>, it's possible that using their suggested-approach with apathetic watch will work </summary>

>Outcome: When swapped to use `apathetic-watch`, the same result still happened with `intensive-watch` printing out its attempt to monitor the file system and running the command 3 times, I might want to examine CLI usage of `file-watchers` directly and see how robust and intensive differs

</details>

<details>

<summary> Idea: Because my program's call of <code>file-watchers</code> is having issues with calling <code>robust-watch</code>, it's possible that the preinstalled version of <code>file-watch</code> that I have is outdated, so that could be causing it to always call <code>intensive-watch</code> </summary>

>Outcome: When I searched the user directory for racket packages in `.local/share/racket/8.3/pkgs/file-watchers`, I found that it had a matching version to the code I was reading, I'm not sure why my library call to `watch` is behaving like `intensive-watch` is the default behavior

</details>

<details>

<summary> Idea: Since my CLI app's library call to <code>file-watcher</code> is having issues, it's possible that using <code>file-watcher</code> own CLI could have the correct behavior, if its own CLI has a different behavior from what I'm seeing, then I can debug from there how my CLI code differs from theirs </summary>

>Outcome: When I execute the command `raco file-watchers -m robust` and edit the `main.rkt` file to trigger file-change notification, the console prints out that the `robust-watcher` detected the change once and prints out once as expected. When I execute the command `raco file-watchers -m intensive` I noticed `intensive-watcher` threads would detect the change then print out 3 times about what it's doing upon editing `main.rkt`. The intensive watcher behavior looks exactly like the problem I'm facing in my CLI code's library call to `watch` while the `robust-watcher` option looks like what I want. I probably have to experiment with copy pasting `file-watcher` CLI code exactly and working from there

</details>

<details>

<summary> Idea: Based on the fact that <code>file-watchers</code> CLI code can correctly invoke <code>robust-watcher</code>, it's possible that something is wrong with the code I copied from <code>raco-watcher</code> and <code>file-watcher</code> needs the call to <code>watch</code> to be a specific way </summary>

>Outcome: When I ported over the `file-watcher` CLI code, I still had the same problem with `intensive-watch` kicking off. However, during closely examining the code, I saw that the parenthesis were not closed around the lambda method to isolate the system call. It was still valid parenthesis closing to the Racket compiler but for the logic I was trying to encapsulate it was invalid. Switching from `(thread-wait (fw:watch exists (lambda (lst) (sys:system (cmd)) displayln fw:robust-watch)))` to `(thread-wait (fw:watch exists (lambda (lst) (sys:system (cmd))) displayln fw:robust-watch))` allowed the code to work properly. The original line of code with the incorrect closing parenthesis actually came from the writer of `raco-watch` and me not identifying the closing parenthesis issue (which explains why using `raco-watch` package has the same error behavior). Lesson to self, scrutinize other people's packages because it's possible to get weird behaviors with even code that passes compiler check. It's also probably super important to format the code to make parenthesis easier to check and verify. One liners with lot of parenthesis can be hard to verify its correctness.

</details>

**Answer**
: The reason for the behavior is due to the parenthesis not correctly encapsulating around `(lambda (lst) (system (cmd))` section. It's supposed to be `(lambda (lst) (system (cmd)))`

---
