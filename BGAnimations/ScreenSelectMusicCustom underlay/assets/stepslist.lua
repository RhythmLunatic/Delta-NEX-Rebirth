local originX = SCREEN_CENTER_X;
local originY = SCREEN_CENTER_Y+82;
local textbanner = 30;
local spacing = 31;
local numcharts = 18;

local voffset = 0;
local paneLabels = {"Taps","Jumps","Holds","Hands","Mines","Other"};

local t = Def.ActorFrame{
    OnCommand=cmd(stoptweening;diffusealpha,0;sleep,0.5;linear,0.2;diffusealpha,1);
    MusicWheelMessageCommand=function(self,param) if param and param.Direction then voffset = 0; end; end;
    StateChangedMessageCommand=function(self)
        self:stoptweening();
        self:decelerate(0.2);
        if Global.state == "GroupSelect" then
            self:diffusealpha(0);
        else
            self:diffusealpha(1);
        end
    end;
    StepsChangedMessageCommand=function(self,param)
        if param and param.Player then
            local newoffset = 0;
            local newindex = Global.pnsteps[param.Player];

            while newindex > numcharts do
                newoffset = newoffset + 1
                newindex = newindex - numcharts
            end;

            if(newoffset ~= voffset) then
                voffset = newoffset
                self:playcommand("MusicWheel");
            end
        end;
    end;
};

--//================================================================

function StepsController(self,param)
    if param.Player then
        if param.Input == "Prev" and param.Button == "Left" then
            Global.confirm[param.Player] = 0; 
            MESSAGEMAN:Broadcast("Deselect"); 

            if #Global.steps > 1 then
                Global.pnsteps[param.Player] = Global.pnsteps[param.Player]-1; 
                if Global.pnsteps[param.Player] < 1 then Global.pnsteps[param.Player] = #Global.steps; end;
                Global.pncursteps[param.Player] = Global.steps[Global.pnsteps[param.Player]]; 
                MESSAGEMAN:Broadcast("StepsChanged", { Prev = true , Player = param.Player }); 
            end

        end;

        if param.Input == "Next" and param.Button == "Right" then
            Global.confirm[param.Player] = 0;
            MESSAGEMAN:Broadcast("Deselect"); 

            if #Global.steps > 1 then
                Global.pnsteps[param.Player] = Global.pnsteps[param.Player]+1; 
                if Global.pnsteps[param.Player] > #Global.steps then Global.pnsteps[param.Player] = 1; end;
                Global.pncursteps[param.Player] = Global.steps[Global.pnsteps[param.Player]];
                MESSAGEMAN:Broadcast("StepsChanged", { Next = true , Player = param.Player }); 
            end;
            
        end;
    end;
        
    if param.Input == "Cancel" or param.Input == "Back" and Global.level == 2 then 
        
        Global.confirm[PLAYER_1] = 0;
        Global.confirm[PLAYER_2] = 0;

        if Global.prevstate == "MusicWheel" then
            Global.level = 2; 
            Global.selection = 2; 
            MESSAGEMAN:Broadcast("MainMenu");
            Global.selection = SetWheelSelection(); 
            Global.state = "MusicWheel";  
        else
            Global.level = 1; 
            Global.selection = 3; 
            Global.state = "MainMenu";  
        end;
        
        MESSAGEMAN:Broadcast("Deselect"); 
        MESSAGEMAN:Broadcast("StateChanged"); 
        MESSAGEMAN:Broadcast("Return");
    end;
end;

--//================================================================

function SelectStep(param)

    if param then Global.confirm[param.Player] = 1; 
        MESSAGEMAN:Broadcast("StepsSelected"); 
        if Global.confirm[PLAYER_1] + Global.confirm[PLAYER_2] >= GAMESTATE:GetNumSidesJoined() then
            Global.level = 1;
            Global.state = "MainMenu";
            Global.selection = 4;
            Global.confirm[PLAYER_1] = 0;
            Global.confirm[PLAYER_2] = 0;
            MESSAGEMAN:Broadcast("StateChanged"); 
            MESSAGEMAN:Broadcast("MainMenu"); 
        end;
    end;
end;

--//================================================================

t[#t+1] = LoadActor(THEME:GetPathG("","dim"))..{
    InitCommand=cmd(diffuse,0.33,0.33,0.33,0.33;y,originY;x,originX;zoomto,640,220;fadeleft,0.33;faderight,0.33;croptop,0.5);
};

