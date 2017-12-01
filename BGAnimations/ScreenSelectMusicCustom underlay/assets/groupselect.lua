local t = Def.ActorFrame{
	InitCommand=cmd(diffusealpha,0);
	StateChangedMessageCommand=function(self)
		self:stoptweening();
		self:decelerate(0.2);
		if Global.state == "GroupSelect" then 
			self:diffusealpha(1);
		else
			self:diffusealpha(0);
		end;
	end;
}

local originX = SCREEN_CENTER_X;
local originY = -32;
local maxitems = 9;
local itemspacing = 128;
local cursorspacing = 64;
local cursorzoom = 0.425;

local coords = {};
for c=1,maxitems do
	coords[c] = originX + (itemspacing*(c-1)) - (itemspacing * math.floor(maxitems/2));
end


function GroupController(self,param)
	if param.Input == "Prev" and param.Button == "Left" then
		if Global.selection > 1 then 
			Global.selection = Global.selection-1;
		else
			Global.selection = #Global.allgroups;
		end
		MESSAGEMAN:Broadcast("SongGroup",{direction=param.Input}); 
	end

	if param.Input == "Next" and param.Button == "Right" then 
		if Global.selection < #Global.allgroups then 
			Global.selection = Global.selection+1;
		else
			Global.selection = 1;
		end
		MESSAGEMAN:Broadcast("SongGroup",{direction=param.Input}); 
	end;

	if param.Input == "Cancel" or param.Input == "Back" and Global.level == 2 then 
		Global.level = 1; 
		Global.selection = 1; 
		Global.state = "MainMenu"; 
		MESSAGEMAN:Broadcast("StateChanged"); 
		MESSAGEMAN:Broadcast("Return");
	end;
end

--//================================================================

function SetGroupSelection()
	local selection = 1
	local song = Global.song or GAMESTATE:GetCurrentSong();
	local name = song:GetGroupName();
	
	for i=1,#Global.allgroups do
		if name == Global.allgroups[i]["Name"] then return i; end;
	end;
	
	return selection;
end;

--//================================================================

function SelectFolder()
	if Global.songgroup == Global.allgroups[Global.selection]["Name"] then
		Global.level = 1; 
		Global.selection = 1; 
		Global.state = "MainMenu"; 
		MESSAGEMAN:Broadcast("StateChanged");
	else
		
		MESSAGEMAN:Broadcast("FolderChanged"); 
		Global.songgroup = Global.allgroups[Global.selection]["Name"];
		Global.songlist = FilterSongList(SONGMAN:GetSongsInGroup(Global.songgroup));
		MESSAGEMAN:Broadcast("MainMenu");

		Global.p1steps = 1;
		Global.p2steps = 1;
		Global.selection = 1;
	
		Global.selection = 1;
		Global.level = 2;
		Global.state = "MusicWheel";

		Global.song = Global.songlist[Global.selection];
		Global.steps = StepsList(Global.song);
		GAMESTATE:SetPreferredSong(Global.song);

		if Global.p1steps and Global.p1steps > #Global.steps then Global.p1steps = #Global.steps; end
		if Global.p2steps and Global.p2steps > #Global.steps then Global.p2steps = #Global.steps; end

		MESSAGEMAN:Broadcast("BuildMusicList"); 
		MESSAGEMAN:Broadcast("StateChanged"); 
		MESSAGEMAN:Broadcast("MusicWheel", { silent = true });


		SetWheelSteps();
		MESSAGEMAN:Broadcast("StepsChanged", { silent = true });

	end;
end;

--//================================================================

function FindGroupImage(str)
	local songdir = SONGMAN:GetSongGroupBannerPath(str)
	songdir = string.gsub(string.lower(songdir), "banner.png", "");
	local files = FILEMAN:GetDirListing(songdir,false,true);

	for i=1,#files do
		if(string.find(string.lower(files[i]), ".png")) then
			return files[i];
		end;
	end;

	return nil;
end;

--//================================================================

