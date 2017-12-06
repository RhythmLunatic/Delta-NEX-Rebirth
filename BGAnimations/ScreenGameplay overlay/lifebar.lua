local player = ...
--For SM5 center 1 player
--local centered = ...[2];

--Size of frame (just the inner part of the lifebar)
local LIFEBAR_WIDTH = SCREEN_WIDTH/2-85

--Size of the actual lifebar. Yes I know this is terrible code I'll fix it later I swear
local LIFEBAR_REALWIDTH = LIFEBAR_WIDTH+60



return Def.ActorFrame{
	--[[
	Everything should be based around the center
	because it's the best indicator of the lifebar
	width (it's easy to debug)
	]]
	
	InitCommand=function(self)
		--It flips itself for player 2, because I'm a lazy coder
		if player == PLAYER_2 then
			self:zoomx(-1);
		end;
	end;
	
	--DANGER
	LoadActor("danger") .. {
		InitCommand=cmd(xy,-5,6;zoomtowidth,LIFEBAR_REALWIDTH;zoomy,0.5); 
		OnCommand=cmd(effectclock,"bgm";diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF66"));
		LifeChangedMessageCommand=function(self,params)		
			if params.Player == player then
			local lifeP1 = params.LifeMeter:GetLife();
				if lifeP1 <= THEME:GetMetric("LifeMeterBar", "DangerThreshold") then
					self:diffusealpha(1);
						
				else
					self:diffusealpha(0);
				end;	
			end;
		end;
	};
	
	--Wavy line
	LoadActor("hot_lores") .. {
		OnCommand=cmd(x,-3;zoomtowidth,LIFEBAR_REALWIDTH;texcoordvelocity,0.1,0;queuecommand,"Begin");
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
		InitCommand=cmd(valign,0.5;xy,-LIFEBAR_WIDTH/2-35,6;horizalign,left;zoomy,0.5;blend,Blend.Add); 
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
					self:zoomtowidth((LIFEBAR_REALWIDTH)*lifeP1)
								
				end;
		end;

	};
	
	-- Left Corner
	LoadActor("mask") .. {
		--Zoom 0.45 does strange things to positioning...
		InitCommand=cmd(x,(-LIFEBAR_WIDTH/2)+80;horizalign,right;zoom,0.45;);
	};
	
	-- Center
	LoadActor("frame") .. {
		OnCommand=cmd(zoomtowidth,LIFEBAR_WIDTH;zoomy,0.75;);
	};
	
	-- Right Corner
	LoadActor("center") .. {
		--horizalign right isn't a mistake, the graphic is flipped with zoomx
		InitCommand=cmd(x,LIFEBAR_WIDTH/2;horizalign,right;zoomx,-0.75;zoomy,0.75;); 
		
		HealthStateChangedMessageCommand=function(self,params)
			if params.Player == player then
				if params.HealthState == 'HealthState_Dead' then
				self:visible(false);
				end;
			end;
		end;
	};
	
	-- Left Corner
	LoadActor("corner") .. {
		InitCommand=cmd(x,-LIFEBAR_WIDTH/2;horizalign,right;zoom,0.75;);
	};
	
	--SCORE
	LoadFont("venacti/_venacti_outline 26px bold monospace numbers") .. {
		InitCommand=cmd(zoomy,0.45;uppercase,true;shadowlength,1;x,LIFEBAR_WIDTH/2+20;);
		
		--Flip the score back around and change alignment if player 2
		OnCommand=function(self)
			if player == PLAYER_2 then
				self:horizalign(left);
				self:zoomx(-.45);
			else
				self:horizalign(right);
				self:zoomx(.45);
			end;
		end;
		ComboChangedMessageCommand=function(self)
			local PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
			self:settext(scorecap(PSS:GetScore()));
		end;
	};
	
	LoadActor("tip") .. {	
		InitCommand=cmd(valign,0.5;y,6;zoom,0.5;blend,Blend.Add;);
		LifeChangedMessageCommand=function(self,params)
			if params.Player == player then	
				local style = GAMESTATE:GetCurrentStyle();		
				local lifeP1 = params.LifeMeter:GetLife();
						
				if lifeP1 <= THEME:GetMetric("LifeMeterBar", "DangerThreshold") then
					self:diffusecolor(1,0.7,0.7,0.7);
				else
					self:diffusecolor(1,1,1,1);
				end
				
				if GAMESTATE:IsHumanPlayer(player)==true then
					if lifeP1==0 then
						self:visible(false);
					else
						self:visible(true);
					end
				end
				--Need to offset it by half the lifebar width since otherwise it would be starting at the lifebar's center and going way off
				self:x(LIFEBAR_REALWIDTH*lifeP1-(LIFEBAR_REALWIDTH/2+5));	

					
			end;
		end;

	};


}