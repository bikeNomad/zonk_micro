Zonk! Micro
===========
Ned Konz

What is Zonk! Micro?
====================

### Programming System for "Physical Computing"

  - Programming language with multiple editors
  - Simulation of I/O
  - Applications portable between targets
  - Playback of recorded trace data for debugging

### Programs run on:

  - Microcontroller-based gadgets
  - Desktop operation using data acquisition modules or microcontroller boards as I/O slaves

Audience
========

### Non-Programmers

  - Gadgeteers
  - Kids
  - Technicians
  - Scientists
  - Industrial Designers
  - Everyone!

### Programmers in a hurry

Zonk's Views
============
- System and Connection Editor
- Task Editor
- Table Editor
- Text Editor
- Trace History View

System & Connection Editor
==========================
- Presents "cookbook" style design patterns for connection of common sensors and actuators
- Lets you easily move an application between different targets
- Monitors I/O using microcontroller board as an I/O slave

Task Editor
===========

### Add outputs to a Task (Tasks own outputs)

- Digital, Analog outputs
- Variables
- Events (broadcast to all tasks)
- Tickers
- Timers (one-shot)
- Communications (serial, I2C, SPI...)

Task Editor (con't.)
===========

### Add inputs to a Task

- Digital, Analog inputs (multiple Tasks can use the same inputs)
- Outputs can be used as inputs
- Variables (set by other Tasks)
- Events
- Communications

### Add Rule Tables to a Task

Table Editor
============

## Rules encode behavior.

### Rule's Input conditions

- AND combination; unset == don't care
- Digital Inputs are ON/OFF
- Analog Inputs are above/below/inside range/outside range
- Events have happened
- Timers have ticked or timed out
- Table has just been entered

Table Editor (con't.)
=====================

### Rule's Output actions

  - Turn Digital Outputs ON/OFF
  - Set Analog Outputs to a value
  - Set/Modify Variables
  - Trigger/Stop/Start Timers or Tickers
  - Play a sound
  - Broadcast an event
  - Communicate
  - Switch Task's current Table to a different Table

Text Editor
===========

### Presents same logic as Table Editor, just in textual form

- Syntax Directed
- Syntax highlighting
- Can switch back and forth between Text and Table editors

Trace History View
==================
- Events, Rule firings, Table and Task actions are traced
  - Recorded in available memory for later communication/playback
  - Sent over communications link if available for recording on desktop
- Support for collaboration
  - Can be annotated with text or pictures
  - Can be synchronized with separately recorded video
  - Can share trace plus annotations/video with others
- Answer questions about program operation
  - Why did something unexpected happen?
  - Why didn't something happen as expected?
