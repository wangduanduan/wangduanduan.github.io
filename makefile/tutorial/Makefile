# Recursive variable. This will print "later" below
one = one ${later_variable}
one = $(one) abc
# Simply expanded variable. This will not print "later" below
two := two ${later_variable}
two := $(two) abc

later_variable = later

all: 
	echo $(one)
	echo $(two)