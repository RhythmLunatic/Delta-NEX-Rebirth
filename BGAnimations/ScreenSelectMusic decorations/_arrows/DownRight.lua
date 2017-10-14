local iState = 0;

return Def.ActorFrame {
		LoadActor("glow arrow")..{
		InitCommand=cmd(zoom,1;blend,"BlendMode_Add";diffusealpha,0;rotationz,-38);
		NextSongMessageCommand=function(self) self:finishtweening(); iState = 0 self:playcommand("Frames") end;
		NextStepMessageCommand=function(self) self:finishtweening(); iState = 0 self:playcommand("Frames") end;
		NextGroupMessageCommand=function(self) self:finishtweening(); iState = 0 self:playcommand("Frames") end;
		FramesCommand=function(self)
			iState = iState+1
		self:zoomy(.73);
		self:zoomx(.87);
		self:diffusealpha(.4);
		self:linear(0.1);
		self:diffusealpha(1);
		self:linear(.4);
		self:zoomy(0);
		self:zoomx(1.6);
		self:diffusealpha(.0);	
			if iState < self:GetNumStates() then
				self:queuecommand("Frames");
			end
		end;
	};
}