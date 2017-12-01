local time;
local bpm;

local display_fulltitle

local display_title;
local display_subtitle;
local display_artist;

local translit_fulltitle

local translit_title;
local translit_subtitle;
local translit_artist;

local t = Def.ActorFrame{
	OnCommand=cmd(stoptweening;diffusealpha,0;sleep,0.5;linear,0.2;diffusealpha,1;playcommand,"MusicWheel");
	MusicWheelMessageCommand=function(self)

		--time
		local total = Global.song:MusicLengthSeconds();
		local minutes = math.floor(total/60)
		local seconds = math.floor(total%60);
		if seconds < 10 then
			seconds = "0"..seconds;
		end;

		time = minutes..":"..seconds;

		--bpm
		local bpm1 = math.ceil(math.min(Global.song:GetDisplayBpms()[1],Global.song:GetDisplayBpms()[2]));
		local bpm2 = math.ceil(math.max(Global.song:GetDisplayBpms()[1],Global.song:GetDisplayBpms()[2]));
	
		if Global.song:IsDisplayBpmRandom() then 
			bpm = "BPM ???";
		else
			if bpm1 == bpm2 then
				bpm = "BPM "..bpm1;
			else
				bpm = "BPM "..bpm1.." ~ "..bpm2;
			end
		end

		display_fulltitle = Global.song:GetDisplayFullTitle();
		display_title = Global.song:GetDisplayMainTitle();
		display_subtitle = Global.song:GetDisplaySubTitle();
		display_artist = Global.song:GetDisplayArtist();
		translit_fulltitle = Global.song:GetTranslitFullTitle();
		translit_title = Global.song:GetTranslitMainTitle();
		translit_subtitle = Global.song:GetTranslitSubTitle();
		translit_artist = Global.song:GetTranslitArtist();

		MESSAGEMAN:Broadcast("SongInformation");

	end;

	StateChangedMessageCommand=function(self)
		self:visible(Global.state ~= "GroupSelect");
	end
}

local originX = SCREEN_CENTER_X;
local originY = SCREEN_CENTER_Y+53;

local titlezoom = 0.75;
local artistzoom = 0.53;
local subzoom = 0.475;

local dim = 0.33;
local spacing = 272;
local animlength = 0.4;

local titlemaxwidth = 460;

--// LENGTH =================
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,originX-spacing-4;y,originY+1);

	Def.BitmapText{
		Font = Fonts.information["Main"];
		InitCommand=cmd(horizalign,left;x,-1;y,-1;vertalign,top;zoom,artistzoom;diffuse,BoostColor(HighlightColor(),0.25);
			strokecolor,BoostColor(HighlightColor(),0.25);shadowcolor,BoostColor(HighlightColor(),0.25);shadowlengthx,1.75;shadowlengthy,1.75);
		SongInformationMessageCommand=function(self)
			self:settext(time);
		end;
	},

	Def.BitmapText{
		Font = Fonts.information["Main"];
		InitCommand=cmd(horizalign,left;vertalign,top;zoom,artistzoom;diffuse,BoostColor(HighlightColor(),0.25);
			strokecolor,BoostColor(HighlightColor(),0.25);shadowcolor,BoostColor(HighlightColor(),0.25);shadowlengthx,1.2;shadowlengthy,1.2);
		SongInformationMessageCommand=function(self)
		self:settext(time);
		end;
	},

	Def.BitmapText{
		Font = Fonts.information["Main"];
		InitCommand=cmd(horizalign,left;x,-1;y,-1;vertalign,top;zoom,artistzoom;diffuse,BoostColor(HighlightColor(),1.2);
			strokecolor,BoostColor(HighlightColor(),0.25);wrapwidthpixels,400/self:GetZoom();vertspacing,-16);
		SongInformationMessageCommand=function(self)
		self:settext(time);
		end;
	}
};




--// BPM =================
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,originX-spacing-6;y,originY-4);

	Def.BitmapText{
		Font = Fonts.information["Main"];
		InitCommand=cmd(horizalign,left;x,-1;y,-1;vertalign,bottom;zoom,artistzoom;diffuse,0.25,0.25,0.25,1;strokecolor,0.25,0.25,0.25,1;
			shadowcolor,0.25,0.25,0.25,1;shadowlengthx,1.2;shadowlengthy,1.2;wrapwidthpixels,400/self:GetZoom();vertspacing,-24);
		SongInformationMessageCommand=function(self)
			self:settext(bpm);
		end;
	},

	Def.BitmapText{
		Font = Fonts.information["Main"];
		InitCommand=cmd(horizalign,left;vertalign,bottom;zoom,artistzoom;diffuse,0.25,0.25,0.25,1;strokecolor,0.25,0.25,0.25,1;
			shadowcolor,0.25,0.25,0.25,1;shadowlengthx,1.2;shadowlengthy,1.2;wrapwidthpixels,400/self:GetZoom();vertspacing,-24);
		SongInformationMessageCommand=function(self)
			self:settext(bpm);
		end;
	},

	Def.BitmapText{
		Font = Fonts.information["Main"];
		InitCommand=cmd(horizalign,left;x,-1;y,-1;vertalign,bottom;zoom,artistzoom;diffusealpha,1;strokecolor,0.25,0.25,0.25,1;wrapwidthpixels,400/self:GetZoom();vertspacing,-24);
		SongInformationMessageCommand=function(self)
			self:settext(bpm);
		end;
	}

};



