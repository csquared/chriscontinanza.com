---
layout: post
title: OMFG - Vim and NEATBEANS ?!?!
---

{{ page.title }}
================

Talk about an unholy alliance.

Two events have lead me to dust off the old java: one was pairing with a buddy who was working on an [AI bot for a google AI] competition he saw.  The other is Austin Hackerspace using Cerberus-Proxy as an interface for our swipecards.

So here's the thing: I don't want to be some too-cool-for-school jackass that is all like "oh, it's not in ruby so I can't touch the codebase."  That's so not hax0r.  So its time to roll up my sleeves and get back into Java. 

Although Vim is my favorite text editor, Java IDEs are pretty well built for Java programs.  And with all the years spent not coding Java I figured its time I see what's been going on in the Java world.  So I download Netbeans.  Then that same voice that goes off in my head ever since I started using Vim says: "hey man, I wonder if there's Vim keybindings for that."  

This is part of the power of Vim: other programmers are willing to make any program they use enough work like Vim.  It's kind of like the oppposite of the Emacs way: the goal of Emacs seems to be to never leave Emacs.  Vim is in my shell prompt (set -o vi), my web browser (vimperator), and is my code editor.  So it only stands to reason that....

YES!  There are not [one](http://jvi.sourceforge.net/) but [two](http://viex.sourceforge.net/) Vim emulators for Netbeans.  Hot fucking dog!  Being the second advertises itself as "Not very good, but useful" I decided to try out the former: jVi.

jVi is pretty cool because it is not using a Vim instance to do the text editing but is a straight Java implementation of Vim functionality.    

After installing Netbeans
<pre>
> chomd u+x netbeans-6.9.1-ml-linux.sh
> ./netbeans-6.9.1-ml-linux.sh
</pre>

And following [these easy instructions provided by kenglish](http://honoluluhacker.com/2009/11/22/install-netbeans-jvi-plugin/) I am using Vim keybindings in Netbeans!  Holy shit Batman!