t[#t+1] = LoadActor(THEME:GetPathG("","stepspane"))..{
    InitCommand=cmd(animate,false;setstate,1+3;y,originY;x,originX;zoomto,(spacing*numcharts),0.425*self:GetHeight();diffusebottomedge,1,1,1,1);
    StateChangedMessageCommand=function(self) self:stoptweening(); self:linear(0.2); if Global.state ~= "SelectSteps" then self:diffusebottomedge(1,1,1,1); else self:diffusebottomedge(0.5,0.5,0.5,1); end; end;
};
t[#t+1] = LoadActor(THEME:GetPathG("","stepspane"))..{
    InitCommand=cmd(animate,false;setstate,0+3;horizalign,right;y,originY;x,originX-((spacing*numcharts)/2);zoom,0.425;diffusebottomedge,1,1,1,1);
    StateChangedMessageCommand=function(self) self:stoptweening(); self:linear(0.2); if Global.state ~= "SelectSteps" then self:diffusebottomedge(1,1,1,1);  else self:diffusebottomedge(0.5,0.5,0.5,1); end; end;
};
t[#t+1] = LoadActor(THEME:GetPathG("","stepspane"))..{
    InitCommand=cmd(animate,false;setstate,2+3;horizalign,left;y,originY;x,originX+((spacing*numcharts)/2);zoom,0.425;diffusebottomedge,1,1,1,1);
    StateChangedMessageCommand=function(self) self:stoptweening(); self:linear(0.2); if Global.state ~= "SelectSteps" then self:diffusebottomedge(1,1,1,1);  else self:diffusebottomedge(0.5,0.5,0.5,1); end; end;
};


for pn in ivalues(GAMESTATE:GetHumanPlayers()) do

--//==========================================
--//  RADAR VALUES
--//==========================================

local iconspacing = 36;
local iconadjust = 24;


local radaritems = 5;
local panespacing = 300;

