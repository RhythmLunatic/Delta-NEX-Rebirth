-- todo: make this read from an env thing (preferably set up in player options)
local player = Var "Player";


local t = Def.ActorFrame {


LoadActor("Timing",player) .. {

	

	OnCommand=function(self)
	--SCREENMAN:SystemMessage(GAMESTATE:GetCurrentStyle():GetStyleType());
	
	
		if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_TwoPlayersSharedSides" then	
			if GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P2" then
				self:x(0+(THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX")/2));
			else
				self:x(0-(THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX")/5));
			end
			
			if Var "LoadingScreen" == "ScreenEdit" then
				self:x(0)	
			end
		end
	
		
		
		if GetUserPref("UserPrefJudgmentType") == "Normal" or GetUserPref("UserPrefJudgmentType") == "Deviation" then
			self:zoomx(0.9);
			self:zoomy(0.85);
			self:y(-1);
		end;
		
		if GetUserPref("UserPrefJudgmentType") == "NX" then
			self:zoomx(1.35);
			self:zoomy(1.375);
			self:y(-15);
		end;
		
		if GetUserPref("UserPrefJudgmentType") == "FIESTA2" then
			self:zoomx(1);
			self:zoomy(0.9);
			self:y(-10);
		end;		

		if GetUserPref("UserPrefJudgmentType") == "DELTANEX" then
			self:zoomx(0.5);
			self:zoomy(0.6);
			self:y(10);
		end;		
		
	end;
};

--[[
LoadActor("Slider",player) .. {
	InitCommand=cmd(y,110;visible,GetUserPrefB("UserPrefDetailedPrecision"));
};
	]]
};
return t;