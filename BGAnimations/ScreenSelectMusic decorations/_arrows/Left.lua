local iState = 0;

return Def.ActorFrame {
		LoadActor("glow arrow")..{
		InitCommand=cmd(zoom,1;blend,"BlendMode_Add";diffusealpha,0;rotationz,-43);
		SongUnchosenMessageCommand=function(self) self:finishtweening(); iState = 0 self:playcommand("Frames") end;
		GoBackSelectingSongMessageCommand=function(self) self:finishtweening(); iState = 0 self:playcommand("Frames") end;
		FramesCommand=function(self)
			iState = iState+1
				self:zoomy(.65);
		self:zoomx(.65);
		self:diffusealpha(.4);
		self:linear(0.1);
		self:diffusealpha(1);
		self:linear(.2);
		self:zoomy(0);
		self:zoomx(1.0);
			if GAMESTATE:IsBasicMode() then self:visible(false);

		else self:visible(true); end;
			if iState < self:GetNumStates() then
				self:queuecommand("Frames");
			end
		end;
	};
}