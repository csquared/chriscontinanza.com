---
layout: post
title:  The Heroku Outage Lights System
---

{{ page.title }}
================

## An exercise in Ambient Awareness

Heroku offers the power of UNIX in a cloud platform.  With great power comes
great responsiblity - we are responsible for running millions of
our users' web applications.

All distributed systems are subject to failure and we are no exception.  Sometimes
systems can automatically recover.  However, sometimes they cannot.  Its the latter
class of failures that require people to be aware and on-call.  Someone getting a
page, while it creates a sense of urgency in the person being paged, doesn't really
do much for anyone else.

Monitoring is also a crucial piece of awareness.  There are large screens around the office
with graphs showing inbound traffic, database read and write performance, and all forms
of integers and floats being graphed live.  In addition to raw numbers, we have a
particularly well-designed and informative <a href="http://status.heroku.com">Status Site</a>
that can summarize the plaform status into a simple red, green, or yellow.

However, we can't spend all day staring at graphs, waiting for something to go wrong.
What we were missing was the "fire alarm": the giant red light that means shit is
currently hitting the fan.

### Aruduino to the rescue

To bridge that gap, I built an Arduino-based lighting system that paints the office red
whenever our status site is red (reporting an outage).  It includes its own monitoring and leverages
as much of the platform as possible.

Painting the office red involves a simple mechanism: a power strip that is connected
to a very special power cord.  What makes the power cord special is that it is operated
by a 5 Volt relay - making it an electronic switch controllable by the arduino.

<img width="300"
src="https://a248.e.akamai.net/camo.github.com/f967e976f641fc3e4f321bc3f0cffbbf60603979/687474703a2f2f692e696d6775722e636f6d2f52583642642e6a7067" />

So simple enough.  Hook up the lights to the power strip, the power strip to the special
cord, the special cord to the arduino, the arduino to an ethernet shield,
some magic happens, aaaand monitoring!  Simple.

On its third iteration, the current outage light system consists of 3 components:

- The actual lighting setup
  - four "wall washers"
  - one airstrip hazard lamp

