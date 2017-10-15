local player = ...;
local colorVar;
if player == PLAYER_1 then
  colorVar = color("0.3,0.5,0.85,1");
else
  colorVar = color("0.85,0.5,0.3,1");
end;


local t = Def.ActorFrame{

	--Hide cursors until they're selecting a song
	--TODO: Maybe move to the actor that loads this.
	OnCommand=cmd(visible,false);
	
	SongChosenMessageCommand=function(self)
		self:visible(true);
	end;
	SongUnchosenMessageCommand=function(self)
		self:visible(false);
	end;
	TwoPartConfirmCanceledMessageCommand=function(self)
		self:visible(false);
	end;
	
	LoadActor("cursor_half")..{
		InitCommand=cmd(diffuse,colorVar;blend,Blend.Add);
		OnCommand=function(self)
			if player == PLAYER_2 then
				self:addrotationz(180);
			end;
		end;
	};
	
	LoadActor("cursor_half")..{
		InitCommand=cmd(diffuse,colorVar;blend,Blend.Add);
		OnCommand=function(self)
			if player == PLAYER_2 then
				self:addrotationz(180);
			end;
		end;
	};
}

return t;
