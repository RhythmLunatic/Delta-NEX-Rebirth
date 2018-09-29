local player = Var "Player";
local judgementType = ActiveModifiers[pname(player)]["JudgmentType"];
local t = Def.ActorFrame {


	LoadActor("Timing",player,judgementType) .. {
		OnCommand=function(self)
			if judgementType == "NX" then
				self:y(-15);
			elseif judgementType == "FIESTA 2" then
				self:y(-10);
			elseif judgementType == "Delta LED" then --WHY IS IT SO BIG
				self:y(10);
			else
				self:y(-10);
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
