local t = Def.ActorFrame{};
t[#t+1] = Def.ActorFrame{
	LoadFont("Common Normal")..{
		--Text="Work in progress...";
		Text=THEME:GetString("ScreenInformationText","ThankYouForDownloading");
		InitCommand=cmd(Center);
	};

};
return t;