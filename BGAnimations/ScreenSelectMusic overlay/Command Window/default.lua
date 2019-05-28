local t = Def.ActorFrame{

    LoadActor(THEME:GetPathS("CommandMenu","Move"))..{
        --PreviousGroupMessageCommand=cmd(play);
        --NextGroupMessageCommand=cmd(play);
        OptionsListOpenedMessageCommand=cmd(play);
        OptionsListClosedMessageCommand=cmd(play);
        OptionsListRightMessageCommand=cmd(play);
        OptionsListLeftMessageCommand=cmd(play);
        OptionsListQuickChangeMessageCommand=cmd(play);
    };
    LoadActor(THEME:GetPathS("CommandMenu","Set"))..{
        OptionsListClosedMessageCommand=cmd(play);
        OptionsListStartMessageCommand=cmd(play);
        OptionsListResetMessageCommand=cmd(play);
    };
    LoadActor(THEME:GetPathS("CommandMenu","InOut"))..{
		CodeMessageCommand = function(self, params)
			if params.Name == 'OpenOpList' then
				--SCREENMAN:SystemMessage("OptionsList opened")
				SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber)
			end
		end;
        OptionsListPopMessageCommand=cmd(play);
        OptionsListPushMessageCommand=cmd(play);
    };
};
if THEME:GetMetric("ScreenSelectMusic","UseOptionsList") then
	local function CurrentNoteSkin(p)
		local state = GAMESTATE:GetPlayerState(p)
		local mods = state:GetPlayerOptionsArray( 'ModsLevel_Preferred' )
		local skins = NOTESKIN:GetNoteSkinNames()

		for i = 1, #mods do
			for j = 1, #skins do
				if string.lower( mods[i] ) == string.lower( skins[j] ) then
				   return skins[j];
				end
			end
		end
	end;
	
	local OPTIONSLIST_NOTESKINS = OptionRowAvailableNoteskins().Choices;
	local OPTIONSLIST_NUMNOTESKINS = OptionRowAvailableNoteskins().NumNoteskins;
	--local OPLIST_WIDTH =		THEME:GetMetric("CustomRIO","OpQuadWidth")	
	local OPLIST_splitAt = THEME:GetMetric("OptionsList","MaxItemsBeforeSplit")
	--Start to shift the optionsList up at this row
	local OPLIST_ScrollAt = 16
	
		--OpList
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		--This keeps the name of the current OptionsList because OptionsListLeft and OptionsListRight does not know what list this is otherwise
		local currentOpList
		--The amount of rows in the current optionsList menu.
		local numRows
		--This gets a handle on the optionsList Actor so it can be adjusted.
		local optionsListActor
		--If player 1, move towards left. If player 2, move towards right.
		local offset = (pn == PLAYER_1) and -1 or 1
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_CENTER_X+300*offset;diffusealpha,0);
			OnCommand=function(self)
				--Named OptionsListP1 or OptionsListP2
				optionsListActor = SCREENMAN:GetTopScreen():GetChild("OptionsList"..pname(pn))
				--assert(optionsListActor,"No actor!")
			end;
			CodeMessageCommand = function(self, params)
				if params.Name == 'OptionList' then
					SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber)
				end;
			end;
			OptionsListOpenedMessageCommand=function(self,params)
				if params.Player == pn then
					--self:zoomx(-0.675*offset);
					self:stoptweening():decelerate(0.3):diffusealpha(1);
				end
			end;
			OptionsListClosedMessageCommand=function(self,params)
				if params.Player == pn then
					self:stoptweening():decelerate(0.3):diffusealpha(0);
				end;
			end;
			LoadFont("venacti/_venacti 26px bold diffuse")..{	--Texto "OPTION LIST"
				Text="Command Window";
				InitCommand=cmd(draworder,999;y,_screen.cy-180;vertalign,bottom;diffusebottomedge,Color("HoloBlue"));
			};
			
			LoadActor("oplist")..{
				InitCommand=cmd(vertalign,top;addx,-300*offset;zoom,0.675);
			};
			
			LoadFont("Common Normal")..{
				--Text="Hello World!";
				InitCommand=cmd(draworder,999;y,_screen.cy-170;vertalign,top;zoom,.5;wrapwidthpixels,350);
				OptionsListOpenedMessageCommand=function(self,params)
					if params.Player == pn then
						currentOpList = "SongMenu"
						--This batshit code finds the value of [ScreenOptionsMaster] SongMenu,1
						self:settext(THEME:GetString("OptionExplanations",string.gsub(THEME:GetMetric("ScreenOptionsMaster",THEME:GetMetric("OptionsList","TopMenu")..",1"):split(";")[1],"name,","")))
					end;
				end;
				AdjustCommand=function(self,params)
					--SCREENMAN:SystemMessage(currentOpList..", "..params.Selection.." "..THEME:GetMetric("ScreenOptionsMaster",currentOpList..","..params.Selection+1))
					if params.Player == pn then
						if currentOpList == "SongMenu" or currentOpList == "System" then
							
							if params.Selection+1 <= numRows then
								local itemName = string.gsub(THEME:GetMetric("ScreenOptionsMaster",currentOpList..","..params.Selection+1):split(";")[1],"name,","")
								self:settext(THEME:GetString("OptionExplanations",itemName))
							else
								self:settext("Exit.");
							end;
						elseif currentOpList == "NoteSkins" then
							local curRow;
							if OPLIST_splitAt < OPTIONSLIST_NUMNOTESKINS then
								curRow = math.floor((params.Selection)/2)+1
							else
								curRow = params.Selection+1
							end;
							--SCREENMAN:SystemMessage(curRow)
							if curRow>OPLIST_ScrollAt then
								optionsListActor:stoptweening():linear(.2):y((SCREEN_CENTER_Y-100)+THEME:GetMetric("OptionsList","ItemsSpacingY")*(OPLIST_ScrollAt-curRow))
							else
								optionsListActor:stoptweening():linear(.2):y(SCREEN_CENTER_Y-100)
							end;
						end;
					end;
					--SCREENMAN:SystemMessage(itemName)
				end;
				OptionsListRightMessageCommand=function(self,params)
					self:playcommand("Adjust",params);
				end;
				OptionsListLeftMessageCommand=function(self,params)
					self:playcommand("Adjust",params);
				end;
				
				OptionsListStartMessageCommand=function(self,params)
					if params.Player == pn then
						if currentOpList == "NoteSkins" then
							local curRow;
							--This global var is exported by OptionRowAvailableNoteskins()
							if OPLIST_splitAt < OPTIONSLIST_NUMNOTESKINS then
								curRow = math.floor((OPTIONSLIST_NUMNOTESKINS)/2)+1
							else
								curRow = OPTIONSLIST_NUMNOTESKINS+1
							end;
							--SCREENMAN:SystemMessage(curRow)
							if curRow>OPLIST_ScrollAt then
								optionsListActor:stoptweening():linear(.2):y((SCREEN_CENTER_Y-100)+THEME:GetMetric("OptionsList","ItemsSpacingY")*(OPLIST_ScrollAt-curRow))
							else
								optionsListActor:stoptweening():linear(.2):y(SCREEN_CENTER_Y-100)
							end;
						end;
					end;
				end;
				OptionsMenuChangedMessageCommand=function(self,params)
					--SCREENMAN:SystemMessage("MenuChanged: Menu="..params.Menu);
					if params.Player == pn then
						currentOpList=params.Menu
						optionsListActor:y(SCREEN_CENTER_Y-100) --Reset the positioning
						if params.Menu ~= "SongMenu" and params.Menu ~= "System" then
							self:settext(THEME:GetString("OptionExplanations",params.Menu))
						else
							--SCREENMAN:SystemMessage(params.Size);
							numRows = tonumber(THEME:GetMetric("ScreenOptionsMaster",currentOpList))
						end;
					end;
				end;
			};
			LoadFont("Common Normal")..{
				Text="Current Velocity:";
				InitCommand=cmd(draworder,999;y,_screen.cy-450;vertalign,top;zoom,.5;wrapwidthpixels,350;diffusebottomedge,Color("HoloBlue");visible,false);
				OnCommand=function(self,params)
					self:playcommand("UpdateText",{Player=pn});
				end;
				UpdateTextCommand=function(self,params)
					if params.Player == pn then
						if GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():MMod() then
							self:settext("Current Velocity: "..GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():MMod());
						else
							self:settext("Current Velocity: None");
						end;
					end;
				end;
				SpeedModChangedMessageCommand=function(self,params)
					if params.Player == pn and currentOpList == "SpeedMods" then
						self:playcommand("UpdateText",params);
					end;
				end;
				AdjustCommand=function(self,params)
					if currentOpList == "SongMenu" then
						if params.Selection == 5 then
							self:playcommand("UpdateText",params);
							self:visible(true);
						else
							self:visible(false);
						end;
					end;
				end;
				OptionsListRightMessageCommand=function(self,params)
					if params.Player == pn then
						self:playcommand("Adjust",params);
					end;
				end;
				OptionsListLeftMessageCommand=function(self,params)
					if params.Player == pn then
						self:playcommand("Adjust",params);
					end;
				end;
			};
			--For the combo judgement only
			Def.Sprite{
				InitCommand=cmd(y,SCREEN_CENTER_Y-116;draworder,999;zoom,.8);
				OptionsMenuChangedMessageCommand=function(self,params)
					if params.Player == pn then
						if params.Menu == "JudgmentType" then
							if ActiveModifiers[pname(pn)]["JudgmentGraphic"] ~= "None" then
								self:Load(THEME:GetPathG("Judgment", ActiveModifiers[pname(pn)]["JudgmentGraphic"])):SetAllStateDelays(1);
							end;
							self:stoptweening():visible(true)--[[:diffusealpha(0):linear(.2):diffusealpha(1)]];
						else
							self:visible(false)
						end;
					end;
				end;
				AdjustCommand=function(self,params)
					if params.Player == pn and currentOpList == "JudgmentType" then
						if params.Selection == #OptionRowJudgmentGraphic().Choices then
							self:Load(THEME:GetPathG("Judgment", ActiveModifiers[pname(pn)]["JudgmentGraphic"])):SetAllStateDelays(1);
						elseif OptionRowJudgmentGraphic().judgementFileNames[params.Selection+1] ~= "None" then
							self:Load(THEME:GetPathG("Judgment", OptionRowJudgmentGraphic().judgementFileNames[params.Selection+1])):SetAllStateDelays(1);
						else
							--SCREENMAN:SystemMessage(params.Selection..", "..#OptionRowJudgmentGraphic().Choices)
							self:Load(nil);
						end;
					end;
				end;
				OptionsListRightMessageCommand=function(self, params)
					self:playcommand("Adjust",params);
				end;
				OptionsListLeftMessageCommand=function(self,params)
					self:playcommand("Adjust", params);
				end;
			
			};
			--Using an ActorFrame here causes draworder issues.
			LoadActor(THEME:GetPathB("ScreenSelectMusic","decorations/mods display/optionIcon"))..{
				InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,.75;y,_screen.cy-130;draworder,998);
				OptionsMenuChangedMessageCommand=function(self,params)
					--SCREENMAN:SystemMessage("MenuChanged: Menu="..params.Menu);
					if params.Player == pn then
						if params.Menu == "NoteSkins" then
							self:stoptweening():linear(.3):diffusealpha(1);
						else
							self:diffusealpha(0);
						end;
					end;
				end;
			};
	
			Def.Sprite{
				InitCommand=cmd(x,1;y,_screen.cy-130;draworder,999);
				OptionsMenuChangedMessageCommand=function(self,params)
					if params.Player == pn then
						if params.Menu == "NoteSkins" then
							self:playcommand("On")
							self:stoptweening():linear(.3):diffusealpha(1);
						else
							self:diffusealpha(0);
						end;
					end;
				end;
				OnCommand=function(self)
					local arrow = "UpLeft";
					local name = "Tap note";
					local highlightedNoteSkin = CurrentNoteSkin(pn);
					local path-- 
					if not path then
						if highlightedNoteSkin == "delta" then
							name = "Ready Receptor";
						elseif highlightedNoteSkin == "delta-note" or string.ends(highlightedNoteSkin, "rhythm") then
							arrow = "_UpLeft";
						end
						path = NOTESKIN:GetPathForNoteSkin(arrow, name, CurrentNoteSkin(pn));
					end
					
					self:Load(path);
					self:croptop(0);
					self:cropright(0);
					self:zoom(0.35);
				end;
				AdjustCommand=function(self,params)
					if params.Player == pn then
						if params.Selection < OPTIONSLIST_NUMNOTESKINS then
							local highlightedNoteSkin = OPTIONSLIST_NOTESKINS[params.Selection+1];
							local arrow = "UpLeft";
							local name = "Tap note";
							local path-- = NOTESKIN:GetPathForNoteSkin("", "__RIO_THUMB", highlightedNoteSkin);
							if not path then
								if highlightedNoteSkin == "delta" then
									name = "Ready Receptor";
								elseif highlightedNoteSkin == "delta-note" or string.ends(highlightedNoteSkin, "rhythm") then
									arrow = "_UpLeft";
								end
								path = NOTESKIN:GetPathForNoteSkin(arrow, name, highlightedNoteSkin);
							end
							self:Load(path);
							self:croptop(0);
							self:cropright(0);
							self:zoom(0.35);
						else
							self:playcommand("On");
						end;
					end;
				end;
				OptionsListRightMessageCommand=function(self,params)
					self:playcommand("Adjust",params);
				end;
				OptionsListLeftMessageCommand=function(self,params)
					self:playcommand("Adjust",params);
				end;
			};
		};
	end;
end;
return t;
