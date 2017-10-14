local t = Def.ActorFrame{}


t[#t+1] = LoadActor("star")..{
	InitCommand=cmd(zoom,0.525;animate,0;x,-31;setstate,1);
	OnCommand=function(self)
		self:stoptweening()
	
		if GetUserPref("UserPrefGameLevel") == "Beginner" then
			self:visible(true);
			self:setstate(0);
		end

		if GetUserPref("UserPrefGameLevel") == "Standard" then
			self:visible(true);
			self:setstate(0);
		end

		if GetUserPref("UserPrefGameLevel") == "Pro" then
			self:visible(true);
			self:setstate(0);
		end
		
		if GetUserPref("UserPrefGameLevel") == "Ultimate" then
			self:visible(false);
			self:setstate(0);
		end
		
		self:sleep(0.1);
		self:queuecommand("On");
	end
}


t[#t+1] = LoadActor("star")..{
	InitCommand=cmd(zoom,0.525;animate,0;x,0;setstate,1;);
	OnCommand=function(self)
		self:stoptweening()
	
		if GetUserPref("UserPrefGameLevel") == "Beginner" then
			self:visible(true);
			self:setstate(1);
			self:zoom(0.525);
		end

		if GetUserPref("UserPrefGameLevel") == "Standard" then
			self:visible(true);
			self:setstate(0);
			self:zoom(0.525);
		end

		if GetUserPref("UserPrefGameLevel") == "Pro" then
			self:visible(true);
			self:setstate(0);
			self:zoom(0.525);
		end
		
		if GetUserPref("UserPrefGameLevel") == "Ultimate" then
			self:visible(true);
			self:setstate(0);
			self:zoom(0.7);
		end
		
				self:sleep(0.1);
		self:queuecommand("On");
	end
}






t[#t+1] = LoadActor("star")..{
	InitCommand=cmd(zoom,0.525;animate,0;x,31;setstate,1);
	OnCommand=function(self)
		self:stoptweening()
	
		if GetUserPref("UserPrefGameLevel") == "Beginner" then
			self:visible(true);
			self:setstate(1);
		end

		if GetUserPref("UserPrefGameLevel") == "Standard" then
			self:visible(true);
			self:setstate(1);
		end

		if GetUserPref("UserPrefGameLevel") == "Pro" then
			self:visible(true);
			self:setstate(0);
		end
		
		if GetUserPref("UserPrefGameLevel") == "Ultimate" then
			self:visible(false);
			self:setstate(0);
		end

				self:sleep(0.1);
		self:queuecommand("On");
	end
}


--[[
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse")..{
	Text="GAME LEVEL";
	InitCommand=cmd(zoomx,0.5;zoomy,0.45;y,-24;shadowlength,0.6);
}
]]

t[#t+1] = LoadActor("beginner")..{
	InitCommand=cmd(zoom,0.5;y,12;glowshift);
	OnCommand=function(self)
	self:stoptweening()

	if GetUserPref("UserPrefGameLevel") == "Beginner" then
			self:visible(true);
		else
			self:visible(false);
		end
					self:sleep(0.1);
		self:queuecommand("On");
	end
	

}


t[#t+1] = LoadActor("standard")..{
	InitCommand=cmd(zoom,0.5;y,12;glowshift);
	OnCommand=function(self)
		self:stoptweening()

	if GetUserPref("UserPrefGameLevel") == "Standard" then
			self:visible(true);
		else
			self:visible(false);
		end
					self:sleep(0.1);
		self:queuecommand("On");
	end
	

}


t[#t+1] = LoadActor("pro")..{
	InitCommand=cmd(zoom,0.5;y,12;glowshift);
	OnCommand=function(self)
		self:stoptweening()

	if GetUserPref("UserPrefGameLevel") == "Pro" then
			self:visible(true);
		else
			self:visible(false);
		end
			self:sleep(0.1);
		self:queuecommand("On");
	end
	
	
}


t[#t+1] = LoadActor("ultimate")..{
	InitCommand=cmd(zoom,0.5;y,12;glowshift);
	OnCommand=function(self)
		self:stoptweening()

	if GetUserPref("UserPrefGameLevel") == "Ultimate" then
			self:visible(true);
		else
			self:visible(false);
		end
					self:sleep(0.1);
		self:queuecommand("On");
	end
	

}


return t