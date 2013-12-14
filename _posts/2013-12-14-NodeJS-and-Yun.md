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
pairing a linux machine to handle networking to an arduino and having the two
communicate over a USB connection using the Serial protocol.

The Arduino Yun is arduino's first attempt to simply have the linux board shrunk down
enough to fit onto the familiar arduino board.
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

Ok, so Node works!  Now how about npm?  I figured I'd install my
[favorite logging library](https://github.com/csquared/node-logfmt)
;)

    root@Arduino:~# npm install logfmt
    -ash: npm: not found

Looks like I'll have to wrap my head around
[@fibasile's post and binaries](http://fibasile.github.io/compiling-nodejs-for-arduino-yun.html)
 if I want `npm`.

For now, I can take the workaround
and copy the files from my copy over with scp (this won't work for anything that
has extensions).

In the Arduino:

    > root@Arduino:~# mkdir node_modules


From my laptop:

I just
[downloaded the zip](https://github.com/csquared/node-logfmt/archive/master.zip)
of node-logfmt and scp'ed the unzipped directory over to the arduino because
tar did not work right on the linino itself.

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

And a cUrl request from my trusty laptop:

    [csquared@autoM8 nodejs-linino]$ curl http://arduino.local:3000
    Hello, Logfmt

I have a dirty hack to install dependencies!

    root@Arduino:~# node http.js
    listening on 3000
    ip=192.168.1.5 time=2013-12-14T21:18:22.982Z method=GET path= status=200 elapsed=99ms

Loglines!  Success!

Next step, `npm`.


## Update: Conserving resources.

[@fibasile's post and binaries](http://fibasile.github.io/compiling-nodejs-for-arduino-yun.html)
mentions running node via:

    node --stack_size=1024 --max_old_space_size=20 --max_new_space_size=2048 --max_executable_size=5 --gc_global --gc_interval=100

some informal benchmarking showed a drop in memory usage via the slick
"advanced luci configuration panel" from 48% to 24%, so I'd highly recommend it.
