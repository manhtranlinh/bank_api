defmodule BankAPI.Accounts.Commands.Validators do
   def positive_integer(data, minimum \\ 0) do
    cond do
      is_integer(data) ->
	if data > minimum do
	  :ok
	else
	  {:error, "Argument must be bigger than #{minimum}"}
	end
	
	true -> {:error, "Argument must be an integer"}
    end
  end
 
end
