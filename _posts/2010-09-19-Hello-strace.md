---
layout: post
title: Hello, strace
---

{{ page.title }}
================

If you haven't seen it, [check out Aman Gupta's talk on using C tools to debug ruby](http://vimeo.com/12748731).
After watching this talk, I was all fired up to use strace to 
shed light on just exactly what's going on when I'm running Ruby code.

## strace [ -dffhiqrtttTvxx ]  ...  [ -ofile ] [ -ppid ] ... [ command [ arg ...  ] ]
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

Let's start with the simplest of cases.  
What we're going to do is run a Ruby Hello World and a C hello world under strace
so we can compare the output and get a feel for whats going on under the hood.

## Hello, strace.

To strace Ruby's hello world, we're going to take advantage of the -e flag.  e means
"Evaluate" and it tells the ruby interpreter you want it to eval the string you are
passing to it.
<pre>
$ strace -o ruby_strace ruby -e 'puts "hello, world"' 
</pre>

This log is about 130 lines, but I've added some comments 
as to what's going on. [You can find my annotated log on github.](http://github.com/csquared/mojombo.github.com/blob/master/_posts/strace/ruby_strace.log)

Here's our C version of the same program.
<pre>

</pre>

Wow!  The strace is a lot shorter, some 100 lines shorter.
[This annotated log is also on github](http://github.com/csquared/mojombo.github.com/blob/master/_posts/strace/c_strace.log).

What's cool is that all of the lines in the C program show up somehow or another in the ruby program, in three distinct chunks.
What Ruby is doing in between those chunks is actually going through the hassle of loading itself.  In the end, the entirety
of both programs boils down to one system call to write:

<pre>
write(1, "Hello, world\n", 13)             = 13  
</pre>

Which is writing our beloved Hello, world to file descriptor 1- better known as standard output.

