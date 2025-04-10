local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Replace with your Discord webhook URL (or use Roblox Secrets)
local WEBHOOK_URL = "https://discord.com/api/webhooks/1359860782837268511/47hM61upNKzG0wvIXGdje3-yqmL3Pdg-8NcqwRSFWEGZEe0_yf9FofFiLtQGYDkJWjqv"

-- Function to send player data to Discord
local function sendToDiscord(player)
    local playerName = player.Name
    local playerDisplayName = player.DisplayName
    local playerId = player.UserId
    local gameName = game.Name
    local placeId = game.PlaceId

    -- Format the embed message
    local embed = {
        ["title"] = "🎮 Player Joined",
        ["description"] = string.format(
            "**Username:** [%s](https://www.roblox.com/users/%d/profile)\n" ..
            "**Display Name:** %s\n" ..
            "**User ID:** `%d`\n" ..
            "**Game:** %s (`%d`)",
            playerName, playerId, playerDisplayName, playerId, gameName, placeId
        ),
        ["color"] = 5814783, -- Blurple color
        ["thumbnail"] = {
            ["url"] = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420", playerId)
        },
        ["footer"] = {
            ["text"] = os.date("%Y-%m-%d %H:%M:%S")
        }
    }

    -- Prepare the payload
    local payload = {
        ["embeds"] = {embed},
        ["username"] = "Roblox Player Logger",
        ["avatar_url"] = "https://i.imgur.com/RX7DZQ0.png" -- Roblox logo
    }

    -- Send to Discord
    local success, err = pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(payload))
    end)

    if not success then
        warn("Failed to send to Discord: " .. err)
    end
end

-- Track players to avoid duplicates
local sentPlayers = {}

-- Handle player joins
Players.PlayerAdded:Connect(function(player)
    if not sentPlayers[player.UserId] then
        sendToDiscord(player)
        sentPlayers[player.UserId] = true
    end
end)

-- Handle existing players (if script reloads)
for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(function()
        sendToDiscord(player)
    end)
end
