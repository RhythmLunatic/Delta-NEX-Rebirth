local noScroller = ...;

footerName = noScroller == true and "_noscroll" or "_footer";

local t = Def.ActorFrame {

	InitCommand=cmd(zoom,.7;vertalign,bottom;xy,SCREEN_CENTER_X,SCREEN_BOTTOM;);
	
	LoadActor(footerName)..{
		InitCommand=cmd(vertalign,bottom;draworder,100);
	};
	
	--P1 NAME
	LoadFont("venacti/_venacti 13px bold diffuse") .. {
		InitCommand=cmd(maxwidth,320;draworder,110;horizalign,right;xy,-250,-50;zoom,.7;shadowlength,1;uppercase,true;queuecommand,"Set");
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
	LoadFont("venacti/_venacti 13px bold diffuse") .. {
		InitCommand=cmd(maxwidth,320;draworder,110;horizalign,left;horizalign,right;xy,250,50;zoom,.7;shadowlength,1;uppercase,true;queuecommand,"Set");
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
}







return t
