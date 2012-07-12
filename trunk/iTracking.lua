-----------------------------------
-- Setting up scope and libs
-----------------------------------

local AddonName, iTracking = ...;
LibStub("AceEvent-3.0"):Embed(iTracking);

local _G = _G;

-----------------------------
-- Setting up the LDB
-----------------------------

iTracking.ldb = LibStub("LibDataBroker-1.1"):NewDataObject(AddonName, {
	type = "data source",
	text = "",
});

iTracking.ldb.OnClick = function(anchor, button)
	if( button == "RightButton" and not _G.IsModifierKeyDown() ) then
		_G.ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, anchor, 0, 0);
	end
end

iTracking.ldb.OnEnter = function() end
iTracking.ldb.OnLeave = iTracking.ldb.OnEnter;

----------------------
-- Initializing
----------------------

function iTracking:Boot()
	self:RegisterEvent("PLAYER_ALIVE", "TrackUpdate");
	self:RegisterEvent("MINIMAP_UPDATE_TRACKING", "TrackUpdate");
	
	_G.MiniMapTracking:UnregisterAllEvents();
	_G.MiniMapTracking.Show = _G.MiniMapTracking.Hide;
	_G.MiniMapTracking:Hide();
	
	self:TrackUpdate();
end
iTracking:RegisterEvent("PLAYER_ENTERING_WORLD", "Boot");

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
				self.ldb.icon = icon;
			end
		end
	end
	
	if( tracking == 0 ) then
		self.ldb.icon = "Interface\\Minimap\\Tracking\\None";
	end
	self.ldb.text = tracking.."/"..numTrackings;
end