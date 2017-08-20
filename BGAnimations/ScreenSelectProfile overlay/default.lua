function GetLocalProfiles()
	local ret = {};

	for p = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
		local profile=PROFILEMAN:GetLocalProfileFromIndex(p);
		local item = Def.ActorFrame {
--[[ 			Def.Quad {
				InitCommand=cmd(zoomto,200,1;y,40/2);
				OnCommand=cmd(diffuse,Color('Outline'););
			}; --]]
			LoadFont("venacti/_venacti_outline 26px bold diffuse") .. {
				Text=profile:GetDisplayName();
				InitCommand=cmd(shadowlength,1;y,-9;zoom,0.55;maxwidth,300;ztest,true);
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse") .. {
				InitCommand=cmd(shadowlength,1;y,5;zoom,0.4;vertspacing,-8;maxwidth,300;ztest,true;diffuse,0.8,0.8,0.8,1);
				BeginCommand=function(self)
					local numSongsPlayed = profile:GetNumTotalSongsPlayed();
					local s = numSongsPlayed == 1 and "Song" or "Songs";
					-- todo: localize
					self:settext( numSongsPlayed.." "..s.." Played" );
				end;
			};
		};
		table.insert( ret, item );
	end;

	return ret;
end;



function LoadCard(cColor)
	local t = Def.ActorFrame {
		
		--[[LoadActor( THEME:GetPathG("ScreenSelectProfile","CardBackground") ) .. {
			InitCommand=cmd(diffuse,cColor);
		};
		LoadActor( THEME:GetPathG("ScreenSelectProfile","CardFrame") );
		
		
		
			LoadActor("panel")..{
				InitCommand=cmd(zoomx,0.6;zoomy,0.7;y,100;difuse,0.3,0.3,0.3,1);
			};
		]]


		
			LoadActor("panel")..{
				InitCommand=cmd(zoomx,0.64;zoomy,0.615;y,2);
			};
			

		};
	return t
end
function LoadPlayerStuff(Player)
	local ret = {};

	local pn = (Player == PLAYER_1) and 1 or 2;

--[[ 	local t = LoadActor(THEME:GetPathB('', '_frame 3x3'), 'metal', 200, 230) .. {
		Name = 'BigFrame';
	}; --]]
	local t = Def.ActorFrame {
		Name = 'JoinFrame';
		LoadCard(Color('Red'));
--[[ 		Def.Quad {
			InitCommand=cmd(zoomto,200+4,230+4);
			OnCommand=cmd(shadowlength,1;diffuse,color("0,0,0,0.5"));
		};
		Def.Quad {
			InitCommand=cmd(zoomto,200,230);
			OnCommand=cmd(diffuse,Color('Orange');diffusealpha,0.5);
		}; --]]
--[[		LoadActor("press 5x2")..{
			Frames = Sprite.LinearFrames(10,.3);
			InitCommand=cmd(shadowlength,1);
			OnCommand=cmd(zoom,0.5);
		};]]
	};
	table.insert( ret, t );
	
	t = Def.ActorFrame {
		Name = 'press';
		LoadActor("press 5x2")..{
			Frames = Sprite.LinearFrames(10,.3);
			InitCommand=cmd(shadowlength,1);
			OnCommand=cmd(zoom,0.5);
		};
	};
	table.insert( ret, t );
	
	t = Def.ActorFrame {
		Name = 'BigFrame';
		LoadCard(PlayerColor(Player));
	};
	table.insert( ret, t );

