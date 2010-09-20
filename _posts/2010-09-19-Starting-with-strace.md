---
layout: post
title: Starting with strace
---

{{ page.title }}
================

If you haven't seen it, check out Aman Gupta's talk on using C tools to debug ruby.
After watching this talk, I was all fired up to use strace and perftools to 
shed light on just exactly what's going on when I'm running Ruby code.

## strace
strace is a tool that traces the system calls (those are calls made to the kernel)
a specific process is making.  Remember in unix-world, every system call is implemented
as a function in C.  strace allows you to see how your program is interacting
with the operating system.

From the man pages:
<pre>
In the simplest case strace runs the specified command until it exits.  It intercepts and records the system calls which are called by a  process  and  the
       signals  which  are  received  by a process.  The name of each system call, its arguments and its return value are printed on standard error or to the file
       specified with the -o option.  
</pre>

You can run an entire program under strace to see the history of every itneraction it
has with the operating system.  
<pre>
> strace jekyll
execve("/home/chris/.rvm/gems/ruby-1.9.2-p0/bin/jekyll", ["jekyll"], [/* 59 vars */]) = 0
brk(0)                                  = 0x86f000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fb26a28d000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
...
</pre>

As you can see, there tends to be a lot of noise.
You can also attach strace to a live process via the -p flag.  For further information see:
<pre>
> man strace
</pre>

Now if you want to do something really fun, try this:
<pre>
> strace irb
</pre>
and then type "hello world"
Those of you playing at home will have found yourself in a very noisy, very interactive session
with irb.

## perftools
