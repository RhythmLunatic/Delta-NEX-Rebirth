--LoadActor("file.lua", argument) -> arguments are passed in as "...". As in literally, the variable is named "..." (without the quotes)
local player = ...;
--in normal syntax, style = (GetStyle() == "OnePlayerTwoSides") ? "Single" : "Double")
local style = (ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType()) == "OnePlayerTwoSides") and "Double" or "Single";
--SCREENMAN:SystemMessage(style);

--TODO: Turn the lifebar width into a variable instead of SCREEN_WIDTH/2 etc etc etc
--And figure out why the fuck horizalign left isn't working on this thing
return Def.ActorFrame{
	--Wavy line
	LoadActor("hot_lores") .. {
		OnCommand=cmd(x,-3;zoomtowidth,SCREEN_WIDTH/2-26;texcoordvelocity,0.1,0;queuecommand,"Begin");
		BeginCommand=function(self)
			if style == "Double" then
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
			if params.Player == player then
				local lifeP1=params.LifeMeter:GetLife();
				if lifeP1>=THEME:GetMetric("LifeMeterBar", "HotValue") then
						self:diffusealpha(0.5);
					else
						self:diffusealpha(0);
					end;
				end;
		end;
	};

	---basemeter masked P1
	LoadActor("basemeter") .. {	
		InitCommand=cmd(valign,0.5;xy,-205,6;horizalign,left;zoomy,0.5;blend,Blend.Add); 
		

		
		OnCommand=cmd(bounce;effectmagnitude,-40,0,0;effectclock,"bgm";effecttiming,1,0,0,0;);
		LifeChangedMessageCommand=function(self,params)
				if params.Player == player then	
					local lifeP1 = params.LifeMeter:GetLife();
					if GAMESTATE:IsHumanPlayer(player)==true then
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
					if style == "Double" then
						self:zoomtowidth((SCREEN_WIDTH-40)*lifeP1+5);
					else
						self:zoomtowidth((SCREEN_WIDTH/2-26)*lifeP1);	
					end;
								
				end;
		end;

	};
	
	-- Left Corner
	LoadActor("mask") .. {
		OnCommand=cmd(diffusealpha,1;x,-95;horizalign,right;zoom,0.45;queuecommand,"Set"); 
		SetCommand = function(self)
				if style == "Double" then
				self:visible(true);
			else
				if GAMESTATE:IsHumanPlayer(player) == true then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		end;
	}; 
	
	
	-- Left Corner
	LoadActor("corner") .. {
		OnCommand=cmd(x,-(SCREEN_WIDTH/2-85)/2;horizalign,right;zoom,0.75;queuecommand,"Set"); 

		
		SetCommand = function(self)
			if style == "Double" then
				self:visible(true);
			else
				if GAMESTATE:IsHumanPlayer(player) == true then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		end;
	}; 
	
	-- Center part 1
	LoadActor("frame") .. {
		--Note: SCREEN_WIDTH/2-85 is 185 (I think);
		OnCommand=cmd(x,0;zoomtowidth,SCREEN_WIDTH/2-85;zoomy,0.75;queuecommand,"Set";); 
		

		
		SetCommand = function(self)
			if style == "Double" then
				self:x(SCREEN_WIDTH/4-10);
				self:zoomtowidth(SCREEN_WIDTH-105);
				self:visible(true)
			else
				if GAMESTATE:IsHumanPlayer(player) == false then
					self:visible(false)
				else
					self:visible(true)
				end
			end;
		end;
	};
	
	-- Center Corner Left
	LoadActor("center") .. {
		OnCommand=cmd(x,(SCREEN_WIDTH/2-85)/2;horizalign,right;zoomx,-0.75;zoomy,0.75;queuecommand,"Set"); 
		
		HealthStateChangedMessageCommand=function(self,params)
			if params.Player == player then
				if params.HealthState == 'HealthState_Dead' then
				self:visible(false);
				end;
			end;
		end;
		
		SetCommand = function(self)
			if style == "Double" then
				self:visible(false);
			else
				if GAMESTATE:IsHumanPlayer(player) == true then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		end;
	};
	
	--P1 SCORE
	LoadFont("venacti/_venacti_outline 26px bold monospace numbers") .. {
				InitCommand=cmd(zoom,0.45;uppercase,true;shadowlength,1;visible,GAMESTATE:IsHumanPlayer(player);playcommand,"Set");
				OnCommand=function(self)
					if style == "Single" then
						self:horizalign(right);
						self:x(SCREEN_WIDTH/4-20);
					else
						self:x(SCREEN_WIDTH/4-12);
					end;
				end;
				ComboChangedMessageCommand=function(self)
					local PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
					self:settext(scorecap(PSS:GetScore()));
				end;
				
				SetCommand=function(self)
					--[[local style = GAMESTATE:GetCurrentStyle();
					
					
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
					end]]
					
					
					
					
				end
	};
};