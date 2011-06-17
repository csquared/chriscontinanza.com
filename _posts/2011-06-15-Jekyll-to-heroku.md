---
layout: post
title: Transitioning my Jekyll site to Heroku (Rack)
---

{{ page.title }}
================

[Jekyll](https://github.com/mojombo/jekyll/wiki) is mojombo&lsquo;s awesome and popular blogging platform for hackers.  I transitioned my site to use it over Wordpress a while ago and haven&lsquo;t looked back.

Jekyll generates a static html site from templates you create with liquid and markdown.  Usually, the generated site is .gitignored and is regenerated on every deploy.  This works great for static site hosts, but what about Heroku?

The strategy is easier than it seems.  We can still generate the static site, but we remove the _site dir from our .gitignore. 

At first I installed the rack-jekyll gem, noticed a wierd problem with my pngs.  It turned out that the rack-jekyll gem rolled its own
static-site serving code that fucks up pngs.

It turns out if you instead use the rack-contribs gem you can use Rack to serve a static site.

Here&lsquo;s my config.ru:
{% highlight ruby %}
require 'bundler'
Bundler.setup
Bundler.require
require 'rack/contrib/try_static'

use Rack::TryStatic, 
    :root => "_site",  # static files root dir
    :urls => %w[/],     # match all requests 
    :try => ['.html', 'index.html', '/index.html'] # try these postfixes sequentially
# otherwise 404 NotFound
run lambda { [404, {'Content-Type' => 'text/html'}, ['whoops! Not Found']]}
{% endhighlight %}

That&lsquo;s it!  Now you can
<pre>
  > heroku create &lt;blog name&gt;
  > git push heroku
</pre>
and go view your Jekyll blog running on Heroku!
