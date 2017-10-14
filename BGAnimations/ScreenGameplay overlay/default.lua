local t = Def.ActorFrame{}

local newBPS;
local oldBPS;

--[[t[#t+1] = Def.ActorFrame{
	Def.Quad {
	InitCommand=cmd(visible,not BGA;Center;diffuse,color("0.15,0.15,0.15,1");zoomto,SCREEN_WIDTH,SCREEN_HEIGHT);
	}
}



t[#t+1] = LoadActor(THEME:GetPathB("ScreenWithMenuElements","background")) .. {
	--InitCommand=cmd(visible,not BGA;Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT);
}; 
]]

-- DECORATIONS ////////////////////////



-- Left Hex Corner Decoration
t[#t+1] = LoadActor("decoration_corner") .. {
	InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
	OnCommand=cmd(horizalign,left;x,SCREEN_LEFT;vertalign,top;y,SCREEN_TOP;zoomy,0.4;zoomx,0.6;diffusealpha,0.3;blend,Blend.Add); 
}; 

-- Right Hex Corner Decoration
t[#t+1] = LoadActor("decoration_corner") .. {
	InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
	OnCommand=cmd(horizalign,left;x,SCREEN_RIGHT;vertalign,top;y,SCREEN_TOP;zoomy,0.4;;zoomx,-0.6;diffusealpha,0.3;blend,Blend.Add); 
}; 


-- WAVY LINE (thanks AJ) ////////////////////////


--P1
t[#t+1] = LoadActor("hot_lores") .. {
	OnCommand=cmd(diffusealpha,0;visible,GAMESTATE:IsHumanPlayer(PLAYER_1);horizalign,left;x,SCREEN_LEFT+18;vertalign,top;y,SCREEN_TOP+16;zoomtowidth,SCREEN_WIDTH/2-26;texcoordvelocity,0.1,0;queuecommand,"Begin");
	BeginCommand=function(self)
		local style = GAMESTATE:GetCurrentStyle();
		if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
			self:visible(false);
		else
		local move = GAMESTATE:GetSongBPS()/2
			if GAMESTATE:GetSongFreeze() then 
				move = 0; 
			end
				self:texcoordvelocity(move,0);
				self:sleep(0.03);
				self:queuecommand("Begin");
		end;
	end;
	
	
	
	LifeChangedMessageCommand=function(self,params)
		if params.Player == PLAYER_1 then
			local lifeP1=params.LifeMeter:GetLife();
			if lifeP1>=THEME:GetMetric("LifeMeterBar", "HotValue") then
					self:diffusealpha(0.5);
				else
					self:diffusealpha(0);
				end;
			end;
	end;	
};

--P2
t[#t+1] = LoadActor("hot_lores") .. {
	OnCommand=cmd(diffusealpha,0;visible,GAMESTATE:IsHumanPlayer(PLAYER_2);horizalign,left;x,SCREEN_RIGHT-18;vertalign,top;y,SCREEN_TOP+16;zoomtowidth,(SCREEN_WIDTH/2-26)*-1;texcoordvelocity,0.1,0;queuecommand,"Begin");
	BeginCommand=function(self)
		local style = GAMESTATE:GetCurrentStyle();
		if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
			self:visible(false);
		else
		local move = GAMESTATE:GetSongBPS()/2
			if GAMESTATE:GetSongFreeze() then 
				move = 0; 
			end
				self:texcoordvelocity(move,0);
				self:sleep(0.05);
				self:queuecommand("Begin");
		end;
	end;
	
	
	LifeChangedMessageCommand=function(self,params)
		if params.Player == PLAYER_2 then
			local lifeP2=params.LifeMeter:GetLife();
			if lifeP2>=THEME:GetMetric("LifeMeterBar", "HotValue") then
					self:diffusealpha(0.5);
				else
					self:diffusealpha(0);
				end;
			end;
	end;	
};

--Double
--customtexturerect,0,0,[PixelsToCoverWidth]/[ImageWidth],[PixelsToCoverHeight]/[ImageHeight]
--I said that I was gonna write it down. thx midi