--// TITLE =================
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,originX+spacing+7;y,originY-7;zoomx,0.98);

	Def.BitmapText{
		Font = Fonts.information["Main"];
		InitCommand=cmd(horizalign,right;vertalign,bottom;x,-1;y,-1;zoom,titlezoom;diffuse,0.25,0.25,0.25,1;strokecolor,0.25,0.25,0.25,1;
			maxwidth,titlemaxwidth/self:GetZoom();wrapwidthpixels,titlemaxwidth/self:GetZoom();vertspacing,-2;shadowcolor,0.25,0.25,0.25,0.75;shadowlengthx,2.5;shadowlengthy,2.5);
		SongInformationMessageCommand=function(self)
			self:settext(display_fulltitle,translit_fulltitle);
		end;
	},

	Def.BitmapText{
		Font = Fonts.information["Main"];
		InitCommand=cmd(horizalign,right;vertalign,bottom;zoom,titlezoom;diffuse,0.3,0.25,0.25,1;strokecolor,0.25,0.25,0.25,1;
			maxwidth,titlemaxwidth/self:GetZoom();wrapwidthpixels,titlemaxwidth/self:GetZoom();vertspacing,-2;shadowcolor,0.25,0.25,0.25,0.8;shadowlengthx,1.2;shadowlengthy,1.2);
		SongInformationMessageCommand=function(self)
			self:settext(display_fulltitle,translit_fulltitle);
		end;
	},

	Def.BitmapText{
		Font = Fonts.information["Main"];
		InitCommand=cmd(horizalign,right;x,-1;y,-1;vertalign,bottom;zoom,titlezoom;strokecolor,0.275,0.275,0.275,1;
			maxwidth,titlemaxwidth/self:GetZoom();wrapwidthpixels,titlemaxwidth/self:GetZoom();vertspacing,-2);
		SongInformationMessageCommand=function(self)
			self:settext(display_fulltitle,translit_fulltitle);

			local index;

			if self:GetText() == display_fulltitle then
				index = string.utf8len(display_title)
			elseif self:GetText() == translit_fulltitle then
				index = string.utf8len(translit_title)
			end;
			
			self:AddAttribute(
				index,{
				Length = -1;
				--Diffuse = {1,0.925,0.5,1}; --fuck SAO
				Diffuse = BoostColor({1,1,1,1},0.7);
				}
			);

		end;
	},

};

--// ARTIST =================
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,originX+spacing+7;y,originY;zoomx,0.975);

		Def.BitmapText{
			Font = Fonts.information["Main"];
			InitCommand=cmd(horizalign,right;x,-1;y,-1;vertalign,top;zoom,artistzoom;diffuse,BoostColor(HighlightColor(),0.25);strokecolor,BoostColor(HighlightColor(),0.25);
				maxwidth,500/self:GetZoom();vertspacing,-16;shadowcolor,BoostColor(HighlightColor(),0.25);shadowlengthx,2.2;shadowlengthy,2.2);
			SongInformationMessageCommand=function(self)
				self:settext(display_artist,translit_artist);
			end;
		},

		Def.BitmapText{
			Font = Fonts.information["Main"];
			InitCommand=cmd(horizalign,right;vertalign,top;zoom,artistzoom;diffuse,BoostColor(HighlightColor(),0.25);strokecolor,BoostColor(HighlightColor(),0.25);
				maxwidth,500/self:GetZoom();vertspacing,-16;shadowcolor,BoostColor(HighlightColor(),0.25);shadowlengthx,1.2;shadowlengthy,1.2);
			SongInformationMessageCommand=function(self)
				self:settext(display_artist,translit_artist);
			end;
		},

		Def.BitmapText{
			Font = Fonts.information["Main"];
			InitCommand=cmd(horizalign,right;x,-1;y,-1;vertalign,top;zoom,artistzoom;diffuse,BoostColor(HighlightColor(),1.0);strokecolor,BoostColor(HighlightColor(),0.3);
				maxwidth,500/self:GetZoom();vertspacing,-16;shadowcolor,BoostColor(HighlightColor(),0.25);shadowlengthx,1;shadowlengthy,1);
			SongInformationMessageCommand=function(self)
				self:settext(display_artist,translit_artist);
			end;
		},
};



return t