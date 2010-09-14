---
layout: post
title: Chaos and Causality: Part 1
---

{{ page.title }}
================

The Background
--------------

I'm very interested in the mathematical phenomenon of Chaos because it tends to show up everywhere, but
only after taking a good, close look.  This pattern is just as fundamental a building block of the 
universe we as the triangle.  And just as it would be hard to build a building without using certain
shapes, its just as equally hard to comprehend our surrounding if we don't know what to look for.  

So what I have planned is a three part series.  Here I want to just catalog some of the various
places chaos shows up and what its doing in those places.  Then we'll draw some chaotic graphs
with javascript, and finally I will share how I think this connects to our broader picture.
That and I'll try to tone down the cursing : )

So let's get down to it:
A Chaotic system is one that can be characterised by a set of equations.  These equations have
a property of being "sensitive to initial conditions."  What that means is that the effects of
small changes in the input - like the difference between 2 and 2.00000000001 can have 
large effects on the output.  In non-chaotic systems we reguarly disregard small changes: in
fact, calculus is the math of disregarding the little changes to be able to easy talk about
the biggest thing that changes.

Here's a prime example: a computer program.  At some point in the life of a computer program
it becomes a long string of ones and zeroes.  Now imagine you flip just one tiny bit at random.
Just one tiny bit, out of billions.  It could wind up having a small effect, like if you changed
the value of a character and someone saw "Hello Worle" instead of "Hello World".
On the other hand, you could change some sort of crucial branch in the startup procedure and now
all it does is crash.  

Now, just being sensitive to initial conditions does not outright make something chaotic.

It can even show up in the chemical world

<object width="480" height="385"><param name="movie" value="http://www.youtube.com/v/bH6bRt4XJcw?fs=1&amp;hl=en_US"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/bH6bRt4XJcw?fs=1&amp;hl=en_US" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="480" height="385"></embed></object>