t[#t+1] = LoadActor("hot_lores") .. {
	OnCommand=cmd(diffusealpha,0;horizalign,left;x,SCREEN_LEFT+18;vertalign,top;y,SCREEN_TOP+16;zoomtowidth,SCREEN_WIDTH-36;customtexturerect,0,0,600/(SCREEN_WIDTH-36),1;;queuecommand,"Begin");
	BeginCommand=function(self)
		local style = GAMESTATE:GetCurrentStyle();
		if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
		local move = GAMESTATE:GetSongBPS()/2
			if GAMESTATE:GetSongFreeze() then 
				move = 0; 
			end
		self:texcoordvelocity(move,0);
		self:sleep(0.05);
		self:queuecommand("Begin");
		else
		self:visible(false);
	end;
	end;

	
	LifeChangedMessageCommand=function(self,params)
			local life=params.LifeMeter:GetLife();
			if life>=THEME:GetMetric("LifeMeterBar", "HotValue") then
					self:diffusealpha(0.5);
				else
					self:diffusealpha(0);
				end;
	end;	
};


-- DANGER ///////////////////////
	

--DANGER P1 single
t[#t+1] = LoadActor("danger") .. {
	InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);horizalign,left;x,SCREEN_LEFT+18;vertalign,top;y,SCREEN_TOP+16;zoomtowidth,SCREEN_WIDTH/2-26;zoomy,0.5); 
	OnCommand=cmd(effectclock,"bgm";diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF66"));
	LifeChangedMessageCommand=function(self,params)		
		if params.Player == PLAYER_1 then
		local lifeP1 = params.LifeMeter:GetLife();
			if lifeP1 <= THEME:GetMetric("LifeMeterBar", "DangerThreshold") then
			
					local style = GAMESTATE:GetCurrentStyle();
					
						if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
							self:diffusealpha(0);
						else
							self:diffusealpha(1);
						end;
					else
				
				self:diffusealpha(0);
				
			end;	
		end;
end;



};

--DANGER P2 single
t[#t+1] = LoadActor("danger") .. {
	InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);horizalign,right;x,SCREEN_RIGHT-18;vertalign,top;y,SCREEN_TOP+16;zoomtowidth,SCREEN_WIDTH/2-26;zoomy,0.5); 
	OnCommand=cmd(effectclock,"bgm";diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF66"));
	
	LifeChangedMessageCommand=function(self,params)		
		if params.Player == PLAYER_2 then
		local lifeP1 = params.LifeMeter:GetLife();
			if lifeP1 <= THEME:GetMetric("LifeMeterBar", "DangerThreshold") then
			
					local style = GAMESTATE:GetCurrentStyle();
					
						if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
							self:diffusealpha(0);
						else
							self:diffusealpha(1);
						end;
					else
				
				self:diffusealpha(0);
				
			end;	
		end;
end;

	HealthStateChangedMessageCommand=function(self,params)
		 local failure = (params.HealthState);
		 if params.PlayerNumber == PLAYER_2 then
			if failure=="HealthState_Dead" then  
				self:visible(false)
			end;
		 end;
    end;
};

--DANGER double
t[#t+1] = LoadActor("danger") .. {
	InitCommand=cmd(visible,false;horizalign,center;x,SCREEN_CENTER_X;vertalign,top;y,SCREEN_TOP+16;zoomtowidth,SCREEN_WIDTH-36;zoomy,0.5); 
	OnCommand=cmd(effectclock,"bgm";diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF66"));
		
	HealthStateChangedMessageCommand=function(self,params)
			if params.HealthState == 'HealthState_Dead' then
			self:visible(false);
		end;
	end;
	
	LifeChangedMessageCommand=function(self,params)
		local life = params.LifeMeter:GetLife();
		local style = GAMESTATE:GetCurrentStyle();
		if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
			if life <= THEME:GetMetric("LifeMeterBar", "DangerThreshold") then
				self:visible(true);
				else
				self:visible(false);
				end;
		end;
	end;
};



-- METERS ////////////////////////





---basemeter masked P1
t[#t+1] = LoadActor("basemeter") .. {	
		InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);horizalign,left;x,SCREEN_LEFT+18;valign,0.5;y,SCREEN_TOP+41;zoomy,0.5;blend,Blend.Add); 
		

		
		OnCommand=cmd(bounce;effectmagnitude,-40,0,0;effectclock,"bgm";effecttiming,1,0,0,0;);
		LifeChangedMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then	
				local style = GAMESTATE:GetCurrentStyle();		
				local lifeP1 = params.LifeMeter:GetLife();
							if GAMESTATE:IsHumanPlayer(PLAYER_1)==true then
								if lifeP1==0 then
									self:visible(false);
								else
									
									if lifeP1==1 then
										self:effectmagnitude(0,0,0);
									else
										self:effectmagnitude(-40,0,0);
									end;
							
									self:visible(true);
								end
							end
							if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
								self:zoomtowidth((SCREEN_WIDTH-40)*lifeP1+5);
							else
								self:zoomtowidth((SCREEN_WIDTH/2-26)*lifeP1);	
							end;
							
					end;
		end;

};







