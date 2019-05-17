
##############################################################################
# Assignment : 5
# Author     : Nick Gardi
# Email      : ngardi2@uwo.ca
# 
# The ShoppingListServer module implements a shopping list server, handling 
# requests from clients # and making use of the ShoppingListStore and UserStore 
# to read and write data
##############################################################################

defmodule ShoppingListServer do

    def start() do
        # Spawn a linked UserStore process
        users_pid = spawn_link(UserStore, :start, [])  
        
        # Spawn a linked ShoppingListStore process
        lists_pid = spawn_link(ShoppingListStore, :start, [])  

        # Leave this here
        Process.register(self(), :server)  

        # Start the message processing loop 
        loop(users_pid, lists_pid)
    end


    defp loop(users, lists) do
        # Receive loop goes here
        #
        # For each request that is received, you MUST spawn a new process
        # to handle it (either here, or in a helper method) so that the main
        # process can immediately return to processing incoming messages
        #
        # Note: use helper functions.  Implementing everything in a massive
        # function here will lose you marks.
        server_pid = self()
        receive do
            {caller, :new_user, username, password} ->
                spawn(fn -> new_user(caller, username, password, users, server_pid) end)
                loop(users, lists)

            {caller, :list_users} ->
                spawn(fn -> list_users(caller, users, server_pid) end)
                loop(users, lists)

            {caller, :shopping_list, username, password} ->
                spawn(fn -> shopping_list(caller, username, password, users, lists, server_pid) end)
                loop(users, lists)

            {caller, :add_item, username, password, item} ->
                spawn(fn -> add_item(caller, username, password, item, users, lists, server_pid) end)
                loop(users, lists)

            {caller, :delete_item, username, password, item} ->
                spawn(fn -> delete_item(caller, username, password, item, users, lists, server_pid) end)
                loop(users, lists)

            {caller, :clear} ->
                spawn(fn -> clear(caller, users, lists, server_pid) end)
                loop(users, lists)

            {caller, :exit} ->
                exit()
            #handle unmatched messages    	
            _ ->
                loop(users, lists)
        end

    end

    #Sends a message to the UserStore process to add a new user
    defp new_user(caller, username, password, users, server_pid) do
      send(users, {self(), :add, username, password})
      receive do	 
        #if user can be successfully added
        {users, :added, user} -> send(caller, {server_pid, :ok, "User created successfully"})
        #if user already exists
        {users, :error, "User already exists"} -> send(caller, {server_pid, :error, "User already exists"})
        #else, unknown error
         _ -> send(caller, {server_pid, :error, "An unknown error occured"})
      end 
    end

    #Sends a message to the UserStore process to get a sorted list of usernames    
    defp list_users(caller, users, server_pid) do
      send(users, {self(), :list})
      receive do
        {users, :user_list, list} -> send(caller, {server_pid, :ok, list})
      end
    end

    #Sends a message to the UserStore process to authenticate the user
    defp shopping_list(caller, username, password, users, lists, server_pid) do
      send(users, {self(), :authenticate, username, password})
      receive do
        #user fails authentication
        {users, :auth_failed, username} -> send(caller, {server_pid, :error, "Authentication failed"})
        {users, :auth_success, username} -> send(lists, {self(), :list, username})
           receive do
             {lists, :list, username, items} -> send(caller, {server_pid, :ok, items})
               _ -> send(caller, {server_pid, :error, "An unknown error occured"})
            end
        end
    end

    #Sends a message to the UserStore process to authenticate the user
    defp add_item(caller, username, password, item, users, lists, server_pid) do
      send(users, {self(), :authenticate, username, password})
      receive do
        {users, :auth_failed, username} -> send(caller, {server_pid, :error, "Authentication failed"})
        {users, :auth_success, username} -> send(lists, {self(), :add, username, item})
           receive do
             #tries to add item to shopping list
             {lists, :added, username, item} -> send(caller, {server_pid, :ok, "Item '#{item}' added to shopping list"})
             {lists, :exists, username, item} -> send(caller, {server_pid, :error, "Item '#{item}' already exists"})
             _ -> send(caller, {server_pid, :error, "An unknown error occured"})
          end
        end
      end

    #Sends a message to the UserStore process to authenticate the user
    defp delete_item(caller, username, password, item, users, lists, server_pid) do
      send(users, {self(), :authenticate, username, password})
      receive do
        {users, :auth_failed, username} -> send(caller, {server_pid, :error, "Authentication failed"})
        {users, :auth_success, username} -> send(lists, {self(), :delete, username, item})
          receive do
          #tries to delete item from shopping list
          {lists, :deleted, username, item} -> send(caller, {server_pid, :ok, "Item '#{item}' deleted from shopping list"})
          {lists, :not_found, username, item} -> send(caller, {server_pid, :error, "Item '#{item}' not found"})
           _ -> send(caller, {server_pid, :error, "An unknown error occured"})
          end
        end
      end

    #Sends appropriate messages to the UserStore and ShoppingListStore processes to clear 
    #all data in the system
    defp clear(caller, users, lists, server_pid) do
      send(users, {self(), :clear})
      receive do
        {users, :cleared} -> send(lists, {self(), :clear})
         receive do
           {lists, :cleared} -> send(caller, {server_pid, :ok, "All data cleared"})
            _ -> send(caller, {self(), :error, "An unknown error occured"})
          end
        end
      end

    #Prints ShoppingListServer shutting down to the screen, terminate process
    defp exit() do
      IO.puts "ShoppingListServer shutting down"
      Process.exit(self(), :ok)
    end

end


