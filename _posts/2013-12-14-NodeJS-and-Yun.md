---
layout: post
title:  Node.js and Yun
---

{{ page.title }}
================

Getting your microcontroller-based hardware projects online is in still
many cases a battle between the ease of use of arduino's I/O yet difficult
to use wifi versus's linux's battle tested tcp stack yet difficult to use
I/O.  There are merits to all solutions, some of which simply include
pairing a linux machine to handle networking to an arduino nad having the two
communicate over a USB connection using the Serial protocol.

The Arduino Yun is arduino's first attempt to simply have the linux board shrunk down
enough to fit on-chip.
[You can read more about it from them](http://arduino.cc/en/Main/ArduinoBoardYun?from=Main.ArduinoYUN).
It is a welcome answer to the Raspberry Pi and BeagleBone
Black.  There are TWO micropocessors on a single Yun board.  One runs the Linino distribution
of linux, which is a variant of OpenWRT.  The other is the familiar arudino ATmega.
[There's some baked-in](http://arduino.cc/en/Guide/ArduinoYun#toc16) ways to communicate between
the two systems I haven't had any time to play with yet.

My first mission was to try to get Node.js on the Lininuo computer running.

# First steps.

[Configuring the Yun for WiFi](http://arduino.cc/en/Guide/ArduinoYun#toc13) was amazingly simple.
On first boot, its starts up as an AP.  You can log in to the network and configure it to connect
to your own wifi.

Once you're on the same network, you can ssh in with:

    ssh root@arduino.local

If that works you're on your way to running node on the Yun.
From there I simply followed
[Giorgio Cefaro's](http://giorgiocefaro.com/blog/installing-node-js-on-arduino-yun)
guide to use his node binaries.

After installation,

    [csquared@autoM8 nodejs-linino]$ ssh root@arduino.local
    root@Arduino:/tmp# opkg install uclibcxx_0.2.4-1_ar71xx.ipk
    Installing uclibcxx (0.2.4-1) to root...
    Configuring uclibcxx.
    root@Arduino:/tmp# opkg install node_v0.10.17-2_ar71xx.ipk
    Installing node (v0.10.17-2) to root...
    Configuring node.

I wanted to confirm things were working:

    root@Arduino:/tmp# node
    > console.log("Hello, Arduino!");
    Hello, Arduino!
    undefined

Money.

Just for fun, I started up a web-server:

    > vi http.js


{% highlight javascript %}
var http = require('http');

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end("Hello, Yun!\n");
}).listen(9615);

console.log("listening on 9615")
{% endhighlight %}


    > root@Arduino:~# node http.js
    listening on 9615


And from my laptop:

    [csquared@autoM8]$ curl http://arduino.local:9615
    Hello, Yun!

Ok, so Node works!  Now how about npm?  How about logging
HTTP requests.

    root@Arduino:~# npm install logfmt
    -ash: npm: not found

Looks like I'll have to wrap my head around
[@fibasile's post and binaries](http://fibasile.github.io/compiling-nodejs-for-arduino-yun.html)

If I want npm.  For now, I can take the workaround:

    > root@Arduino:~# mkdir node_modules

And copy the files from my copy over with scp (this won't work for anything that
has extensions).

    [csquared@autoM8]$ cd ~/Downloads/node-logfmt-master
    [csquared@autoM8]$ npm install --production
    [csquared@autoM8]$ scp -r ~/Downloads/node-logfmt-master root@arduino.local:~/node_modules/logfmt


I screwed up the first time and forgot to include the npm dependencies before I scp'ed the directory over.
It would definitely be better to just "have" npm.

Anyways, after a quick rewrite of my HTTP server:

    root@Arduino:~# vi http.js

{% highlight javascript %}
var http = require('http');
var logfmt = require('../logfmt');

var HTTPhandler = function(req, res){
  logfmt.requestLogger()(req,res,function(){
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end("Hello, Logfmt\n");
  })
}

http.createServer(HTTPhandler).listen(3000)
console.log("listening on 3000")
{% endhighlight %}


    root@Arduino:~# node http.js

A cUrl request from my trusty laptop:

    [csquared@autoM8 nodejs-linino]$ curl http://arduino.local:3000
    Hello, Logfmt

And a dirty hack to install dependencies!

    root@Arduino:~# node http.js
    listening on 3000
    ip=192.168.1.5 time=2013-12-14T21:18:22.982Z method=GET path= status=200 elapsed=99ms

Next step, `npm`.



