---basemeter masked P2
t[#t+1] = LoadActor("basemeter") .. {	
		InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);horizalign,right;x,SCREEN_RIGHT+18;valign,0.5;y,SCREEN_TOP+41;zoomy,0.5;blend,Blend.Add;queuecommand,"Set"); 
		OnCommand=cmd(bounce;effectmagnitude,40,0,0;effectclock,"bgm";effecttiming,1,0,0,0;);
		SetCommand=function(self,params)
						local style = GAMESTATE:GetCurrentStyle();	
							if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
								self:effectmagnitude(-40,0,0);
								self:horizalign(left);
								self:x(SCREEN_LEFT+18);
					end;
			end;
			

			
		LifeChangedMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then	
				local style = GAMESTATE:GetCurrentStyle();		
				local lifeP2 = params.LifeMeter:GetLife();
							if GAMESTATE:IsHumanPlayer(PLAYER_2)==true then
								if lifeP2==0 then
									self:visible(false);
								else
									
									if lifeP2==1 then
										self:effectmagnitude(0,0,0);
									else
										if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
										self:effectmagnitude(-40,0,0);
										else
										self:effectmagnitude(40,0,0);
										end
									end;
							
									self:visible(true);
								end
							end
							if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
								self:zoomtowidth((SCREEN_WIDTH-40)*lifeP2);
							else
								self:zoomtowidth(((SCREEN_WIDTH/2-26)*lifeP2)+40);	
							end;
							
					end;
		end;

};




-- FRAMES & TIPS ////////////////////////


-- Left Corner
t[#t+1] = LoadActor("mask") .. {
	OnCommand=cmd(horizalign,right;x,SCREEN_LEFT+130;vertalign,top;y,SCREEN_TOP+12;zoom,0.45;queuecommand,"Set"); 
	SetCommand = function(self)
		local style = GAMESTATE:GetCurrentStyle();
		if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
		self:visible(true);
	else
		if GAMESTATE:IsHumanPlayer(PLAYER_1) == true then
		self:visible(true);
		else
		self:visible(false);
		end;
		end;
	end;
}; 

-- Right Corner
t[#t+1] = LoadActor("mask") .. {
	OnCommand=cmd(horizalign,right;x,SCREEN_RIGHT-130;vertalign,top;y,SCREEN_TOP+12;zoomx,-0.45;zoomy,0.45;queuecommand,"Set"); 
SetCommand = function(self)
		local style = GAMESTATE:GetCurrentStyle();
		if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
			self:visible(true);
		else
			if GAMESTATE:IsHumanPlayer(PLAYER_2) == true then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	end;
}; 


-- Left Corner
t[#t+1] = LoadActor("corner") .. {
	OnCommand=cmd(horizalign,left;x,SCREEN_LEFT+15;vertalign,top;y,SCREEN_TOP+16;zoom,0.75;queuecommand,"Set"); 

	
	SetCommand = function(self)
		local style = GAMESTATE:GetCurrentStyle();
		if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
		self:visible(true);
	else
		if GAMESTATE:IsHumanPlayer(PLAYER_1) == true then
		self:visible(true);
		else
		self:visible(false);
		end;
		end;
	end;
}; 

-- Right Corner
t[#t+1] = LoadActor("corner") .. {
	
	HealthStateChangedMessageCommand=function(self,params)
		if params.Player == PLAYER_2 then
			if params.HealthState == 'HealthState_Dead' then
			self:visible(false);
			end;
		end;
	end;
	
	OnCommand=cmd(horizalign,left;x,SCREEN_RIGHT-15;vertalign,top;y,SCREEN_TOP+16;zoomx,-0.75;zoomy,0.75;queuecommand,"Set"); 
		SetCommand = function(self)
		local style = GAMESTATE:GetCurrentStyle();
		if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
			self:visible(true);
		else
			if GAMESTATE:IsHumanPlayer(PLAYER_2) == true then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	end;
}; 

-- Center Corner Left
t[#t+1] = LoadActor("center") .. {
	OnCommand=cmd(horizalign,left;x,SCREEN_CENTER_X+5;vertalign,top;y,SCREEN_TOP+16;zoomx,-0.75;zoomy,0.75;queuecommand,"Set"); 
	
	HealthStateChangedMessageCommand=function(self,params)
		if params.Player == PLAYER_1 then
			if params.HealthState == 'HealthState_Dead' then
			self:visible(false);
			end;
		end;
	end;
	
	SetCommand = function(self)
		local style = GAMESTATE:GetCurrentStyle();
		if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
			self:visible(false);
		else
			if GAMESTATE:IsHumanPlayer(PLAYER_1) == true then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	end;
}; 

