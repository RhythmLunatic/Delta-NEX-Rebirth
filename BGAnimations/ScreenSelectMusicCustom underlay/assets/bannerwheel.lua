local wheelspacing = 128;
local maxitems = 15;
local tweenSpeed = 0.22

local path;

local coords = {};
local selfcoords = {};

local originX = SCREEN_CENTER_X;
local originY = SCREEN_CENTER_Y+176;

local min = 9999999;
local max = 0;

local minIndex = 1;
local maxIndex = 1;

local reload = false;
local offset = 1;

local cursorspacing = 72;
local cursorzoom = 0.5;

for k=1,maxitems do
	coords[k] = originX - ((k*-wheelspacing) + (math.ceil(maxitems/2)*wheelspacing));
end;

selfcoords = coords;

--//================================================================

function WheelController(self,param)
	if param.Input == "Prev" and param.Button == "Left" then 
		if(Global.selection>1) then
			Global.selection = Global.selection-1;
		else
			Global.selection = #Global.songlist;
		end
		 
		Global.song = Global.songlist[Global.selection]; 
		Global.steps = FilterSteps(Global.song) 
		MESSAGEMAN:Broadcast("MusicWheel",{Direction="Prev",Anim=true}); 
		MESSAGEMAN:Broadcast("StepsChanged"); 
	end

	if param.Input == "Next" and param.Button == "Right" then 
		if(Global.selection < #Global.songlist) then
			Global.selection = Global.selection+1;
		else
			Global.selection = 1;
		end
		 
		Global.song = Global.songlist[Global.selection]; 
		Global.steps = FilterSteps(Global.song) 
		MESSAGEMAN:Broadcast("MusicWheel",{Direction="Next",Anim=true}); 
		MESSAGEMAN:Broadcast("StepsChanged"); 
	end;

	if param.Input == "Cancel" or param.Input == "Back" and Global.level == 2 then 
		Global.level = 1; 
		Global.selection = 2; 
		Global.state = "MainMenu";  
		MESSAGEMAN:Broadcast("StateChanged"); 
		MESSAGEMAN:Broadcast("Return");
	end;
end;

--//================================================================

function SelectSong()
	Global.prevstate = "MusicWheel"
	Global.selection = 3;
	Global.state = "SelectSteps";
	MESSAGEMAN:Broadcast("SongSelected"); 
	MESSAGEMAN:Broadcast("StateChanged"); 
	MESSAGEMAN:Broadcast("MainMenu"); 
end;

--//================================================================

function LoadBanner(self,item)
	local path;

	--self:Load(nil);
	path = Global.songlist[item]:GetJacketPath(); 
	if path ~= nil --[[and FILEMAN:DoesFileExist(path)]] then
		self:Load(path)
	else

		path = Global.songlist[item]:GetBannerPath(); 
		if path ~= nil --[[and FILEMAN:DoesFileExist(path)]] then
			self:LoadFromCachedBanner(path)
			--self:Load(path)
		else
			self:Load(THEME:GetPathG("Common fallback","banner"));	
			--self:Load(THEME:GetPathG("Common fallback","banner"));
		end;

	end;
end;

--//================================================================

local function AdjustBanner(self)
	self:cropleft(0);
	self:cropright(0);
	self:croptop(0);
	self:cropbottom(0);

	local ratio = self:GetWidth()/self:GetHeight();
	local adjust;

	if ratio <= 1 then
		adjust = ((self:GetHeight()*1.5) - (self:GetWidth())) / (self:GetHeight()*1.5) / 2;
		self:croptop(adjust);
		self:cropbottom(adjust);
		self:setsize(105,105);
	elseif ratio <= 1.5 then 
		self:setsize(105,70);
	else
		adjust = ((self:GetWidth() - (self:GetHeight()*1.5)) / self:GetWidth()) / 2;
		self:cropleft(adjust);
		self:cropright(adjust);
		self:setsize(ratio*70,70);
	end
end;

--//================================================================

local t = Def.ActorFrame{
		InitCommand=cmd(fov,60*((SCREEN_WIDTH/SCREEN_HEIGHT)/(4/3)*0.9333);vanishpoint,originX,originY-74);
		BuildMusicListMessageCommand=function(self)
			offset = Global.selection;

			for k=1,maxitems do
				coords[k] = originX - ((k*-wheelspacing) + (math.ceil(maxitems/2)*wheelspacing));
			end;

			selfcoords = coords;
			minIndex = 1;
			maxIndex = 15;

			GetWheelSteps();
			
			--steps ok
			MESSAGEMAN:Broadcast("Reload",{Reload=true});
			MESSAGEMAN:Broadcast("StepsChanged");
		end;

		StateChangedMessageCommand=function(self)
			self:stoptweening();
			self:decelerate(0.2);
			if Global.state == "GroupSelect" then 
				self:diffusealpha(0);
			else 
				self:diffusealpha(1);
			end; 
		end;

		MusicWheelMessageCommand=function(self,param)
			SetWheelSteps();

			if param then
				if param.Direction == "Prev" then
					table.insert(selfcoords,selfcoords[1])
					table.remove(selfcoords,1)
					offset = offset-1;
				end

				if param.Direction == "Next" then
					table.insert(selfcoords,1,selfcoords[maxitems])
					table.remove(selfcoords,#selfcoords)
					offset = offset+1;
				end
			end
			
			while offset > #Global.songlist do
				offset = 1;
			end;

			while offset < 1 do
				offset = #Global.songlist;
			end;
			
			min = #Global.songlist;
			max = 0;

			minIndex = 999999;
			maxIndex = 1;

			for i=1,maxitems do
				if (selfcoords[i] < min) then
					min = selfcoords[i];
					minIndex = i;
				end
				if (selfcoords[i] > max) then 
					max = selfcoords[i];
					maxIndex = i;
				end
			end

			MESSAGEMAN:Broadcast("Reload"); 
			MESSAGEMAN:Broadcast("Tween", { silent = param.silent });
			
		end;
};

--//========== 
--//  ITEMS
--//==========


for i=1,maxitems do

		t[#t+1] = Def.ActorFrame{
			Name = "Item"..tostring(i);
			InitCommand=cmd(vertalign,bottom;x,selfcoords[i];y,originY-3;visible,false);
			BuildMusicListMessageCommand=function(self,param) 
				self:stoptweening();
				self:x(coords[i]);
				local tilt = (coords[i]-SCREEN_CENTER_X)/320;
				self:z(math.abs(tilt)*-70);
				self:rotationy(clamp(tilt*60,-90,90));

				if param and param.first then
					local dist = math.abs((self:GetX()-SCREEN_CENTER_X)/3000);
					self:zoomx(0);
					self:diffusealpha(0);
					self:visible(true);
					self:sleep(0.15);
					self:decelerate(0.1+dist);
					self:diffusealpha(1);
					self:zoomx(1);
				end;
			end;

            StateChangedMessageCommand=cmd(queuecommand,"Tween");
			TweenMessageCommand=function(self,param)
				self:stoptweening();
				if i ~= minIndex and i ~= maxIndex and not param.silent then
					self:decelerate(tweenSpeed);
				end;

                local tilt = (selfcoords[i]-SCREEN_CENTER_X)/320;
				self:x(selfcoords[i]);
				self:z(math.abs(tilt)*-70);
				self:rotationy(clamp(tilt*60,-90,90));
			end;

			--//========== 
			--//  REFLECTION
			--//==========

			Def.ActorFrameTexture{
			    --Name = "BannerReflection"..i;
			    InitCommand=function(self)
			        self:SetTextureName("BannerReflection"..i);
			        self:x(62);
			        self:SetWidth(124);
			        self:SetHeight(80);
			        self:EnableFloat(false);
			        self:EnableAlphaBuffer(true);
			        self:EnableDepthBuffer(true);
			        self:Create();
			    end;

			    OnCommand=cmd(y,999);

					Def.ActorProxy{
						Name = "BannerProxy"..i;
						InitCommand=cmd(x,62;y,7);
						OnCommand=cmd(SetTarget,self:GetParent():GetParent():GetChild("Banner"..i);zoomy,-1);
					};

					Def.ActorProxy{
						Name = "FrameProxy"..i;
						InitCommand=cmd(x,62;y,7);
						OnCommand=cmd(SetTarget,self:GetParent():GetParent():GetChild("Frame"..i);zoomy,-1);
					};

			};

		    Def.Sprite{
		        Name = "ReflectionSprite"..i;
		        Texture = "BannerReflection"..i;
		        InitCommand=function(self)
		        	self:diffuse(0.75,0.75,0.75,0.75);
		        	self:zoomto(124,80);
		        	self:y(-1);
		        	self:vertalign(top);
		        	self:fadebottom(1);
		        	self:cropbottom(0.5);
		        	self:zoomy(0.925);
		        	self:blend("BlendMode_Add");
		        end;
		    };


			--//========== 
			--//  BANNER
			--//==========

			Def.Banner{
				Name = "Banner"..i;
				InitCommand=cmd(y,-34);
				TweenMessageCommand=function(self,param)
					
					self:stoptweening();
					AdjustBanner(self);

					if i ~= minIndex and i ~= maxIndex then
						self:decelerate(tweenSpeed);
					end;

					if Global.state ~= "MusicWheel" then 
						self:diffuse(0.5,0.5,0.5,1); 
					else 
						self:diffuse(1,1,1,1);
					end; 

				end;

				ReloadMessageCommand=function(self,param)
					local item;

					if i == minIndex then
						item = offset-math.floor(maxitems/2)
						reload = true;
					elseif i == maxIndex then
						item = offset+math.floor(maxitems/2)
						reload = true;
					else
						item = offset-math.ceil(maxitems/2)+i
						reload = false;
						if param then 
							reload = param.Reload; 
						end;
					end

					while item > #Global.songlist do
						item = item%#Global.songlist
					end

					while item < 1 do
						item = #Global.songlist-math.abs(item)
					end

					if Global.songlist[item] and reload then
						LoadBanner(self,item);
						AdjustBanner(self);
					end;

				end;
			};

			--//========== 
			--//  FRAME
			--//==========

			LoadActor(THEME:GetPathG("","WheelItemFrame"))..{
				Name = "Frame"..i;
				InitCommand=cmd(zoomto,124,80;vertalign,bottom;y,7);
				BuildMusicListMessageCommand=cmd(playcommand,"Tween");
				StateChangedMessageCommand=cmd(playcommand,"Tween");
				TweenMessageCommand=function(self,param)
		
					self:stoptweening();		

					if i ~= minIndex and i ~= maxIndex then
						self:decelerate(tweenSpeed);
					end

					if Global.state~="MusicWheel" then 
						self:diffuse(0.5,0.5,0.5,1); 
					else 
						self:diffuse(1,1,1,1);
					end; 

				end;
			};
			
	};

end;

-- cover
t[#t+1] = LoadActor(THEME:GetPathG("","bg"))..{
	InitCommand=cmd(Center;croptop,0.475;fadetop,0.275;diffuse,Global.bgcolor;diffusealpha,0);
	StateChangedMessageCommand=function(self)
		self:stoptweening();
		self:decelerate(0.2);
		if Global.state == "GroupSelect" or Global.state == "SelectSteps" or Global.state == "HighScores" then
			self:diffusealpha(0.925);
		else
			self:diffusealpha(0);
		end
	end;
};

return t
