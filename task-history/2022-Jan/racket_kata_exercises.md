# Practice scientific notation process and racket lang while doing code exercises

**Problem**: Go through 3 of "Exercises for Programmers" problems using scientific notation and discovery process, scientific domain design, theory to events modeling, to sharpen abilities

**Solution**: I went through 3 of the simple exercises and feel more comfortable with doing things in Racket without any internet resources.

**Relevant skills before**:
- Racket - Beginner 
- Scientific notation process - Intermediate
- Scientific domain design - Advanced
- Theory to event modeling - Beginner

**Relevant skills after**:
- Racket - Beginner 
- Scientific notation process - Advanced
- Scientific domain design - Advanced
- Theory to event modeling - Intermediate

**Lessons Learned**:
- Make sure to surround a return value with () to ensure it gets evaluated or else you'll get unpredictable errors
- Don't confuse typed racket with racket default which is untyped

## Tutorials:

## How-to's:

## Explanations:

## References:
- https://docs.racket-lang.org/raco/
- https://docs.racket-lang.org/readline/index.html#%28def._%28%28lib._readline%2Freadline..rkt%29._readline%29%29
- https://stackoverflow.com/questions/8956789/turn-string-into-number-in-racket

## Thought Process:
---

**Question**
: How do I read input line in Racket?

**Research**

- Idea: Based on https://docs.racket-lang.org/readline/index.html#%28def._%28%28lib._readline%2Freadline..rkt%29._readline%29%29, it's possible that you call the method `(readline)` and give it the prompt
  >Outcome: When I defined variable and used the `(readline)` method, I was able to assign the input console value as the variable name

**Answer**
: Import library called `(require readline/readline)` and call the method `(readline prompt) → string?`

---

**Question**
: How do I accomplish string interpolation in Racket?

**Research**

- Idea: Based on https://docs.racket-lang.org/reference/Writing.html?q=printf#%28def._%28%28quote._~23~25kernel%29._format%29%29, it looks like I can use `format` method and it uses the same verbiage as `fprintf`
  >Outcome: When I used the `format` method and the `~s` value to act as the string interpolation value I got to print out the calculated value

**Answer**
: Use the `format` method along with `~s` place holder to perform string formatting

---

**Question**
: How do I get the current year in Racket?

**Research**

- Idea: Based on https://docs.racket-lang.org/reference/time.html#%28def._%28%28lib._racket%2Fdate..rkt%29._current-date%29%29, I may be able to get the return date struct for the current date and then access the year
  >Outcome: When I did the operation `(current-date)`, I got the `date*` struct. Now I need to access the year field
- Idea: Based on https://docs.racket-lang.org/guide/define-struct.html, I may be able to get the year field of the date struct by calling `(date-year (current-date))`
  >Outcome: When I called `(date-year (current-date))`, I was able to get the year of the `(current-date)`

**Answer**
: Call the method `(date-year (current-date))` and get the year back as an integer

---

**Question**
: How do you convert string to flonum in Racket?

**Research**

- Idea: Based on https://stackoverflow.com/questions/8956789/turn-string-into-number-in-racket, it looks like I can call `string->number` method and it will give a flonum if the string represented a valid flonum
  >Outcome: When I called `(string->number "3.5)`, I did get back a value that evalated to true when evaluating `(flonum? value)`

**Answer**
: Call the method `string->number` and then use that to do number operations and the runtime will auto convert everything to float as necessary

---

**Question**
: How to round to two decimal places in Racket?

**Research**

- Idea: Based on https://docs.racket-lang.org/reference/strings.html?#%28def._%28%28lib._racket%2Fformat..rkt%29._~7er%29%29, it's possible that using the DSL for how string formatting will work `~r #:precision '(= 2)`
  >Outcome: When I used the code `(~r final-amount #:precision '(= 2))` along with adding the require for `racket/format`, I was able to get a return the string version of the flonum with 2 decimal places

**Answer**
: Use the method `~r <number> #:precision '(= 2)` to be able to get the number value rounded to 2 decimal places

---
