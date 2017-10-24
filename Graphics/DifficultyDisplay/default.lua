local t = Def.ActorFrame{}
local baseZoom = 0.3
local spacing = 29;
local delay = 2

local baseX = -(spacing*5.5);
local baseY = 80;

local stepsArray;


function SortCharts(a,b)
    local bST = StepsType:Compare(a:GetStepsType(),b:GetStepsType()) < 0
    if a:GetStepsType() == b:GetStepsType() then
        return a:GetMeter() < b:GetMeter()
    else
        return bST
    end;
end

function GetCurrentStepsIndex(pn)
	local playerSteps = GAMESTATE:GetCurrentSteps(pn);
	for i=1,#stepsArray do
		if playerSteps == stepsArray[i] then
			return i;
		end;
	end;
	--If it reaches this point, the selected steps doesn't equal anything.
	return -1;
end;

--What's the point of this when we're playing Pump?
--[[local difficulties = {
	diff1 = "Beginner",
	diff2 = "Easy",
	diff3 = "Medium",
	diff4 = "Hard",
	diff5 = "Challenge",
	diff6 = "Edit",
};]]


t[#t+1] = Def.ActorFrame{
	CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh");
	RefreshCommand=function(self)
			self:stoptweening();
			local song = GAMESTATE:GetCurrentSong();
			if song then
				stepsArray = song:GetAllSteps();
				table.sort(stepsArray, SortCharts)
			else
				stepsArray = nil;
			end;
	end;
	--[[Def.Quad{
		InitCommand=cmd(vertalign,top;zoomto,SCREEN_WIDTH,60;diffuse,0,0,0,1;fadebottom,0.9);
	};]]
	
	LoadActor("bg diff_12")..{
		InitCommand=cmd(addy,baseY-35;zoomy,0.71;zoomx,0.665;);
	};
	
	--[[LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		InitCommand=cmd(Center;addx,-100);
		--InitCommand=cmd(draworder,999);
		CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh");
		RefreshCommand=function(self)
			if stepsArray then
				self:settext(#stepsArray);
			else
				self:settext("nil");
			end;
		end;
	};]]
}



for i=1,12 do

	--The original code was an absolute fucking nightmare
	t[#t+1] = Def.ActorFrame{
		LoadActor("_icon")..{
			InitCommand=cmd(zoom,baseZoom-0.05;x,baseX+spacing*(i-1);y,baseY;animate,false);
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Refresh");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Refresh");
			CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh");
			NextSongMessageCommand=cmd(playcommand,"Refresh");
			PreviousSongMessageCommand=cmd(playcommand,"Refresh");
			RefreshCommand=function(self)
				--[[
				The PIU default colors are
				Single = Orange
				Double = Green
				Single Performance = Purple
				Double Performance = Blue
				Co-Op / Routine = Yellow
				Halfdouble = Cyan (It's green in PIU, but it doesn't tell you if it's halfdouble)
				]]
				
				if stepsArray then
					local j;
					--TODO: Fix it so it can account for over 24 charts.
					if GetCurrentStepsIndex(PLAYER_1) > 12 or GetCurrentStepsIndex(PLAYER_2) > 12 then
						j = i+12;
					else
						j = i;
					end;
					if stepsArray[j] then

						local steps = stepsArray[j];
						self:diffusealpha(1);
						if steps:GetStepsType() == "StepsType_Pump_Single" then
							self:setstate(2);
						elseif steps:GetStepsType() == "StepsType_Pump_Double" then
							--Check for StepF2 Double Performace tag
							if string.find(steps:GetDescription(), "DP") then
								self:setstate(0);
							else
								self:setstate(6);
							end;
						elseif steps:GetStepsType() == "StepsType_Pump_Halfdouble" then
							self:setstate(4);
						elseif steps:GetStepsType() == "StepsType_Pump_Routine" then
							self:setstate(1);
						else
							self:setstate(3);
						end;
					else
						self:diffusealpha(0);
					end;
				end
			end
		};

		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			InitCommand=cmd(zoomx,baseZoom+0.1;zoomy,baseZoom+0.075;shadowlength,0.8;shadowcolor,color("0,0,0,1");x,baseX-0.33+spacing*(i-1);y,baseY-0.33;);
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Refresh");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Refresh");
			CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh");
			NextSongMessageCommand=cmd(playcommand,"Refresh");
			PreviousSongMessageCommand=cmd(playcommand,"Refresh");
			RefreshCommand=function(self)
				self:stoptweening();

				if stepsArray then
					local j;
					--TODO: Fix it so it can account for over 24 charts.
					if GetCurrentStepsIndex(PLAYER_1) > 12 or GetCurrentStepsIndex(PLAYER_2) > 12 then
						j = i+12;
					else
						j = i;
					end;
					if stepsArray[j] then
						self:diffusealpha(1);
						local steps = stepsArray[j];
						self:settext(steps:GetMeter());
					else
						self:diffusealpha(0.3);
						self:settext("--");
					end
				end
			end


		};
	};


end

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = LoadActor("UnifiedCursor", pn)..{
		InitCommand=cmd(zoom,baseZoom-0.05;x,baseX;y,baseY;rotationx,180;rotationz,180;spin;playcommand,"Set";visible,GAMESTATE:IsSideJoined(pn));
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
		CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
		NextSongMessageCommand=cmd(playcommand,"Set");
		PreviousSongMessageCommand=cmd(playcommand,"Set");

		--I know this looks moronic, but I don't think there's any other way to do it...
		SetCommand=function(self)
			if stepsArray then
				local index = GetCurrentStepsIndex(pn);
				if index > 12 then
					index = index%12;
				end;
				self:x(baseX+spacing*(index-1));
			end;
		end;
	}
end

return t
