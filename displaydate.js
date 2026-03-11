#!/bin/bash

###########################################################################
# Creating a code to display current date and perform system node health test

# Author name : David Timilehin

###############################################################################


date | echo "Today is $(date)"


set -x

dh -f

free -h

nproc