--[[ 	t = LoadActor(THEME:GetPathB('', '_frame 3x3'), 'metal', 170, 20) .. {
		Name = 'SmallFrame';
	}; --]]
		t = Def.ActorFrame {
		Name = 'USB';
			LoadActor(THEME:GetPathG("","USB"))..{
				InitCommand=cmd(zoom,0.45;y,10;);
			};
		};
	
		table.insert( ret, t );

	
	t = Def.ActorFrame {
		Name = 'SmallFrame';
--[[ 		Def.Quad {
			InitCommand=cmd(zoomto,170+4,32+4);
			OnCommand=cmd(shadowlength,1);
		}; --]]
		InitCommand=cmd(y,-2);
		--Def.Quad {
		--	InitCommand=cmd(zoomto,200-10,40+2);
		--	OnCommand=cmd(diffuse,Color('Black');diffusealpha,0.5);
		--};
		Def.Quad {
			InitCommand=cmd(zoomto,200-10,40;blend,Blend.Add);
			OnCommand=cmd(diffuse,PlayerColor(Player);fadeleft,0.25;faderight,0.25;glow,color("1,1,1,0.25"));
		};
		Def.Quad {
			InitCommand=cmd(zoomto,200-10,40;y,-40/2+20);
			OnCommand=cmd(diffuse,Color("Black");fadebottom,1;diffusealpha,0.35);
		};
		Def.Quad {
			InitCommand=cmd(zoomto,200-10,1;y,-40/2+1;blend,Blend.Add);
			OnCommand=cmd(diffuse,PlayerColor(Player);glow,color("1,1,1,0.25"));
		};	
	};
	

	
	table.insert( ret, t );

	t = Def.ActorScroller{
		Name = 'Scroller';
		NumItemsToDraw=3;
-- 		InitCommand=cmd(y,-230/2+20;);
		OnCommand=cmd(y,1;SetFastCatchup,true;SetMask,250,60;SetSecondsPerItem,0.15);
		TransformFunction=function(self, offset, itemIndex, numItems)
			local focus = scale(math.abs(offset),0,2,1,0);
			self:visible(false);
			self:y(math.floor( offset*40 ));
-- 			self:zoomy( focus );
-- 			self:z(-math.abs(offset));
-- 			self:zoom(focus);
		end;
		children = GetLocalProfiles();
	};
	table.insert( ret, t );
	
	t = Def.ActorFrame {
		Name = "EffectFrame";
	--[[ 		Def.Quad {
				InitCommand=cmd(y,-230/2;vertalign,top;zoomto,200,8;fadebottom,1);
				OnCommand=cmd(diffuse,Color("Black");diffusealpha,0.25);
			};
			Def.Quad {
				InitCommand=cmd(y,230/2;vertalign,bottom;zoomto,200,8;fadetop,1);
				OnCommand=cmd(diffuse,Color("Black");diffusealpha,0.25);
			}; --]]
	};
	table.insert( ret, t );
--[[ 	t = Def.BitmapText {
		OnCommand = cmd(y,160);
		Name = 'SelectedProfileText';
		Font = "Common Normal";
		Text = 'No profile';
	}; --]]
	
	--display name fora do quadrado
	t = LoadFont("venacti/_venacti_outline 26px bold diffuse") .. {
		Name = 'SelectedProfileText';
		--InitCommand=cmd(y,160;shadowlength,1;diffuse,PlayerColor(Player));
		InitCommand=cmd(y,-25;maxwidth,270;zoom,0.6;shadowlength,1;uppercase,true);
	};
	table.insert( ret, t );

	return ret;
end;

function UpdateInternal3(self, Player)
	local pn = (Player == PLAYER_1) and 1 or 2;
	local frame = self:GetChild(string.format('P%uFrame', pn));
	local scroller = frame:GetChild('Scroller');
	local seltext = frame:GetChild('SelectedProfileText');
	local joinframe = frame:GetChild('JoinFrame');
	local smallframe = frame:GetChild('SmallFrame');
	local bigframe = frame:GetChild('BigFrame');
	local usb = frame:GetChild('USB');
	local press = frame:GetChild('press')
	usb:visible(false);
	
	if GAMESTATE:IsHumanPlayer(Player) then
		frame:visible(true);
		if MEMCARDMAN:GetCardState(Player) == 'MemoryCardState_none' then
			--using profile if any
			joinframe:visible(false);
			smallframe:visible(true);
			bigframe:visible(true);
			seltext:visible(true);
			scroller:visible(true);
			local ind = SCREENMAN:GetTopScreen():GetProfileIndex(Player);
			if ind > 0 then
				scroller:SetDestinationItem(ind-1);
				--seltext:settext(PROFILEMAN:GetLocalProfileFromIndex(ind-1):GetDisplayName());
				seltext:settext("");
			else
				if SCREENMAN:GetTopScreen():SetProfileIndex(Player, 1) then
					scroller:SetDestinationItem(0);
					self:queuecommand('UpdateInternal2');
				else
					press:visible(false);
					joinframe:visible(true);
					smallframe:visible(false);
					bigframe:visible(false);
					scroller:visible(false);
					seltext:settext('No profile');
				end;
			end;
		else
			--using card
			press:visible(false)
			usb:visible(true);
			smallframe:visible(false);
			scroller:visible(false);
			seltext:visible(true);
			seltext:settext(MEMCARDMAN:GetName(Player));
			SCREENMAN:GetTopScreen():SetProfileIndex(Player, 0);
		end;
	else
		joinframe:visible(true);
		scroller:visible(false);
		seltext:visible(false);
		smallframe:visible(false);
		bigframe:visible(false);
	end;
