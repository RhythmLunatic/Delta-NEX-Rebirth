if randomBackground then
	return Def.ActorFrame{
		LoadActor(randomBackground)..{
			InitCommand=function(self)
				self:Cover();
				randomBackground = nil; --Set to nil so it only shows up when coming from the loading screen and not from results or group select
			end;
			OnCommand=cmd(decelerate,.4;diffusealpha,0);
		};
	};
else
	return Def.ActorFrame{LoadActor("_FadeFromWhite")};
end;