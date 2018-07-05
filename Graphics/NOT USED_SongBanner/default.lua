local t = Def.ActorFrame{}
local song = GAMESTATE:GetCurrentSong();

if GAMESTATE:GetCurrentGame():GetName() == "pump" then 
	--[[if song:HasJacket() then
		t[#t+1] = LoadActor("JacketFrame")..{};
	else

	end;]]

	t[#t+1] = Def.Sprite {
		InitCommand=cmd(LoadFromSongBanner,GAMESTATE:GetCurrentSong();scaletoclipped,292,180);
		--[[InitCommand=function(self)
			local path;
			path = song:GetJacketPath();
			self:scaletoclipped(292,180);
			if not path then
				path = song:GetBannerPath();
				--Assume it's a pump song?
				--self:scaletoclipped(300,188);
				self:scaletoclipped(300,188);
			end;
			if not path then path = THEME:GetPathG("Common","fallback banner") end
			self:Load(path);
		end;]]
	};


	t[#t+1] = LoadActor("BannerFrame")..{};
end

if GAMESTATE:GetCurrentGame():GetName() == "dance" then 
	--[[if song:HasJacket() then
		t[#t+1] = LoadActor("JacketFrame")..{};
	else
	end;]]

	t[#t+1] = Def.Sprite {
		InitCommand=cmd(LoadFromSongBanner,GAMESTATE:GetCurrentSong();scaletoclipped,300,100);
		--[[InitCommand=function(self)
			local path;
			path = song:GetJacketPath();
			self:scaletoclipped(200,200);
			if not path then
				path = song:GetBannerPath();
				--Assume it's a pump song?
				--self:scaletoclipped(267,200);
				self:scaletoclipped(300,100);
			end;
			if not path then path = THEME:GetPathG("Common","fallback banner") end
			self:Load(path);
		end;]]
	};


	t[#t+1] = LoadActor("BannerFrameDance")..{};
end

return t