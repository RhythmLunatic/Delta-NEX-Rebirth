local total = 0
return Def.ActorFrame {
	OnCommand=cmd(diffusealpha,0;zoom,1;linear,0;diffusealpha,1;zoom,1;);
	PlayerJoinedMessageCommand=cmd(playcommand,"On");

-- banners
	Def.Banner {
		Name="SongBanner";
		InitCommand=cmd(diffusealpha,1);
		SetMessageCommand=function(self,params)
			self:stoptweening();
			local song = params.Song;
			local path;
			if song then
				path = song:GetJacketPath();
				self:scaletoclipped(180,180);
				if not path then
					path = song:GetBannerPath();
					--I don't know what's up with the size, so this is the best guess
					--To make it fit in the banner frame..
					self:scaletoclipped(250,177);
				end;
			end;
			if not path then path = THEME:GetPathG("Common","fallback banner") end
			self:Load(path);
		end;
	};
};