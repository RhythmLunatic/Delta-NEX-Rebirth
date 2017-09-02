local t = Def.ActorFrame {};
local setup = GetUserPref("UserPrefSetPreferences");
if setup == nil then
	setup = "Undefined"
end
local timing = math.floor(PREFSMAN:GetPreference("TimingWindowScale")*100)/100;

t[#t+1] = Def.Quad{
	InitCommand=cmd(Center;vertalign,bottom;y,SCREEN_BOTTOM;zoomto,SCREEN_WIDTH,40;diffuse,0,0,0,0.5);
}

t[#t+1] = Def.Quad{
	InitCommand=cmd(Center;vertalign,top;y,SCREEN_TOP;zoomto,SCREEN_WIDTH,40;diffuse,0,0,0,0.5);
}

t[#t+1] = Def.Quad{
	InitCommand=cmd(glowshift;Center;vertalign,bottom;y,SCREEN_BOTTOM-40;zoomto,SCREEN_WIDTH,2;diffuse,color("#F54D70"));
}

t[#t+1] = Def.Quad{
	InitCommand=cmd(glowshift;Center;vertalign,top;y,SCREEN_TOP+40;zoomto,SCREEN_WIDTH,2;diffuse,color("#F54D70"));
}


t[#t+1] = LoadActor(THEME:GetPathG("","logo"))..{
	InitCommand=cmd(Center;y,SCREEN_CENTER_Y-10;zoom,0.9);
}

-- press buttons

t[#t+1] = LoadActor(THEME:GetPathG("","player_base"))..{
	InitCommand=cmd(Center;x,SCREEN_LEFT+40;y,SCREEN_BOTTOM-80;zoom,0.5);
};

t[#t+1] = LoadActor(THEME:GetPathG("","player_base"))..{
	InitCommand=cmd(Center;x,SCREEN_RIGHT-40;y,SCREEN_BOTTOM-80;zoomy,0.5;zoomx,-0.5);
};

t[#t+1] = LoadActor(THEME:GetPathG("","1p"))..{
	InitCommand=cmd(glowshift;horizalign,center;x,SCREEN_LEFT+35;y,SCREEN_BOTTOM-80;zoom,0.5);
};

t[#t+1] = LoadActor(THEME:GetPathG("","2p"))..{
	InitCommand=cmd(glowshift;horizalign,center;x,SCREEN_RIGHT-35;y,SCREEN_BOTTOM-80;zoom,0.5);
};

t[#t+1] = LoadActor(THEME:GetPathG("","_press "..GAMESTATE:GetCurrentGame():GetName().." 5x2.png"))..{
	Frames = Sprite.LinearFrames(10,.6);
	InitCommand=cmd(Center;x,SCREEN_LEFT+95;y,SCREEN_BOTTOM-102;zoom,0.5);
};

t[#t+1] = LoadActor(THEME:GetPathG("","_press "..GAMESTATE:GetCurrentGame():GetName().." 5x2.png"))..{
	Frames = Sprite.LinearFrames(10,.6);
	InitCommand=cmd(Center;x,SCREEN_RIGHT-95;y,SCREEN_BOTTOM-102;zoom,0.5);
};

--fin

--[[t[#t+1] = LoadFont("Common normal") .. {
	Text="Timing Difficulty: "..GetTimingDifficulty().."\nLife Difficulty: "..GetLifeDifficulty().."\nAuto Settings: "..(setup).."\nTimingWindowScale: "..(timing);
	InitCommand=cmd(horizalign,left;zoom,0.35;x,SCREEN_LEFT+10;y,SCREEN_BOTTOM-30)
};]]


t[#t+1] = LoadActor(THEME:GetPathG("","gl"))..{
	InitCommand=cmd(horizalign,right;x,SCREEN_RIGHT-60;y,SCREEN_TOP+18;zoom,0.75)
};


t[#t+1] = LoadFont("frutiger/frutiger 24px") .. {
	Text="Powered by SSC - Spinal Shark Collective\nNEX is a Hack by Schranz Conflict | Based on Theme Delta by Luizsan\nRebirth by RhythmLunatic, new graphics by Joao Almeida\n";
	InitCommand=cmd(horizalign,center;vertalign,top;zoom,0.4;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-35)
};

t[#t+1] = LoadFont("Common normal") .. {
	Text="Delta NEX Rebirth 1.0";
	InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+15;y,SCREEN_TOP+15;zoom,0.45)
};

t[#t+1] = LoadFont("Common normal") .. {
	Text=SONGMAN:GetNumAdditionalSongs()+SONGMAN:GetNumSongs().." Songs on "..SONGMAN:GetNumSongGroups().." folders.";
	InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+15;y,SCREEN_TOP+28;zoom,0.35)
};




return t;
