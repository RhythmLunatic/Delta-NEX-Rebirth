return Def.ActorFrame{
    LoadFont("venacti/_venacti 26px bold diffuse")..{
        Text="Delta NEX Rebirth "..tostring(themeVersion);
        InitCommand=cmd(horizalign,center;vertalign,top;xy,SCREEN_CENTER_X,20;diffusebottomedge,Color("HoloDarkPurple"));
    }

}