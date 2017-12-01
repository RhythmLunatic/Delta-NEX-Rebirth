local currentsort = 1;
local sorts = { "dp", "misscount", "maxcombo", "date" };

local maxdigits = 1;
local hs_grade = JudgmentGrade();
table.remove(hs_grade, #hs_grade);

local personal_score = {
	[PLAYER_1] = nil,
	[PLAYER_2] = nil,
};

local machine_score = {
	[PLAYER_1] = nil,
	[PLAYER_2] = nil,
}

function HighScoreController(self,param)
	if param.Input == "Cancel" or param.Input == "Back" and Global.level == 2 then 
		Global.level = 1; 
		Global.selection = 5; 
		Global.state = "MainMenu"; 
		MESSAGEMAN:Broadcast("StateChanged"); 
		MESSAGEMAN:Broadcast("Return");
	end;
end

function SelectHighScore(param)

end;

--//================================================================

local t = Def.ActorFrame{
	InitCommand=cmd(diffusealpha,0);
	MainMenuMessageCommand=cmd(playcommand,"StateChanged");
	MusicWheelMessageCommand=function(self) MESSAGEMAN:Broadcast("GetScores"); end;
	StepsChangedMessageCommand=function(self) MESSAGEMAN:Broadcast("GetScores"); end;
	StateChangedMessageCommand=function(self) 
		self:stoptweening(); 
		self:decelerate(0.2); 
		self:diffusealpha(Global.state == "HighScores" and 1 or 0); 
		if Global.state == "HighScores" then MESSAGEMAN:Broadcast("GetScores"); end;
	end;
	GetScoresMessageCommand=function(self)
		hs_grade = JudgmentGrade();
		table.remove(hs_grade, #hs_grade);

			local machinedigits = 1;
			local personaldigits = 1;

		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			personal_score[pn] = FetchScores(pn, PROFILEMAN:GetProfile(pn), sorts[currentsort]);
			machine_score[pn] = FetchScores(pn, PROFILEMAN:GetMachineProfile(), sorts[currentsort]);

			for p=2,#hs_grade do
				machinedigits = math.max(machinedigits,GetHighScoreValue(machine_score[pn], hs_grade[p].Label, GetHighScoreValue(machine_score[pn], hs_grade[p-1].Label))); 
				personaldigits = math.max(personaldigits,GetHighScoreValue(personal_score[pn], hs_grade[p].Label, GetHighScoreValue(personal_score[pn], hs_grade[p-1].Label))); 
			end;

			maxdigits = math.max(machinedigits,personaldigits);
			maxdigits = clamp(string.len(maxdigits),1,math.huge);

		end;

		MESSAGEMAN:Broadcast("UpdateScores");
	end;
};

local spacing = 186;
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do 


	-- highscore panel
	local panel = Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_CENTER_X + (140*pnSide(pn));y,SCREEN_CENTER_Y-148);

		-- bg
		Def.Quad{
			InitCommand=cmd(vertalign,top;zoomto,350*pnSide(pn),210;diffuse,0,0,0,0.25;diffusebottomedge,0,0,0,0;faderight,0.25;fadeleft,0.25);
		},

		-- machine best grade
		Def.Sprite{
			InitCommand=cmd(vertalign,top;x,-86 - 16;y,12;zoom,0.15;diffusealpha,0.2);
			UpdateScoresMessageCommand=function(self)
				local grade = nil;
				if machine_score[pn] then
					if IsGame("pump") then
						grade = PIUHighScoreGrade(machine_score[pn]);
						grade = FormatGradePIU(grade);
					else
						grade = machine_score[pn]:GetGrade();
						grade = FormatGrade(grade);
					end;
				end;

				self:Load(grade and THEME:GetPathG("","eval/"..string.gsub(grade,"+","").."_normal") or nil);
				self:diffuse(GradeColor(grade));
				self:diffusealpha(0.2);
                self:diffusetopedge(1,1,1,0.2);
			end;
		},

		-- personal best grade
		Def.Sprite{
			InitCommand=cmd(vertalign,top;x,-86;y,12;zoom,0.3);
			UpdateScoresMessageCommand=function(self)
				local grade = nil;
				if personal_score[pn] then
					if IsGame("pump") then
						grade = PIUHighScoreGrade(personal_score[pn]);
						grade = FormatGradePIU(grade);
					else
						grade = personal_score[pn]:GetGrade();
						grade = FormatGrade(grade);
					end;
				end;

				self:Load(grade and THEME:GetPathG("","eval/"..string.gsub(grade,"+","").."_normal") or nil);
				self:diffuse(GradeColor(grade));
                self:diffusetopedge(1,1,1,1);
			end;
		},


		-- award
		Def.BitmapText{
			Font = Fonts.highscores["Main"];
			Text = "Single Digit Flawless!";
			InitCommand=cmd(zoom,0.38;diffuse,PlayerColor(pn);strokecolor,BoostColor(PlayerColor(pn),0.3);vertalign,top;x,-86;y,74;wrapwidthpixels,200;maxwidth,200;vertspacing,-6);
			UpdateScoresMessageCommand=function(self)
				if personal_score[pn] then
					local award = personal_score[pn] and FormatAward(personal_score[pn]:GetStageAward());
					if award == "" then 
						if personal_score[pn]:GetGrade() == "Grade_Failed" then 
							award = "Failed"
						else
							award = "Clear" 
						end;
					end;
					self:settext(award);
				else
					self:settext("");
				end
			end;
		},


		-- personal best dp
		Def.BitmapText{
			Font = Fonts.highscores["Main"];
			Text = "98.76%";
			InitCommand=cmd(zoom,0.475;vertalign,top;x,-86;y,90+13;strokecolor,0.2,0.2,0.2,1);
			UpdateScoresMessageCommand=function(self)
				if personal_score[pn] then
					self:settext(FormatDP(personal_score[pn]:GetPercentDP()));
				else
					self:settext("No Play");
				end;
			end;
		},

		-- machine best dp
		Def.BitmapText{
			Font = Fonts.highscores["Main"];
			Text = "99.87%";
			InitCommand=cmd(zoom,0.45;vertalign,top;x,-86;y,106+13;diffuse,2/3,2/3,2/3,0.5;strokecolor,0.2,0.2,0.2,1);
			UpdateScoresMessageCommand=function(self)
				if machine_score[pn] then
					self:settext(FormatDP(machine_score[pn]:GetPercentDP()));
				else
					self:settext("No Play");
				end;
			end;
		},

	};

	local label_spacing = 15;
	local label_size = 0.45;
	local label_pos = 16;
	for i=1,#hs_grade do 

		-- labels
		panel[#panel+1] = Def.BitmapText{
			Font = Fonts.highscores["Main"];
			Text = hs_grade[i].Label;
			InitCommand=cmd(zoomx,label_size;zoomy,label_size*0.95;horizalign,right;vertalign,top;vertspacing,-6;x,8;y,label_pos + ((i-1)*label_spacing));
			OnCommand=cmd(diffuse,hs_grade[i].Color;strokecolor,BoostColor(hs_grade[i].Color,0.3));
			UpdateScoresMessageCommand=function(self)
				self:diffusealpha(hs_grade[i].Enabled and (personal_score[pn] or machine_score[pn]) and 1 or 0.25);
			end;
		};

		-- personal best
		panel[#panel+1] = Def.BitmapText{
			Font = Fonts.highscores["Main"];
			Text = CapDigits(1,0,4);
			InitCommand=cmd(zoomx,label_size;zoomy,label_size*0.95;horizalign,left;vertalign,top;vertspacing,-6;x,36;y,label_pos + ((i-1)*label_spacing));
			OnCommand=cmd(diffuse,hs_grade[i].Color;strokecolor,BoostColor(hs_grade[i].Color,0.3));
			UpdateScoresMessageCommand=function(self)
				self:diffusealpha(hs_grade[i].Enabled and personal_score[pn] and 1 or 0.25);
				self:settext(CapDigits(GetHighScoreValue(personal_score[pn], hs_grade[i].Label),0,maxdigits));
			end;
		};

		-- machine best
		panel[#panel+1] = Def.BitmapText{
			Font = Fonts.highscores["Main"];
			InitCommand=cmd(zoomx,label_size;zoomy,label_size*0.95;horizalign,left;vertalign,top;vertspacing,-6;x,84;y,label_pos + ((i-1)*label_spacing));
			OnCommand=cmd(diffuse,2/3,2/3,2/3,1;strokecolor,0.25,0.25,0.25,1);
			UpdateScoresMessageCommand=function(self)
				self:diffusealpha(hs_grade[i].Enabled and machine_score[pn] and 1 or 0.25);
				self:settext(CapDigits(GetHighScoreValue(machine_score[pn], hs_grade[i].Label),0,maxdigits));
			end;
		};

	end;

	t[#t+1] = panel;

	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(diffusealpha,0);
        StateChangedMessageCommand=function(self) self:stoptweening():decelerate(0.3):diffusealpha(Global.state == "HighScores" and 1 or 0); end;

        Def.Quad{
            InitCommand=cmd(CenterX;y,SCREEN_CENTER_Y-148;zoomto,_screen.w * 0.5 * pnSide(pn),1;horizalign,left;fadeleft,0.75;cropleft,0.15;diffuse,PlayerColor(pn));
        },

        -- TEXT
        Def.ActorFrame{
            InitCommand=cmd(x,SCREEN_CENTER_X + (pnSide(pn)*(spacing+32));y,SCREEN_CENTER_Y-148);
            StateChangedMessageCommand=function(self) 
            	self:stoptweening();
            	self:decelerate(0.4);
            	local offset = Global.state == "HighScores" and -8 or 8;
            	self:x(SCREEN_CENTER_X + (pnSide(pn)*(spacing + offset))); 
            end;

            -- title
            Def.BitmapText{
                Font = "regen strong";
                Text = string.upper("Top  Accuracy  Score");
                InitCommand=cmd(x,-48*pnSide(pn);zoomy,0.31;zoomx,0.3075;horizalign,pnAlign(OtherPlayer[pn]);strokecolor,BoostColor(PlayerColor(pn,0.9),1/3);diffusealpha,0);
                StateChangedMessageCommand=function(self)
                    self:stoptweening();
                    self:decelerate(Global.state == "HighScores" and 0.2 or 0.3);
                    self:diffusealpha(Global.state == "HighScores" and 0.75 or 0);
                end;
            },
        },
    };

