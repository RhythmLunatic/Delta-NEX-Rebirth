-- todo: make this read from an env thing (preferably set up in player options)
local player = Var "Player";

local t = Def.ActorFrame {};


t[#t+1] = LoadActor("Number")..{
	OnCommand=function(self)
		if GetUserPref("UserPrefJudgmentType") == "NX" then
			self:zoom(1.9);
			self:y(-2);
		elseif GetUserPref("UserPrefJudgmentType") == "FIESTA2" then
			self:zoomx(0.8);
			self:zoomy(0.85);
			self:y(6);
		elseif GetUserPref("UserPrefJudgmentType") == "Delta LED" then
			self:zoom(0.6);
			self:y(28);
		else --Normal or Deviation
			self:zoomy(1);
			self:zoomx(1.2);
			self:y(1);
		end;
		
end
	
}
t[#t+1] = LoadActor("ComboLabel")..{
	OnCommand=function(self)
		
		if GetUserPref("UserPrefJudgmentType") == "NX" then
			self:zoomx(1.55);
			self:zoomy(1.75);
			self:y(11);
		elseif GetUserPref("UserPrefJudgmentType") == "FIESTA2" then
			self:zoomx(1.25);
			self:zoomy(1.25);
			self:y(0);
		elseif GetUserPref("UserPrefJudgmentType") == "Delta LED" then
			self:zoomx(0.55);
			self:zoomy(0.55);
			self:y(10);
		else --Normal or Deviation
			self:zoom(1.45);
			self:y(8);
		end;
		
end
}

return t;
