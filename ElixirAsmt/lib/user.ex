##############################################################################
# Assignment : 5
# Author     : Nick Gardi
# Email      : ngardi2@uwo.ca
# 
# User is a struct that represents a user. 
# Each User contains a username and a password
##############################################################################

defmodule User do

	@enforce_keys [:username, :password]
	defstruct [:username, :password]

end
