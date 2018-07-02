local t = Def.ActorFrame{};

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do

	local profile = PROFILEMAN:GetProfile(pn)
	
	t[#t+1] = Def.ActorFrame{
		--[[CodeMessageCommand=function(self, params)
			if params.Name == "start" then
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
			elseif params.Name == "Back" then
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
			else
				SCREENMAN:SystemMessage("Unknown button: "..params.Name)
			end;
		end;]]
		--I long for the day when this theme gets rewritten for 720p so I never have to deal with another zoom function ever again
		InitCommand=function(self)
			self:y(SCREEN_CENTER_Y):zoom(.9):rotationx(90);
			if pn == PLAYER_1 then
				self:x(SCREEN_CENTER_X/2)
			else
				self:x(SCREEN_WIDTH*.75)
			end;
		end;
		
		OnCommand=cmd(decelerate,1;rotationx,0);
		
		OffCommand=cmd(decelerate,.5;rotationx,90);
		
		LoadActor(THEME:GetPathG("", "profile"))..{};
		
		LoadFont("MyDefault")..{
			Text=profile:GetDisplayName();
			InitCommand=cmd(y,-173;diffuse,color("#4C4C4C"));
		};
		
		Def.ActorFrame{
			InitCommand=cmd(y,-120);
		
			LoadFont("MyDefault")..{
				InitCommand=cmd(horizalign,left;x,-350/2;diffusebottomedge,Color("Red"));
				Text="Dance Points";
			};
			LoadFont("MyDefault")..{
				InitCommand=cmd(horizalign,right;x,350/2);
				Text=profile:GetTotalDancePoints();
			};
			Def.Quad{
				InitCommand=cmd(setsize,350,1;diffuse,color("#AAAAAAFF");y,13);
			};
			
		};
		
		Def.ActorFrame{
			InitCommand=cmd(y,-20);
		
			LoadFont("MyDefault")..{
				InitCommand=cmd(horizalign,left;x,-350/2;diffusebottomedge,Color("Orange"));
				Text="Single S+ Grades";
			};
			LoadFont("MyDefault")..{
				InitCommand=cmd(horizalign,right;x,350/2);
				--Text=profile:GetTotalStepsWithTopGrade("StepsType_Pump_Single");
			};
			Def.Quad{
				InitCommand=cmd(setsize,350,1;diffuse,color("#AAAAAAFF");y,13);
			};
			
		};
		Def.ActorFrame{
			InitCommand=cmd(y,20);
		
			LoadFont("MyDefault")..{
				InitCommand=cmd(horizalign,left;x,-350/2;diffusebottomedge,Color("Green"));
				Text="Double S+ Grades";
			};
			LoadFont("MyDefault")..{
				InitCommand=cmd(horizalign,right;x,350/2);
				--Text=profile:GetTotalStepsWithTopGrade("StepsType_Pump_Single");
			};
			Def.Quad{
				InitCommand=cmd(setsize,350,1;diffuse,color("#AAAAAAFF");y,13);
			};
		};
		
		Def.ActorFrame{
			InitCommand=cmd(y,80);
		
			LoadFont("MyDefault")..{
				InitCommand=cmd(horizalign,left;x,-350/2;diffusebottomedge,Color("HoloBlue"));
				Text="Steps Taken";
			};
			LoadFont("MyDefault")..{
				InitCommand=cmd(horizalign,right;x,350/2);
				Text=profile:GetTotalTapsAndHolds();
			};
			Def.Quad{
				InitCommand=cmd(setsize,350,1;diffuse,color("#AAAAAAFF");y,13);
			};
			
		};
		Def.ActorFrame{
			InitCommand=cmd(y,120);
		
			LoadFont("MyDefault")..{
				InitCommand=cmd(horizalign,left;x,-350/2;diffusebottomedge,Color("HoloBlue"));
				Text="Play Count";
			};
			LoadFont("MyDefault")..{
				InitCommand=cmd(horizalign,right;x,350/2);
				Text=profile:GetNumTotalSongsPlayed();
			};
			Def.Quad{
				InitCommand=cmd(setsize,350,1;diffuse,color("#AAAAAAFF");y,13);
			};
			
		};
		Def.ActorFrame{
			InitCommand=cmd(y,160);
		
			LoadFont("MyDefault")..{
				InitCommand=cmd(horizalign,left;x,-350/2;diffusebottomedge,Color("HoloBlue"));
				Text="Calories Burned";
			};
			LoadFont("MyDefault")..{
				InitCommand=cmd(horizalign,right;x,350/2;maxwidth,140);
				OnCommand=function(self)
					self:settextf("%.3f", profile:GetTotalCaloriesBurned());
				end;
			};
			Def.Quad{
				InitCommand=cmd(setsize,350,1;diffuse,color("#AAAAAAFF");y,13);
			};
			
		};

	}
end
return t;