---
title: "Not knowing...Pratt parsers"
date: 2021-08-12T10:43:24+02:00
draft: false

tags: ["lox", "compilers", "virtual machine", "c", "stack trace"]
series: ["not knowing"]

---

This summer I've been learning a bit about programming language design. In the
past, I've thrown together a few little programs use regular expressions to
parse some simple language according to a simple context free grammars. Like
any other programming newbie, I've also built the ubiquitous calculator or
two. 

Back in 2017 I resolved to teach myself something about computer science. I
surveyed a few computer science undergraduate programs and decided to patch
together my own from online courses, docs, tutorials and textbooks. 
For some reason, the Theory of Computation by Michael Sipser was one of the first
textbooks I bought. Now don't get me wrong, it's a really great book. It's just
not something I got a whole log of mileage out of for the first couple of
years. The penny only dropped after I'd spent a good few years working
practically with things like regular expressions. 

In hindsight, it might have been useful to know about [teachyourselfcs.com](https://www.teachyourselfcs.com) 
back in 2017. Computer Science is a fairly large topic and it's useful to have
a few hints on how to structure your approach. Anyway, it's a resource I only
discovered this year. I wanted to learn a bit more about operating systems and
compiler design and found some great recommendations on this site. The one
relating to compilers and language design is [this
one](https://www.craftinginterpreters.com), written by Bob Nystrom. It walks you through 
two implementations of a scripting language called lox. One is a tree-walk interpreter 
implemented in Java and the other is a bytecode virtual machine implemented in
C. It's illuminating to see how these types of programs are put together. It's
one of the places where you start to see where the theory of computer science
come in to play.

### Compiling Expressions

One of the easier exercises pops up at the end of chapter 17 in crafting
interpreters, At this stage in the book our interpreter is able to parse 
very simple expressions. I've created a [tag](https://www.github.com/adammccartney/clox/releases/tag/v0.17) 
in the Github repo to refer to the program at this particular stage if you 
want to run it for yourself.

As anyone who has ever implemented a calculator will know, evaluating complex
expressions in the correct order is essential to for correct calculations. We
want to understand what the parser is doing in order to evaluate the following
expression:
```
(-2 + 5) * 8 - -3
```

At this stage in the implementation, clox is still giving us a good print out of 
how it is assembling the program.

```
> (-2 + 5) * 8 - -3
== code ==
0000    1 OP_CONSTANT         0 '2'
0002    | OP_NEGATE
0003    | OP_CONSTANT         1 '5'
0005    | OP_ADD
0006    | OP_CONSTANT         2 '8'
0008    | OP_MULTIPLY
0009    | OP_CONSTANT         3 '3'
0011    | OP_NEGATE
0012    | OP_SUBTRACT
0013    2 OP_RETURN

0000    1 OP_CONSTANT         0 '2'
        [ 2 ]
0002    | OP_NEGATE
        [ -2 ]
0003    | OP_CONSTANT         1 '5'
        [ -2 ][ 5 ]
0005    | OP_ADD
        [ 3 ]
0006    | OP_CONSTANT         2 '8'
        [ 3 ][ 8 ]
0008    | OP_MULTIPLY
        [ 24 ]
0009    | OP_CONSTANT         3 '3'
        [ 24 ][ 3 ]
0011    | OP_NEGATE
        [ 24 ][ -3 ]
0012    | OP_SUBTRACT
        [ 27 ]
0013    2 OP_RETURN
27
```


This steps through main, calls a few init functions that sets up our VM and
eventually gets to the branch `runFile(argv[1])`

First thing that happens on this path is the file contents is copied to a
buffer within the program memory called `source`. The contents of this buffer 
is then passed on to `interpret()` 

Key functions that we want to trace:
```
|runFile()
  |__readFile()
    |__interpret()
      |__compile()
        |__advance() 
          |__scanToken()
            |__identifier() || number()
               |__identifierType()
                 |__checkKeyword()
            |__makeToken()
        |__expression()
          |__parsePrecedence()
            |__advance()
            |__getRule()
        |__consume()

    |__run()


```

`advance()` calls `scanToken()` to set `parser.current`. Once the parser has a
token to read, then we're off to the races. Another call to `advance()` here
pushes another token onto the parser stack. Okay...it's not really a stack,
it's really an object with two attributes and two flags. But the behaviour is
kind of like a stack ... With a hole at the bottom. Every time `advance()` is
called, it moves the current token to the address that previous points to.
Following this, it loads a new token into the address pointed to by current. 

```
typedef struct {
  Token current;
  Token previous;
  bool hadError;
  bool panicMode;
} Parser;

```

I don't mean to reproduce so much of the original source code here, 
as it's so well documented in the book. But the simplicity and
jazziness of this approach is just so much fun that it's hard not to.
Each parse rule contains two function pointers and an order of precedence.

```
typedef void (*ParseFn)();

typedef struct {
    ParseFn prefix;
    ParseFn infix;
    Precedence precedence;
} ParseRule;

ParseRule rules[] = {
  [TOKEN_LEFT_PAREN]    = {grouping, NULL,   PREC_NONE},
  [TOKEN_RIGHT_PAREN]   = {NULL,     NULL,   PREC_NONE},
  [TOKEN_LEFT_BRACE]    = {NULL,     NULL,   PREC_NONE}, 
  [TOKEN_RIGHT_BRACE]   = {NULL,     NULL,   PREC_NONE},
  [TOKEN_COMMA]         = {NULL,     NULL,   PREC_NONE},
  [TOKEN_DOT]           = {NULL,     NULL,   PREC_NONE},
  [TOKEN_MINUS]         = {unary,    binary, PREC_TERM},
  [TOKEN_PLUS]          = {NULL,     binary, PREC_TERM},
  [TOKEN_SEMICOLON]     = {NULL,     NULL,   PREC_NONE},
  [TOKEN_SLASH]         = {NULL,     binary, PREC_FACTOR},
  [TOKEN_STAR]          = {NULL,     binary, PREC_FACTOR},
  [TOKEN_BANG]          = {NULL,     NULL,   PREC_NONE},
  [TOKEN_BANG_EQUAL]    = {NULL,     NULL,   PREC_NONE},
  [TOKEN_EQUAL]         = {NULL,     NULL,   PREC_NONE},
  [TOKEN_EQUAL_EQUAL]   = {NULL,     NULL,   PREC_NONE},
  [TOKEN_GREATER]       = {NULL,     NULL,   PREC_NONE},
  [TOKEN_GREATER_EQUAL] = {NULL,     NULL,   PREC_NONE},
  [TOKEN_LESS]          = {NULL,     NULL,   PREC_NONE},
  [TOKEN_LESS_EQUAL]    = {NULL,     NULL,   PREC_NONE},
  [TOKEN_IDENTIFIER]    = {NULL,     NULL,   PREC_NONE},
  [TOKEN_STRING]        = {NULL,     NULL,   PREC_NONE},
  [TOKEN_NUMBER]        = {number,   NULL,   PREC_NONE},
  [TOKEN_AND]           = {NULL,     NULL,   PREC_NONE},
  [TOKEN_CLASS]         = {NULL,     NULL,   PREC_NONE},
  [TOKEN_ELSE]          = {NULL,     NULL,   PREC_NONE},
  [TOKEN_FALSE]         = {NULL,     NULL,   PREC_NONE},
  [TOKEN_FOR]           = {NULL,     NULL,   PREC_NONE},
  [TOKEN_FUN]           = {NULL,     NULL,   PREC_NONE},
  [TOKEN_IF]            = {NULL,     NULL,   PREC_NONE},
  [TOKEN_NIL]           = {NULL,     NULL,   PREC_NONE},
  [TOKEN_OR]            = {NULL,     NULL,   PREC_NONE},
  [TOKEN_PRINT]         = {NULL,     NULL,   PREC_NONE},
  [TOKEN_RETURN]        = {NULL,     NULL,   PREC_NONE},
  [TOKEN_SUPER]         = {NULL,     NULL,   PREC_NONE},
  [TOKEN_THIS]          = {NULL,     NULL,   PREC_NONE},
  [TOKEN_TRUE]          = {NULL,     NULL,   PREC_NONE},
  [TOKEN_VAR]           = {NULL,     NULL,   PREC_NONE},
  [TOKEN_WHILE]         = {NULL,     NULL,   PREC_NONE},
  [TOKEN_ERROR]         = {NULL,     NULL,   PREC_NONE},
  [TOKEN_EOF]           = {NULL,     NULL,   PREC_NONE},
};
```


### gdb

We could of course use gdb to get a more precise understanding of what's going
on with the program as it moves through its mode of operation. This would be
useful for making sure that the program is actually doing what it claims to be
doing. Anyway, as these examples are coming from a source that has already been
extensively tested, I'll just show the process for academic purposes. It might
be useful to look back on if I some day manage to write something that is this
complex! 

GDB needs debug info to be of any use. So first of all, we need to compile the
program using the `-g` flag.  

Then we need to figure out where to set our trace points. We can use gdb to
simply step through the source and note in what order the functions are called.

We're going to call gdb with a file that contains our expression and simply run
the program. We can step through the program using our breakpoints and view
what assignments are happening as we move through. For the sake of brevity,
I'll just print a backtrace after a fairly random number of loops through our
program to give you an idea of what the gdb output is... Precision computing at
its finest! 

```
> gdb --args ./cloxd test/expression/simple.lox
(gdb) b expression
(gdb) b parsePrecedence
(gdb) b scanToken
(gdb) run
(gdb) s
...
(gdb) backtrace
#0  makeToken (type=TOKEN_NUMBER) at src/scanner.c:59
#1  0x0000555555556abe in number () at src/scanner.c:162
#2  0x0000555555556bf6 in scanToken () at src/scanner.c:186
#3  0x0000555555555757 in advance () at src/compiler.c:77
#4  0x0000555555555a0b in parsePrecedence (precedence=PREC_ASSIGNMENT) at src/compiler.c:214
#5  0x0000555555555ab3 in expression () at src/compiler.c:235
#6  0x0000555555555980 in grouping () at src/compiler.c:148
#7  0x0000555555555a3f in parsePrecedence (precedence=PREC_ASSIGNMENT) at src/compiler.c:221
#8  0x0000555555555ab3 in expression () at src/compiler.c:235
#9  0x0000555555555aff in compile (source=0x55555555c4a0 "(-1 + 2) * 3 - -4\n",
    chunk=0x7fffffffdb20) at src/compiler.c:246
#10 0x0000555555555e2c in interpret (source=0x55555555c4a0 "(-1 + 2) * 3 - -4\n")
    at src/vm.c:82
#11 0x000055555555609a in runFile (path=0x7fffffffe077 "test/expressions/simple.lox")
    at src/main.c:55
#12 0x0000555555556110 in main (argc=2, argv=0x7fffffffdc88) at src/main.c:69
(gdb)
```