- An Arduino, with an ethernet shield, on the office network.
  - [Powertail II](https://www.sparkfun.com/products/10747) to control a power strip
  - [Custom software on the arduino](https://gist.github.com/csquared/4341720)

- [A Heroku app](https://gist.github.com/csquared/4341720) with 2 processes

  - a `web` process with 2 endpoints:
    - one that serves the platform status to the arduino
    - one that serves the system status to the Heroku employees
  - a `monitor` process that alerts the system operator via email if the outage lights themselves are down

## The Arduino program

The Arduino presented a few constraints: I had to use a raw HTTP endpoint (no ssl).  Also, the Arduino's `EthernetClient` is
a byte-level interface.
The program has been through a few iterations.
On the current one I've [written my own http library](http://github.com/csquared/arduino-http).
The lib sets the `Host` header for you, which Heroku uses to determine which app you are requesting.
I'm also using a Basic Auth header as a lightweight way of keeping people honest.

### Connecting to Heroku from an Arduino Ethernet Shield
Here's a snippet of the Arduino program that connects to Heroku.

{% highlight c++ %}
//boolean flag
status_on = false;

HTTP heroku = HTTP("outage-lights.herokuapp.com");

// Make an HTTP request:
char* auth_header[] = {"Authorization: Basic <REDACTED>"};
String response = "";

if (heroku.get("/status", auth_header, 1, &response) == 0) {
  http_failures = 0;
  Serial.println(response);
  Serial.println(response.indexOf("red"));

  // If its red, turn the switch on.
  if(response.indexOf("red") == -1){
    Serial.println("Status clear - LED OFF");
  }
  else {
    Serial.println("Status red! - LED ON");
    status_on = true;
  }
}
else {
  //count failures cus you didn't get a connection to the server
  http_failures++;
  Serial.println("connection to status failed");
}

{% endhighlight %}

Another limitation of the Arduino is that strings must be less that 1024KB in length.
This meant truncation for any large JSON packets, so having my own endpoint that
returns a body of `red` or `green` is perfect for the Arduino.

### The Heroku App -  watching the watchers

The lights controller is pretty cool, but how would I know when the Arduino fails?

Clearly, the outage lights need their own monitoring system.

Originally the arduino connected to separate endpoints for consuming status and POSTing
heartbeats.  When we started using our own app to serve the red/green status, it
made sense to use those requests for the heartbeat as well.

The way it works now is that when every `/status` request comes in,
a key in redis gets set (via `Arduino.heartbeat`)
with an expiration (default 10 seconds, configurable by ENV var).

This enables us to check if requests have come in during the last ten seconds
by simply checking on the presence of this key.

#### Status/Heartbeat Endpoint for the Arduino

The following Sinatra endpoint implements returning the string `red` or `green`
when status is red or green and also sets the Redis key used for monitoring
the system.

{% highlight ruby %}
class Status < Sinatra::Base
  use Rack::Auth::Basic, "Restricted Area", &BASIC_AUTH

  get '*' do
    red = true
    # Let's us trigger a "red" response by setting a config var for testing
    if ENV['FIREDRILL']
      $stdout.puts "firedrill=true "
    else
      # Assume we're up!
      Arduino.heartbeat
      begin
        # Connect to status
        url = ENV['STATUS_URL']:
        result = Excon.get(url).body
        $stdout.puts "url=#{url} result=#{result}"
        red = (result.empty? || JSON.parse(result)["status"].values.include?('red'))
      rescue Exception => e
        puts "Error connecting to status #{e.message}"
      end
    end
    status = red ? 'red' : 'green'
    $stdout.puts "status=#{status}"
    status
  end
end
{% endhighlight %}

### Monitor the System for the Peoples

The following Sinatra endpoint serves an html page that indicates whether the
lights are working or not.


{% highlight ruby %}
  get '/' do
    @color = Arduino.up? ? 'green' : 'red'
    erb :index
  end
{% endhighlight %}

If the key is set, the Outage Lights system is up, and `Arduino.up?` returns `true`.
If that key is not set, the Outage Lights system is not up, and `Arduino.up?` returns false.

in `views/index.erb`

{% highlight html %}
<!doctype>
<html>
  <head>
    <style type="text/css">
      body {
        height: 100%;
        width: 100%;
        background-color: <%= @color %>;
      }
    </style>
    <title>Monitoring the Monitor Lights!</title>
    <script type="text/javascript">
      setTimeout("window.location.reload()", 10000)
    </script>
  </head>
  <body>
  </body>
</html>
{% endhighlight %}

We now have a simple web frontend
(<a href="https://github.com/csquared/sinatra-google-auth">protected via google auth</a>)
that lets us know the status of the Outage Lights system.

We also have a monitor process that checks the status and alerts me via email if
the lights are ever down.

{% highlight ruby %}
# monitor.rb -- run with `ruby monitor.rb`

require './env'

loop do
  sleep ENV['MONITOR_INTERVAL'].to_i
  unless Arduino.up?
    Mail.deliver do
      from 'heartbeat-monitor'
      to   ENV['MONITOR_EMAIL']
      subject 'Outage Lights Down'
      body    Time.now.to_s
    end
  end
end
{% endhighlight %}

With those in place, we have a monitoring system for the Outage Lights system!
A way to watch  the watchers, if you will.
The <a href="https://github.com/csquared/heartbeat-monitor">Heroku app</a>
is a simple `Rack` app composed of two `Sinatra` apps.
Its pretty thoroughly Unit tested and relatively undocumented.

## Putting it together

<img width="400px" src="http://f.cl.ly/items/2D3f2P0E0f072W0P1Z3M/photo.JPG"/>

The light system on with our status site red in the background.

<img width="400px" src="http://f.cl.ly/items/0P2R251b24410n2U1w0T/lights2.jpeg"/>

Stairwell light- this is a former Runway light from San Francisco International Airport.


This system, besides being fun to design and build, allows us to have a more visceral
connection to our status site.  Using these techniques (and lifting the code), you
can leverage the power of the cloud in your physical world.  Happy Hacking!
