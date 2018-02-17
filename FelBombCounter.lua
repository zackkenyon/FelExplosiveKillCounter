
function FelBombCounterFrame_OnEvent(_,eventType,...)
  if eventType == "COMBAT_LOG_EVENT_UNFILTERED" then
    FelBombCounterFrame_OnCombatEvent(...)
  elseif eventType == "PLAYER_ENTERING_WORLD" then 
    FelBombCounterFrame_OnPEW(...)
  elseif eventType== "ADDON_LOADED" then
    addon_name=...
    if addon_name=="FelBombCounter" then

      if not FelBombKillCounts then
        FelBombKillCounts={}
      end
      if FBCVerbose==nil then
        FBCVerbose=true
      end
      print("Welcome to Fel Bomb Kill Counter");
      print("To print the current Fel bomb kill scores to the party type '/fbc show'");
      print("To reset the kill counter scores type '/fbc reset'");
      print("To toggle kill notifications and this message type '/fbc verbose'");
    
    end
  end
end
-- function FelBombCounterFrame_OnPEW(...)
--   local zone = GetInstanceInfo();
--   if zone == "" then
--     -- we are nowhere, we should wait until we are somewhere
--     return
--   end
--   -- print("Changed Zone");
--   -- local instance,z1
--   -- instance,z1=IsInInstance();
-- end
SLASH_FBC1 = "/fbc"
SlashCmdList["FBC"] = function(msg)
  if msg=="show" then
    SendChatMessage("Fel Explosive kill counts since tracking started","PARTY",nil,nil)
    SendChatMessage("------------------------------------------------","PARTY",nil,nil)
    for key,value in pairs(FelBombKillCounts) do
      SendChatMessage(key..": "..value,"PARTY",nil,nil)
    end
  elseif msg=="reset" then
    FelBombKillCounts={}
  elseif msg=="verbose" then
    FBCVerbose = not FBCVerbose
  else
    print("Command not recognized");
  end
end 
function FelBombCounterFrame_OnCombatEvent(timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...) 
  local _, overkill
  if event == "SWING_DAMAGE" then
    _, overkill = ...
  elseif event:find("_DAMAGE", 1, true) and not event:find("_DURABILITY_DAMAGE", 1, true) then
    _, _, _, _, overkill = ...
  end
  if (not (overkill == nil)) and (not (overkill == -1)) then
    if destName=="Fel Explosives" then
      if FelBombKillCounts[sourceName] then
        FelBombKillCounts[sourceName] = FelBombKillCounts[sourceName]+1
      else
        FelBombKillCounts[sourceName] = 1
      end
      if FBCVerbose then
        print(sourceName.." has killed "..FelBombKillCounts[sourceName].." "..destName.." so far.");
      end
    end
  end
end
function FelBombCounterFrame_OnLoad()
  getglobal("FelBombCounterFrame"):RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
  -- getglobal("FelBombCounterFrame"):RegisterEvent("PLAYER_ENTERING_WORLD");
  getglobal("FelBombCounterFrame"):RegisterEvent("ADDON_LOADED")
  getglobal("FelBombCounterFrame"):SetScript("OnEvent", FelBombCounterFrame_OnEvent);
end
function helloworld()
  print("Hello Justin");
end
