-- Player settings -----------------------------------------------
local playerScreenFade = false        -- player's screen fade status
------------------------------------------------------------------

elseif command[1] == "/blindfold" or command[1] == "/screenfade" then
        if playerScreenFade == false then
            Text.SetLoadingText("Blindfolded")
            Game.ForceLoadingScreen(true)
            playerScreenFade = true
        else
            Game.ForceLoadingScreen(false)
            playerScreenFade = false
        end   