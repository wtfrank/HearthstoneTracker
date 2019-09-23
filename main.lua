local HEARTHSTONE_ITEM_ID = 6948;
local HEARTHSTONE_SPELL_ID = 8690;
local HEARTHSTONE_COOLDOWN = 60*60;

local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
--UNIT_SPELLCAST_SUCCEEDED: "unitTarget", "castGUID", spellID
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");

function frame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = (self.sinceLastUpdate or 0) + sinceLastUpdate;
	if ( self.sinceLastUpdate >= 1 ) then -- in seconds
		-- update the cooldown
		self.sinceLastUpdate = 0;
	end
end
frame:SetScript("OnUpdate",frame.onUpdate)

function frame:OnEvent(event, arg1, arg2, arg3, arg4, arg5)
  if event == "ADDON_LOADED" and arg1 == "HearthstoneTracker" then
    --first load of addon
    if WTFRANK_HearthstoneTracker == nil then
      print("First load of HearthstoneTracker");
      WTFRANK_HearthstoneTracker = {};
    end
    
    --first log on of character
    if WTFRANK_HearthstoneTracker[UnitName("player")] == nil then
      print("First load of addon by "..UnitName("player"));
      startTime, duration, enable = GetItemCooldown(HEARTHSTONE_ITEM_ID);
      local remaining = 0;
      if startTime > 0 then
        remaining = startTime + duration - GetTime();
       
      WTFRANK_HearthstoneTracker[UnitName("player")] = os.time() + remaining;
    end
  elseif event == "UNIT_SPELLCAST_SUCCEEDED" and arg5 == HEARTHSTONE_SPELL_ID:
    print("Hearthstone cast detected");
    WTFRANK_HearthstoneTracker[UnitName("player")] = os.time() + HEARTHSTONE_COOLDOWN;
  end
end
