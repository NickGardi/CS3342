
##############################################################################
# Assignment : 5
# Author     : Nick Gardi
# Email      : ngardi2@uwo.ca
# 
# The ShoppingListStore module manages shopping lists for users. 
# Shopping list files are stored as text files in db/lists/*, 
# and one file is stored per user.
##############################################################################

defmodule ShoppingListStore do

  # Path to the shopping list files (db/lists/*)
  # Don't forget to create this directory if it doesn't exist
  @database_directory Path.join("db", "lists")




  # Note: you will spawn a process to run this store in
  # ShoppingListServer.  You do not need to spawn another process here
  def start() do

    # Call your receive loop
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
      
      {caller, :list, username} ->
        list(caller, username)
	loop()

      {caller, :add, username, item} ->
	add(caller, username, item)
	loop()

      {caller, :delete, username, item}	->
	delete(caller, username, item)
	loop()

      {caller, :exit} ->
	exit()
      # Always handle unmatched messages
      # Otherwise, they queue indefinitely
      _ ->
        loop()
    end

  end

  # Implemented for you
  defp clear(caller) do
    File.rm_rf @database_directory
    send(caller, {self(), :cleared})
  end


  # Loads the user's shopping list from db/lists/USERNAME.txt
  defp list(caller, username) do
  #if USERNAME.txt does exist:
    if File.exists?(user_db(username)) do
      list = String.split(File.read!(user_db(username)), "\n", trim: true)
      items = Enum.sort(list)
      send(caller, {self(), :list, username, items})	
      else
        #if file doesnt exist
        items = []
        send(caller, {self(), :list, username, items})
    end
  end


  # Adds the item to db/lists/USERNAME.txt
  defp add(caller, username, item) do
    #if user file doesnt exist, create it
    if !File.exists?(user_db(username)) do
      File.write(user_db(username), "#{item}\n", [:write])
      send(caller, {self(), :added, username, item})
    else
      #get list
      items = String.split(File.read!(user_db(username)), "\n", trim: true)
      #if item is in list, return
      if Enum.member?(items, item) do
        send(caller, {self(), :exists, username, item})
        #if item is not in list 
      else
        #add item
        newList = items ++ [item]
        newListSorted = Enum.sort(newList)
        File.write(user_db(username), "#{item}\n", [:append])
        send(caller, {self(), :added, username, item})
      end
    end
  end










  #  deletes the item from db/lists/USERNAME.txt
  defp delete(caller, username, item) do
    #if user file doesnt exist, return
    unless File.exists?(user_db(username)) do
      send(caller, {self(), :not_found, username, item})
    else
      #get list
      items = String.split(File.read!(user_db(username)), "\n", trim: true)
      # if item is in list
      if Enum.member?(items, item) do
        #delete item
        itemsNew = List.delete(items, item)
        #overwrite old file with new list
        itemsSorted = Enum.sort(itemsNew)
        #recreate empty file
	File.write(user_db(username), "", [:write])
        Enum.each(itemsSorted, fn item -> File.write(user_db(username), "#{item}\n", [:append]) end)
        send(caller, {self(), :deleted, username, item})
      #if item not in list
      else
        send(caller, {self(), :not_found, username, item})
      end 
    end
  end

  # Prints ShoppingListStore shutting down to the screen and terminates process 
  defp exit() do
    IO.puts "ShoppingListStore shutting down"
    Process.exit(self(), :ok)
  end



  # Path to the shopping list file for the specified user
  # (db/lists/USERNAME.txt)
  defp user_db(username), do: Path.join(@database_directory, "#{username}.txt")

end

