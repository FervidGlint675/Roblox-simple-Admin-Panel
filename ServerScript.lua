local DataStoreService = game:GetService("DataStoreService")
local Data = DataStoreService:GetDataStore("Datae")

local isAdminfunc = game:GetService("ReplicatedStorage"):WaitForChild("IsAdmin")

local Admins = { 
	[1408930356] = true --Set your userId here or more people userid to have admin access
}


local function Admin(player)
	return Admins[player.UserId] == true
end

local KickEvent = game:GetService("ReplicatedStorage"):WaitForChild("KickPanel")
KickEvent.OnServerEvent:Connect(function(player, nome)
	if Admin(player) then
		local target = game.Players:FindFirstChild(nome)
		if target then 
			print(player.Name, "kicked:", nome)
			target:Kick("Sei stato kickato da un admin")
		else
			print("Non ci sono persone on con il nome di:",nome)
		end

	end
end)




local BanEvent = game:GetService("ReplicatedStorage"):WaitForChild("BanPanel")	
BanEvent.OnServerEvent:Connect(function(player, nome)
	if Admin(player) then
		local target = game.Players:FindFirstChild(nome)
		if target then
			local succes,data = pcall(function()
				return Data:SetAsync(tostring(target.UserId), true)
			end)

			if succes and data then
				print(data)
			else
				print("Warn, ",data)
		 	end
			target:Kick("Sei stato kickato per ban")
			
		else
			print("Non ci sono persone con quel nome!")
		end
	end
end)
		
local function unBan(player)
	player.Chatted:Connect(function(msg)
		if Admin(player) and string.sub(msg, 1, 6) == ":unban" then
			local nome = string.sub(msg, 8)

			local target = game.Players:FindFirstChild(nome)
			
			print(target)
			
			if target  then
			local success, data = pcall(function()
				return Data:SetAsync(tostring(target.UserId), false)
			end)

				if success then
					print("Unbannato:", nome)
				else
					warn("Errore DataStore:", data)
				end
			else
				print("Non cè un player con quel nome: ", target)
			end	
		end
	end)
end



local TpEvent = game:GetService("ReplicatedStorage"):WaitForChild("TpPanel")
TpEvent.OnServerEvent:Connect(function(player, nome1, nome2)
	if Admin(player)then
		local player1 = game.Players:FindFirstChild(nome1)
		if not player1 then print("Giocatore 1 non trovato:", nome1) return end
		local player2 = game.Players:FindFirstChild(nome2)
		if not player2 then print("Giocatore 2 non trovato:", nome2) return end
		
		

			
			
		local char1 = player1.Character or player1.CharacterAdded:Wait()	
		local char2 = player2.Character or player2.CharacterAdded:Wait()
		
		char1:FindFirstChild("HumanoidRootPart").CFrame = char2:FindFirstChild("HumanoidRootPart").CFrame
	else
		print("Non sei un admin non puoi usare :tp")
	end
end)
		
		

isAdminfunc.OnServerInvoke = function(player)
	return Admin(player)
end

game.Players.PlayerAdded:Connect(function(player)
	if game:GetService("RunService"):IsStudio() then
		--this just make so when your testing in studio the Player test have admin 
		Admins[player.UserId] = true
	end

	if Admin(player) then
		print("Un admin è entrato")

	end
	
	local success,data = pcall(function()
		return Data:GetAsync(tostring(player.UserId))
	end)
	
	if success and data == true then
		player:Kick("sei bannato")
	else
		warn("Errore datastore", data)
	end
	
	unBan(player)
end)