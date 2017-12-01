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
	InitCommand=cmd(visible,(GAMESTATE:IsHumanPlayer(PLAYER_1) or ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType()) == "OnePlayerTwoSides"));
	OnCommand=cmd(horizalign,left;x,SCREEN_LEFT;vertalign,top;y,SCREEN_TOP;zoomy,0.4;zoomx,0.6;diffusealpha,0.3;blend,Blend.Add); 
}; 

-- Right Hex Corner Decoration
t[#t+1] = LoadActor("decoration_corner") .. {
	InitCommand=cmd(visible,(GAMESTATE:IsHumanPlayer(PLAYER_2) or ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType()) == "OnePlayerTwoSides"));
	OnCommand=cmd(horizalign,left;x,SCREEN_RIGHT;vertalign,top;y,SCREEN_TOP;zoomy,0.4;;zoomx,-0.6;diffusealpha,0.3;blend,Blend.Add); 
}; 

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
							self:settext("Player 1");
						else
							self:settext( name );
						end
					end	
					
				end;
};


-- WAVY LINE (thanks AJ) ////////////////////////




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


-- METERS ////////////////////////
local style = (ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType()) == "OnePlayerTwoSides") and "Double" or "Single";

if style == "Single" then
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		--The good lifebar
		t[#t+1] = LoadActor("lifebar", pn)..{
			InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);y,34);
			OnCommand=function(self)
				if pn == PLAYER_1 then
					self:x(225);
					self:horizalign(left);
				else
					self:x(SCREEN_WIDTH-225);
					self:horizalign(right);
				end;
			end;
		}
	end;
else

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


	-- Doubles... And legacy code.
	t[#t+1] = LoadActor("doubles_lifebar", PLAYER_1)..{
		InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);xy,225,34);

	}

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
end




-- Progress bar
t[#t+1] = Def.ActorFrame{

	InitCommand=cmd(y,SCREEN_BOTTOM-20);
	LoadActor("progressmeter")..{
		InitCommand=cmd(diffusealpha,.8;zoomx,0;horizalign,left;x,SCREEN_CENTER_X-607/2);
		OnCommand=cmd(sleep,math.abs(GAMESTATE:GetCurrentSong():GetFirstBeat());linear,GAMESTATE:GetCurrentSong():GetStepsSeconds();zoomx,1);
	};

	LoadActor("progress-bar")..{
		InitCommand=cmd(x,SCREEN_CENTER_X);
	};

};

--The current stage
--TODO: Some kind of cool graphic under the text
t[#t+1] = Def.ActorFrame{
	LoadFont("soms2/_soms2 techy") .. {
		Text="Hello World";
		InitCommand=cmd(xy,SCREEN_CENTER_X,12);
	}
}

			
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