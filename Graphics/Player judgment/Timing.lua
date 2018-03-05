local c = {};
local player = Var "Player";
local Pulse = THEME:GetMetric("Combo", "JudgmentPulseCommand");
local current = 0;
local scoreAdd = 0;
local multiplier = 1;
local meter = 0;
local AllowSuperb = (PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Everywhere');

local t = Def.ActorFrame {

	Def.ActorFrame {
		Name="JudgmentFrame";
		LoadActor(GetUserPref("UserPrefJudgmentType")) .. {
			Name="Judgment";
			InitCommand=cmd(pause;y,30;visible,false);
			ResetCommand=cmd(finishtweening;stopeffect;visible,false);
		};
	};
	
	

};
--[[
local JudgeCmds = {
	TapNoteScore_W1 = THEME:GetMetric( "Judgment", "JudgmentW1Command" );
	TapNoteScore_W2 = THEME:GetMetric( "Judgment", "JudgmentW2Command" );
	TapNoteScore_W3 = THEME:GetMetric( "Judgment", "JudgmentW3Command" );
	TapNoteScore_W4 = THEME:GetMetric( "Judgment", "JudgmentW4Command" );
	TapNoteScore_W5 = THEME:GetMetric( "Judgment", "JudgmentW5Command" );
	TapNoteScore_Miss = THEME:GetMetric( "Judgment", "JudgmentMissCommand" );
};
]]

--Specifies which frame is for which grading in the node judgment sprites
local TNSFrames = {
	TapNoteScore_W1 = 0;
	TapNoteScore_W2 = 1;
	TapNoteScore_W3 = 2;
	TapNoteScore_W4 = 3;
	TapNoteScore_W5 = 4;
	TapNoteScore_Miss = 5;
	TapNoteScore_CheckpointHit = (AllowSuperb and 0 or 1);
	TapNoteScore_CheckpointMiss = 5;
	TapNoteScore_AvoidMine = 0;
};

--WTF is this shit? Is it just arbitrary scoring?
local TapScoring = {
	TapNoteScore_W1 = 1000;
	TapNoteScore_W2 = 1000;
	TapNoteScore_W3 = 500;
	TapNoteScore_W4 = 100;
	TapNoteScore_W5 = -200;
	TapNoteScore_Miss = -800;
	TapNoteScore_CheckpointHit = 900;
	TapNoteScore_CheckpointMiss = -700;
	TapNoteScore_AvoidMine = 0;
};

local HoldScoring = {
	HoldNoteScore_None = 0;
	HoldNoteScore_Held = 0;
	HoldNoteScore_LetGo = 0;
};

t.InitCommand = function(self)
	c.JudgmentFrame = self:GetChild("JudgmentFrame");
	c.Judgment = c.JudgmentFrame:GetChild("Judgment");
end;

t.OnCommand = function(self)
	local player = self:GetParent();
	altcombo = 0;
--	player:SetActorWithJudgmentPosition( c.JudgmentFrame );
end;



t.JudgmentMessageCommand=function(self, param)

	if param.Player ~= player then return end;
	if not param.TapNoteScore then return end;
	if param.HoldNoteScore then return end;	

	local iNumStates = c.Judgment:GetNumStates();
	local iFrame = TNSFrames[param.TapNoteScore];

	
	if iNumStates == 12 then
		iFrame = iFrame * 2;
		if not param.Early then
			iFrame = iFrame + 1;
		end
	end
	


	
		local PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(param.Player);	
		local meter = math.ceil(GAMESTATE:GetCurrentSteps(param.Player):GetMeter()/5);
		local multiplier = 1+(math.floor(PSS:GetCurrentCombo()/100));
	
		if multiplier>=5 then
			multiplier=5
		end
	
		current = current+((TapScoring[param.TapNoteScore])*meter);
		
		if current < 0 then
			current = 0;
		end
	
	--SCREENMAN:SystemMessage("desu  "..current.."   "..multiplier.."X".."   "..meter);

	PSS:SetScore(current);
	

	
	c.Judgment:visible( true );
	c.Judgment:setstate( iFrame );
	--(cmd(stoptweening;diffusealpha,1;zoom,0.875;linear,0.05;zoom,0.625;sleep,1;linear,0.2;diffusealpha,0;zoomx,1.05;zoomy,0.5))(c.Judgment);
	
	
	if GetUserPref("UserPrefJudgmentType") == "NX" then
		(cmd(stoptweening;y,24;diffusealpha,1;zoomx,0.85;zoomy,0.8;linear,0.075;y,30;zoomx,0.6;zoomy,0.55;sleep,1;linear,0.2;diffusealpha,0;zoomx,1.05;zoomy,0.5))( c.Judgment, param );
	elseif GetUserPref("UserPrefJudgmentType") == "FIESTA2" then
--[[		(cmd(stoptweening;y,34;diffusealpha,1;zoomx,0.85;zoomy,0.75;linear,0.075;y,26;zoomx,1.4;zoomy,1.2;linear,0.075;y,34;diffusealpha,1;zoomx,0.85;zoomy,0.75;sleep,0.3;linear,0.175;diffusealpha,0;zoomx,1.2,zoomy,0.2))( c.Judgment, param );]]--
		(cmd(stoptweening;y,18;diffusealpha,1;zoomx,1.35;zoomy,1;linear,0.075;y,32;zoomx,0.8;zoomy,0.8;sleep,0.3;linear,0.175;diffusealpha,0;zoomx,1.5;zoomy,0.05))( c.Judgment, param );
	elseif GetUserPref("UserPrefJudgmentType") == "DELTANEX" then
--[[		(cmd(stoptweening;y,16;diffusealpha,0.6;zoomx,0.65;zoomy,0.7;linear,0.075;y,0;diffusealpha,0.9;zoomx,1.3;zoomy,1.3;sleep,0.3;linear,0.175;y,30;diffusealpha,0;zoomx,1.3;zoomy,0.2))( c.Judgment, param );]]--
		(cmd(stoptweening;y,0;diffusealpha,1;zoomx,0.9;zoomy,0.9;linear,0.075;y,16;zoomx,0.65;zoomy,0.65;sleep,0.3;linear,0.2;diffusealpha,0;zoomx,1.05;zoomy,0.5))( c.Judgment, param );
	else --if GetUserPref("UserPrefJudgmentType") == "Normal" or GetUserPref("UserPrefJudgmentType") == "Deviation" then
		Pulse( c.Judgment, param );
	end
	
--	JudgeCmds[param.TapNoteScore](c.Judgment);

	c.JudgmentFrame:stoptweening();

end;



return t;
