local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1359860782837268511/47hM61upNKzG0wvIXGdje3-yqmL3Pdg-8NcqwRSFWEGZEe0_yf9FofFiLtQGYDkJWjqv"

local function sendToDiscord(player)
	local playerName = player.Name
	local playerDisplayName = player.DisplayName
	local playerId = player.UserId
	local gameName = game.Name
	local placeId = game.PlaceId

	local embed = {
		["title"] = "Script Executed!",
		["description"] = string.format(
			"**Username:** [%s](https://www.roblox.com/users/%d/profile)\n" ..
				"**Display Name:** %s\n" ..
				"**User ID:** `%d`\n" ..
				"**Game:** %s (`%d`)",
			playerName, playerId, playerDisplayName, playerId, gameName, placeId
		),
		["color"] = 5814783,
		["thumbnail"] = {
			["url"] = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", playerId)
		},
		["footer"] = {
			["text"] = os.date("%Y-%m-%d %H:%M:%S")
		}
	}

	local message = {
		["embeds"] = {embed},
		["username"] = "Roblox Join Notifier",
		["avatar_url"] = "https://i.imgur.com/RX7DZQ0.png" -- Roblox logo
	}

	local success, err = pcall(function()
		HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(message))
	end)

	if not success then
		warn("Failed to send to Discord: " .. err)
	end
end

Players.PlayerAdded:Connect(function(player)
	-- Wait a bit to ensure all player data is loaded
	wait(2)
	sendToDiscord(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(function()
		sendToDiscord(player)
	end)
end
