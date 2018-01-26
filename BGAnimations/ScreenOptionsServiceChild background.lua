return Def.ActorFrame{
    LoadActor("_backgroundRedir", "init")..{
        InitCommand=cmd(diffusealpha,.4);
    }

}