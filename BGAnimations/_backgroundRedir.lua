local fileName = ...;
return Def.ActorFrame{
    LoadActor(THEME:GetPathG("","_VIDEOS/"..fileName))..{
        InitCommand=cmd(FullScreen;Center);
    };
}