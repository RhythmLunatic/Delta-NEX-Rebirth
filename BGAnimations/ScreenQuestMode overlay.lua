local t = Def.ActorFrame{};

function parallelogramGen(width,height,clr)
	return Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(setsize,width-height,height;diffuse,clr);
		};
		Def.ActorMultiVertex{
			InitCommand=function(self)
				self:xy((width-height)/2,-height/2);
				self:SetDrawState{Mode="DrawMode_Triangles"}
				self:SetVertices({
					{{0, 0, 0}, clr},
					{{height, 0, 0}, clr},
					{{0, height, 0}, clr}
			
				});
			end;
		};
		Def.ActorMultiVertex{
			InitCommand=function(self)
				self:xy(-(width+height)/2,-height/2);
				self:SetDrawState{Mode="DrawMode_Triangles"}
				self:SetVertices({
					{{height, height, 0}, clr},
					{{0, height, 0}, clr},
					{{height, 0, 0}, clr}
				});
			end;
		};

	};
end

function rectGen(width, height, lineSize, bgColor)
    return Def.ActorFrame{
    
        --Background transparency
        Def.Quad{
            InitCommand=cmd(setsize,width, height;diffuse,bgColor);
            
        };
        --Bottom line
        Def.Quad{
            InitCommand=cmd(setsize,width + lineSize, lineSize;addy,height/2;--[[horizalign,0;vertalign,2]]);
            
        };
        --Top line
        Def.Quad{
            InitCommand=cmd(setsize,width + lineSize, lineSize;addy,-height/2;--[[horizalign,2;vertalign,0]]); --2 = right aligned
            
        };
        --Left line
        Def.Quad{
            InitCommand=cmd(setsize,lineSize, height + lineSize;addx,-width/2;--[[vertalign,0;horizalign,2]]); --2 = right aligned
            
        };
        --Right line
        Def.Quad{
            InitCommand=cmd(setsize,lineSize, height + lineSize;addx,width/2;--[[vertalign,2;horizalign,0]]); --2 = bottom aligned
            
        };
    };
end;

--1 indexed, because lua.
local currentMissionNum;
local currentGroupNum = 1;
local NUM_MISSION_GROUPS = #RIO_COURSE_GROUPS

local GroupCache = {};
function updateGroupCache()
	GroupCache.currentGroup = RIO_COURSE_GROUPS[currentGroupNum];
	GroupCache.courses = SONGMAN:GetCoursesInGroup(GroupCache.currentGroup,false);
	GroupCache.numCourses = #GroupCache.courses;
	--Reset the mission num when switching groups.
	currentMissionNum = 1;
	GAMESTATE:SetCurrentCourse(GroupCache.courses[currentMissionNum]);
	MESSAGEMAN:Broadcast("CurrentMissionGroupChanged");
end;
updateGroupCache();


