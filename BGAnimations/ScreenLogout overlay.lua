local function inputs(event)
	--Check if player clicked screen, then skip to next screen if they did.
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	if not pn then return end
	--Ignore unjoined players
	if not GAMESTATE:IsSideJoined(pn) then return end
	
	--This theme doesn't use the mouse, so no need to check..
	--[[if event.DeviceInput.is_mouse then
		button = ToEnumShortString(event.DeviceInput.button)
	end]]
	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	if button == "Start" or button == "Center" then
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
	else
		--SCREENMAN:SystemMessage("Unregistered button: "..button);
	end;
end;


--Header
local t = Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;

	LoadActor(THEME:GetPathG("","header"), false);
	
	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(rotationx,30;diffuse,0.08,0.08,0.08,1;diffusetopedge,0.2,0.2,0.2,1;shadowlengthy,-1;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_TOP+37;zoomx,0.7;zoomy,0.725;);
		Text="RESULTS";
	};
	
	--TIMER

	LoadActor("B0") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+190;y,SCREEN_TOP+16;zoomy,0.55;zoomx,-0.55);

	};

	LoadActor("B1") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

	};

	LoadActor("B2") .. {
		InitCommand=cmd(draworder,103;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

	};

	LoadFont("venacti/_venacti 26px bold diffuse")..{
		InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,-0.8;shadowlength,-0.8;horizalign,left;x,SCREEN_CENTER_X+185 ;y,SCREEN_TOP+16;zoom,0.40);
		Text="TIMER"
	};
};

t[#t+1] = LoadActor(THEME:GetPathG("","footer"), true)..{
	InitCommand=cmd(draworder,130);
};

return t;