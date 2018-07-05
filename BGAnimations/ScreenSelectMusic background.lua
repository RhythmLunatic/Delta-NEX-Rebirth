if ReadPrefFromFile("UserPrefBackgroundType") == "Prime" then
	return LoadActor(THEME:GetPathG("","_VIDEOS/diffuseMusicSelect"))..{
		InitCommand=cmd(Center;FullScreen;diffuse,Color("Blue"));
	};
else
	return LoadActor(THEME:GetPathG("","_VIDEOS/MusicSelect"))..{
		InitCommand=cmd(Center;FullScreen);
	};
end;