-- Center Corner Right
t[#t+1] = LoadActor("center") .. {
	OnCommand=cmd(horizalign,left;x,SCREEN_CENTER_X-5;vertalign,top;y,SCREEN_TOP+16;zoom,0.75;queuecommand,"Set"); 
	

	
	SetCommand = function(self)
		local style = GAMESTATE:GetCurrentStyle();
		if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
		self:visible(false);
	else
		if GAMESTATE:IsHumanPlayer(PLAYER_2) == true then
		self:visible(true);
		else
		self:visible(false);
		end;
		end;
	end;
}; 

-- Center part 1
t[#t+1] = LoadActor("frame") .. {
	OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);horizalign,left;x,SCREEN_LEFT+52.5;vertalign,top;y,SCREEN_TOP+16;zoomtowidth,SCREEN_WIDTH/2-85;zoomy,0.75;queuecommand,"Set";); 
	

	
	SetCommand = function(self)
		local style = GAMESTATE:GetCurrentStyle();
		if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
		self:zoomtowidth(SCREEN_WIDTH-105);
		self:visible(true)
		else
		if GAMESTATE:IsHumanPlayer(PLAYER_1) == false then
		self:visible(false)
		else
		self:visible(true)
		end
		end;
	end;
}; 

-- Center part 2
t[#t+1] = LoadActor("frame") .. {
	OnCommand=cmd(horizalign,right;x,SCREEN_RIGHT-52.5;vertalign,top;y,SCREEN_TOP+16;zoomtowidth,SCREEN_WIDTH/2-85;zoomy,0.75;queuecommand,"Set";); 

	
	SetCommand = function(self)
		local style = GAMESTATE:GetCurrentStyle();
		if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
		self:visible(false)
	else
		if GAMESTATE:IsHumanPlayer(PLAYER_2) == true then
		self:visible(true)
		else
		self:visible(false)
		end;
		end;
	end;
}; 



---tip P1
t[#t+1] = LoadActor("tip") .. {	
		InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);valign,0.5;y,SCREEN_TOP+41;zoom,0.5;blend,Blend.Add;queuecommand,"Set"); 

		
		LifeChangedMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then	
				local style = GAMESTATE:GetCurrentStyle();		
				local lifeP1 = params.LifeMeter:GetLife();
						
						if lifeP1 <= THEME:GetMetric("LifeMeterBar", "DangerThreshold") then
							self:diffusecolor(1,0.7,0.7,0.7);
							else
							self:diffusecolor(1,1,1,1);
							end
						
							if GAMESTATE:IsHumanPlayer(PLAYER_1)==true then
								if lifeP1==0 then
									self:visible(false);
								else
									self:visible(true);
								end
							end
							
							if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
								if lifeP1 == 1 then
								self:x((SCREEN_WIDTH-40)*lifeP1+17);

								else

								self:x((SCREEN_WIDTH-40)*lifeP1+20);
							
								end
							else
								self:x((SCREEN_WIDTH/2-26)*lifeP1+20);	
							end;
							
					end;
		end;

};



---tip P2
t[#t+1] = LoadActor("tip") .. {	
		InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);valign,0.5;y,SCREEN_TOP+41;zoom,0.5;blend,Blend.Add;); 

		
		LifeChangedMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then	
				local style = GAMESTATE:GetCurrentStyle();		
				local lifeP2 = params.LifeMeter:GetLife();
						

							if GAMESTATE:IsHumanPlayer(PLAYER_2)==true then
								if lifeP2==0 then
									self:visible(false);
								else
									self:visible(true);
								end
							end
							if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
								if lifeP2 == 1 then
								self:x((SCREEN_WIDTH-40)*lifeP2+17);
								else
								self:x((SCREEN_WIDTH-40)*lifeP2+20);
								end
							else
								self:x(SCREEN_RIGHT-((SCREEN_WIDTH/2-26)*lifeP2)-20);	
							end;
							
					end;
		end;

};

-- NAMES ////////////////////////

--P1 NAME
t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse") .. {
				InitCommand=cmd(maxwidth,300;horizalign,left;x,SCREEN_LEFT+30;y,SCREEN_TOP+14;zoom,0.45;shadowlength,1;uppercase,true);
			
				
				BeginCommand=function(self)
					local profile = PROFILEMAN:GetProfile(PLAYER_1);
					local name = profile:GetDisplayName();
					
					if GAMESTATE:IsHumanPlayer(PLAYER_1) == true then
						if name=="" then
							self:settext("Player 1");
						else
							self:settext( name );
						end
					end	
					
				end;
};
	
	
	