end;

-- QUADS BG
local bg = Def.ActorFrame{
    InitCommand=cmd(CenterX;y,SCREEN_CENTER_Y-10.5;diffusealpha,0);
    StateChangedMessageCommand=function(self)
        self:stoptweening();
        self:decelerate(0.25);
        self:diffusealpha(Global.state == "HighScores" and 0.9 or 0);
    end;

    Def.Quad{
        InitCommand=cmd(zoomto,_screen.w,_screen.h;cropbottom,1/3;
            diffuse,BoostColor(Global.bgcolor,0.75);diffusebottomedge,BoostColor(AlphaColor(Global.bgcolor,0.5),0.5);fadebottom,1/3);
    },

    Def.Quad{
        InitCommand=cmd(zoomto,_screen.w,_screen.h;diffuse,BoostColor(Global.bgcolor,0.6);cropbottom,1/25;fadetop,0.5);
    },

    LoadActor(THEME:GetPathG("","_pattern"))..{
        InitCommand=cmd(zoomto,_screen.w,_screen.h;blend,Blend.Add;
            diffuse,BoostColor(HighlightColor(1),0.1);diffusebottomedge,0.1,0.1,0.1,0;fadetop,1;
                customtexturerect,0,0,_screen.w / 384 * 2.5 ,_screen.h / 384 * 2.5;texcoordvelocity,0,-0.075);
    },
};

return Def.ActorFrame{ bg, t };