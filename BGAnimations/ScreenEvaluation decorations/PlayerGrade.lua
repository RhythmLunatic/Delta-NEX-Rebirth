local player = ...

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local delay = 0.325

local dancepoints = round(STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPercentDancePoints()*100)
local misses = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_Miss")+
		STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointMiss");

--local grade = ToEnumShortString(STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetGrade());

local grade = GetGradeFromDancePoints(dancepoints);

return Def.ActorFrame{

	--[[OnCommand=function(self)
		SCREENMAN:SystemMessage("DP: "..dancepoints.." | Misses: "..misses.." | Grade: "..grade);
	end;]]
	
	--GRADE
	LoadActor(THEME:GetPathG("","GradeDisplayEval/"..grade))..{
		InitCommand=cmd(draworder,200;zoom,1.2;skewx,-0.1;);
		OnCommand=cmd(diffusealpha,0;sleep,1+delay*11;decelerate,0.15;diffusealpha,1;zoom,0.6);
	};
	LoadActor(THEME:GetPathG("","GradeDisplayEval/"..grade))..{
		InitCommand=cmd(draworder,200;zoom,1.2;skewx,-0.1;diffusealpha,0;zoom,0.6;);
		OnCommand=cmd(sleep,1+delay*11+0.15;diffusealpha,1;linear,0.8;diffusealpha,0;zoom,0.85);
	};

	LoadActor(THEME:GetPathS("","GradeShow"))..{
		--There's some way to pause a sound for a while without queuecommand, right?
		OnCommand=cmd(sleep,1+delay*11;queuecommand,"PlaySound");
		PlaySoundCommand=cmd(play);
	};

	--%
	LoadFont("venacti/_venacti 13px bold diffuse")..{
		InitCommand=cmd(horizalign,center;zoomx,0.375;zoomy,0.35);
		--OnCommand=cmd(x,-75;y,110;diffusealpha,0;sleep,1+delay*9;decelerate,0.3;diffusealpha,1);
		OnCommand=cmd(y,55;diffusealpha,0;decelerate,0.3;diffusealpha,1;playcommand,"SetText");
		Text="ACCURACY";
	};
	LoadFont("combo/_handelgothic bt 70px")..{
		InitCommand=cmd(horizalign,center;vertalign,top;zoom,0.25;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1"));
		--OnCommand=cmd(x,-75;y,125;diffusealpha,0;sleep,1+delay*9;decelerate,0.3;diffusealpha,1);
		OnCommand=cmd(y,65;diffusealpha,0;decelerate,0.3;diffusealpha,1);
		Text=dancepoints.."%";
	};
	
	--Best score thingy
	--[[LoadFont("venacti/_venacti 13px bold diffuse")..{
		InitCommand=function(self)
			self:horizalign(center):zoomx(0.375):zoomy(0.35);
			local scorelist = PROFILEMAN:GetProfile(player):GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(player));
			
		end;
		OnCommand=cmd(y,55;diffusealpha,0;decelerate,0.3;diffusealpha,1;playcommand,"SetText");
		Text="ACCURACY";
	};]]

}