end;

local t = Def.ActorFrame {


	StorageDevicesChangedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	CodeMessageCommand = function(self, params)
		if params.Name == 'Start' or params.Name == 'Center' then
			MESSAGEMAN:Broadcast("StartButton");
			if not GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, -1);
			else
				SCREENMAN:GetTopScreen():Finish();
			end;
		end;
		if params.Name == 'Up' or params.Name == 'Up2' or params.Name == 'DownLeft' then
			if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(params.PlayerNumber);
				if ind > 1 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, ind - 1 ) then
						MESSAGEMAN:Broadcast("DirectionButton");
						self:queuecommand('UpdateInternal2');
					end;
				end;
			end;
		end;
		if params.Name == 'Down' or params.Name == 'Down2' or params.Name == 'DownRight' then
			if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(params.PlayerNumber);
				if ind > 0 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, ind + 1 ) then
						MESSAGEMAN:Broadcast("DirectionButton");
						self:queuecommand('UpdateInternal2');
					end;
				end;
			end;
		end;
		if params.Name == 'Back' then
			--if GAMESTATE:GetNumPlayersEnabled()==0 then
			SCREENMAN:GetTopScreen():Cancel();
			--else
				MESSAGEMAN:Broadcast("BackButton");
			--	SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, -2);
			--end;
		end;
	end;

	PlayerJoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	PlayerUnjoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	OnCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	UpdateInternal2Command=function(self)
		UpdateInternal3(self, PLAYER_1);
		UpdateInternal3(self, PLAYER_2);
	end;

	children = {
	

		
		Def.Quad{
				InitCommand=cmd(diffuse,0,0,0,0.85;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT/1.75;fadetop,1;vertalign,bottom;y,SCREEN_BOTTOM;x,SCREEN_CENTER_X);
		};

	
			Def.Quad{
				InitCommand=cmd(diffuse,0,0,0,0.85;zoomto,SCREEN_WIDTH,30;fadetop,0.05;fadebottom,0.05;y,SCREEN_CENTER_Y+60;x,SCREEN_CENTER_X);
		};
		LoadFont("Common Normal")..{
			Text="WARNING: Silly things happen when you choose the same profile for both players, so, just DON'T.";
			InitCommand=cmd(zoom,0.4;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+60;);
		};

	
	
		Def.ActorFrame {
			Name = 'P1Frame';
			InitCommand=cmd(x,SCREEN_CENTER_X-110;y,SCREEN_CENTER_Y-20);
			OnCommand=cmd(zoom,0;bounceend,0.35;zoom,1);
			OffCommand=cmd(bouncebegin,0.35;zoom,0);
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_1 then
					(cmd(;zoom,1.15;bounceend,0.175;zoom,1.0;))(self);
				end;
			end;
			children = LoadPlayerStuff(PLAYER_1);
		};
		Def.ActorFrame {
			Name = 'P2Frame';
			InitCommand=cmd(x,SCREEN_CENTER_X+110;y,SCREEN_CENTER_Y-20);
			OnCommand=cmd(zoom,0;bounceend,0.35;zoom,1);
			OffCommand=cmd(bouncebegin,0.35;zoom,0);
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_2 then
					(cmd(zoom,1.15;bounceend,0.175;zoom,1.0;))(self);
				end;
			end;
			children = LoadPlayerStuff(PLAYER_2);
		};
		
		-- sounds
		LoadActor( THEME:GetPathS("Common","start") )..{
			StartButtonMessageCommand=cmd(play);
		};
		LoadActor( THEME:GetPathS("Common","cancel") )..{
			BackButtonMessageCommand=cmd(play);
		};
		LoadActor( THEME:GetPathS("Common","value") )..{
			DirectionButtonMessageCommand=cmd(play);
		};
	};




};

return t;
