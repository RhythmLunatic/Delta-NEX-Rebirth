local total = 0
return Def.ActorFrame {
	OnCommand=cmd();
	PlayerJoinedMessageCommand=cmd(playcommand,"On");

	-- banners
	Def.Banner {
		Name="SongBanner";
		InitCommand=cmd(diffusealpha,1;scaletoclipped,250,177;);
		SetMessageCommand=function(self,params)
			self:stoptweening();
			local course = params.Course;
			local path;
			if course then
				path = course:GetBannerPath();
			end;
			if path == nil then path = THEME:GetPathG("Common","fallback banner") end
			--SCREENMAN:SystemMessage(path);
			self:Load(path);
		end;
	};
	--[[LoadFont("Common Normal") .. {
		InitCommand=cmd(zoom,1;horizalign,center;maxwidth,500;addy,25);
		SetCommand= function(self,params)
			local course = params.Course;
			if course then
				local courseTitle = course:GetDisplayFullTitle();
				if string.sub(courseTitle, -6) == "Random" then
					self:settext(courseTitle);
                    self:diffusebottomedge(Color("Red"));
					--self:diffuse(color("#ff5050"));
				elseif string.sub(courseTitle, 0,11) == "Most Played" then
					self:settext(courseTitle);
                    self:diffusebottomedge(color("#F2A2C2"));
					--self:diffuse(color("#ff99ff"));
				else
					self:settext(courseTitle);
                    self:diffusebottomedge(color("#F2A2C2"));
				end;
			else
				self:settext("AA");
			end;
		end;
		CurrentCourseChangedMessageCommand=function(self)
            self:queuecommand("Set");
        end;
	};]]
};
