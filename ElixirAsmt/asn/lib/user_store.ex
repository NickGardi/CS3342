##############################################################################
# Assignment : 5
# Author     : Nick Gardi
# Email      : ngardi2@uwo.ca
# 
# The UserStore module manages a database of users, storing their usernames and passwords. 
# The user database is a simple text file stored in db/users.txt, with one user stored per line. 
# The format of each line is as follows: username:hash
##############################################################################

import User

defmodule UserStore do

  # Path to the user database file
  # Don't forget to create this directory if it doesn't exist
  @database_directory "db"

  # Name of the user database file
  @user_database "users.txt"

  # Note: you will spawn a process to run this store in
  # ShoppingListServer.  You do not need to spawn another process here
  def start() do
    
    # Load your users and start your loop
    loop()

  end


defp loop() do

    unless File.dir?(@database_directory) do
      File.mkdir_p(@database_directory)
    end

    receive do

      {caller, :clear} ->
        clear(caller)
        loop()

      {caller, :list} ->
        list(caller)
        loop()

      {caller, :add, username, password} ->
        add(caller, username, password)
        loop()

      {caller, :authenticate, username, password} ->
        authenticate(caller, username, password)
        loop()

      {caller, :exit} ->
        exit()
      # Always 3handle unmatched messages
      # Otherwise, they queue indefinitely
      _ ->
	loop()
    end
  end

  
  defp clear(caller) do
    File.rm_rf user_database()
    send(caller, {self(), :cleared})
  end

  
  defp list(caller) do
    #if users.txt does exist:
    if File.exists?(user_database()) do
      #sorted list of usernames
      temp = File.read!(user_database())
      items = String.split(temp, ["\n", ":"], trim: true)
      list1 = Enum.take_every(items, 2)
      list = Enum.sort(list1)
      send(caller, {self(), :user_list, list})
    #if users.txt does not exist, return empty list
    else
      list = []
      send(caller, {self(), :user_list, list}) 
   end
  end

 
  defp add(caller, username, password) do
    #if no users.txt exists
    if !File.exists?(user_database()) do
      hash = hash_password(password)
      string = "#{username}" <> ":" <> "#{hash}"
      File.write(user_database(), "#{string}\n", [:write])
      #create user struct for send
      user = %User{username: "#{username}", password: "#{hash}"}
      send(caller, {self(), :added, user})
      
    else
      #sorted list of usernames
      temp = File.read!(user_database())
      items = String.split(temp, ["\n", ":"], trim: true)
      usernames = Enum.take_every(items, 2)
      #if username is in db
      if Enum.member?(usernames, username) do
        #return
        send(caller, {self(), :error, "User already exists"})
      else
        #hash password, create string to add, add to file
        hash = hash_password(password)
        string = "#{username}" <> ":" <> "#{hash}"
        File.write(user_database(), "#{string}\n", [:append])
        #create user struct for send
        user = %User{username: "#{username}", password: "#{hash}"}
        send(caller, {self(), :added, user})
      end
    end
  end
  
  
  defp authenticate(caller, username, password) do
    unless File.exists?(user_database()) do
      #no users.txt file, failed auth
      send(caller,{self(), :auth_failed, username})
    else
      hash = hash_password(password)
      string = "#{username}" <> ":" <> "#{hash}"
      #compare lines of user000:hash in database to the one passed
      temp = File.read!(user_database())
      linesList = String.split(temp, "\n", trim: true)
      if Enum.member?(linesList, string) do
        send(caller, {self(), :auth_success, username})
      #if password is incorrect
      else
        send(caller, {self(), :auth_failed, username})
      end
    end
  end


  # Prints UserStore shutting down to the screen and terminates process 
  defp exit() do
    IO.puts "ShoppingListStore shutting down"
    Process.exit(self(), :ok)
  end


  # Path to the user database
  defp user_database(), do: Path.join(@database_directory, @user_database)


  # Use this function to hash your passwords
  defp hash_password(password) do
    hash = :crypto.hash(:sha256, password)
    Base.encode16(hash)
  end


end