local function ItemIndex(sel, i, num)
	local index = sel + (i-1) - math.floor(maxitems/2)
	while (index < 1) do index = index + num end
	while (index > num) do index = index - num end
	return index
end

--//================================================================

t[#t+1] = Def.Sprite{
	InitCommand=cmd(diffusealpha,0.75;fadebottom,1);
	OnCommand=cmd(playcommand,"ReloadGroups");
	ReloadGroupsMessageCommand=function(self,param)

		local index = Global.selection;
		local img = nil;
		
		if Global.allgroups[Global.selection] then
			img = FindGroupImage(Global.allgroups[Global.selection]["Name"]);
		end;

		if(img) then
			self:Load(img);
		else
			self:Load(nil);
		end;

		self:scaletofit(0,0,SCREEN_WIDTH-192,SCREEN_HEIGHT-192);
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y-48);
	end
};


for i=1,maxitems do 

	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(x,originX;y,SCREEN_BOTTOM-140;diffusealpha,0);
		OnCommand=cmd(playcommand,"SongGroup");
		SongGroupMessageCommand=function(self,param)

			self:stoptweening();
			local reload = false;

			if param and param.direction == "Prev" then i = i+1; end;
			if param and param.direction == "Next" then i = i-1; end;

			    if i < 1 then i = maxitems; 
			elseif i > maxitems then i = 1;
			else self:decelerate(0.175); end;
			
			if i == 1 or i == maxitems then 
				self:diffusealpha(0);
				reload = true;
			else
				self:diffusealpha(1);
			end;

			self:x(coords[i]);
			MESSAGEMAN:Broadcast("ReloadGroups", { Reload = reload });
		end;

		StateChangedMessageCommand=function(self)
			if Global.state == "GroupSelect" then
				MESSAGEMAN:Broadcast("ReloadGroups");
			end
		end;

		-- SHADOW
		LoadActor(THEME:GetPathG("","glow"))..{
			InitCommand=cmd(zoomto,96,32;diffuse,0.1,0.1,0.1,0.33;y,20);
		};
			
		-- FOLDER IMAGE
		LoadActor(THEME:GetPathG("","folder"))..{
			InitCommand=cmd(zoom,2/3;y,-8;diffuse,0.66,0.66,0.66,1;diffusebottomedge,0.75,0.75,0.75,2/3);
			OnCommand=cmd(playcommand,"ReloadGroups");
		};

		-- FOLDER NAME
		Def.BitmapText{
			Font = Fonts.groupselect["Name"];
			InitCommand=cmd(zoom,0.42;diffusealpha,1;strokecolor,0.175,0.175,0.175,0.85;y,8;
				maxheight,128;maxwidth,(itemspacing-24)/self:GetZoom();wrapwidthpixels,(itemspacing-24)/self:GetZoom();vertspacing,-4;vertalign,bottom);
			OnCommand=cmd(playcommand,"ReloadGroups");
			ReloadGroupsMessageCommand=function(self)
				local index = ItemIndex(Global.selection, i, #Global.allgroups);
				self:settext(Global.allgroups[index]["Name"]); 
			end;
		};
		
		-- NUMSONGS
		Def.BitmapText{
			Font = Fonts.groupselect["Songs"];
			InitCommand=cmd(zoom,0.38;diffuse,HighlightColor();diffusealpha,1;strokecolor,BoostColor(HighlightColor(),0.25);y,16);
			OnCommand=cmd(playcommand,"ReloadGroups");
			ReloadGroupsMessageCommand=function(self,param)
				local index = ItemIndex(Global.selection, i, #Global.allgroups);
				local numsongs = Global.allgroups[index]["Count"];
				if numsongs == 1 then 
					self:settext(numsongs.." song"); 
				else 
					self:settext(numsongs.." songs"); 
				end;


			end;
		};
	};

end;

--//================================================================

	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(x,originX;y,SCREEN_BOTTOM-72);
		StateChangedMessageCommand=function(self)
			self:stoptweening();
			if Global.state == "GroupSelect" then 
				self:diffusealpha(1);
			else
				self:diffusealpha(0);
			end;
		end;


			LoadActor(THEME:GetPathG("ScrollBar","middle"))..{
				InitCommand=cmd(y,5;rotationz,90;zoomto,6,80;diffusealpha,0.6;queuecommand,"StateChanged");
			};
			
			LoadActor(THEME:GetPathG("ScrollBar","TickThumb"))..{
				InitCommand=cmd(y,5;diffusealpha,1;zoom,0.5);
				OnCommand=cmd(playcommand,"StateChanged");
				SongGroupMessageCommand=function(self)
					self:stoptweening();
					if Global.state == "GroupSelect" then 
						self:decelerate(0.15);
					end;
					local index = Global.selection 
					self:x((((index-1)/(#Global.allgroups-1))*80)-40);
				end;

				StateChangedMessageCommand=function(self)
					local index = Global.selection 
					self:x((((index-1)/(#Global.allgroups-1))*80)-40);
					self:playcommand("SongGroup")
				end;

			};
		
			Def.ActorFrame{
			Name = "Normal";
				LoadActor(THEME:GetPathG("","miniarrow"))..{
					InitCommand=cmd(animate,false;x,-cursorspacing;zoom,cursorzoom;diffuse,0.6,0.6,0.6,0.95;shadowlengthy,1);
				},	
				LoadActor(THEME:GetPathG("","miniarrow"))..{
					InitCommand=cmd(animate,false;x,cursorspacing;zoom,cursorzoom;zoomx,-cursorzoom;diffuse,0.6,0.6,0.6,0.95;shadowlengthy,1);
				},
			},

			Def.ActorFrame{
			Name = "Glow";
				LoadActor(THEME:GetPathG("","miniarrow"))..{
					InitCommand=cmd(animate,false;setstate,1;x,-cursorspacing;zoom,cursorzoom;diffusealpha,0;blend,"BlendMode_Add");
					GlowCommand=cmd(stoptweening;diffusealpha,1;decelerate,0.3;diffusealpha,0);
					SongGroupMessageCommand=function(self,param)
						if param and param.direction == "Prev" then
							self:playcommand("Glow");
						end;
					end;
				},	
				LoadActor(THEME:GetPathG("","miniarrow"))..{
					InitCommand=cmd(animate,false;setstate,1;x,cursorspacing;zoom,cursorzoom;zoomx,-cursorzoom;diffusealpha,0;blend,"BlendMode_Add");
					GlowCommand=cmd(stoptweening;diffusealpha,1;decelerate,0.3;diffusealpha,0);
					SongGroupMessageCommand=function(self,param)
						if param and param.direction == "Next" then
							self:playcommand("Glow");
						end;
					end;
				},
			},

			Def.BitmapText{
				Font = Fonts.groupselect["Folders"];
				InitCommand=cmd(y,-8;zoomx,0.3;zoomy,0.3;strokecolor,0.175,0.175,0.175,0.75);
				StateChangedMessageCommand=cmd(playcommand,"SongGroup");
				SongGroupMessageCommand=function(self)
					local a = string.format("%0"..string.len(#Global.allgroups).."d",Global.selection);
					local b = #Global.allgroups;
					self:settext(a .. "  /  " .. b);
				end;
			};




	};



-- QUADS BG
local bg = Def.ActorFrame{
    InitCommand=cmd(CenterX;y,SCREEN_CENTER_Y-10.5;diffusealpha,0);
    StateChangedMessageCommand=function(self)
        self:stoptweening();
        self:decelerate(0.2);
        self:diffusealpha(Global.state == "GroupSelect" and 1 or 0);
    end;


    LoadActor(THEME:GetPathG("","_pattern"))..{
        InitCommand=cmd(zoomto,_screen.w,_screen.h;blend,Blend.Add;
            diffuse,BoostColor(HighlightColor(0.5),0.125);diffusebottomedge,0.1,0.1,0.1,0;cropbottom,1/3;
                customtexturerect,0,0,_screen.w / 384 * 2,_screen.h / 384 * 2;texcoordvelocity,0,-0.075);
    },
};



return Def.ActorFrame{ bg, t }