--P2 NAME	
t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse") .. {
				InitCommand=cmd(maxwidth,300;horizalign,right;x,SCREEN_RIGHT-30;y,SCREEN_TOP+14;zoom,0.45;shadowlength,1;uppercase,true);
				BeginCommand=function(self)
					local profile = PROFILEMAN:GetProfile(PLAYER_2);
					local name = profile:GetDisplayName();
					
					if GAMESTATE:IsHumanPlayer(PLAYER_2) == true then
						if name=="" then
							self:settext("Player 2");
						else
							self:settext( name );
						end
					end
				end;
};

			
			
--P1 SCORE
t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold monospace numbers") .. {
				InitCommand=cmd(horizalign,right;y,SCREEN_TOP+14;zoom,0.45;uppercase,true;shadowlength,1;visible,GAMESTATE:IsHumanPlayer(PLAYER_1);playcommand,"Set");
				ComboChangedMessageCommand=function(self)
					local PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
					self:settext(scorecap(PSS:GetScore()));
				end;
				
				SetCommand=function(self)
					local style = GAMESTATE:GetCurrentStyle();
					
					
					if GetUserPref("UserPrefScorePosition") == "Top" then 
							if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
								self:x(SCREEN_RIGHT-30);
							else
								self:x(THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX")+130);
							end
					end
					
					if GetUserPref("UserPrefScorePosition") == "Bottom" then 
							self:x(THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX"));
							self:y(SCREEN_BOTTOM-14);
							self:horizalign(center)
					end		
				
					
					if GetUserPref("UserPrefScorePosition") == "Off" then 
							self:y(SCREEN_BOTTOM+9999);
					end
					
						if style:GetStyleType() == "StyleType_TwoPlayersSharedSides" then
								self:x(SCREEN_CENTER_X-1);
								self:visible(GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P1")
								self:horizalign(center)
					end
					
					
				end
};
	
--P2 SCORE
t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold monospace numbers") .. {
				InitCommand=cmd(horizalign,left;y,SCREEN_TOP+14;zoom,0.45;uppercase,true;shadowlength,1;visible,GAMESTATE:IsHumanPlayer(PLAYER_2);playcommand,"Set");	
				ComboChangedMessageCommand=function(self)
					
					local PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
					self:settext(scorecap(PSS:GetScore()));
				end;
				
				SetCommand=function(self)
					local style = GAMESTATE:GetCurrentStyle();
					
					
					if GetUserPref("UserPrefScorePosition") == "Top" then 
							if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
								self:x(SCREEN_LEFT+30);
							else
								self:x(THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX")-130);
							end
					end
					
					if GetUserPref("UserPrefScorePosition") == "Bottom" then 
							self:x(THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX"));
							self:y(SCREEN_BOTTOM-14);
							self:horizalign(center)
					end		
					
					
					if GetUserPref("UserPrefScorePosition") == "Off" then 
							self:y(SCREEN_BOTTOM+9999);
					end
					
					
					if style:GetStyleType() == "StyleType_TwoPlayersSharedSides" then
								self:x(SCREEN_CENTER_X-1);
								self:visible(GAMESTATE:GetMasterPlayerNumber() == "PlayerNumber_P2")
								self:horizalign(center)
					end
								
				end
};			

t[#t+1] = Def.ActorFrame{

	InitCommand=cmd(y,SCREEN_BOTTOM-20);
	LoadActor("progressmeter")..{
		InitCommand=cmd(diffusealpha,.8;zoomx,0;horizalign,left;x,SCREEN_CENTER_X-607/2);
		OnCommand=cmd(sleep,GAMESTATE:GetCurrentSong():GetFirstBeat();linear,GAMESTATE:GetCurrentSong():GetStepsSeconds();zoomx,1);
	};

	LoadActor("progress-bar")..{
		InitCommand=cmd(x,SCREEN_CENTER_X);
	};

};
			
--[[ MISC ///////////////////////////////////


	gonna save this for later


	HealthStateChangedMessageCommand=function(self,params)
		 local failure = (params.HealthState);
		 if params.PlayerNumber == PLAYER_1 then
			if failure=="HealthState_Dead" then  
				self:visible(false)
			end;
		 end;
    end;
	
	
	
	
	
	
	]]
			

return t