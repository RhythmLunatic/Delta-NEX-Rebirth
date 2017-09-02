local t = Def.ActorFrame{
};

local dP1 = (math.floor((STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetPercentDancePoints())*1000000))/10000
local dP2 = (math.floor((STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetPercentDancePoints())*1000000))/10000
local dancepoints = math.max(dP1,dP2)
local grade;
local misses;

local mP1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetTapNoteScores("TapNoteScore_Miss")+
		STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetTapNoteScores("TapNoteScore_CheckpointMiss");
		
local mP2 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetTapNoteScores("TapNoteScore_Miss")+
		STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetTapNoteScores("TapNoteScore_CheckpointMiss");

	


if GAMESTATE:GetNumSidesJoined() == 2 then
	if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_TwoPlayersSharedSides" then
			if GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P1" then
				misses = mP1
			else
				misses = mP2
			end
	else
		misses = math.min(mP1,mP2);
	end
else
	if GAMESTATE:IsHumanPlayer(PLAYER_1) then
		misses = mP1
	end
	if GAMESTATE:IsHumanPlayer(PLAYER_2) then
		misses = mP2
	end
end


		
if STATSMAN:GetCurStageStats():AllFailed() then
	grade = "F";
else 
	if dancepoints >= 50 then
		grade = "D";
		if dancepoints >= 60 then
			grade = "C";
			if dancepoints >= 70 then
				grade = "B";
				if dancepoints >= 80 then
					grade = "A";
					if misses == 0 then
						grade = "S";
						if dancepoints >= 99 then
							grade = "S";
							if dancepoints == 100 then
								grade = "S";
							end
						end	
					end
				end	
			end
		end
	else 
		grade = "F";
	end
end

--SCREENMAN:SystemMessage(misses.."  -  "..grade);


t[#t+1] = LoadActor(THEME:GetPathS("","EvalBG/"..grade))..{
	InitCommand=cmd(queuecommand,"Pause";sleep,4.65;queuecommand,"Start");
	PauseCommand=cmd(pause,true);
	StartCommand=cmd(pause,false);
};


t[#t+1] = LoadActor(THEME:GetPathS("","EvalAnnouncer/RANK_"..grade))..{
	InitCommand=cmd(queuecommand,"Pause";sleep,4.5;queuecommand,"Start");
	PauseCommand=cmd(pause,true);
	StartCommand=cmd(pause,false);
	--[[
	StartCommand=function(self)
		if grade == "S" then
		self:stop();
		else
		self:play();
		end
		
	end]]
};
	
t[#t+1] = LoadActor(THEME:GetPathS("","GradeShow"))..{
	InitCommand=cmd(queuecommand,"Pause";sleep,4.5;queuecommand,"Start");
	PauseCommand=cmd(pause,true);
	StartCommand=cmd(pause,false);
};



return t;