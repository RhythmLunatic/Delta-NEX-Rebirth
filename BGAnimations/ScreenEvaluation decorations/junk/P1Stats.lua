local t = Def.ActorFrame{}

local spacing = 21
local itembaseX = -20
local itembaseY = 20
local delay = 0.325
local labelZoomX = 0.375
local labelZoomY = 0.35

local perfects = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetTapNoteScores("TapNoteScore_W1")+
		STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetTapNoteScores("TapNoteScore_W2")+
		STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetTapNoteScores("TapNoteScore_CheckpointHit");

local greats = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetTapNoteScores("TapNoteScore_W3");
local goods = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetTapNoteScores("TapNoteScore_W4");
local bads = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetTapNoteScores("TapNoteScore_W5");

local misses = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetTapNoteScores("TapNoteScore_Miss")+
		STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetTapNoteScores("TapNoteScore_CheckpointMiss");

local combo = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):MaxCombo();

local score = 	scorecap(STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetScore());

local dancepoints;

if string.find(PREFSMAN:GetPreference("VideoRenderers"), "d3d,") then
	dancepoints = math.floor(STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetPercentDancePoints()*100)
else
	dancepoints = (math.floor((STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetPercentDancePoints())*1000000))/10000
end


local percent = dancepoints.."%";

local digits = string.len(math.max(perfects,greats,goods,bads,misses,combo));
if digits < 3 then digits = 3 end;
--local grade = ToEnumShortString(STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetGrade());
	
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
	InitCommand=cmd(draworder,200;zoom,1.2;skewx,-0.1;x,-80;y,50);
	OnCommand=cmd(diffusealpha,0;sleep,1+delay*11;decelerate,0.15;diffusealpha,1;zoom,0.6);
}
t[#t+1] = LoadActor(THEME:GetPathG("","GradeDisplayEval/"..grade))..{
	InitCommand=cmd(draworder,200;zoom,1.2;skewx,-0.1;x,-80;y,50;diffusealpha,0;zoom,0.6;);
	OnCommand=cmd(sleep,1+delay*11+0.15;diffusealpha,1;linear,0.8;diffusealpha,0;zoom,0.85);
}


--%
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(horizalign,center;zoomx,labelZoomX;zoomy,labelZoomY);
	--OnCommand=cmd(x,-75;y,110;diffusealpha,0;sleep,1+delay*9;decelerate,0.3;diffusealpha,1);
	OnCommand=cmd(x,-75;y,110;diffusealpha,0;decelerate,0.3;diffusealpha,1;playcommand,"SetText");
	Text="ACCURACY";
}
t[#t+1] = LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
	InitCommand=cmd(horizalign,center;zoom,0.6;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,200);
	--OnCommand=cmd(x,-75;y,125;diffusealpha,0;sleep,1+delay*9;decelerate,0.3;diffusealpha,1);
	OnCommand=cmd(x,-75;y,125;diffusealpha,0;decelerate,0.3;diffusealpha,1);
	Text=percent;
}






