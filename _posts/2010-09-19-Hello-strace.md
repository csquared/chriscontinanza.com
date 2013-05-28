---
layout: post
title: Hello, strace (an introduction to strace)
---

{{ page.title }}
================

If you haven't seen it, [check out Aman Gupta's talk on using C tools to debug ruby](http://vimeo.com/12748731).
After watching this talk, I was all fired up to use strace to
shed light on just exactly what's going on when I'm running Ruby code.

## strace

    strace [ -dffhiqrtttTvxx ]  ...  [ -ofile ] [ -ppid ] ... [ command [ arg ...  ] ]

strace is a tool that traces the system calls (those are calls made to the kernel)
a specific process is making.  Remember in unix-world, every system call is implemented
as a function in C.  strace allows you to see how your program is interacting
with the operating system.

From the man pages:
<blockquote>
In the simplest case strace runs the specified command until it exits.
It intercepts and records the system calls which are called by a process
and the signals  which  are  received  by a process.  The name of each system
call, its arguments and its return value are printed on standard error or to the file
specified with the -o option.
</blockquote>

So let's start with the simplest of cases.

What we're going to do is run a Ruby hello world and a C hello world under strace
so we can compare the output and get a feel for whats going on under the hood.

## Hello, strace.

To strace Ruby's hello world, we're going to take advantage of the -e flag.  e means
"Evaluate" and it tells the ruby interpreter you want it to eval the string you are
passing to it.

    $ strace -o ruby_strace ruby -e 'puts "hello, world"'

[This log is about 130 lines, so I've added some commentsas to what's going on.](http://github.com/csquared/mojombo.github.com/blob/master/_posts/strace/ruby_strace.log)

Here's our C version of the same program.

    @@@c
    #include <stdio.h>
    main() {
      printf("Hello, world");
    }

Oooh exciting.

now for a little

    $ gcc c_hw.c -o chw
    $ strace chw -o c_strace.log

And boo-ya!

[The strace is a lot shorter, like 100 lines shorter.](http://github.com/csquared/mojombo.github.com/blob/master/_posts/strace/c_strace.log).

## So what's going on?

First off, you can find all of the lines in the C program show up somehow or another in the ruby program, in three distinct chunks.
In the end, the entirety of both programs boils down to one system call to write:

    write(1, "Hello, world", 12)             = 12

Which is writing our beloved Hello, world to file descriptor 1- better known as standard output.
What's going on differently in the Ruby version is that the Ruby version has to load Ruby.
Ruby then registers some interrupt handlers, seeds its random key, queries the process about its ids and goes along its merry way.

Only to wind up with:

    write(1, "hello, world\n", 13)             = 13

Yup, that's the same instruction.  *As it should be.*  Ok.  Not totally the same.  I used Ruby's
_puts_ method, which post-pends a newline to the string.  This explains the difference between
the 12 and 13 number of characters.

Nevertheless, the basic idea is that Ruby does everything the C program does plus loading all the parts that are simply Ruby.

Since we're all Visual learners:

<img src="/images/strace_img.jpg" />

Because this is a trivial example, loading up Ruby seems like a lot of work.  That's just because
the point of this excercise is to show the relationship between what Ruby is doing and what the
equivalent C program would do.

Just one line of ruby generated ~100 lines of strace.  That's a lot going on
for just one line of code, so to do more beyond this [we must harness the secret power of regular
expressions.](http://xkcd.com/208/)  There are many more tools to cover, but
strace teamed up with grep (or ack) is one of those power combos no programmer
should be without.

For a real gas try:

    $ strace irb

And just type "hello, world."  Welcome to the interactive strace!
