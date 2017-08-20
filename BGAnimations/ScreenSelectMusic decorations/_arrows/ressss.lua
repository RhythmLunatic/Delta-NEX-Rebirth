----------------comandos iniciales----------------
local t = Def.ActorFrame {
	ChangeStepsMessageCommand=function(self, params)
		if params.Direction == 1 then
			MESSAGEMAN:Broadcast("NextStep");
		elseif params.Direction == -1 then
			MESSAGEMAN:Broadcast("PreviousStep");
		end;
	end;
}

local common = cmd(stoptweening;diffusealpha,0;linear,.1;diffusealpha,.5;sleep,.2;diffusealpha,1);
-----------------------UpLeft-------------------------
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,cx-85;y,cy-85;zoom,.7);
	OnCommand=cmd(stoptweening;sleep,.3;linear,.1;x,2;y,4);
	SongUnchosenMessageCommand=cmd(stoptweening;decelerate,.05;x,2;y,2;decelerate,.3;x,2;y,4);
	GoBackSelectingGroupMessageCommand=cmd(playcommand,'SongUnchosen');
	GoBackSelectingSongMessageCommand=cmd(playcommand,'SongUnchosen');
	StartSelectingStepsMessageCommand=cmd(playcommand,'SongUnchosen');
	StartSelectingSongMessageCommand =cmd(playcommand,'SongUnchosen');
	OffCommand=cmd(stoptweening;x,2;y,4;decelerate,.1;x,10;y,10;accelerate,.1;x,-40;y,-40);
	children = {
	LoadActor("black_up")..{
		OnCommand=function(self)
		if( GAMESTATE:IsBasicMode() ) then (common)(self); else (cmd(stoptweening;diffusealpha,0))(self); end; end;
		InitCommand=cmd(horizalign,'HorizAlign_Left';vertalign,'VertAlign_Top');
		GoFullModeMessageCommand=cmd(stoptweening;diffusealpha,0);
		GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,0;linear,.2;diffusealpha,.8);
		StartSelectingSongMessageCommand =cmd(stoptweening;diffusealpha,.8;sleep,.2;linear,0;diffusealpha,0);
		OffCommand=cmd(stoptweening;diffusealpha,0);
	};
	LoadActor("up")..{
		OnCommand=function(self)
		if not( GAMESTATE:IsBasicMode() ) then (common)(self); else (cmd(stoptweening;diffusealpha,0))(self); end; end;
		GoBackSelectingSongMessageCommand=function(self)
		if not ( GAMESTATE:IsBasicMode() ) then return; else (cmd(stoptweening;diffusealpha,1;linear,.2;diffusealpha,0))(self); end; end;
		StartSelectingStepsMessageCommand=function(self)
		if not ( GAMESTATE:IsBasicMode() ) then return; else (cmd(stoptweening;diffusealpha,0;sleep,.2;decelerate,.2;diffusealpha,1))(self); end; end;
		InitCommand=cmd(horizalign,'HorizAlign_Left';vertalign,'VertAlign_Top');
		GoFullModeMessageCommand=cmd(stoptweening;diffusealpha,1);
		GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.2;diffusealpha,0);
		StartSelectingSongMessageCommand =cmd(stoptweening;diffusealpha,0;sleep,.2;decelerate,.2;diffusealpha,1);
		OffCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
	};
	LoadActor("up")..{
		InitCommand=cmd(horizalign,'HorizAlign_Left';vertalign,'VertAlign_Top');
		OnCommand=cmd(stoptweening;blend,'BlendMode_Add';diffusealpha,0;sleep,.3;queuecommand,'SongUnchosen');
		SongUnchosenMessageCommand=cmd(stoptweening;fadebottom,0;faderight,0;sleep,0;diffusealpha,1;sleep,.25;fadebottom,0;faderight,0;accelerate,.2;diffusealpha,0);
		StartSelectingStepsMessageCommand=cmd(playcommand,'SongUnchosen');
		GoBackSelectingGroupMessageCommand=cmd(playcommand,'SongUnchosen');
		StartSelectingSongMessageCommand =cmd(playcommand,'SongUnchosen');
		OffCommand=cmd(stoptweening;diffusealpha,0);
	};
	LoadActor("up")..{
		InitCommand=cmd(horizalign,'HorizAlign_Left';vertalign,'VertAlign_Top';blend,'BlendMode_Add';diffuseshift;effectcolor1,1,1,1,0;effectcolor2,1,1,1,.3;effectperiod,2);
		OffCommand=cmd(stoptweening;diffusealpha,0;zoom,0);
	};
};
}
---------------------------------------------DestelloUpLeft---------------------------------------------
t[#t+1] = Def.ActorFrame {
		LoadActor("Left.lua")..{
		OnCommand=cmd(stoptweening;x,26;y,28);
		OffCommand=cmd(stoptweening;diffusealpha,0);
	};
};
--------------------------------------------------UpRight-------------------------------------
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,cx+85;y,cy-85;zoom,.7);
	OnCommand=cmd(stoptweening;sleep,.3;linear,.1;x,SCREEN_WIDTH+1-4;y,4);
	SongUnchosenMessageCommand=cmd(stoptweening;decelerate,.05;x,SCREEN_WIDTH+1;y,0;decelerate,.3;x,SCREEN_WIDTH+1-4;y,4);
	StartSelectingStepsMessageCommand=cmd(playcommand,'SongUnchosen');
	GoBackSelectingGroupMessageCommand=cmd(playcommand,'SongUnchosen');
	GoBackSelectingSongMessageCommand=cmd(playcommand,'SongUnchosen');
	StartSelectingSongMessageCommand =cmd(playcommand,'SongUnchosen');
	OffCommand=cmd(stoptweening;x,SCREEN_WIDTH+1-4;y,4;decelerate,.1;x,SCREEN_WIDTH+1-10;y,10;accelerate,.1;x,SCREEN_WIDTH+1+40;y,-40);
	children = {
	LoadActor("black_ur")..{
		OnCommand=function(self)
		if( GAMESTATE:IsBasicMode() ) then (common)(self); else (cmd(stoptweening;diffusealpha,0))(self); end; end;
		InitCommand=cmd(horizalign,'HorizAlign_Right';vertalign,'VertAlign_Top');
		GoFullModeMessageCommand=cmd(stoptweening;diffusealpha,0);
		GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,0;linear,.2;diffusealpha,.8);
		StartSelectingSongMessageCommand =cmd(stoptweening;diffusealpha,.8;sleep,.2;linear,0;diffusealpha,0);
		OffCommand=cmd(stoptweening;diffusealpha,0);
		
	};
	LoadActor("ur")..{
		OnCommand=function(self)
		if not ( GAMESTATE:IsBasicMode() ) then (common)(self); else (cmd(stoptweening;diffusealpha,0))(self); end; end;
		GoBackSelectingSongMessageCommand=function(self)
		if not ( GAMESTATE:IsBasicMode() ) then return; else (cmd(stoptweening;diffusealpha,1;linear,.2;diffusealpha,0))(self); end; end;
		StartSelectingStepsMessageCommand=function(self)
		if not ( GAMESTATE:IsBasicMode() ) then return; else (cmd(stoptweening;diffusealpha,0;sleep,.2;decelerate,.2;diffusealpha,1))(self); end; end;
		InitCommand=cmd(horizalign,'HorizAlign_Right';vertalign,'VertAlign_Top');
		GoFullModeMessageCommand=cmd(stoptweening;diffusealpha,1);
		GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.2;diffusealpha,0);
		StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.2;decelerate,.2;diffusealpha,1);
		OffCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
	};
	LoadActor("ur")..{
		InitCommand=cmd(horizalign,'HorizAlign_Right';vertalign,'VertAlign_Top');
		OnCommand=cmd(stoptweening;blend,'BlendMode_Add';diffusealpha,0;sleep,.3;queuecommand,'SongUnchosen');
		SongUnchosenMessageCommand=cmd(stoptweening;fadebottom,0;fadeleft,0;sleep,0;diffusealpha,1;sleep,.25;fadebottom,0;fadeleft,0;accelerate,.2;fadebottom,2;fadeleft,2;diffusealpha,0);
		StartSelectingStepsMessageCommand=cmd(playcommand,'SongUnchosen');
		GoBackSelectingGroupMessageCommand=cmd(playcommand,'SongUnchosen');
		StartSelectingSongMessageCommand =cmd(playcommand,'SongUnchosen');
		OffCommand=cmd(stoptweening;diffusealpha,0);
	};
	LoadActor("ur")..{
		InitCommand=cmd(horizalign,'HorizAlign_Right';vertalign,'VertAlign_Top';blend,'BlendMode_Add';diffuseshift;effectcolor1,1,1,1,0;effectcolor2,1,1,1,.3;effectperiod,2);
		OffCommand=cmd(stoptweening;diffusealpha,0;zoom,0);
	};
};
};
--------------------------------------------------DestelloUpRight-------------------------------------
t[#t+1] = Def.ActorFrame {
		LoadActor("Right.lua")..{
		OnCommand=cmd(stoptweening;x,SCREEN_RIGHT-26;y,28);
		OffCommand=cmd(stoptweening;diffusealpha,0);
	};
};
-------------------------------------------------DownRight-----------------------------------
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,cx+85;y,cy+85;zoom,.7);
	OnCommand=cmd(stoptweening;sleep,.3;linear,.1;x,SCREEN_WIDTH+1-4;y,SCREEN_HEIGHT-4);
	NextSongMessageCommand=cmd(stoptweening;linear,.05;x,SCREEN_WIDTH+1-2;y,SCREEN_HEIGHT-2;decelerate,.3;x,SCREEN_WIDTH+1-4;y,SCREEN_HEIGHT-4);
	NextStepMessageCommand=cmd(playcommand,'NextSong');
	NextGroupMessageCommand=cmd(playcommand,'NextSong');
	StartSelectingStepsMessageCommand=cmd(playcommand,'NextSong');
	OffCommand=cmd(stoptweening;x,SCREEN_WIDTH+1-4;y,SCREEN_HEIGHT-4;decelerate,.1;x,SCREEN_WIDTH+1-10;y,SCREEN_HEIGHT-10;accelerate,.1;x,SCREEN_WIDTH+1+40;y,SCREEN_HEIGHT+40);
	children = {
	LoadActor("dr")..{
		InitCommand=cmd(horizalign,'HorizAlign_Right';vertalign,'VertAlign_Bottom');
		OnCommand=common;
		OffCommand=cmd(stoptweening;diffusealpha,0);
		OffCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
	};
	LoadActor("dr")..{
		InitCommand=cmd(horizalign,'HorizAlign_Right';vertalign,'VertAlign_Bottom');
		OnCommand=cmd(stoptweening;blend,'BlendMode_Add';diffusealpha,0;sleep,.3;queuecommand,'NextSong');
		NextSongMessageCommand=cmd(stoptweening;fadetop,0;fadeleft,0;sleep,0;diffusealpha,1;sleep,0.15;fadetop,0;fadeleft,0;accelerate,.2;fadetop,2;fadeleft,2;diffusealpha,0);
		NextStepMessageCommand=cmd(playcommand,'NextSong');
		SongUnchosenMessageCommand=cmd(stoptweening;fadetop,0;fadeleft,0;sleep,0;diffusealpha,1;sleep,0.25;fadetop,0;fadeleft,0;accelerate,.2;fadetop,2;fadeleft,2;diffusealpha,0);
		StartSelectingSongMessageCommand=cmd(stoptweening;fadetop,0;fadeleft,0;sleep,0;diffusealpha,1;sleep,0.25;fadetop,0;fadeleft,0;accelerate,.2;fadetop,2;fadeleft,2;diffusealpha,0);
		OffCommand=cmd(stoptweening;diffusealpha,0);
	};
	LoadActor("dr")..{
		InitCommand=cmd(horizalign,'HorizAlign_Right';vertalign,'VertAlign_Bottom';blend,'BlendMode_Add';diffuseshift;effectcolor1,1,1,1,0;effectcolor2,1,1,1,.3;effectperiod,2);
		OffCommand=cmd(stoptweening;diffusealpha,0;zoom,0);
	};
};
};
-------------------------------------------------DestelloDownRight-----------------------------------
t[#t+1] = Def.ActorFrame {
		LoadActor("DownRight.lua")..{
		OnCommand=cmd(stoptweening;x,SCREEN_RIGHT-26;y,SCREEN_HEIGHT-28);
		OffCommand=cmd(stoptweening;diffusealpha,0);
	};
};
---------------------------------------------DownLeft-----------------------------------------
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,cx-85;y,cy+85;zoom,.7);
	OnCommand=cmd(stoptweening;sleep,.3;linear,.1;x,2;y,SCREEN_HEIGHT-4);
	PreviousSongMessageCommand=cmd(stoptweening;linear,.05;x,2;y,SCREEN_HEIGHT-2;decelerate,.3;x,2;y,SCREEN_HEIGHT-4);
	PreviousStepMessageCommand=cmd(playcommand,'PreviousSong');
	PrevGroupMessageCommand=cmd(playcommand,'PreviousSong');
	StartSelectingStepsMessageCommand=cmd(playcommand,'PreviousSong');
	OffCommand=cmd(stoptweening;x,2;y,SCREEN_HEIGHT-4;decelerate,.1;x,10;y,SCREEN_HEIGHT-10;accelerate,.1;x,-40;y,SCREEN_HEIGHT+40);
	children = {
	LoadActor("dl")..{
		OnCommand=common;
		InitCommand=cmd(horizalign,'HorizAlign_Left';vertalign,'VertAlign_Bottom');
		OffCommand=cmd(stoptweening;diffusealpha,0);
		OffCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
	};
	LoadActor("dl")..{
		InitCommand=cmd(horizalign,'HorizAlign_Left';vertalign,'VertAlign_Bottom');
		OnCommand=cmd(stoptweening;blend,'BlendMode_Add';diffusealpha,0;sleep,.3;queuecommand,'PreviousSong');
		PreviousSongMessageCommand=cmd(stoptweening;fadetop,0;faderight,0;sleep,0;diffusealpha,1;sleep,0.15;fadetop,0;faderight,0;accelerate,.2;fadetop,2;faderight,2;diffusealpha,0);
		PreviousStepMessageCommand=cmd(playcommand,'PreviousSong');
		
		SongUnchosenMessageCommand=cmd(stoptweening;fadetop,0;faderight,0;sleep,0;diffusealpha,1;sleep,.25;fadetop,0;faderight,0;accelerate,.2;fadetop,2;faderight,2;diffusealpha,0);
		StartSelectingSongMessageCommand=cmd(stoptweening;fadetop,0;faderight,0;sleep,0;diffusealpha,1;sleep,.25;fadetop,0;faderight,0;accelerate,.2;fadetop,2;faderight,2;diffusealpha,0);
		OffCommand=cmd(stoptweening;diffusealpha,0);
	};
	LoadActor("dl")..{
		InitCommand=cmd(horizalign,'HorizAlign_Left';vertalign,'VertAlign_Bottom';blend,'BlendMode_Add';diffuseshift;effectcolor1,1,1,1,0;effectcolor2,1,1,1,.3;effectperiod,2);
		OffCommand=cmd(stoptweening;diffusealpha,0;zoom,0);
	};
};
};
---------------------------------------------DestelloDownLeft-----------------------------------------
t[#t+1] = Def.ActorFrame {
		LoadActor("DownLeft.lua")..{
		OnCommand=cmd(stoptweening;x,26;y,SCREEN_HEIGHT-28);
		OffCommand=cmd(stoptweening;diffusealpha,0);
	};
};

return t;