t[#t+1] = Def.ActorFrame{
	Def.Sprite{
		--No Quest Mode BGA so we'll have to live with it
		Texture=THEME:GetPathG("","_VIDEOS/back");
		InitCommand=cmd(Cover;)
	};
	--Header stuff

	LoadActor(THEME:GetPathG("","header"), false)..{};
			--TITLE
	LoadFont("venacti/_venacti 26px bold diffuse")..{
			InitCommand=cmd(draworder,100;rotationx,30;diffuse,0.08,0.08,0.08,1;diffusetopedge,0.2,0.2,0.2,1;shadowlengthy,-1;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_TOP+37;zoomx,0.7;zoomy,0.725;);
		Text="QUEST ZONE";
	};

	--TIMER

	LoadActor("B0") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+190;y,SCREEN_TOP+16;zoomy,0.55;zoomx,-0.55);

	}; 

	LoadActor("B1") .. {
		InitCommand=cmd(draworder,101;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

	}; 

	LoadActor("B2") .. {
		InitCommand=cmd(draworder,103;x,SCREEN_CENTER_X+160;y,SCREEN_TOP+25;zoomy,0.6;zoomx,-0.6);

	}; 

	LoadFont("venacti/_venacti 13px bold diffuse")..{
			InitCommand=cmd(draworder,102;diffuse,0.6,0.6,0.6,0.6;shadowcolor,0,0,0,0.3;shadowlengthx,-0.8;shadowlength,-0.8;horizalign,left;x,SCREEN_CENTER_X+185 ;y,SCREEN_TOP+16;zoom,0.40);
			Text="TIMER"
	};
	LoadActor(THEME:GetPathG("","footer"))..{
		InitCommand=cmd(draworder,130);
	};
	
	--TIME
	--[[LoadFont("monsterrat/_montserrat light 60px")..{
			Text="TIME";
			InitCommand=cmd(x,SCREEN_CENTER_X-25;y,SCREEN_BOTTOM-92;zoom,0.6;skewx,-0.2);
	};]]
	
	Def.Quad{
		InitCommand=cmd(diffuse,color("0,0,0,.5");setsize,300,50;xy,200,90;);
	};
	LoadFont("Common Normal")..{
		Text="Mission Group Name Goes here";
		InitCommand=cmd(xy,200,90;wrapwidthpixels,300);
		OnCommand=function(self)
			self:settext(GroupCache.currentGroup);
		end;
		CurrentMissionGroupChangedMessageCommand=cmd(playcommand,"On");
	
	};
	Def.Quad{
		InitCommand=cmd(diffuse,color("0,0,0,.5");setsize,120,20;xy,200+160,90-50/2;horizalign,left;vertalign,top;);
	};
	Def.ActorMultiVertex{
		InitCommand=function(self)
			self:xy(200+160+120,90-50/2);
			self:SetDrawState{Mode="DrawMode_Triangles"}
            self:SetVertices({
                {{0, 0, 0}, color("0,0,0,.5")},
        		{{0, 20, 0}, color("0,0,0,.5")},
				{{20, 0, 0}, color("0,0,0,.5")}
            });
        end;
	};
	--Mission 2...
	parallelogramGen(130,20,color("0,0,0,.5"))..{
		InitCommand=cmd(xy,560,90-50/2+20/2;);
	};
	--Mission 3..
	parallelogramGen(130,20,color("0,0,0,.5"))..{
		InitCommand=cmd(xy,560+130+5,90-50/2+20/2;);
	};
	
	--Mission info..
	Def.Quad{
		InitCommand=cmd(setsize,410,300;diffuse,color("0,0,0,.5");xy,200+160,100;horizalign,left;vertalign,top;);
	};

	LoadFont("monsterrat/_montserrat semi bold 60px")..{
		InitCommand=cmd(xy,200+160+410/2,110;vertalign,top;zoom,0.6;skewx,-0.255;maxwidth,650);
		--Mission Name Goes Here
		--Text="aaaaaaaaaaaaaaaaaaaaaaaaaaaa";
		OnCommand=cmd(settext,GroupCache.courses[currentMissionNum]:GetDisplayFullTitle();stoptweening;diffusealpha,0;x,200+160+410/2+75;decelerate,0.5;x,200+160+410/2;diffusealpha,1;);
		CurrentCourseChangedMessageCommand=cmd(playcommand,"On");
		CurrentMissionGroupChangedMessageCommand=cmd(playcommand,"On");
	};
	Def.Quad{
		InitCommand=cmd(setsize,410,2;diffuse,color("1,1,1,1");xy,200+160,140;horizalign,left;vertalign,top;fadeleft,.8;faderight,.8;);
	};
	--[[Def.Quad{
		InitCommand=cmd(setsize,410,80;diffuse,color("1,1,1,.2");xy,200+160,150;horizalign,left;vertalign,top;);
	};]]
	
	Def.Quad{
		InitCommand=cmd(diffuse,color("1,1,1,.5");setsize,300,35;xy,200,135;);
		CodeMessageCommand=function(self, params)
			if params.Name == "UpLeft" then
				if currentGroupNum > 1 then
					currentGroupNum = currentGroupNum-1;
					updateGroupCache();
				end;
			elseif params.Name== "UpRight" then
				if currentGroupNum < NUM_MISSION_GROUPS then
					currentGroupNum = currentGroupNum+1;
					updateGroupCache();
				end;
			elseif params.Name == "DownLeft" then
				if currentMissionNum > 1 then
					currentMissionNum = currentMissionNum -1;
					GAMESTATE:SetCurrentCourse(GroupCache.courses[currentMissionNum]);
					MESSAGEMAN:Broadcast("CurrentCourseChanged")
					self:stoptweening():decelerate(.2):y(135+35*(currentMissionNum-1));
				end;
			elseif params.Name == "DownRight" then
				if currentMissionNum < GroupCache.numCourses then
					currentMissionNum = currentMissionNum + 1;
					GAMESTATE:SetCurrentCourse(GroupCache.courses[currentMissionNum]);
					MESSAGEMAN:Broadcast("CurrentCourseChanged")
					self:stoptweening():decelerate(.2):y(135+35*(currentMissionNum-1));
				end;
			end;
		end;
	};
};



