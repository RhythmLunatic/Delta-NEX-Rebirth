return Def.ActorFrame{
	FOV=60;
	InitCommand=cmd(SetSpecularLightColor,color("1,0,0,1");SetAmbientLightColor,color("1,0,0,1");vanishpoint,10,10);
	
--[[
	LoadActor(THEME:GetPathG("","3dtest"))..{
	InitCommand=cmd(Center;zoom,60;spin;effectmagnitude,0,100,0);
	};
]]
};