# Assert

This service program provides procedures to make assertions and provides
information if an assertion fails.


## Requirements

This software depends on the *message* service program, see project
[OSSILE](https://github.com/OSSILE/OSSILE/tree/master/main/message).


## Installation
For standard installation the setup script can be executed as is. For automatically
copying the copybook to a directory in the IFS export `OSSILE_INCDIR` like this

    export OSSILE_INCDIR=/usr/local/include/ossile

before executing the setup script. The directory which is stated in the export
should exist before executing the script.


## Usage

Just include the `assert_h.rpgle` file to use the procedures.

To get the number of called assertions or to access additional information
about a failed assertion import the data structure *assert_info* like this:

    dcl-ds assert_info_consumer likeds(assert_info_t) import('assert_info');


## License

This service program is released under the MIT License.
