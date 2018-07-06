local player = ...
local pos = (player == PLAYER_1) and -1 or 1; --ternary

local mainMenuIndex = 0;

local Scroll = {

	-- MainMenu State
	MainMenuSpeed =8;
	MainMenuDisplay = 7;
	MainMenuNoteSkins = 6;
	MainMenuPath = 5;
	MainMenuAlterNate = 4;
	MainMenuJudge = 3;
	MainMenuRush = 2;
	MainMenuRank = 1;	
	MainMenuReset = 0;	
	
	-- Speed State
	SpeedMin=0;
	SpeedMax=11;	
	
	--Display State
	DisplayMin=16;
	DisplayMax=22;
	
	--NoteSkins State
	NoteSkinsMin=32;
	NoteSkinsMax=63;
	
	--Path
	PathMin=64;
	PathMax=71;
	
	--AlterNate State
	AlterNateMin=80;
	AlterNateMax=81;	
		
	--Judge State
	JudgeMin=87;
	JudgeMax=88;	
	
	--Rush State
	RushMin=112;
	RushMax=118;
	
	ResetMin=97;
	ResetMax=97;
	
	RankMin=144;
	RankMax=144;
};

local t = Def.ActorFrame{}

t[#t+1] = Def.ActorFrame{
	--InitCommand=cmd(y,SCREEN_CENTER_Y-30;zoom,.65);
	InitCommand=cmd(xy,SCREEN_CENTER_X+(SCREEN_CENTER_X+100)*pos,SCREEN_CENTER_Y-90;zoom,.65);
	CommandWindowOpenedMessageCommand=function(self,params)
		if params.Player == player then
			self:decelerate(.5):addx(-220*pos):queuecommand("LockInput");
		end;
	end;
	CommandWindowClosedMessageCommand=function(self,params)
		if params.Player == player then
			self:accelerate(.5):addx(220*pos)
		end;
	end;
	LockInputCommand=function(self)
		SCREENMAN:set_input_redirected(player,true);
	end;
	Def.ActorFrame{
		--InitCommand=cmd(x,SCREEN_RIGHT-410);
		LoadActor("BasePrime")..{
			--InitCommand=cmd(zoom,1.3);
		};
		LoadActor("PrimeUpFrame")..{			
			InitCommand=cmd(y,-41);
			CWChangeMenuMessageCommand=function(self,params)
				if params.Player == player then
					if params.Menu == "MainMenu" then
						(cmd(stoptweening;linear,.1;y,-41))(self)
					else
						(cmd(stoptweening;linear,.1;y,-9))(self)
					end;					
				end;
			end;
		};	
		LoadActor("PrimeUpGlow")..{
			InitCommand=cmd(y,5;diffusealpha,0;blend,"BlendMode_Add");
			CWChangeIndexMessageCommand=function(self,params)
				if params.Player == player then			
					if params.Direccion == -1 then
						(cmd(stoptweening;diffusealpha,.5;faderight,0;fadeleft,0;linear,.4;faderight,5;diffusealpha,0;))(self)
					elseif params.Direccion == 1 then
						(cmd(stoptweening;diffusealpha,.5;fadeleft,0;faderight,0;linear,.4;fadeleft,5;diffusealpha,0))(self)
					end;
				end;
			end;
			CWChangeMenuMessageCommand=function(self,params)
				if params.Player == player then
					if params.Menu == "MainMenu" then
						(cmd(stoptweening;diffusealpha,.75;fadeleft,.1;faderight,.1;linear,.3;fadeleft,2;faderight,2;y,0;diffusealpha,0;))(self)
					else
						(cmd(stoptweening;diffusealpha,.75;fadeleft,.1;faderight,.1;linear,.3;fadeleft,2;faderight,2;y,30;diffusealpha,0;))(self)
					end;					
				end;
			end;
		};		
		LoadActor("PrimeGlow")..{
			InitCommand=cmd(diffusealpha,0;blend,"BlendMode_Add");
			CWChangeIndexMessageCommand=function(self,params)
				if params.Player == player then			
					if params.Direccion == -1 then
						(cmd(stoptweening;diffusealpha,.5;faderight,0;fadeleft,0;linear,.4;faderight,5;diffusealpha,0;))(self)
					elseif params.Direccion == 1 then
						(cmd(stoptweening;diffusealpha,.5;fadeleft,0;faderight,0;linear,.4;fadeleft,5;diffusealpha,0))(self)
					end;
				end;
			end;
			CWChangeMenuMessageCommand=function(self,params)
				if params.Player == player then
					(cmd(stoptweening;diffusealpha,.5;fadeleft,.1;faderight,.1;linear,.3;fadeleft,2;faderight,2;diffusealpha,0;))(self)
				end;
			end;
		};
		LoadActor("MainMenuPrime")..{
			OnCommand=cmd(animate,false;zoom,1.1;y,-40;setstate,8);
			CWChangeIndexMessageCommand=function(self,params)
				if params.Player == player then			
					if params.Menu == "MainMenu" then
						if params.Direccion == -1 then
							(cmd(stoptweening;diffusealpha,1;x,-90;rotationy,-75;linear,.1;x,0;rotationy,0;setstate,Scroll[params.Menu..params.Text]))(self)
						elseif params.Direccion == 1 then
							(cmd(stoptweening;diffusealpha,1;x,90;rotationy,75;linear,.1;x,0;rotationy,0;setstate,Scroll[params.Menu..params.Text]))(self)
						else
							(cmd(stoptweening;diffusealpha,1;linear,.1;y,-40;setstate,Scroll[params.Menu..params.Text]))(self)
						end;
					end;
				end;
			end;
			CWChangeMenuMessageCommand=function(self,params)
				if params.Player == player then
					if params.Menu == "MainMenu" then
						(cmd(stoptweening;linear,.1;y,-40))(self)
					else
						(cmd(stoptweening;linear,.1;y,-10))(self)
					end;
				end;
			end;
		};
		
		LoadActor("MainMenuPrime")..{
			OnCommand=cmd(animate,false;zoom,1.1;x,-90;rotationy,-70;y,-40;setstate,8);
			CWChangeIndexMessageCommand=function(self,params)	
				if params.Player == player then
					if params.Menu == "MainMenu" then
						local iState = Scroll[params.Menu..params.Text]+1;
						iState = (iState > 8 and 0 or (iState < 0 and 8 or iState));
						if params.Direccion == -1 then
							(cmd(stoptweening;diffusealpha,0;x,-180;linear,.1;x,-90;linear,.05;rotationy,-70;diffusealpha,1;setstate,iState))(self)
						elseif params.Direccion == 1 then
							(cmd(stoptweening;diffusealpha,1;x,0;linear,.1;x,-90;setstate,iState))(self)
						else
							(cmd(setstate,iState))(self)
						end;
					end;
				end;
			end;
			CWChangeMenuMessageCommand=function(self,params)	
				if params.Player == player then
					if params.Menu == "MainMenu" then
						(cmd(stoptweening;linear,.1;y,-40))(self)
					else
						(cmd(stoptweening;linear,.1;y,-10))(self)
					end;
				end;
			end;
		};
		
		LoadActor("MainMenuPrime")..{
			OnCommand=cmd(animate,false;zoom,1.1;x,90;rotationy,70;y,-40;setstate,1);
			CWChangeIndexMessageCommand=function(self,params)	
				if params.Player == player then
					if params.Menu == "MainMenu" then
						local iState = Scroll[params.Menu..params.Text]-1;
						iState = (iState > 8 and 0 or (iState < 0 and 8 or iState));
						if params.Direccion == -1 then
							(cmd(stoptweening;diffusealpha,1;x,0;linear,.1;x,90;setstate,iState))(self)
						elseif params.Direccion == 1 then
							(cmd(stoptweening;diffusealpha,0;x,90;linear,.1;x,90;linear,.05;rotationy,70;diffusealpha,1;setstate,iState))(self)
						else
							(cmd(setstate,iState))(self)
						end;
					end;
				end;
			end;
			CWChangeMenuMessageCommand=function(self,params)	
				if params.Player == player then
					if params.Menu == "MainMenu" then
						(cmd(stoptweening;linear,.1;y,-40))(self)
					else
						(cmd(stoptweening;linear,.1;y,-10))(self)
					end;
				end;
			end;
		};
		
		LoadActor("CursorArrow")..{
			InitCommand=cmd(zoomx,1;zoomy,.9;y,-40);
			CWChangeIndexMessageCommand=function(self,params)	
				if params.Player == player then
					(cmd(zoomx,.7;zoomy,.7;linear,.2;zoomx,0.8;zoomy,.8))(self);
				end;
			end;
			CWChangeMenuMessageCommand=function(self,params)	
				if params.Player == player then
					if params.Menu ~= "MainMenu" then
						(cmd(stoptweening;linear,.1;diffusealpha,0))(self)	
					else
						(cmd(stoptweening;linear,.1;diffusealpha,1))(self)
					end;
				end;
			end;
		};
		
	};
	
	LoadFont("Common Normal")..{
		InitCommand=cmd(y,60;zoom,.7;settext,THEME:GetString("CommandWindow","Speed"));
		CWChangeIndexMessageCommand=function(self,params)
			if params.Player == player then
				if params.Menu == "MainMenu" then
					self:settext(THEME:GetString("CommandWindow",params.Text));
				else
					self:settext(params.Menu);
				end
			end;
		end;
	};
	
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_RIGHT-410;y,-70;diffusealpha,0);
		CWChangeMenuMessageCommand=function(self,params)	
			if params.Player == player then
				if params.Menu == "MainMenu" then
					(cmd(stoptweening;linear,.1;diffusealpha,0))(self)	
				else
					(cmd(stoptweening;linear,.1;diffusealpha,1))(self)
				end;
			end;
		end;
		
		LoadActor("PrimeUpFrame")..{			
			InitCommand=cmd(y,-1);
			CWChangeMenuMessageCommand=function(self,params)
				if params.Player == player then
					if params.Menu == "MainMenu" then
						(cmd(stoptweening;linear,.1;y,-1))(self)
					else
						(cmd(stoptweening;linear,.1;y,-1))(self)
					end;					
				end;
			end;
		};	
		LoadActor("PrimeUpGlow")..{
			InitCommand=cmd(y,40;diffusealpha,0;blend,"BlendMode_Add");
			CWChangeIndexMessageCommand=function(self,params)
				if params.Player == player then			
					if params.Direccion == -1 then
						(cmd(stoptweening;diffusealpha,.5;faderight,0;fadeleft,0;linear,.4;faderight,5;diffusealpha,0;))(self)
					elseif params.Direccion == 1 then
						(cmd(stoptweening;diffusealpha,.5;fadeleft,0;faderight,0;linear,.4;fadeleft,5;diffusealpha,0))(self)
					end;
				end;
			end;
			CWChangeMenuMessageCommand=function(self,params)
				if params.Player == player then
					if params.Menu == "MainMenu" then
						(cmd(stoptweening;diffusealpha,.75;fadeleft,.1;faderight,.1;linear,.3;fadeleft,2;faderight,2;y,0;diffusealpha,0;))(self)
					else
						(cmd(stoptweening;diffusealpha,.75;fadeleft,.1;faderight,.1;linear,.3;fadeleft,2;faderight,2;y,40;diffusealpha,0;))(self)
					end;					
				end;
			end;
		};	
			
		LoadActor("AllPrime")..{
			OnCommand=cmd(animate,false;y,-1);
			CWChangeIndexMessageCommand=function(self,params)	
				if params.Player == player then
					if params.Menu ~= "MainMenu" then
						if params.Direccion == -1 then
							(cmd(stoptweening;diffusealpha,1;x,-75;linear,.1;x,0;setstate,Scroll[params.Menu.."Min"]+params.Index + (UsingMod(PLAYER_2,params.Text) and 0 or 160)))(self)
						elseif params.Direccion == 1 then
							(cmd(stoptweening;diffusealpha,1;x,75;linear,.1;x,0;setstate,Scroll[params.Menu.."Min"]+params.Index + (UsingMod(PLAYER_2,params.Text) and 0 or 160)))(self)
						else
							(cmd(setstate,Scroll[params.Menu.."Min"]+params.Index + (UsingMod(PLAYER_2,params.Text) and 0 or 160)))(self)
						end;
					end;
				end;
			end;
		};
		
		LoadActor("AllPrime")..{
			OnCommand=cmd(animate,false;x,-75;y,-1);
			CWChangeIndexMessageCommand=function(self,params)	
				if params.Player == player then
					if params.Menu ~= "MainMenu" then
						local iState = Scroll[params.Menu.."Min"]+params.Index-1;
						local TextMod =string.split(THEME:GetMetric("CommandWindow",params.Menu),",");
						iState = (iState > Scroll[params.Menu.."Max"] and Scroll[params.Menu.."Min"] or (iState < Scroll[params.Menu.."Min"] and Scroll[params.Menu.."Max"] or iState));
						if params.Direccion == -1 then
							(cmd(stoptweening;diffusealpha,0;x,-150;linear,.1;x,-75;linear,.05;diffusealpha,1;setstate,iState + (UsingMod(PLAYER_2,TextMod[params.Index == 0 and #TextMod or params.Index]) and 0 or 160)))(self)
						elseif params.Direccion == 1 then
							(cmd(stoptweening;diffusealpha,1;x,0;linear,.1;x,-75;setstate,iState + (UsingMod(PLAYER_2,TextMod[params.Index == 0 and #TextMod or params.Index]) and 0 or 160)))(self)
						else
							(cmd(setstate,iState + (UsingMod(PLAYER_2,TextMod[params.Index == 0 and #TextMod or params.Index]) and 0 or 160)))(self)
						end;
					end;
				end;
			end;
		};
		
		LoadActor("AllPrime")..{
			OnCommand=cmd(animate,false;x,75;y,-1);
			CWChangeIndexMessageCommand=function(self,params)	
				if params.Player == player then
					if params.Menu ~= "MainMenu" then
						local iState = Scroll[params.Menu.."Min"]+params.Index+1;
						local TextMod =string.split(THEME:GetMetric("CommandWindow",params.Menu),",");
						iState = (iState > Scroll[params.Menu.."Max"] and Scroll[params.Menu.."Min"] or (iState < Scroll[params.Menu.."Min"] and Scroll[params.Menu.."Max"] or iState));
						if params.Direccion == -1 then
							(cmd(stoptweening;diffusealpha,1;x,0;linear,.1;x,75;setstate,iState + (UsingMod(PLAYER_2,(params.Index+1 == #TextMod and TextMod[1] or TextMod[params.Index+2])) and 0 or 160)))(self)
						elseif params.Direccion == 1 then
							(cmd(stoptweening;diffusealpha,0;x,75;linear,.1;x,75;linear,.05;diffusealpha,1;setstate,iState + (UsingMod(PLAYER_2,(params.Index+1 == #TextMod and TextMod[1] or TextMod[params.Index+2])) and 0 or 160)))(self)
						else
							(cmd(setstate,iState + (UsingMod(PLAYER_2,(params.Index+1 == #TextMod and TextMod[1] or TextMod[params.Index+2])) and 0 or 160)))(self)
						end;
					end;
				end;
			end;
		};		
		
		LoadActor("CursorArrow")..{
			InitCommand=cmd(zoomx,0.5;zoomy,.8);
			CWChangeIndexMessageCommand=function(self,params)
				if params.Player == player then
					(cmd(zoomx,.4;zoomy,.7;linear,.2;zoomx,0.5;zoomy,.8))(self);
				end;
			end;
		};		
	};
};

t[#t+1] = Def.ActorFrame{

	LoadActor(THEME:GetPathS("CommandMenu","Appear"))..{
			CWChangeMenuMessageCommand=function(self,params)
				if params.Menu ~= "MainMenu" then				
					(cmd(play))(self);
				end;
			end;
		};
		
		LoadActor(THEME:GetPathS("CommandMenu","Set"))..{
			--CWApplyModMessageCommand=cmd(play);
			CWPushModMessageCommand=cmd(play);
			--CWLuaMessageCommand=cmd(play);
		};
		
		LoadActor(THEME:GetPathS("CommandMenu","Move"))..{
			CWChangeIndexMessageCommand=function(self,params)
				if params.Direccion ~= 0 then				
					(cmd(play))(self);
				end;
			end;
		};
		
		LoadActor(THEME:GetPathS("CommandMenu","InOut"))..{
			CommandWindowOpenedMessageCommand=cmd(play);
			CommandWindowClosedMessageCommand=cmd(play);
		};
		
};

return t;
