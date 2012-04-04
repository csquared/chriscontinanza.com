---
layout: post
title: Unix is my everything
---

{{ page.title }}
================

The original title of this post was going to be "Unix is my IDE", something I am fond of saying whenever anyone mentions their IDE of choice.
I realized that although many have heard that quip, a lot of people may not understand it is, in fact, the truth.
UNIX *is* my IDE.  Don&rsquo;t know where that function is defined?  `grep` for it, bro.

So when I decided to sit down and encapsulate some of my ideas on using UNIX as a development 
platform, I realized the UNIX way was buried way further into my psyche than I had anticipated.  
In fact, UNIX is in a large way responsible for the fact
that I don&rsquo;t see my day job as a day job.  

The summary of the Unix Philosophy, according to Doug McIlroy:

> This is the Unix philosophy: Write programs that do one thing and do it well. Write programs to work together. Write programs to handle text streams, because that is a universal interface. [Salus]

UNIX is a living lesson in the power of abstraction: everything is text and files.  And although, 
like all abstractions, it proved leaky, its success has been far greater than its failure.

The emphasis on sharp, small tools that are simple by design is not merely a paradigm of programming.
The pipe allows one to feed the output of one program into another.  Because everything is designed
to work with text, this allows programs to be combined in ways not originally envisioned by the 
author.  This is called emergent behavior, and mirrors the organisation of the natural world.

Compare this with a monolithic program, designed to do everything the designer
wanted to do and planned for you to do.  
The UNIX philosophy is that the end user is the best judge of their needs.
This stance is inherently anti-authority.  Rather than the author trying to solve everyone&lsquo;s
problems, he/she is encouraged to solve his/her own.

I continually see this philosophy breaking out of its traditional UNIX confines and changing
the world around me.
For instance, modern lean startups build what is called a "Minimun Viable Product": something
that delivers the core value or idea of a product without every bell and whistle.
This is because the bells and whistles all take time away from getting that product in
front of people, which is the ultimate test of its viability.
This sounds to me a lot like the [New Jersey Style](http://en.wikipedia.org/wiki/Worse_is_better).

As we remake our world in terms of networks, in terms of the internet, it will always pay
to know the ideas and philosophies that drove the most successful projects. 
When UNIX is one day obsoleted, the UNIX way will live on.

[Salus] Peter H. Salus. A Quarter-Century of Unix. Addison-Wesley. 1994. ISBN 0-201-54777-5.
