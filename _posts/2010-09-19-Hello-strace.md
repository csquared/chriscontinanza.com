---
layout: post
title: Starting with strace
---

{{ page.title }}
================

If you haven't seen it, check out Aman Gupta's talk on using C tools to debug ruby.
After watching this talk, I was all fired up to use strace to 
shed light on just exactly what's going on when I'm running Ruby code.

## strace
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

Let's start with the simplest of cases and go deep.  Hello, strace.

<pre>
$ strace -o ruby_strace ruby -e 'puts "hello, world"' 
</pre>



