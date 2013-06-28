---
layout: post
title:  Machine Cloud Raspi-Shield v1 Build
---

{{ page.title }}
================

These are the work-in-progress instructions for building a Raspberry Pi Device Sheild
to work with the [mc-device repo](https://github.com/machine-cloud/mc-device).

## Parts

<img src="/images/mc-build/v1/parts.jpg" width="700px" />

- adafruit pi shield w. GPIO header
- push button
- temp sensor
- mcp 3008 analog to digital converter
- RGB led
- breadboard hookup wire

## Solder the GPIO Header

<img src="/images/mc-build/v1/gpio_header.jpg" width="700px" />

## Solder the MCP Seat

The notch in the MCP seat should be facing the adafruit logo.

<img src="/images/mc-build/v1/seat_mcp.jpg" width="700px" />

## Wire up the RGB LED

<img src="/images/mc-build/v1/rgb_led.jpg" width="700px" />

## Test the LED

<img src="/images/mc-build/v1/test_rgb_led.jpg" width="700px" />

    > cd mc-device
    > make
    > ./bin/test_led

## Hookup the Temp Sensor

### Top View (finished for orientation):
<img src="/images/mc-build/v1/top_view.jpg" width="700px" />

### Bottom View (for the wiring on this step):
<img src="/images/mc-build/v1/bottom_wiring.jpg" width="700px" />

## Wire up the MCP

<img src="/images/mc-build/v1/wire_mcp_top.jpg" width="700px" />

## Seat MCP

The notch in the MCP should match the notch in the seat (should be facing the adafruit logo).

<img src="/images/mc-build/v1/top_view2.jpg" width="700px" />

## Test the Temp Sensor

    > cd mc-device
    > ./bin/test_temperature

## Seat the Button

## Solder the Button

Note: this step is screwed up on my board.

## Test the Button

    > cd mc-device
    > ./bin/test_switch
