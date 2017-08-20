local t = Def.ActorFrame{}
	
	
t[#t+1] = Def.Quad{
	InitCommand=cmd(draworder,200;diffuseshift;effectcolor1,color("0,0.55,0.6,0.6");effectcolor2,color("0,0.7,0.8,0.8");zoomto,160,3;fadeleft,0.75;faderight,0.75;blend,Blend.Add;y,6);
}	
t[#t+1] = Def.Quad{
	InitCommand=cmd(draworder,200;diffuseshift;effectcolor1,color("0,0.55,0.6,0.6");effectcolor2,color("0,0.7,0.8,0.8");zoomto,160,3;fadeleft,0.75;faderight,0.75;blend,Blend.Add;y,6);
}	

return t