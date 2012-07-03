-----------------------------------
-- Setting up scope and libs
-----------------------------------

local AddonName = select(1, ...);
iTracking = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceEvent-3.0");

-----------------------------
-- Setting up the feed
-----------------------------

iTracking.Feed = LibStub("LibDataBroker-1.1"):NewDataObject(AddonName, {
	type = "data source",
	text = "",
});

function iTracking.Feed.OnClick(anchor, button)
	if( button == "RightButton" ) then
		_G.ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, anchor, 0, 0);
	end
end

----------------------
-- Initializing
----------------------

function iTracking:OnInitialize()
	self:RegisterEvent("PLAYER_ALIVE", "TrackUpdate");
	self:RegisterEvent("MINIMAP_UPDATE_TRACKING", "TrackUpdate");
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "TrackUpdate");
	
	_G.MiniMapTracking:UnregisterAllEvents();
	_G.MiniMapTracking.Show = _G.MiniMapTracking.Hide;
	_G.MiniMapTracking:Hide();
end

------------------------------------------
-- Update
------------------------------------------

local numTrackings;
function iTracking:TrackUpdate()
	numTrackings = _G.GetNumTrackingTypes();
	
	local tracking = 0;
	local name, icon, active;
	
	for i = 1, numTrackings do
		name, icon, active = _G.GetTrackingInfo(i);
		
		if( active ) then
			tracking = tracking + 1;
			
			if( tracking == 1 ) then
				self.Feed.icon = icon;
			end
		end
	end
	
	if( tracking == 0 ) then
		self.Feed.icon = "Interface\\Minimap\\Tracking\\None";
	end
	self.Feed.text = tracking.."/"..numTrackings;
end