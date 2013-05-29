---
layout: post
title:  Heroku Deploy Visualizer
---

{{ page.title }}
================

## An(other) exercise in Ambient Awareness

For my last trick I built an [Outage Lights](/2013/05/26/Heroku-Outage-Lights.html) system to make it
plainly obvious whenever we were having an outage.  However, one thing I always disliked about this
system is that although it is continually working, we (hopefully) rarely see it in action.  So I set
my sights on building something that could visualize an activity that we actually wanted happening.

The fundamental unit at Heroku is the application.
Some thoughts included blinking an LED whenever someone creates an app, or perhaps showing an
app counter.  However, creating an app on Heroku is so easy and quick it only encapsulates that
first moment of inspiration.  I wanted to show something even more meaningful and quickly realized
that it wasn't creations, but deploys, that are the sign of people doing real work on the platform.

Ok, so with the event (deploys) in mind I now needed a way to visualize it.  Blinking an LED could work,
but is *quite* subtle and would require a lengthy explanation to make it apparent.  I needed something
more visceral.  There must be an LED display compatible with Arduino.  Sure enough, [there is](http://adafruit.com/products/555).

Not only does adafruit sell these LED matrices, but they are chainable!
On top of that, they have an Arduino Library that makes interfacing as simple as:

{% highlight c++ %}
// LED Matrix Library
#include "HT1632.h"

// LED Matrix Pins
#define DATA 2
#define WR   3
#define CS   4

//Led Matrix Controller
HT1632LEDMatrix matrix = HT1632LEDMatrix(DATA, WR, CS);

void setup() {
  //center cursor
  matrix.setCursor(2, 4);
  //print to LED matrix
  matrix.print("Hello, world");
}

{% endhighlight %}

## System Design

The goal of this system is to display a Heroku app name whenever that app is deployed to the platform.
I needed to subscribe to an internal Pusher Feed of app events.
I filter the stream for deploy events and push those events into a [redis](http://redis.io) queue.
The Arduino makes requests over HTTP for a comma-separated list of app names which are built by
popping N items from the queue.

For the CS nerds out there, this is a basic producer-consumer relationship.
The pusher feed is the producer; the arduino the consumer.

Here's a high-level description:

- Arduino Microcontroller
  - [Ethernet Shield](https://www.sparkfun.com/products/9026)
  - 6 [16X24 LED Matrices](http://adafruit.com/products/555)
  - [9V Power Supply](https://www.sparkfun.com/products/298)

- [Web App](https://github.com/csquared/deploy-viz)
  - 1 Web Process for Arduino Requests
  - 1 Background Process to consume event feed
  - 1 Redis instance to store the app name queue

## The Web App

The web app uses Redis and the `pusher-client` gem to do most of the heavy lifting.

### The `firehose` process.

The `Firehose` class is a simple wrapper around the `pusher-client` for parsing a JSON feed.
It is defined in `firehose.rb` and allows me to register a callback that is executed for every
event.  For simplicity's sake, the callback is defined in the bin script itself:

{% highlight ruby %}
#!/usr/bin/env ruby

require_relative "../firehose"
require_relative "../deploys"

BLACKLIST = (ENV['BLACKLIST'] || '').split(',')
PUSHER_CREDS = {
  channel: ENV["PUSHER_CHANNEL"],
  key:     ENV["PUSHER_KEY"],
  secret:  ENV["PUSHER_SECRET"]
}

Firehose.new(PUSHER_CREDS) do |data|
  if data[:action] == 'deploy-app'
    name = data[:target]
    if BLACKLIST.find{ |string| name =~ /^#{string}/ }
      puts "BLACKLIST: #{name}"
    else
      puts "DEPLOY: #{name}"
      Deploys.add(name)
    end
  end
end

{% endhighlight %}

The `BLACKLIST` env var lets me filter certain apps we're constantly deploying as health checks.
When the `action` key in the payload matches the string `deploy-app`, we're in business.
The name of the app is stored in the `target` key.
The `Deploys::add` call adds the app name to the queue in Redis.

### The `web` process.

Because we're only assuming one consumer, the web process is dead simple:

{% highlight ruby %}
require 'sinatra'
require_relative './deploys'

set :port, ENV['PORT'] || 3000

get '*' do
  Deploys.get(ENV['MAX_DEPLOYS']).join(',')
end
{% endhighlight %}

That's it! `Deploys::get` pops the next N names from the queue.  We just  join them with a comma and
ship them back to the arduino.


## The Arduino Program

For the arduino, we just poll the server for the comma-separated list and write the app name to the
LED Matrix.  The most efficient way to do this is to build up an `app_name` variable with each
character of the string.  When we see a comma, we write the app to the LED matrix, clear out the
app_name, and start building the next string.

{% highlight c++ %}
//Variables for loop()
String response;
String app_name;

void loop() {
  response = "";

  //connect to HTTP
  if(heroku.get("/", &response) == 0){
    app_name = "";

    for(int i = 0; i < response.length(); i++){
      if(response.charAt(i) == ','){
        Serial.print("Print: ");
        Serial.println(app_name);
        matrix.clearScreen();
        matrix.setCursor(x_offset, y_offset);
        matrix.print(app_name);
        matrix.writeScreen();
        app_name  = "";
        delay(display_length_millis);
      }else{
        app_name.concat(response.charAt(i));
      }
    }
  }else{
    //wait before next attempt to connect
    delay(display_length_millis);
  }
}
{% endhighlight %}

### We're gonna need a bigger boat

The real issue I ran into was the [LED Driver lib](https://github.com/adafruit/HT1632) only
supporting 4 matrices.  It was truncating a decent number of app names, so I
[decided to add support for more matrices by just hacking the lib I had cloned](https://github.com/csquared/HT1632/commit/a27df6a48359f0f9e27060e7eee4b40649aeefa0#L0L52).
However, it turns out [I wasn't the first person to think of this](https://github.com/adafruit/HT1632/pull/2).
Given the state of that pull request, I decided not to issue one for my changes.

## Putting it all together

Here you can see the Deploy Visualizer installed in the office:

<img src="/images/deploy-viz.jpg" style="width: 500px" title="Heroku Office Installation" />

These techniques could easily be extended to make the LED matrix display other sources of data such
as tweets or text messages, which is left as an excercise for the reader.
Happy hacking!
