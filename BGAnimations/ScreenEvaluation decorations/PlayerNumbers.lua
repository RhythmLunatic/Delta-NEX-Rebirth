local player = ...
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

local dancepoints;

--What?
if string.find(PREFSMAN:GetPreference("VideoRenderers"), "d3d,") then
	dancepoints = math.floor(STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPercentDancePoints()*100)
else
	dancepoints = (math.floor((STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPercentDancePoints())*1000000))/10000
end


local percent = dancepoints.."%";

local digits = string.len(math.max(perfects,greats,goods,bads,misses,combo));
if digits < 3 then digits = 3 end;
--local grade = ToEnumShortString(STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetGrade());
	
local grade;

if STATSMAN:GetCurStageStats():AllFailed() then
	grade = "Failed";
else 
	if dancepoints >= 50 then
		grade = "Tier06";
		if dancepoints >= 60 then
			grade = "Tier05";
			if dancepoints >= 70 then
				grade = "Tier04";
				if dancepoints >= 80 then
					grade = "Tier03";
					if misses==0 then
						grade = "Tier02";
						if dancepoints >= 99 then
							grade = "Tier01";
							if dancepoints == 100 then
								grade = "Tier00";
							end
						end
					end
				end	
			end
		end
	else 
		grade = "Tier07";
	end
end


--GRADE
t[#t+1] = LoadActor(THEME:GetPathG("","GradeDisplayEval/"..grade))..{
	InitCommand=cmd(draworder,200;zoom,1.2;skewx,-0.1;x,-80;y,spacing*3);
	OnCommand=cmd(diffusealpha,0;sleep,1+delay*11;decelerate,0.15;diffusealpha,1;zoom,0.6);
}
t[#t+1] = LoadActor(THEME:GetPathG("","GradeDisplayEval/"..grade))..{
	InitCommand=cmd(draworder,200;zoom,1.2;skewx,-0.1;x,-80;y,spacing*3;diffusealpha,0;zoom,0.6;);
	OnCommand=cmd(sleep,1+delay*11+0.15;diffusealpha,1;linear,0.8;diffusealpha,0;zoom,0.85);
}


--%
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(horizalign,center;zoomx,labelZoomX;zoomy,labelZoomY);
	--OnCommand=cmd(x,-75;y,110;diffusealpha,0;sleep,1+delay*9;decelerate,0.3;diffusealpha,1);
	OnCommand=cmd(x,-75;y,spacing*3+55;diffusealpha,0;decelerate,0.3;diffusealpha,1;playcommand,"SetText");
	Text="ACCURACY";
}
t[#t+1] = LoadFont("combo/_handelgothic bt 70px")..{
	InitCommand=cmd(horizalign,center;vertalign,top;zoom,0.25;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,200);
	--OnCommand=cmd(x,-75;y,125;diffusealpha,0;sleep,1+delay*9;decelerate,0.3;diffusealpha,1);
	OnCommand=cmd(x,-75;y,spacing*3+65;diffusealpha,0;decelerate,0.3;diffusealpha,1);
	Text=percent;
}

--PERFECTS
t[#t+1] = LoadFont("combo/_handelgothic bt 70px")..{
	InitCommand=cmd(horizalign,left;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,1000;zoom,numberZoom);
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
	InitCommand=cmd(horizalign,left;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,1000;zoom,numberZoom);
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
	InitCommand=cmd(horizalign,left;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,1000;zoom,numberZoom);
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
	InitCommand=cmd(horizalign,left;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,1000;zoom,numberZoom);
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
	InitCommand=cmd(horizalign,left;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,1000;zoom,numberZoom);
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
	InitCommand=cmd(horizalign,left;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,1000;zoom,numberZoom);
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
	InitCommand=cmd(horizalign,left;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,320;zoom,numberZoom);
	OnCommand=cmd(y,spacing*6;diffusealpha,0;sleep,1+delay*7;decelerate,0.3;diffusealpha,1);
	Text=score;
}



return t