--PERFECTS
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(horizalign,left;zoomx,labelZoomX;zoomy,labelZoomY);
	OnCommand=cmd(x,itembaseX;y,itembaseY-8;playcommand,"SetText");
	SetTextCommand=function(self)
	if	GetUserPref("UserPrefJudgmentType") == "Pro" then
		self:settext("SUPERB");
	else
		self:settext("PERFECT");
	end
	end
};
t[#t+1] = Def.Quad{
	InitCommand=cmd(horizalign,left;zoomto,110,1;faderight,1;diffuse,color("#2264b7");blend,Blend.Add);
	OnCommand=cmd(x,itembaseX;y,itembaseY);
}
t[#t+1] = LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
	InitCommand=cmd(horizalign,right;zoom,0.6;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,90);
	OnCommand=cmd(x,itembaseX+110;y,itembaseY-10;diffusealpha,0;sleep,1+delay;decelerate,0.3;diffusealpha,1;playcommand,"Cap");
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
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(horizalign,left;zoomx,labelZoomX;zoomy,labelZoomY);
	OnCommand=cmd(x,itembaseX;y,itembaseY-8+(spacing*1);playcommand,"SetText");
	SetTextCommand=function(self)
	if	GetUserPref("UserPrefJudgmentType") == "Pro" then
		self:settext("PERFECT");
	else
		self:settext("GREAT");
	end
	end
};
t[#t+1] = Def.Quad{
	InitCommand=cmd(horizalign,left;zoomto,110,1;faderight,1;diffuse,color("#34851f");blend,Blend.Add);
	OnCommand=cmd(x,itembaseX;y,itembaseY+(spacing*1));
}
t[#t+1] = LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
	InitCommand=cmd(horizalign,right;zoom,0.6;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,90);
	OnCommand=cmd(x,itembaseX+110;y,itembaseY-10+(spacing*1);diffusealpha,0;sleep,1+delay*2;decelerate,0.3;diffusealpha,1;playcommand,"Cap");
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
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(horizalign,left;zoomx,labelZoomX;zoomy,labelZoomY);
	OnCommand=cmd(x,itembaseX;y,itembaseY-8+(spacing*2);playcommand,"SetText");
	SetTextCommand=function(self)
	if	GetUserPref("UserPrefJudgmentType") == "Pro" then
		self:settext("GREAT");
	else
		self:settext("GOOD");
	end
	end
};
t[#t+1] = Def.Quad{
	InitCommand=cmd(horizalign,left;zoomto,110,1;faderight,1;diffuse,color("#85781f");blend,Blend.Add);
	OnCommand=cmd(x,itembaseX;y,itembaseY+(spacing*2));
}
t[#t+1] = LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
	InitCommand=cmd(horizalign,right;zoom,0.6;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,90);
	OnCommand=cmd(x,itembaseX+110;y,itembaseY-10+(spacing*2);diffusealpha,0;sleep,1+delay*3;decelerate,0.3;diffusealpha,1;playcommand,"Cap");
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
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(horizalign,left;zoomx,labelZoomX;zoomy,labelZoomY);
	OnCommand=cmd(x,itembaseX;y,itembaseY-8+(spacing*3);playcommand,"SetText");
	SetTextCommand=function(self)
	if	GetUserPref("UserPrefJudgmentType") == "Pro" then
		self:settext("GOOD");
	else
		self:settext("BAD");
	end
	end
};
t[#t+1] = Def.Quad{
	InitCommand=cmd(horizalign,left;zoomto,110,1;faderight,1;diffuse,color("#932192");blend,Blend.Add);
	OnCommand=cmd(x,itembaseX;y,itembaseY+(spacing*3));
}
t[#t+1] = LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
	InitCommand=cmd(horizalign,right;zoom,0.6;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,90);
	OnCommand=cmd(x,itembaseX+110;y,itembaseY-10+(spacing*3);diffusealpha,0;sleep,1+delay*4;decelerate,0.3;diffusealpha,1;playcommand,"Cap");
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
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(horizalign,left;zoomx,labelZoomX;zoomy,labelZoomY);
	OnCommand=cmd(x,itembaseX;y,itembaseY-8+(spacing*4));
	Text="MISS";
}
t[#t+1] = Def.Quad{
	InitCommand=cmd(horizalign,left;zoomto,110,1;faderight,1;diffuse,color("#ac1e1e");blend,Blend.Add);
	OnCommand=cmd(x,itembaseX;y,itembaseY+(spacing*4));
}
t[#t+1] = LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
	InitCommand=cmd(horizalign,right;zoom,0.6;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,90);
	OnCommand=cmd(x,itembaseX+110;y,itembaseY-10+(spacing*4);diffusealpha,0;sleep,1+delay*5;decelerate,0.3;diffusealpha,1;playcommand,"Cap");
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
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(horizalign,left;zoomx,labelZoomX;zoomy,labelZoomY);
	OnCommand=cmd(x,itembaseX;y,itembaseY-8+(spacing*5));
	Text="MAX COMBO";
}
t[#t+1] = Def.Quad{
	InitCommand=cmd(horizalign,left;zoomto,110,1;faderight,1;diffuse,color("#666666");blend,Blend.Add);
	OnCommand=cmd(x,itembaseX;y,itembaseY+(spacing*5));
}
t[#t+1] = LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
	InitCommand=cmd(horizalign,right;zoom,0.6;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,90);
	OnCommand=cmd(x,itembaseX+110;y,itembaseY-10+(spacing*5);diffusealpha,0;sleep,1+delay*6;decelerate,0.3;diffusealpha,1;playcommand,"Cap");
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
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	InitCommand=cmd(horizalign,left;zoomx,labelZoomX;zoomy,labelZoomY);
	OnCommand=cmd(x,itembaseX-100;y,itembaseY-8+(spacing*6.75));
	Text="SCORE";
}
--[[
t[#t+1] = Def.Quad{
	InitCommand=cmd(horizalign,left;zoomto,210,1;faderight,1;diffuse,color("#c1800e");blend,Blend.Add);
	OnCommand=cmd(x,itembaseX-100;y,itembaseY+(spacing*6.75));
}
]]
t[#t+1] = LoadFont("venacti/_venacti_ 26px bold monospace numbers")..{
	InitCommand=cmd(horizalign,right;zoom,0.6;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1"));
	OnCommand=cmd(x,itembaseX+110;y,itembaseY-10+(spacing*6.75);diffusealpha,0;sleep,1+delay*7;decelerate,0.3;diffusealpha,1);
	Text=score;
}



return t