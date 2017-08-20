local Player = ...
assert(Player,"Must pass in a player, dingus");

local paneCategoryValues = {
	{ Category = 'RadarCategory_TapsAndHolds', Text = THEME:GetString("RadarCategory","Taps"), Color = color("1,1,1,0.8") },
	{ Category = 'RadarCategory_Jumps', Text = THEME:GetString("RadarCategory","Jumps"), Color = color("1,1,0.75,0.8") },
	{ Category = 'RadarCategory_Holds', Text = THEME:GetString("RadarCategory","Holds"), Color = color("0.75,0.75,1,0.8") },
	{ Category = 'RadarCategory_Mines', Text = THEME:GetString("RadarCategory","Mines"), Color = color("1,0.75,0.75,0.8") },
	{ Category = 'RadarCategory_Hands', Text = THEME:GetString("RadarCategory","Hands"), Color = color("0.75,1,1,0.8") },
	--{ Category = 'RadarCategory_Rolls', Text = THEME:GetString("RadarCategory","Rolls"), Color = color("0.75,1,0.75,0.8") },
};
-- todo: sm-ssc supports Lifts in PaneDisplay; add them?

local rb = Def.ActorFrame{
	Name="PaneDisplay"..Player;
	BeginCommand=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(Player));
	end;
	PlayerJoinedMessageCommand=function(self,param)
		if param.Player == Player then
			self:visible(true);
		end;
	end;
	PlayerUnjoinedMessageCommand=function(self,param)
		if param.Player == Player then
			self:visible(false);
		end;
	end;
};

local yOffset = 16;	-- vertical offset between rows
local fontZoom = 0.475;			-- font zooming
local rv; -- for storing the RadarValues.

-- was _handelgothic 20px
local labelFont  = "_mods small";
local numberFont = "_mods small";

-- pre-runthrough setup of some very important junk:
local Selection; -- either song or course.
local bIsCourseMode = GAMESTATE:IsCourseMode();
local StepsOrTrail;

for idx, cat in pairs(paneCategoryValues) do
	local paneCategory = cat.Category;

	
	
	rb[#rb+1] = LoadActor("icons")..{

		InitCommand=cmd(zoom,0.9;diffusealpha,0;pause;setstate,idx-1;playcommand,"Set");
		OnCommand=cmd(sleep,0.6;sleep,idx/10;linear,0.25;diffusealpha,0.4);
		SetCommand=function(self)
				self:x(0);
				self:y(6);
				if idx-1 >= 3 then
					self:y(40);
					self:x(math.abs(idx-3)*34+17);
				else
					self:x(idx*34);
				end;
	
		end;
};
				
	
	
	rb[#rb+1] = Def.ActorFrame{
	
		

	LoadFont("venacti/_venacti 26px bold diffuse")..{
		Text=cat.Text;
		InitCommand=cmd(diffusealpha,0;horizalign,center;shadowlength,1;zoom,0.3);



		OnCommand=cmd(sleep,0.6;sleep,idx/10;linear,0.25;diffusealpha,1);
		BeginCommand=cmd(playcommand,"Set");
		SetCommand=function(self)
					self:x(0);
					self:y(18);
				

				if idx-1 >= 3 then
					self:y(52);
					self:x(math.abs(idx-3)*34+17);
				else
					self:x(idx*34);
				end;
	end;
	};
		

		
	--values
		LoadFont("venacti/_venacti 26px bold diffuse")..{


			InitCommand=cmd(diffusealpha,0;sleep,0.7;sleep,idx/10;horizalign,center;shadowlength,1;zoom,fontZoom;queuecommand,"Set");
			SetCommand=function(self)
					self:x(0);
					self:y(6);
				

				if idx-1 >= 3 then
					self:y(40);
					self:x(math.abs(idx-3)*34+17);
				else
					self:x(idx*34);
				end;
				

				
				local value = 0;
				self:diffusealpha(0.5);
				if bIsCourseMode then
					Selection = GAMESTATE:GetCurrentCourse();
					StepsOrTrail = GAMESTATE:GetCurrentTrail(Player);
				else
					Selection = GAMESTATE:GetCurrentSong();
					StepsOrTrail = GAMESTATE:GetCurrentSteps(Player);
				end;

				if not Selection then value = 0;
				else
					-- we have a selection.
					-- Make sure there's something to grab values from.
					if not StepsOrTrail then value = 0;
					else
						rv = StepsOrTrail:GetRadarValues(Player);
						value = rv:GetValue(paneCategory);
						if value == 0 then
						self:diffusealpha(0.5);
							else
						self:diffusealpha(1);
						end;
					end;
				end;
				value = value < 0 and "?" or value
				self:settext("0");
				self:settext( value );
			end;
			-- generic song/course changes
			CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
			CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
			-- player based changes
			CurrentStepsP1ChangedMessageCommand=function(self)
				if Player == PLAYER_1 then self:playcommand("Set"); end;
			end;
			CurrentTrailP1ChangedMessageCommand=function(self)
				if Player == PLAYER_1 then self:playcommand("Set"); end;
			end;
			CurrentStepsP2ChangedMessageCommand=function(self)
				if Player == PLAYER_2 then self:playcommand("Set"); end;
			end;
			CurrentTrailP2ChangedMessageCommand=function(self)
				if Player == PLAYER_2 then self:playcommand("Set"); end;
			end;
		};
	};
end;

return rb;