---
layout: post
title:  Introducing IMGKit
---

{{ page.title }}
================

I recently discovered JD Pace's <a href="http://github.com/jdpace/PDFKit">PDFKit</a> in the search for better ways to do things.  It's a great solution for generating PDF files from html sources.  It is basically a wrapper for the open source executable <a href="http://code.google.com/p/wkhtmltopdf/">wkhtmltopdf</a>.

The idea behind <code>wkhtmltopdf</code> is simple: use the rendering engine of browser without the GUI to generate PDFs and you'll have pages that look exactly like they render on the web and get updated when the browsers do!

That in mind, I set forth to tackle a new requirement for a task at hand: turning an HTML page into a JPG.  With my PDFKit hammer at my side, I quickly strung together a processing pipeline that used PDFKit to transform my html to a PDF and then RMagick to transmogrify the PDF into JPG.  I looked something like this:

{% highlight ruby %}
    pdf  = PDFKit.new(html, :page_size => 'Letter').to_pdf
    gif  = Magick::Image.from_blob(pdf)
{% endhighlight %}

Simple, for sure. But it looked like SHIT.  Back to the drawing board.  A big problem was all the fine text was illegible.  Imagemagick seemed to be doing a bad job of rasterizing the text getting produced in the PDF.  I reasoned that perhaps I could find a flag in wkhtmltopdf to rasterize the text.  Instead, I found something better.  Something much better...

## wkhtmltoimage

It turns out wkhtmlto<b>image</b> does for JPGs what wkthmlto<b>pdf</b> does for PDFs. Woot!  Like any good hacker, I first decided to try to screw around with the PDFKit gem, swapping out the call to wkhtmltopdf with one to wkhtmltoimage.

As that broke, it lead me to try to just call the command on my own, which eventually lead to discovering this little gem of Ruby in PDFKit:

## stdin and stdout and stderr, oh my!

{% highlight ruby %}
    pdf = Kernel.open('|-', "w+")
    exec(*command) if pdf.nil?
    pdf.puts(@source.to_s) if @source.html?
    pdf.close_write
    result = pdf.gets(nil)
    pdf.close_read
{% endhighlight %}

<a href="http://ruby-doc.org/core/classes/Kernel.html#M005950">It turns out you can open a pipe with `Kernel#open`</a>
that you can read and write to like a file!  Moments like this make me really appreciate the power of the 'file' abstraction.

If you pass `Kernel#open` `'|&lt;cmdname&gt;'`, you will have a pipe to that command that you can read and write to with normal <code>IO</code> methods, such as `#gets`, `#puts`, and my favorite `#&lt;&lt;`.

If you pass <code>Kernel#open</code> the special string <code>'|-'</code>, not only do you get back a pipe, _but the process forks,_ returning nil to the child and the file-like pipe <code>IO</code> Object to the parent.  That's a pretty elegant way to wrap a process and that's how the <code> exec(&ast;command) if pdf.nil? </code> line works.

The command we are wrapping is <code>wkhtmltoimage</code>, which takes two inputs: the source and ouptut destination.  It can take a url, file location, or stdin as input if you pass the special parameter '-'.  Output can either be a file or standard out if you use the same '-'.  In this situation, we're always reading from standard out, which is accomplished via the call to <code>result = pdf.gets(nil)</code>.

This may make it more clear:

## in Ruby, files can be pipes...

{% highlight ruby %}
    pipe = Kernel.open('|-', "w+")
    exec(*command) if pipe.nil?
    pipe.puts(@source.to_s) if @source.html?
    pipe.close_write
    result = pipe.gets(nil)
    pipe.close_read
{% endhighlight %}

So I got to quick work writing my own script that just called wkhtmltoimage with this bit of code.  However, I quickly found out <code>wkthmltoimage</code> does not support the <code>--quiet</code> flag, which leads to a leaky standard error printing out the the console.  This is something that is very noticable during unit testing and is just a bad form and practice to not manage right.

## Standard error, you bastard!

PDFKit is able to pass the <code>--quiet</code> flag to <code>wkhtmltopdf</code> to silence standard error; <code>wkhtmltoimage</code> has no such flag.  Using redirection is one way out and works fine when passing the command as a string to exec, a la <code>&quot;wkhtmltoimage - - 2&amp;/dev/null&quot;</code>.  However, this fails when using the splat operator on an array of built up parameters (ie: <code>exec(&ast;command)</code>).  It turns out Ruby has another way to call a process that, while not as terse as the above, does the job:

{% highlight ruby %}
    result = nil
    Open3.popen3(*command) do |stdin,stdout,stderr|
      stdin << (@source.to_s) if @source.html?
      stdin.close
      result = stdout.gets(nil)
      stdout.close
      stderr.close
    end
{% endhighlight %}

`Open3#open3` allows you to explicitly manage standard input, output, and error of the child process command.  Since we're not really interested in what it has to say, we just close it when we're done reading the jpg on <code>stdout</code>.  The call to exec in the <code>Kernel#open</code> method does not provide a way to manage the output of standard error in the child process, so it winds up connected to the parent's standard error.

## Rolling my own

Eventually I made enough changes to PDFKit to warrant creating my own library I am calling IMGKit, which I am proud to announce is available via:

<code>gem install imgkit</code>

You can then create JPGs from HTML files with:

{% highlight ruby %}
    require 'imgkit'
    kit = IMGKit.new(html, :quality => 50)

    # Get the image BLOB
    img = kit.to_img

    # Save to a file
    file = kit.to_file('/path/to/save/file2.jpg')
    # or
    File.open('/path/to/save/file1.jpg') { |f| f << kit.to_img }

    # send to browser (Rails - use with #caches_page)
    send_data(kit.to_img, :type => "image/jpeg", :disposition => 'inline')
{% endhighlight %}

Code is available on <a href="http://github.com/csquared/IMGKit">github</a>.

Oh, and this is my first gem! Enjoy!!
