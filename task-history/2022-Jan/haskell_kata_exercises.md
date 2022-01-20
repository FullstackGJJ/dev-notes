# Practice scientific noting process while doing code exercises

**Problem**: Go through entire problems of "Exercises for Programmers" using scientific notation and discovery process, scientific domain design, theory to events modeling, to sharpen abilities

**Solution**: I went through 3 of the simple exercises and feel more comfortable with doing things in Haskell without any internet resources. The rest of the exercises looked a little boring so moving on.

**Relevant skills before**:
- Haskell - Intermediate
- Scientific notation process - Beginner
- Scientific domain design - Advanced
- Theory to event modeling - Beginner

**Relevant skills after**:
- Haskell - Intermediate
- Scientific notation process - Intermediate
- Scientific domain design - Advanced
- Theory to event modeling - Beginner

## Tutorials:

## How-to's:

## Explanations:

## References:
- http://learnyouahaskell.com/input-and-output
- https://haskell-language-server.readthedocs.io/en/latest/installation.html
- https://www.haskell.org/ghcup/install/

## Thought Process:
---

**Question**
: How do you read a line input when prompting users for it in Haskell?

**Research**

- Idea: Based on http://learnyouahaskell.com/input-and-output, it seems that the command `variable <- getLine` will do just that, super easy
  >Outcome: When I created a do block and then do the arrow in assignment with getLine, I was able to use that value out after typing into the prompt

**Answer**
: Use the `getLine` function which will return an IO string. Doing it inside of a do block is even more convenient than doing it outside of one

---

**Question**
: Why do I get `[coc.nvim] Server languageserver.haskell failed to start: Launching server "languageserver.haskell" using command haskell-language-server-wrapper failed.`?

**Research**

- Idea: Based on https://haskell-language-server.readthedocs.io/en/latest/installation.html, it seems that I have to install stack and install the language server protocol on the container for it to work, which I wasn't doing before
  >Outcome: When I installed and used ghcup to install haskell language server, nvim opening up to connect to haskell language server worked, issue is now fixed but syntax highlighting isn't as good compared to using the vim haskell plugin

**Answer**
: You have to install haskell language server through one of the recommended methods. GHCUP worked in my case and haskell language server works fine now. Good timing because GHCID author will no longer work on it and moved on to using haskell language server himself

---
