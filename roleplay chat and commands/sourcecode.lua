-- Server defines -----------------------------------------------

local maxplayers = 31                 -- maximum number of players + 1

local chatProxyDistance = 20          -- talking distance
local lowProxyDistance = 6            -- low distance
local shoutProxyDistance = 30         -- shouting distance
local whisperProxyDistance = 5        -- whisper distance

------------------------------------------------------------------

-- Function ------------------------------------------------------

-- 1 > /local 
-- 2 > /low
-- 3 > /shout
-- 4 > /b
-- 5 > /me /melow
-- 6 > /do /dolow
-- 7 > /my

local function proxyCommand(type, proxyDistance, message)
    local pos = table.pack(Game.GetCharCoordinates(Game.GetPlayerChar(Game.GetPlayerId())))
    local playerName = Game.GetPlayerName(Game.GetPlayerId())
    local cmdText = ""

    if type == 1 or type == 2 then -- /local & /low
        for i = 0, maxplayers do
            if Game.IsNetworkPlayerActive(i) then
                
                local target = Player.GetServerID(i)
                local targetId = Player.GetIDFromServerID(target) 
                local x, y, z = Game.GetCharCoordinates(Game.GetPlayerChar(targetId)) 
                local distance = Game.GetDistanceBetweenCoords3d(x, y, z, pos[1], pos[2], pos[3])
                if distance <= proxyDistance/16 then
                    if type == 1 then
                        cmdText = "{e6e6e6}" .. playerName .. " says: " .. message
                    else
                        cmdText = "{e6e6e6}" .. playerName .. " says [low]: " .. message
                    end
                    Events.CallRemote("proxySay", { target, cmdText })
                elseif distance <= proxyDistance/8 then
                    if type == 1 then
                        cmdText = "{c8c8c8}" .. playerName .. " says: " .. message
                    else
                        cmdText = "{c8c8c8}" .. playerName .. " says [low]: " .. message
                    end
                    Events.CallRemote("proxySay", { target, cmdText })
                elseif distance <= proxyDistance/4 then
                    if type == 1 then
                        cmdText = "{aaaaaa}" .. playerName .. " says: " .. message
                    else
                        cmdText = "{aaaaaa}" .. playerName .. " says [low]: " .. message
                    end
                    Events.CallRemote("proxySay", { target, cmdText })
                elseif distance <= proxyDistance/2 then
                    if type == 1 then
                        cmdText = "{8c8c8c}" .. playerName .. " says: " .. message
                    else
                        cmdText = "{8c8c8c}" .. playerName .. " says [low]: " .. message
                    end
                    Events.CallRemote("proxySay", { target, cmdText })
                elseif distance <= proxyDistance then
                    if type == 1 then
                        cmdText = "{6e6e6e}" .. playerName .. " says: " .. message
                    else
                        cmdText = "{6e6e6e}" .. playerName .. " says [low]: " .. message
                    end
                    Events.CallRemote("proxySay", { target, cmdText })
                end
            end
        end
    end

    if type == 3 or type == 4 or type == 5 or type == 6 or type == 7 then -- /shout /b /me /melow /do /dolow /my
        for i = 0, maxplayers do
            if Game.IsNetworkPlayerActive(i) then
                
                local target = Player.GetServerID(i)
                local targetId = Player.GetIDFromServerID(target) 
                local x, y, z = Game.GetCharCoordinates(Game.GetPlayerChar(targetId)) 
                local distance = Game.GetDistanceBetweenCoords3d(x, y, z, pos[1], pos[2], pos[3])
                if distance <= proxyDistance then
                    if type == 3 then -- /shout
                        cmdText = "{ffffff}" .. playerName .. " shouts: " .. message
                        Events.CallRemote("proxySay", { target, cmdText })
                    end
                    if type == 4 then -- /b
                        local sid = Player.GetServerID(i)
                        cmdText = "{afafaf}(( [" .. sid .. "] " .. playerName .. ": " .. message .. " ))"
                        Events.CallRemote("proxySay", { target, cmdText })
                    end
                    if type == 5 then -- /me /melow
                        cmdText = "{c2a2da}* " .. playerName .. " " .. message
                        Events.CallRemote("proxySay", { target, cmdText })
                    end
                    if type == 6 then -- /do /dolow
                        cmdText = "{c2a2da}* " .. message .. " ((" .. playerName .. "))"
                        Events.CallRemote("proxySay", { target, cmdText })
                    end
                    if type == 7 then -- /my
                        cmdText = "{c2a2da}* " .. playerName .. "'s " .. message
                        Events.CallRemote("proxySay", { target, cmdText })
                    end
                end
            end
        end
    end
end

-- Server Side ---------------------------------------------------

Events.Subscribe("proxySay", function(id, message)
    Chat.SendMessage(id, message)
end, true)

-- Calling function  ---------------------------------------------

elseif command[1] == "/local"  or command[1] == "/l" then
        if command[2] == nil then Chat.AddMessage("Usage: /local [message]")
        else proxyCommand(1, chatProxyDistance, string.sub(fullcommand, string.len(command[1]) + 2))
        end 
    elseif command[1] == "/low" then
        if command[2] == nil then Chat.AddMessage("Usage: /low [message]")
        else proxyCommand(2, lowProxyDistance, string.sub(fullcommand, string.len(command[1]) + 2))
        end 
    elseif command[1] == "/shout" or command[1] == "/s" then
        if command[2] == nil then Chat.AddMessage("Usage: /shout [message]")
        else proxyCommand(3, shoutProxyDistance, string.sub(fullcommand, string.len(command[1]) + 2))
        end 
    elseif command[1] == "/b" then
        if command[2] == nil then Chat.AddMessage("Usage: /b [message]")
        else proxyCommand(4, chatProxyDistance, string.sub(fullcommand, string.len(command[1]) + 2))
        end 
    elseif command[1] == "/me" then
        if command[2] == nil then Chat.AddMessage("Usage: /me [action]")
        else proxyCommand(5, chatProxyDistance, string.sub(fullcommand, string.len(command[1]) + 2))
        end 
    elseif command[1] == "/melow" or command[1] == "/lowme" then
        if command[2] == nil then Chat.AddMessage("Usage: /melow [action]")
        else proxyCommand(5, lowProxyDistance, string.sub(fullcommand, string.len(command[1]) + 2))
        end 
    elseif command[1] == "/do" then
        if command[2] == nil then Chat.AddMessage("Usage: /do [emote]")
        else proxyCommand(6, chatProxyDistance, string.sub(fullcommand, string.len(command[1]) + 2))
        end 
    elseif command[1] == "/dolow" or command[1] == "/lowdo" then
        if command[2] == nil then Chat.AddMessage("Usage: /do [emote]")
        else proxyCommand(6, lowProxyDistance, string.sub(fullcommand, string.len(command[1]) + 2))
        end 
    elseif command[1] == "/my" then
        if command[2] == nil then Chat.AddMessage("Usage: /my [action]")
        else proxyCommand(7, chatProxyDistance, string.sub(fullcommand, string.len(command[1]) + 2))
        end 
