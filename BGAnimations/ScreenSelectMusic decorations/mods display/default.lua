local step = 35;
local pn = ...;

local function increasePlayerSpeed(pn, amount)
	--SCREENMAN:SystemMessage(playerState);
	local playerState = GAMESTATE:GetPlayerState(pn);
	--This returns an instance of playerOptions, you need to set it back to the original
	local playerOptions = playerState:GetPlayerOptions("ModsLevel_Preferred")
	--SCREENMAN:SystemMessage(PlayerState:GetPlayerOptionsString("ModsLevel_Current"));
	--One of these will be valid, depending on the player's currently set speed mod.
	local cmod = playerOptions:CMod();
	local mmod = playerOptions:MMod();
	local xmod = playerOptions:XMod();
	if cmod then
		if amount*100+playerOptions:CMod() < 100 then
			playerOptions:CMod(800);
		elseif amount*100+playerOptions:CMod() > 1000 then
			playerOptions:CMod(100);
		else
			playerOptions:CMod(playerOptions:CMod()+amount*100);
		end;
	elseif mmod then
		if amount*100+playerOptions:MMod() < 100 then
			playerOptions:MMod(800);
		elseif amount*100+playerOptions:MMod() > 1000 then
			playerOptions:MMod(100);
		else
			playerOptions:MMod(playerOptions:MMod()+amount*100);
		end;
	elseif xmod then
		--SCREENMAN:SystemMessage(playerOptions:XMod())
		if amount+playerOptions:XMod() < .5 then
			playerOptions:XMod(8);
		elseif amount+playerOptions:XMod() > 8 then
			playerOptions:XMod(.5);
		else
			playerOptions:XMod(playerOptions:XMod()+amount,true);
		end;
		--SCREENMAN:SystemMessage("Set speed to "..playerOptions:XMod().." ("..tostring(xmod).."+"..tostring(amount)..")");
	else
		SCREENMAN:SystemMessage("ERROR: Can't determine "..pn.."'s current speed mod!");
	end;
	GAMESTATE:GetPlayerState(pn):SetPlayerOptions('ModsLevel_Preferred', playerState:GetPlayerOptionsString("ModsLevel_Preferred"));
	--SCREENMAN:SystemMessage(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Current").." "..playerState:GetCurrentPlayerOptions():XMod());
end


return Def.ActorFrame{
		InitCommand=function(self)
			self:y(60);
			self:draworder(11);
			if pn == PLAYER_1 then
				self:x(SCREEN_LEFT+27);
			else
				self:x(SCREEN_RIGHT-27);
			end;
		end;
		
		--Speed modifier
		Def.ActorFrame{
			InitCommand=cmd(y,step*5);
			OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
			
			LoadActor(THEME:GetPathS("CommandMenu","Set"))..{
				CodeMessageCommand = function(self, params)
					local sTable = {
						Quarter = .25,
						Half = .5,
						Full = 1
					};

					if params.PlayerNumber == pn then
						if params.Name == 'SpeedQuarterUp' then
							increasePlayerSpeed(pn,sTable['Quarter']);
							self:play();
						end;
						if params.Name == 'SpeedHalfUp' then
							increasePlayerSpeed(pn,sTable['Half']);
							self:play();
						end;
						if params.Name == 'SpeedUp' then
							increasePlayerSpeed(pn,sTable['Full']);
							self:play();
						end;
						
						--Increasing... By a negative number
						if params.Name == 'SpeedQuarterDown' then
							increasePlayerSpeed(pn,sTable['Quarter']*-1);
							self:play();
						end;
						if params.Name == 'SpeedHalfDown' then
							increasePlayerSpeed(pn,sTable['Half']*-1);
							self:play();
						end;
						if params.Name == 'SpeedDown' then
							increasePlayerSpeed(pn,sTable['Full']*-1);
							self:play();
						end;
					end
				end
			};--speedmods

			LoadActor("optionIcon")..{
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,0.75;);
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
				InitCommand=cmd(draworder,100;zoom,.45;diffusebottomedge,0.7,0.7,0.7,1;maxwidth,70;shadowlength,0.8);
				OnCommand=cmd(playcommand,"UpdateText");
				--sleep,0.1;queuecommand,"On");
				OptionsListClosedMessageCommand=cmd(playcommand,"UpdateText");
				CodeMessageCommand=function(self)
					self:playcommand("UpdateText");
				end;
				UpdateTextCommand=function(self)
					local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
					local cmod = playerOptions:CMod();
					local mmod = playerOptions:MMod();
					local xmod = playerOptions:XMod();
					if cmod then
						self:settext("C"..cmod);
					elseif mmod then
						self:settext("AV\n"..mmod);
					elseif xmod then
						self:settext(xmod.."x");
					else
						self:settext("???");
					end;
				end;
			};
			LoadActor("optionFlash")..{
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffuse,1,1,1,0;visible,GAMESTATE:IsHumanPlayer(pn);sleep,0.1;blend,Blend.Add;queuecommand,"Init");
				CodeMessageCommand=function(self,params)
					if params.PlayerNumber == pn then
						if params.Name == 'SpeedUp' or
							params.Name == 'SpeedDown' or
							params.Name == 'SpeedHalfUp' or
							params.Name == 'SpeedHalfDown' or
							params.Name == 'SpeedQuarterUp' or
							params.Name == 'SpeedQuarterDown' then
							self:stoptweening();
							self:diffusealpha(1);
							self:sleep(0.1);
							self:linear(0.3)
							self:diffusealpha(0);
						end
					end
				end
			};
		};
		
		-- Noteskin modifier
		LoadActor("NoteSkin Display", pn)..{
			InitCommand=function(self)
				self:y(step*4);
				self:draworder(11);
			end;
		};
		
		-- Perspective modifiers: NX (Space), HW/Hallway, DS/Distant, IN/Incoming.
		Def.ActorFrame{
			InitCommand=function(self)
				self:y(step*2);
				self:draworder(11);
			end;
			OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);playcommand,"UpdateText");
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
			OptionsListClosedMessageCommand=cmd(playcommand,"UpdateText");
			UpdateTextCommand=function(self)
				local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
				local text = self:GetChild("Text");
				--local anim = self:GetChild("Animation");
				if playerOptions:Space() then
					self:visible(true);
					--anim:playcommand("Play");
					text:settext("NX");
				elseif playerOptions:Hallway() then
					self:visible(true);
					--anim:queuecommand("Play");
					text:settext("HW");
				elseif playerOptions:Distant() then
					self:visible(true);
					--anim:queuecommand("Play");
					text:settext("DS");
				elseif playerOptions:Incoming() then
					self:visible(true);
					--anim:queuecommand("Play");
					text:settext("IN");
				else
					self:visible(false);
				end;
			end;
			
			LoadActor("optionIcon")..{
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,0.75;);
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
				Name="Text";
				InitCommand=cmd(draworder,100;zoom,.6;diffusebottomedge,0.7,0.7,0.7,1;maxwidth,70;shadowlength,0.8);
			};
			--[[LoadActor("optionFlash")..{
				Name="Animation";
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffuse,1,1,1,0;sleep,0.1;blend,Blend.Add;);
				PlayCommand=cmd(stoptweening;diffusealpha,1;sleep,0.1;linear,0.3;diffusealpha,0;);
			};]]
		};
		
		-- Acceleration modifiers: AC (Boost), DC (Brake), EW (Expand), WV/Wave, BM/Boomerang
		Def.ActorFrame{
			InitCommand=function(self)
				self:y(step*3);
				self:draworder(11);
			end;
			OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);playcommand,"UpdateText");
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
			OptionsListClosedMessageCommand=cmd(playcommand,"UpdateText");
			UpdateTextCommand=function(self)
				local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred");
				local text2 = self:GetChild("Text");
				if playerOptions:Boost() ~= 0 then
					self:visible(true);
					text2:settext("AC");
				elseif playerOptions:Brake() ~= 0 then
					self:visible(true);
					text2:settext("DC");
				elseif playerOptions:Expand() ~= 0 then
					self:visible(true);
					text2:settext("EW");
				elseif playerOptions:Wave() ~= 0 then
					self:visible(true);
					text2:settext("WV");
				elseif playerOptions:Boomerang() ~= 0 then
					self:visible(true);
					text2:settext("BM");
				else
					self:visible(false);
				end;
			end;
			
			LoadActor("optionIcon")..{
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,0.75;);
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
				Name="Text";
				Text="???";
				InitCommand=cmd(draworder,100;zoom,.6;diffusebottomedge,0.7,0.7,0.7,1;maxwidth,70;shadowlength,0.8);
			};
		};
		
		-- Appearance modifiers: Hidden (V), Sudden (AP), Stealth (NS), Blink (FL)
		Def.ActorFrame{
			InitCommand=function(self)
				self:y(step*0);
				self:draworder(11);
			end;
			OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);playcommand,"UpdateText");
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
			OptionsListClosedMessageCommand=cmd(playcommand,"UpdateText");
			UpdateTextCommand=function(self)
				local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred");
				local text = self:GetChild("Text");
				if playerOptions:Hidden() ~= 0 then
					self:visible(true);
					text:settext("V");
					--SCREENMAN:SystemMessage(playerOptions:Hidden());
				elseif playerOptions:Sudden() ~= 0 then
					self:visible(true);
					text:settext("AP");
				elseif playerOptions:Stealth() ~= 0 then
					self:visible(true);
					text:settext("NS");
					--SCREENMAN:SystemMessage(playerOptions:Stealth());
				elseif playerOptions:Blink() ~= 0 then
					self:visible(true);
					text:settext("FL");
				else
					self:visible(false);
				end;
			end;
			
			LoadActor("optionIcon")..{
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,0.75;);
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
				Name="Text";
				Text="???";
				InitCommand=cmd(draworder,100;zoom,.6;diffusebottomedge,0.7,0.7,0.7,1;maxwidth,70;shadowlength,0.8);
			};
		};
		-- Alternate modifiers: Mirror (M), Shuffle (RS), SuperShuffle (SRS), Backwards (BK), Left (L), Right, (R), Soft Shuffle (SFS)
		Def.ActorFrame{
			InitCommand=function(self)
				self:y(step*1);
				self:draworder(11);
			end;
			OnCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);playcommand,"UpdateText");
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
			OptionsListClosedMessageCommand=cmd(playcommand,"UpdateText");
			UpdateTextCommand=function(self)
				local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred");
				local text = self:GetChild("Text");
				if playerOptions:Mirror() then
					self:visible(true);
					text:settext("M");
				elseif playerOptions:Shuffle() then
					self:visible(true);
					text:settext("RS");
				elseif playerOptions:SuperShuffle() then
					self:visible(true);
					text:settext("SRS");
				elseif playerOptions:Backwards() then
					self:visible(true);
					text:settext("BK");
				elseif playerOptions:Left() then
					self:visible(true);
					text:settext("L");
				elseif playerOptions:Right() then
					self:visible(true);
					text:settext("R");
				elseif playerOptions:SoftShuffle() then
					self:visible(true);
					text:settext("SFS");
				else
					self:visible(false);
				end;
			end;
			
			LoadActor("optionIcon")..{
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,0.75;);
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
				Name="Text";
				Text="???";
				InitCommand=cmd(draworder,100;zoom,.45;diffusebottomedge,0.7,0.7,0.7,1;maxwidth,70;shadowlength,0.8);
			};
		};
	};
