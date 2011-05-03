---
layout: post
title: Hackers Hacking at a Hackerspace 
---

{{ page.title }}
================

Sometimes I think we forget how good we have it in the Rails world.  I don my ruby-colored slippers to work every morning and its easy to forget this wasn&quot;t always the case.  I was recently reminded of this dark past when our local hackspace needed to write some database-backed web software.

If I was hanging out with my Ruby friends, this is the moment the cool ones (myself included) suggest we use Sinatra.  Sure, it doesn&quot;t ship with an ORM, but you can try out a new one!  And despite being Rails being leaps and bounds more capable of leaping and bounding than other frameworks out there, Sinatra has an elegance factor that appeals to me.  There&quot;s a certain joy from building complex things out of simple components.

However, I was not in Ruby land.  I was at a hackerspace.  Sinatra is that guy who sings New York, New York and Ruby is seen as a to-be-tested improvment upon Perl.  Gross.

So a discussion inevitably comes up as to which framework to use.  To my shock, Rails does not come up as a winner: being a lingua franca, they debate Java and *eventually choose PHP*.  Great.  Its going to be a flame war. 

I found myself in a common dilemma: having used Ruby frameworks, PHP frameworks, and Java frameworks I was in a clear place to argue for a winner.  But this is not a situation for arguments becuase winning one would require everyone else to have the same level of knowledge.  I can talk for hours to the Java guys about how Ruby&quot;s objects just "make sense", or the PHP guys about how you can still use all your dirty little tricks.  However, so long as they think I am making these arguments for the sole purpose of convincing them, which is half true, arguments are useless.  

Instead of despairing we opted to use competition.  We would take a week and the PHP team could work its magic while I got to be the lone member of team Ruby.  After coding up a [single-file frontend in Sinatra](http://github.com/csquared/cerberus_prox_sinatra_old) I was more than prepared to shock and awe everyone with what we could do with Ruby.  Instead, I had to listen to the benefits of the Zend Framework.

The Zend fucking Framework.  I fail.  I showed up with a knife to a gun fight.

And at first, I was legitimately scared.  Fuck, these are engineers.  *We&quot;re not going for elegance, we&quot;re going for features*.  And yet as this realization dawned on me while the show-and-tell continued, I realized I had, in fact, already had this figured out.  Zend Framework is so productive, you can generate a form from an array.  Imagine that.  A whole form out of just a little array.   I&quot;ll see your Zend Framework, and I&quot;ll raise you RAILZ 3!!

So yes, this is a story about how using Rails 3 made me a badass.  Because for a breif moment, it did.  That night I went home and <code>rails generate</code>-d my way into a fully functional frontend.  Psh.  An array to build a form.  I thought I would show off and share with them a shell script that would generate the whole app for them too, but as usual I was getting ahead of myself.  Rails has come a long way with legacy database support but I still needed to code around some legacy fields.  Nevertheless, I was up and going in an evening.

After generating the backend, I moved to deploy over working on features.  This step was crucial, and something you can only do in software.  In the real world if you want a bigger boat, you&quot;re gonna need a bigger boat.  You can&quot;t just tell your current boat to double itself.  In the digital world we have this ability and that&quot;s why its important to deploy quickly and often.  By building the entire pipeline to your users, it overcomes the prototype phase by forcing the app to perform or perish.

It turned out the ability to iterate quickly was what gave Rails the edge in our quick battle of the frameworks.  The cerberus-prox project updated its database schema.  One migration, one commit, and one deploy and my app was already running on the updated database.  At this point, the [Cerberus Prox Frontend](http://www.github.com/csquared/cerberus-prox-frontend) was moved to port 80, where it still remains.  A testament to deploying early, iterating often, and just doing what works instead of debating it.

At a the first [Austin.rb](http://austinrb.org) meeting, we were asked what we like about Ruby.  This is what I like about Ruby.  It grants a level of control over the machine that once took a great many lines of subtle syntax.  Ruby either makes you dumber or unleashes your creativity.  Perhaps a little of both, which is probably what makes it so damn fun.

