#!/bin/gawk -f

####################################
# Utility to split each line of a  #
# file into it's own separate file #
#                                  #
# Right now the new file has .xml  #
# extension                        #
####################################

# ARGV[0] is input file
# ARGV[1] is starting number
BEGIN {
	counter = ARGV[2]
	delete ARGV[2]
}
{
	print counter
	filename = counter ".xml"
	print > filename
	counter = counter + 1
}
