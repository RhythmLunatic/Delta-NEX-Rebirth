local player,sStats,containerHeight = ...
local steps = sStats:GetPlayerStageStats(player):GetPlayedSteps()[1]
--P1 = left side, P2 = right
--Ternary
local alignment = (player == "PlayerNumber_P1") and -1 or 1;
--local alignment = 1;
local halignment = (alignment == -1) and 1 or 0;
return Def.ActorFrame{

	LoadActor("PlayerSteps", steps)..{
		InitCommand=cmd(draworder,100;zoom,1.2;x,145*alignment;y,-45*(containerHeight/100););
		OnCommand=function(self)
			if alignment == 1 then
			
			end;
		end;
	};
	
	LoadFont("combo/_handelgothic bt 70px")..{
		InitCommand=cmd(x,70*alignment;halign,halignment;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");maxwidth,320;zoom,containerHeight/100/2);
		Text=round(sStats:GetPlayerStageStats(player):GetPercentDancePoints()*100).."%";
		--Text="14%";
	};
	LoadFont("combo/_handelgothic bt 70px")..{
		InitCommand=cmd(xy,70*alignment,43*(containerHeight/100);halign,halignment;vertalign,bottom;shadowlengthy,0.8;shadowlengthx,0.6;shadowcolor,color("0,0,0,0.6");diffusebottomedge,color("0.8,0.8,0.8,1");zoom,containerHeight/100/2);
		OnCommand=cmd(diffusealpha,0;decelerate,0.3;diffusealpha,1);
		Text=scorecap(sStats:GetPlayerStageStats(player):GetScore());
	};
	
	LoadActor("PlayerGrade", player, sStats)..{
		InitCommand=cmd(addx,350*alignment;zoom,.9*(containerHeight/100));
	};
}