for num=0,radaritems do

    --// radar item
    t[#t+1] = Def.ActorFrame{
            InitCommand=cmd(y,SCREEN_CENTER_Y+112;x,SCREEN_CENTER_X+(panespacing*pnSide(pn));draworder,num);
            OnCommand=cmd(visible,SideJoined(pn));

            --// ICONS ==================
            Def.Sprite{
                Texture = THEME:GetPathG("","radar");
                InitCommand=cmd(zoom,0.375;animate,false;halign,0.5;valign,0.5;diffuse,PlayerColor(pn);y,12;diffusebottomedge,0.2,0.2,0.2,0.5;diffusealpha,0;);
                OnCommand=cmd(setstate,self:GetNumStates() > num and num or 0;playcommand,"StateChanged");
                StateChangedMessageCommand=function(self)
                    self:stoptweening();
                    self:decelerate(0.15);

                    if Global.state == "SelectSteps" then
                        self:diffusealpha(0.5);
                    else
                        self:diffusealpha(0);
                    end;

                    if pn == PLAYER_1 then
                        self:x((num*iconspacing)+iconadjust);
                    elseif pn == PLAYER_2 then
                        self:x((-radaritems*iconspacing)+(num*iconspacing)-iconadjust);
                    end;

                end;
            };

            --// LABELS ==================
            Def.BitmapText{
                Font = Fonts.radar["Label"];
                InitCommand=cmd(zoomx,0.31;zoomy,0.3;halign,0.5;valign,0.5;diffuse,PlayerColor(pn);strokecolor,BoostColor(PlayerColor(pn),0.3);vertspacing,-30.9;diffusealpha,0);
                OnCommand=cmd(playcommand,"StateChanged");
                StateChangedMessageCommand=function(self)
                    self:stoptweening();
                    self:decelerate(0.15);

                    if Global.state == "SelectSteps" then
                        self:y(32);
                        self:diffusealpha(1);
                    else
                        self:y(28);
                        self:diffusealpha(0);
                    end;

                    if pn == PLAYER_1 then
                        self:x((num*iconspacing)+iconadjust);
                    elseif pn == PLAYER_2 then
                        self:x((-radaritems*iconspacing) + (num*iconspacing)-iconadjust);
                    end;

                    self:settext(string.upper((num+1) <= #paneLabels and paneLabels[num+1] or ""));
                end;
            };


            --// NUMBERS ==================
            Def.BitmapText{
                Font = Fonts.radar["Number"];
                InitCommand=cmd(zoomx,0.425;zoomy,0;halign,0.5;valign,0.5;maxwidth,72;diffusealpha,0);
                OnCommand=cmd(playcommand,"StateChanged");
                StateChangedMessageCommand=function(self)
                    self:stoptweening();
                    self:decelerate(0.15);
                    if Global.state == "SelectSteps" then
                        self:zoomy(0.45);
                        self:diffusealpha(1);
                    else
                        self:zoomy(0);
                        self:diffusealpha(0);
                    end;

                    if pn == PLAYER_1 then
                        self:x((num*iconspacing)+iconadjust);
                    elseif pn == PLAYER_2 then
                        self:x((-radaritems*iconspacing) + (num*iconspacing)-iconadjust);
                    end;
                end;

                StepsChangedMessageCommand=function(self)
                    local value = 0;
                    if GAMESTATE:IsSideJoined(pn) and Global.pncursteps[pn] then
                        value = GetRadar(Global.steps[Global.pnsteps[pn]],pn,num+1);
                    end;
                    self:y(20);
                    self:settext(string.rep("0",3-string.len(value))..value);

                    if value == 0 then
                        self:diffusetopedge(1,0.5,0.5,1);
                        self:diffusebottomedge(0.5,0.5,0.5,1);
                        self:strokecolor(0.3,0.175,0.175,0.8);
                    else
                        self:diffusetopedge(1,1,1,1);
                        self:diffusebottomedge(BoostColor(PlayerColor(pn),1.5));
                        self:strokecolor(BoostColor(PlayerColor(pn,0.8),0.25))
                    end;
                end;

            };

    };

end;

--//==========================================
--//  SCORES
--//==========================================

-- personal

local score_width = 112;
local score_height = 0.35;
local score_size = 0.35;
local score_pos = originY + 42;

-- personal
local hs_p = Def.ActorFrame{
    InitCommand=cmd(x,_screen.cx - 12;y,score_pos;diffusealpha,0);
    StateChangedMessageCommand=function(self)
        self:stoptweening();
        self:decelerate(Global.state == "SelectSteps" and 0.3 or 0.15);
        self:x(Global.state == "SelectSteps" and _screen.cx or _screen.cx - 12);
        self:diffusealpha(Global.state == "SelectSteps" and 1 or 0);
    end;

    LoadActor(THEME:GetPathG("","litepane"))..{
        InitCommand=cmd(zoomto,score_width,score_height*self:GetHeight();animate,false;setstate,1)
    },
    LoadActor(THEME:GetPathG("","litepane"))..{
        InitCommand=cmd(zoom,score_height;x,-score_width/2;horizalign,right;animate,false;setstate,0);
    },   
    LoadActor(THEME:GetPathG("","litepane"))..{
        InitCommand=cmd(zoom,score_height;x,score_width/2;horizalign,left;animate,false;setstate,2);
    },
    LoadActor(THEME:GetPathG("","separator"))..{
        InitCommand=cmd(zoom,0.3;diffuse,0.1,0.1,0.1,1);
        OnCommand=cmd(visible,GAMESTATE:GetNumSidesJoined() > 1);
    },
    Def.BitmapText{
        Font = Fonts.radar["Label"];
        Text = string.upper("Personal Best");
        InitCommand=cmd(zoomx,0.31;zoomy,0.3;diffuse,HighlightColor();strokecolor,BoostColor(HighlightColor(),0.3);y,-18);
    },
};

-- machine
local hs_m = Def.ActorFrame{
    InitCommand=cmd(x,_screen.cx + 12;y,score_pos+22);
    StateChangedMessageCommand=function(self)
        self:stoptweening();
        self:decelerate(Global.state == "SelectSteps" and 0.3 or 0.15);
        self:x(Global.state == "SelectSteps" and _screen.cx or _screen.cx + 12);
        self:diffusealpha(Global.state == "SelectSteps" and 1 or 0);
    end;

    LoadActor(THEME:GetPathG("","litepane"))..{
        InitCommand=cmd(zoomto,score_width,score_height*self:GetHeight();animate,false;setstate,1)
    },
    LoadActor(THEME:GetPathG("","litepane"))..{
        InitCommand=cmd(zoom,score_height;x,-score_width/2;horizalign,right;animate,false;setstate,0);
    },   
    LoadActor(THEME:GetPathG("","litepane"))..{
        InitCommand=cmd(zoom,score_height;x,score_width/2;horizalign,left;animate,false;setstate,2);
    },
    LoadActor(THEME:GetPathG("","separator"))..{
        InitCommand=cmd(zoom,0.3;diffuse,0.1,0.1,0.1,1);
        OnCommand=cmd(visible,GAMESTATE:GetNumSidesJoined() > 1);
    },
    Def.BitmapText{
        Font = Fonts.radar["Label"];
        Text = string.upper("Machine Best");
        InitCommand=cmd(zoomx,0.31;zoomy,0.3;diffuse,HighlightColor();strokecolor,BoostColor(HighlightColor(),0.3);y,18);
    },
};

local grade_size = 0.1;
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    if SideJoined(pn) then

--[[

    -- personal best grade
    hs_p[#hs_p+1] = Def.Sprite{
        UpdateScoresMessageCommand=function(self)
            local song = Global.song or GAMESTATE:GetCurrentSong();
            local steps = Global.pncursteps[pn] or GAMESTATE:GetCurrentSteps(pn);
            local hs = GetTopScoreForProfile(song,steps,PROFILEMAN:GetProfile(pn));
            local grade = nil;

            if hs then
                if IsGame("pump") then
                    grade = PIUHighScoreGrade(hs);
                    grade = FormatGradePIU(grade);
                else
                    grade = hs:GetGrade();
                    grade = FormatGrade(grade);
                end;
            end;
            self:Load(grade and THEME:GetPathG("","eval/"..string.gsub(grade,"+","").."_normal") or nil);
            self:horizalign(pnAlign(OtherPlayer[pn]));
            self:diffuse(GradeColor(grade));
            self:diffusetopedge(1,1,1,1);
            self:diffusealpha(1/3);
            self:zoom(grade_size);
        end;
    };

    -- machine best grade
    hs_m[#hs_m+1] = Def.Sprite{
        UpdateScoresMessageCommand=function(self)
            local song = Global.song or GAMESTATE:GetCurrentSong();
            local steps = Global.pncursteps[pn] or GAMESTATE:GetCurrentSteps(pn);
            local hs = GetTopScoreForProfile(song,steps,PROFILEMAN:GetMachineProfile());
            local grade = nil;

            if hs then
                if IsGame("pump") then
                    grade = PIUHighScoreGrade(hs);
                    grade = FormatGradePIU(grade);
                else
                    grade = hs:GetGrade();
                    grade = FormatGrade(grade);
                end;
            end;
            self:Load(grade and THEME:GetPathG("","eval/"..string.gsub(grade,"+","").."_normal") or nil);
            self:horizalign(pnAlign(OtherPlayer[pn]));
            self:diffuse(GradeColor(grade));
            self:diffusetopedge(1,1,1,1);
            self:diffusealpha(1/3);
            self:zoom(grade_size);
        end;
    };

]]

    -- personal best dp
    hs_p[#hs_p+1] = Def.BitmapText{
        Font = Fonts.stepslist["Percentage"];
        InitCommand=cmd(x,GAMESTATE:GetNumSidesJoined() == 1 and 0 or (score_width-8) * 0.5 * pnSide(pn);horizalign,GAMESTATE:GetNumSidesJoined() == 1 and center or pnAlign(pn));
        OnCommand=cmd(zoomx,score_size;zoomy,score_size);
        UpdateScoresMessageCommand=function(self)
            local song = Global.song or GAMESTATE:GetCurrentSong();
            local steps = Global.pncursteps[pn] or GAMESTATE:GetCurrentSteps(pn);
            local hs = GetTopScoreForProfile(song,steps,PROFILEMAN:GetProfile(pn));

            self:stoptweening();
            self:diffuse(BoostColor(PlayerColor(pn),1));
            --self:diffusetopedge(BoostColor(PlayerColor(pn),1.25));
            self:strokecolor(BoostColor(PlayerColor(pn,0.75),0.15));

            if hs then 
                self:settext(FormatDP(hs:GetPercentDP())) 
                self:diffusealpha(1);
            else 
                self:settext("0%");
                self:diffusealpha(0.3);
            end
        end;
    };

    -- machine best dp
    hs_m[#hs_m+1] = Def.BitmapText{
        Font = Fonts.stepslist["Percentage"];
        InitCommand=cmd(x,GAMESTATE:GetNumSidesJoined() == 1 and 0 or (score_width-8) * 0.5 * pnSide(pn);horizalign,GAMESTATE:GetNumSidesJoined() == 1 and center or pnAlign(pn));
        OnCommand=cmd(zoomx,score_size;zoomy,score_size);
        UpdateScoresMessageCommand=function(self)
            local song = Global.song or GAMESTATE:GetCurrentSong();
            local steps = Global.pncursteps[pn] or GAMESTATE:GetCurrentSteps(pn);
            local hs = GetTopScoreForProfile(song,steps,PROFILEMAN:GetMachineProfile());

            self:stoptweening();
            self:diffuse(0.6,0.6,0.6,1);
            --self:diffusetopedge(0.85,0.85,0.85,1);
            self:strokecolor(0.1,0.1,0.1,1);

            if hs then 
                self:settext(FormatDP(hs:GetPercentDP())) 
                self:diffusealpha(1);
            else 
                self:settext("0%");
                self:diffusealpha(0.3);
            end
        end;
    };


    end;
end;



t[#t+1] = hs_p;
t[#t+1] = hs_m;

--//==========================================
--//  CURSOR
--//==========================================


t[#t+1] = Def.ActorFrame{
    InitCommand=cmd(playcommand,"StepsChanged");
    OnCommand=cmd(visible,SideJoined(pn));
    StateChangedMessageCommand=cmd(playcommand,"StepsChanged");
    StepsChangedMessageCommand=function(self)
        if GAMESTATE:IsSideJoined(pn) then
            local index = 1;
            self:stoptweening();
            self:decelerate(0.15);

            if Global.pnsteps[pn] then
                index = Global.pnsteps[pn];
                if index > numcharts then
                    index = index % numcharts
                end
            end;

            self:x((originX)+(spacing*(index-1))-((numcharts/2)*spacing)+(spacing/2));
            self:y(originY);
        end;
    end;

    LoadActor(THEME:GetPathG("","cursor"))..{
        InitCommand=cmd(spin;effectmagnitude,0,0,720;animate,false;zoom,0.475;rotationy,20;rotationx,-50;x,-1;blend,Blend.Add;diffusealpha,0;);
        StateChangedMessageCommand=function(self,param) 
            self:stoptweening(); 
            
            if param and (param.Prev or param.Next) and param.Player == pn then
                self:linear(0.2);
            end;

            if Global.state ~= "SelectSteps" or not GAMESTATE:IsSideJoined(pn) then 
                self:diffusealpha(0); 
            else 
                self:diffusealpha(1); 
            end; 

        end;
        OnCommand=function(self)
            if pn == PLAYER_1 then 
                self:setstate(1); 
            elseif pn == PLAYER_2 then 
                self:setstate(3); 
            end;    
        end;
    };

    LoadActor(THEME:GetPathG("","label"))..{
        InitCommand=cmd(animate,false;zoom,0.36;diffusealpha,0);
        OnCommand=cmd(playcommand,"StepsChanged");
        StateChangedMessageCommand=cmd(playcommand,"StepsChanged");
        StepsChangedMessageCommand=function(self,param)
            if GAMESTATE:IsSideJoined(pn) then

                local index = 1;
                self:stoptweening();
                
                if param and (param.Prev or param.Next) and param.Player == pn then
                    self:decelerate(0.275);
                end;

                if Global.state ~= "SelectSteps" or not GAMESTATE:IsSideJoined(pn) then 
                    self:diffusealpha(0) 
                else 
                    self:diffusealpha(1);
                end;
                
                if pn == PLAYER_1 then 
                    self:setstate(0); 
                    self:x(-12);
                    self:y(-11);
                elseif pn == PLAYER_2 then 
                    self:setstate(1); 
                    self:x(11);
                    self:y(12);
                end; 
            end;
        end;
    };

};

end;
    
for i=1,numcharts do


    t[#t+1] = Def.BitmapText{
        Font = Fonts.stepslist["Main"];
        InitCommand=cmd(zoom,0.5;diffuse,1,1,1,0;strokecolor,0,0,0,0.25;y,originY;x,(originX)+(spacing*(i-1))-((numcharts/2)*spacing)+(spacing/2)-1);
        OnCommand=cmd(playcommand,"MusicWheel");
        MusicWheelMessageCommand=function(self,param)
            
            self:stoptweening();
            self:decelerate(0.175);
            
            if param and param.Direction then voffset = 0; end;

            local tint;
            local offset = voffset * numcharts;
            local steps = Global.steps[i + offset];

            self:diffuse(1,1,1,1);
            self:strokecolor(0,0,0,0.25);

            if steps then

                local tint = StepsColor(steps);
                self:diffuse(tint);
                self:diffusetopedge(BoostColor(tint,9));
                self:strokecolor(BoostColor(tint,0.25));

                if TotalNotes(steps) == 0 then
                    self:settext("00");
                else
                    self:settext(FormatMeter(steps:GetMeter()));
                end

            else    
                self:settext("00");
                self:diffusealpha(0.1);
            end;

            self:x((originX)+(spacing*(i-1))-((numcharts/2)*spacing)+(spacing/2)-1);
        end;
    };



    t[#t+1] = LoadActor(THEME:GetPathG("","separator"))..{
        OnCommand=cmd(diffuse,0.1,0.1,0.1,0.9;y,originY+0.5;zoom,0.25;queuecommand,"MusicWheel");
        MusicWheelMessageCommand=function(self)
        self:x((originX)+(spacing*(i-1))-((numcharts/2)*spacing)+(spacing/2)+14);
        if i<numcharts then self:visible(true) else self:visible(false); end;
        end;
    };

end;



return t