--I don't think this is correct
local q = Def.ActorFrame{
	InitCommand=cmd(xy,75,100);
};
for i = 1,6 do
	q[i] = Def.ActorFrame{
		InitCommand=cmd(addy,35*i);
		Def.Quad{
			InitCommand=cmd(diffuse,color(".5,.5,.5,.5");setsize,30,30);
		};
		LoadFont("venacti/_venacti_outline 26px bold monospace numbers")..{
			Text=i;
			InitCommand=cmd(zoom,.8;);
		};
		LoadFont("venacti/_venacti 26px bold diffuse")..{
			Text="Mission title goes here";
			InitCommand=cmd(horizalign,left;x,20;addy,2);
			OnCommand=function(self)
				if i <= GroupCache.numCourses then
					self:settext(GroupCache.courses[i]:GetDisplayFullTitle());
				else
					self:settext("");
				end;
			end;
		};
	};
end;
t[#t+1] = q;

local j = Def.ActorFrame{
	InitCommand=cmd(xy,200+160+15,130;);
};
--I don't expect there to be more than 4 songs.
for i = 1,4 do
	j[i] = Def.ActorFrame{
		InitCommand=cmd(addy,30*i);
		OnCommand=function(self)
			local course = GAMESTATE:GetCurrentCourse();
			self:stoptweening():diffusealpha(0);
			if i <= course:GetNumCourseEntries() then
				self:GetChild("SongName"):settext(course:GetCourseEntry(i-1):GetSong():GetDisplayFullTitle());
				local trail = GroupCache.courses[currentMissionNum]:GetAllTrails()[i]
				local meter = trail:GetMeter();
				if meter >= 99 then
					self:GetChild("Label"):settext("??");
				else
					self:GetChild("Label"):settextf("%02d",meter);
				end;
				
				local StepsType = trail:GetStepsType();
				local labelBG = self:GetChild("LabelBG");
				if StepsType then
					sString = THEME:GetString("StepsDisplay StepsType",ToEnumShortString(StepsType));
					if sString == "Single" then
						--There is no way to designate a single trail as DANGER, unfortunately.
						if meter >= 99 then
							labelBG:setstate(4);
						else
							labelBG:setstate(0);
						end
					elseif sString == "Double" then
						labelBG:setstate(1);
					elseif sString == "SinglePerformance" or sString == "Half-Double" then
						labelBG:setstate(2);
					elseif sString == "DoublePerformance" or sString == "Routine" then
						labelBG:setstate(3);	
					else
						labelBG:setstate(5);
					end;
				end;
				
				self:sleep(.05*i):decelerate(.2):diffusealpha(1);
			else
				--Do nothing.
			end;
		end;
		CurrentCourseChangedMessageCommand=cmd(playcommand,"On");
		CurrentMissionGroupChangedMessageCommand=cmd(playcommand,"On");
		
		LoadActor(THEME:GetPathG("","DifficultyDisplay/_icon"))..{
			Name="LabelBG";
			InitCommand=cmd(zoom,0.25;animate,false);--draworder,140;);
		};
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			Name="Label";
			InitCommand=cmd(zoom,.5);
		};
		-- NEW LABEL
		--[[LoadActor(THEME:GetPathG("StepsDisplayListRow","frame/danger"))..{
			InitCommand=cmd(zoom,0.5;y,22);
			OnCommand=cmd(diffuseshift; effectoffset,1; effectperiod, 0.5; effectcolor1, 1,1,0,1; effectcolor2, 1,1,1,1;);
			SetMessageCommand=function(self,param)
				profile = PROFILEMAN:GetMachineProfile();
				scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),param.Steps);
				scores = scorelist:GetHighScores();
				topscore = scores[1];
				
				local descrp = param.Steps:GetDescription();

				if descrp == "DANGER!" then
					self:visible(true);
				else
					self:visible(false);
				end;
			
			end;
		};]]
		LoadFont("facu/_zona pro bold 40px")..{
			Name="SongName";
			Text="Song names here";
			InitCommand=cmd(horizalign,left;zoom,.5;addx,15);

		};
	};
end;
t[#t+1] = j;

return t;
