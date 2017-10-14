local t = Def.ActorFrame{}



t[#t+1] = LoadActor("cursor_half")..{
InitCommand=cmd(diffuse,0.3,0.5,0.85,1;blend,Blend.Add;);

}

t[#t+1] = LoadActor("cursor_half")..{
InitCommand=cmd(diffuse,0.3,0.5,0.85,1;blend,Blend.Add;);

}


t[#t+1] = LoadActor("cursor_full")..{
InitCommand=cmd(diffuse,0.3,0.5,0.85,1;blend,Blend.Add;visible,false);
StepsChosenMessageCommand=function(self,params)
	if params.Player == PLAYER_1 then
		self:visible(true)
	end
end;
SongUnchosenMessageCommand=cmd(visible,false);
}
t[#t+1] = LoadActor("cursor_full")..{
InitCommand=cmd(diffuse,0.3,0.5,0.85,1;blend,Blend.Add;visible,false);
StepsChosenMessageCommand=function(self,params)
	if params.Player == PLAYER_1 then
		self:visible(true)
	end
end;
SongUnchosenMessageCommand=cmd(visible,false);
}




return t