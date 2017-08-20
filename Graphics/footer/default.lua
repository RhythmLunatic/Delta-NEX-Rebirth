local noScroller = ...;


local t = Def.ActorFrame {}

if noScroller == true then
	--For the footer without an area for the scroller to go.
	t[#t+1] = LoadActor("_noscroll")..{
		InitCommand=cmd(draworder,100;Center;zoom,0.675);
	}
else
	t[#t+1] = LoadActor("_footer")..{
		InitCommand=cmd(draworder,100;Center;zoom,0.675);
	}
end;


--P1 NAME
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse") .. {
				InitCommand=cmd(maxwidth,320;draworder,110;horizalign,right;x,SCREEN_CENTER_X-180;y,SCREEN_BOTTOM-30;zoom,0.4;shadowlength,1;uppercase,true;queuecommand,"Set");
				OnCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(queuecommand,"Set");
				PlayerUnjoinedMessageCommand=cmd(queuecommand,"Set");
				SetCommand=function(self)
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
t[#t+1] = LoadFont("venacti/_venacti 26px bold diffuse") .. {
				InitCommand=cmd(maxwidth,320;draworder,110;horizalign,left;x,SCREEN_CENTER_X+180;y,SCREEN_BOTTOM-30;zoom,0.4;shadowlength,1;uppercase,true;queuecommand,"Set");
				OnCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(queuecommand,"Set");
				PlayerUnjoinedMessageCommand=cmd(queuecommand,"Set");
				SetCommand=function(self)
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




return t