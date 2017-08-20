local player = ...;
local colorVar;
if player == PLAYER_1 then
  colorVar = color("0.3,0.5,0.85,1");
else
  colorVar = color("0.85,0.5,0.3,1");
end;

local t = Def.ActorFrame{}

t[#t+1] = LoadActor("cursor_half")..{
	InitCommand=cmd(diffuse,colorVar;blend,Blend.Add);
}
t[#t+1] = LoadActor("cursor_half")..{
	InitCommand=cmd(diffuse,colorVar;blend,Blend.Add);
}
t[#t+1] = LoadActor("cursor_full")..{
    InitCommand=cmd(diffuse,colorVar;blend,Blend.Add;visible,false);
  --[[StepsChosenMessageCommand=function(self,params)
  	if params.Player == PLAYER_2 then
  		self:visible(true)
  	end
  end;
  SongUnchosenMessageCommand=cmd(visible,false);]]
}
t[#t+1] = LoadActor("cursor_full")..{
	InitCommand=cmd(diffuse,colorVar;blend,Blend.Add;visible,false);
  --[[StepsChosenMessageCommand=function(self,params)
  	if params.Player == PLAYER_2 then
  		self:visible(true)
  	end
  end;
  SongUnchosenMessageCommand=cmd(visible,false);]]
}
return t;
