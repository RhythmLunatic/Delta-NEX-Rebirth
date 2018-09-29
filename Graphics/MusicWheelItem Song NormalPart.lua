local bannerFirst = true;
if GetUserPref("UserPrefWheelPriority") == "Banner" then
	--Don't need to assign, since it's already true
	--bannerFirst = true;
elseif GetUserPref("UserPrefWheelPriority") == "Jacket" then
	bannerFirst = false;
else --Auto
	if GAMESTATE:GetCurrentGame():GetName() == "pump" then
		bannerFirst = true;
	else
		bannerFirst = false; --Prioritize jackets for every other game mode
	end;
end;

--local total = 0
return Def.ActorFrame {
	OnCommand=cmd(diffusealpha,1;zoom,.9);
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
				if bannerFirst then
					path = song:GetBannerPath();
					self:scaletoclipped(250,177);
					if not path then
						path = song:GetJacketPath();
						self:scaletoclipped(180,180);
					end;
				else
					path = song:GetJacketPath();
					self:scaletoclipped(180,180);
					if not path then
						path = song:GetBannerPath();
						self:scaletoclipped(250,177);
					end;
				end;
			end;
			if not path then path = THEME:GetPathG("Common","fallback banner") end
			self:Load(path);
		end;
	};
};
