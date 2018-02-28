-- ITEM SCROLLER
-- /////////////////////////////////
local scroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local numWheelItems = 11 --THEME:GetMetric("ScreenSelectGroup", "NumWheelItems")

--Item scroller starts at 0, duh.
local currentItemIndex = 0;

-- Scroller function thingy
local item_mt= {
  __index= {
	-- create_actors must return an actor.  The name field is a convenience.
	create_actors= function(self, params)
	  self.name= params.name
		return Def.ActorFrame{		
			InitCommand= function(subself)
				-- Setting self.container to point to the actor gives a convenient
				-- handle for manipulating the actor.
		  		self.container= subself
			end;
				
			Def.BitmapText{
				Name= "text",
				Font= "Common Normal",
			};
			
			Def.Sprite{
				Name="banner";
			};
		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		PrimeWheel(self.container,offsetFromCenter,item_index,numWheelItems)
		--self.container:x(item_index*50)
		--self.container:zoom(math.abs(offsetFromCenter)+1/2)
		
		--[[if offsetFromCenter == 0 then
			self.container:diffuse(Color("Red"));
		else
			self.container:diffuse(Color("White"));
		end;]]
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, info)
	  self.container:GetChild("text"):settext(info)
	  self.container:GetChild("banner"):Load(SONGMAN:GetSongGroupBannerPath(info))
	end,
	gettext=function(self)
		return self.container:GetChild("text"):gettext()
	end,
}}
--local info_set= {"fin", "tail", "gorg", "lilk", "zos", "mink", "aaa"}
local info_set = SONGMAN:GetSongGroupNames();


-- INPUT HANDLER
-- /////////////////////////
local function inputs(event)
	
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	if not pn or isSelectingDifficulty then return end

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	if button == "Center" then
		--SCREENMAN:SystemMessage(scroller:get_info_at_focus_pos());
		--IT'S A HACK! (if you don't put local it makes a global variable)
		currentGroup = scroller:get_info_at_focus_pos();
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
	elseif button == "DownLeft" then
		scroller:scroll_by_amount(-1);
	elseif button == "DownRight" then
		scroller:scroll_by_amount(1);
	end
	
	if button == "MenuDown" then
		local groupName = scroller:get_info_at_focus_pos()
		SCREENMAN:SystemMessage(groupName.." | "..SONGMAN:GetSongGroupBannerPath(groupName));
	end;
	
end;

-- ACTORFRAMES FOR BOTH
-- ////////////////////////
local t = Def.ActorFrame{
	OnCommand=function(self)
		scroller:set_info_set(info_set, 1);
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		SCREENMAN:SystemMessage(math.ceil(numWheelItems/2));
	end;
};
t[#t+1] = scroller:create_actors("foo", numWheelItems, item_mt, SCREEN_CENTER_X, SCREEN_CENTER_Y);


return t;
