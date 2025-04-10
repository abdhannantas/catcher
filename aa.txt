local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Your Discord webhook URL
local WEBHOOK_URL = "https://discord.com/api/webhooks/1359860782837268511/47hM61upNKzG0wvIXGdje3-yqmL3Pdg-8NcqwRSFWEGZEe0_yf9FofFiLtQGYDkJWjqv"

-- Function to send webhook (no error warnings)
local function logScripter(player)
    local embed = {
        ["title"] = "🛠️ Script Executed",
        ["description"] = string.format(
            "**Username:** [%s](https://www.roblox.com/users/%d/profile)\n" ..
            "**Display Name:** %s\n" ..
            "**User ID:** `%d`",
            player.Name, player.UserId, player.DisplayName, player.UserId
        ),
        ["color"] = 16753920,
        ["footer"] = {
            ["text"] = os.date("%Y-%m-%d %H:%M:%S")
        }
    }

    local payload = {
        ["embeds"] = {embed},
        ["username"] = "Script Logger",
        ["avatar_url"] = "https://i.imgur.com/RX7DZQ0.png"
    }

    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(payload))
    end)
end

-- Wait for a player, then log
task.spawn(function()
    local player = Players:GetPlayers()[1]
    if not player then
        player = Players.PlayerAdded:Wait()
    end
    logScripter(player)
end)
