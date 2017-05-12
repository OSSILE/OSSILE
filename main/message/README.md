# Message

This service program provides wrappers for the OS message API QMHRCVPM, QMHRSNEM
and QMHSNDPM. It eases the handling of program and escape messages.

This module was part of the [RPGUnit](http://rpgunit.sourceforge.net) framework.
It is now moved to a its own project as this is a more modular approach and 
further encourages reuse.

## Features

* sending messages
* receiving messages
* resending messages
* controlling the call stack level

## Requirements

This software has no further dependencies. It comes with all necessary files.

## Installation
For standard installation the setup script can be executed as is. For automatically
copying the copybook to a directory in the IFS export `OSSILE_INCDIR` like this

    export OSSILE_INCDIR=/usr/local/include/ossile

before executing the setup script. The directory which is stated in the export
should exist before executing the script.

## Usage

Just include the `message_h.rpgle` file to use the procedures.

## License

This service program is released under the MIT License.
