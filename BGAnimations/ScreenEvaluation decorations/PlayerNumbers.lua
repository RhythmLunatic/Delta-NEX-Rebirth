local player = ...
local alignment = 0;
if player == "PlayerNumber_P2" then alignment = 1 end;

local t = Def.ActorFrame{}

local spacing = 40
local itembaseX = -20
local itembaseY = 20
local delay = 0.325
local labelZoomX = 0.375
local labelZoomY = 0.35
local numberZoom = .5;

local perfects = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W1")+
		STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W2")+
		STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointHit");

local greats = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W3");
local goods = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W4");
local bads = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W5");

local misses = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_Miss")+
		STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointMiss");

local combo = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):MaxCombo();

local score = 	scorecap(STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetScore());

local digits = string.len(math.max(perfects,greats,goods,bads,misses,combo));
if digits < 3 then digits = 3 end;

--PERFECTS
t[#t+1] = LoadFont("combo/_handelgothic bt 70px")..{
	InitCommand=cmd(halign,alignment;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,1000;zoom,numberZoom);
	OnCommand=cmd(diffusealpha,0;sleep,1+delay;decelerate,0.3;diffusealpha,1;playcommand,"Cap");
	CapCommand=function(self)
			local attr = {
				Length = digits-string.len(perfects);
				Diffuse = color("#FFFFFF88");
			};
		self:AddAttribute(0,attr);
	end;
	Text=string.rep("0",digits-string.len(perfects))..perfects;
}

--GREATS
t[#t+1] = LoadFont("combo/_handelgothic bt 70px")..{
	InitCommand=cmd(halign,alignment;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,1000;zoom,numberZoom);
	OnCommand=cmd(y,spacing;diffusealpha,0;sleep,1+delay*2;decelerate,0.3;diffusealpha,1;playcommand,"Cap");
	CapCommand=function(self)
			local attr = {
				Length = digits-string.len(greats);
				Diffuse = color("#FFFFFF88");
			};
		self:AddAttribute(0,attr);
	end;
	Text=string.rep("0",digits-string.len(greats))..greats;
}

--GOODS
t[#t+1] = LoadFont("combo/_handelgothic bt 70px")..{
	InitCommand=cmd(halign,alignment;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,1000;zoom,numberZoom);
	OnCommand=cmd(y,spacing*2;diffusealpha,0;sleep,1+delay*3;decelerate,0.3;diffusealpha,1;playcommand,"Cap");
	CapCommand=function(self)
			local attr = {
				Length = digits-string.len(goods);
				Diffuse = color("#FFFFFF88");
			};
		self:AddAttribute(0,attr);
	end;
	Text=string.rep("0",digits-string.len(goods))..goods;
}

--BADS
t[#t+1] = LoadFont("combo/_handelgothic bt 70px")..{
	InitCommand=cmd(halign,alignment;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,1000;zoom,numberZoom);
	OnCommand=cmd(y,spacing*3;diffusealpha,0;sleep,1+delay*4;decelerate,0.3;diffusealpha,1;playcommand,"Cap");
	CapCommand=function(self)
			local attr = {
				Length = digits-string.len(bads);
				Diffuse = color("#FFFFFF88");
			};
		self:AddAttribute(0,attr);
	end;
	Text=string.rep("0",digits-string.len(bads))..bads;
}

--MISSES
t[#t+1] = LoadFont("combo/_handelgothic bt 70px")..{
	InitCommand=cmd(halign,alignment;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,1000;zoom,numberZoom);
	OnCommand=cmd(y,spacing*4;diffusealpha,0;sleep,1+delay*5;decelerate,0.3;diffusealpha,1;playcommand,"Cap");
	CapCommand=function(self)
			local attr = {
				Length = digits-string.len(misses);
				Diffuse = color("#FFFFFF88");
			};
		self:AddAttribute(0,attr);
	end;
	Text=string.rep("0",digits-string.len(misses))..misses;
}

--COMBO
t[#t+1] = LoadFont("combo/_handelgothic bt 70px")..{
	InitCommand=cmd(halign,alignment;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,1000;zoom,numberZoom);
	OnCommand=cmd(y,spacing*5;diffusealpha,0;sleep,1+delay*6;decelerate,0.3;diffusealpha,1;playcommand,"Cap");
	CapCommand=function(self)
			local attr = {
				Length = digits-string.len(combo);
				Diffuse = color("#FFFFFF88");
			};
		self:AddAttribute(0,attr);
	end;
	Text=string.rep("0",digits-string.len(combo))..combo;
}

--SCORE

t[#t+1] = LoadFont("combo/_handelgothic bt 70px")..{
	InitCommand=cmd(halign,alignment;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,320;zoom,numberZoom);
	OnCommand=cmd(y,spacing*6;diffusealpha,0;sleep,1+delay*7;decelerate,0.3;diffusealpha,1);
	Text=score;
}



return t
