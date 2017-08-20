local gc = Var("GameCommand");
local t = Def.ActorFrame {};
--[[t[#t+1] = Def.Quad{
		InitCommand=cmd(zoomto,8,8;blend,Blend.Add);
		GainFocusCommand=cmd(stoptweening;diffuse,0.8,0,0.2,0;linear,0.15;zoomto,14,14;diffusealpha,1);
		LoseFocusCommand=cmd(stoptweening;diffuse,0.8,0,0.2,0.2;linear,0.15;zoomto,8,8;diffusealpha,0.5;);

};]]
return t