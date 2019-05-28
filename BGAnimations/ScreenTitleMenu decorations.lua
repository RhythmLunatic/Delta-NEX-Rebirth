local setup = GetUserPref("UserPrefSetPreferences");
if setup == nil then
	setup = "Undefined"
end
local timing = math.floor(PREFSMAN:GetPreference("TimingWindowScale")*100)/100;
local t = Def.ActorFrame {

	--[[Def.Quad{
		InitCommand=cmd(Center;vertalign,bottom;y,SCREEN_BOTTOM;zoomto,SCREEN_WIDTH,40;diffuse,0,0,0,0.5);
	};]]

	Def.Quad{
		InitCommand=cmd(Center;vertalign,top;y,SCREEN_TOP;zoomto,SCREEN_WIDTH,40;diffuse,0,0,0,0.5);
	};

	--[[Def.Quad{
		InitCommand=cmd(glowshift;Center;vertalign,bottom;y,SCREEN_BOTTOM-40;zoomto,SCREEN_WIDTH,2;diffuse,color("#F54D70"));
	};]]
	
	 Def.Quad{
		InitCommand=cmd(glowshift;Center;vertalign,top;y,SCREEN_TOP+40;zoomto,SCREEN_WIDTH,2;diffuse,color("#F54D70"));
	};


	 LoadActor(THEME:GetPathG("","logo"))..{
		InitCommand=cmd(Center;y,SCREEN_CENTER_Y-10;zoom,0.9);
	};

	-- press buttons

	 LoadActor(THEME:GetPathG("","player_base"))..{
		InitCommand=cmd(Center;x,SCREEN_LEFT+40;y,SCREEN_BOTTOM-80;zoom,0.5);
	};

	 LoadActor(THEME:GetPathG("","player_base"))..{
		InitCommand=cmd(Center;x,SCREEN_RIGHT-40;y,SCREEN_BOTTOM-80;zoomy,0.5;zoomx,-0.5);
	};

	 LoadActor(THEME:GetPathG("","1p"))..{
		InitCommand=cmd(glowshift;horizalign,center;x,SCREEN_LEFT+35;y,SCREEN_BOTTOM-80;zoom,0.5);
	};

	 LoadActor(THEME:GetPathG("","2p"))..{
		InitCommand=cmd(glowshift;horizalign,center;x,SCREEN_RIGHT-35;y,SCREEN_BOTTOM-80;zoom,0.5);
	};

	 LoadActor(THEME:GetPathG("","_press "..GAMESTATE:GetCurrentGame():GetName().." 5x2.png"))..{
		Frames = Sprite.LinearFrames(10,.6);
		InitCommand=cmd(Center;x,SCREEN_LEFT+95;y,SCREEN_BOTTOM-102;zoom,0.5);
	};

	 LoadActor(THEME:GetPathG("","_press "..GAMESTATE:GetCurrentGame():GetName().." 5x2.png"))..{
		Frames = Sprite.LinearFrames(10,.6);
		InitCommand=cmd(Center;x,SCREEN_RIGHT-95;y,SCREEN_BOTTOM-102;zoom,0.5);
	};
	
	-- Memory cards
	
	LoadActor(THEME:GetPathG("", "USB"))..{
		InitCommand=cmd(horizalign,left;vertalign,bottom;xy,SCREEN_LEFT+5,SCREEN_BOTTOM;zoom,.2);
		OnCommand=cmd(visible,ToEnumShortString(MEMCARDMAN:GetCardState(PLAYER_1)) == 'ready');
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};
	
	LoadActor(THEME:GetPathG("", "USB"))..{
		InitCommand=cmd(horizalign,right;vertalign,bottom;xy,SCREEN_RIGHT-5,SCREEN_BOTTOM;zoom,.2);
		--OnCommand=cmd(visible,true);
		OnCommand=cmd(visible,ToEnumShortString(MEMCARDMAN:GetCardState(PLAYER_2)) == 'ready');
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};
	
	--fin

	--[[ LoadFont("Common normal") .. {
		Text="Timing Difficulty: "..GetTimingDifficulty().."\nLife Difficulty: "..GetLifeDifficulty().."\nAuto Settings: "..(setup).."\nTimingWindowScale: "..(timing);
		InitCommand=cmd(horizalign,left;zoom,0.35;x,SCREEN_LEFT+10;y,SCREEN_BOTTOM-30)
	};]]


	 --[[LoadActor(THEME:GetPathG("","gl"))..{
		InitCommand=cmd(horizalign,right;x,SCREEN_RIGHT-60;y,SCREEN_TOP+18;zoom,0.75)
	};]]


	 LoadFont("frutiger/frutiger 24px") .. {
		Text="Powered by SSC - Spinal Shark Collective\nNEX is a mod by Schranz Conflict | Based on PIU Delta by Luizsan\nRebirth by Rhythm Lunatic, new graphics by Joao Almeida\n";
		InitCommand=cmd(horizalign,right;vertalign,top;zoom,0.4;x,SCREEN_RIGHT-5;y,SCREEN_TOP+5)
	};

	--[[LoadFont("Common normal") .. {
		Text="Delta NEX Rebirth "..tostring(themeVersion);
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+5;y,SCREEN_TOP+10;zoom,0.45)
	};]]

	 LoadFont("Common normal") .. {
		--%d songs in %d groups
		Text=string.format(THEME:GetString("ScreenTitleMenu","%d songs in %d groups"),SONGMAN:GetNumAdditionalSongs()+SONGMAN:GetNumSongs(),SONGMAN:GetNumSongGroups());
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+5;y,SCREEN_TOP+32;zoom,0.35)
	};
	
 	LoadFont("Common normal") .. {
		Text="Delta 2 "..tostring(themeVersion).."\n"..ProductFamily().." "..ProductVersion();
		InitCommand=cmd(horizalign,left;x,5;y,SCREEN_TOP+13;zoom,0.45)
	};
	
	LoadFont("soms2/_soms2 techy")..{
		Condition=GAMESTATE:IsEventMode();
		Text="EVENT MODE";
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_BOTTOM-10;diffusebottomedge,Color("HoloBlue");Stroke,Color("Black"));
	};

	LoadActor(THEME:GetPathS("ScreenTitleMenu", "music"))..{
		OnCommand=function(self)
			--[[if PREFSMAN:GetPreference("AttractSoundFrequency") == 'AttractSoundFrequency_EveryTime' or SCREENMAN:GetTopScreen():GetName() == "ScreenTitleJoin" or SCREENMAN:GetTopScreen():GetName() == "ScreenTitleMenu" then
				self:play();
			end]]
			
		end;
		--No need to stop anyway
		--OffCommand=cmd(stop);
		--[[OffCommand=function(self)
			GAMESTATE:ApplyGameCommand("stopmusic");
		end;]]
	};
	--DoesSongGroupExist
	Def.ActorFrame{
		InitCommand=cmd(visible,(SONGMAN:DoesSongGroupExist("BasicModeGroup") == false and ReadPrefFromFile("UserPrefBasicModeType") == "BasicModeGroup"));
		Def.Quad{
			InitCommand=cmd(setsize,SCREEN_WIDTH,100;diffuse,Color("Black");Center);
		};
		
		LoadFont("soms2/_soms2 techy")..{
			Text=THEME:GetString("ScreenTitleJoin","BasicModeWarning");
			InitCommand=cmd(Center;wrapwidthpixels,SCREEN_WIDTH-10);
		};
	
	};
};

return t;
