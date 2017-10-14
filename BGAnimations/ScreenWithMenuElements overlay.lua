--core file, don't edit

local t = Def.ActorFrame{
	InitCommand=function(self)
		--SUPER ULTRA MEGA DEBUG
		--SCREENMAN:SystemMessage(ReadPrefFromFile("UserPrefLite"));
		--SCREENMAN:SystemMessage(PREFSMAN:GetPreference("VideoRenderers"));
		if GetUserPref("UserPrefSetPreferences") == "Yes" then
			Setup();
			--SCREENMAN:SystemMessage("Big Success!");
		end
	
	end
}


return t