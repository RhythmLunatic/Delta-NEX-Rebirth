local function IntegerToMenu(pos)
	--Junk by retards who don't know what an array is
	--[[if int == 0 then return "Rank",144 end;
	if int == 1 then return "Speed",0 end;
	if int == 2 then return "NoteSkins",32 end;
	if int == 3 then return "Display",16 end;
	if int == 4 then return "Path",64 end;
	if int == 5 then return "Judge",87 end;
	if int == 6 then return "AlterNate",80 end;
	if int == 7 then return "Rush",112 end;]]
	local a = {
		{"Rank", 144},
		{"Speed", 0},
		{"NoteSkins",32},
		{"Display",16},
		{"Path", 64},
		{"Judge", 87},
		{"AlterNate", 80},
		{"Rush", 112},
	}
	return a[pos];
end;

local function NewState(sMenu,iCurrent,pn)
	local menu,iMin = IntegerToMenu(sMenu);
	local metric = string.split(THEME:GetMetric("CommandWindow",menu),",");
	local index = iCurrent - (iCurrent >= 158 and 158 or iMin); 
	index = (index > #metric-1 and index-#metric or index	);
	
	for x=1,32,1 do
		index = (index > #metric-1 and index-(#metric-1) or index);
	end;	
		
	if index > #metric-1 then
		return 158
	end;
		
	if metric[index+1] and metric[index+1] ~= "lua" then		
		if UsingMod(pn,metric[index+1]) then
			return iMin+index
		else
			return 158
		end;
	else
		return 158
	end;
end;

AnimRatio = 1;

local t = Def.ActorFrame{}

for P=1,2,1 do

	for I=0,3,1 do
		
		local PN = P==1 and PLAYER_1 or PLAYER_2
		local PosX = P==1 and SCREEN_LEFT+25 or SCREEN_RIGHT-25
		
		t[#t+1] = Def.ActorFrame{
			LoadActor("AllPrime")..{
				OnCommand=cmd(zoom,.7;x,PosX;y,SCREEN_CENTER_Y-120+(I*33);setstate,158;animate,false;queuecommand,"Update");
				AnimateCommand=cmd(sleep,AnimRatio;playcommand,"Update";queuecommand,"Animate");
				CWPushModMessageCommand=cmd(playcommand,"Update");
				UpdateCommand=function(self)
					if PlayerJoined(PN) == false then
						self:diffusealpha(0);
					else
						self:diffusealpha(1);
					end;
					local st = self:GetState();
					for x=1,33,1 do					
						local nst = NewState(I,st+x,PN)
						if st == 16 and x == 1 then	
							--MSG("Vanish, next to: " ..st+x);
						end;
						if nst ~= 158 then
							self:stoptweening();
							self:setstate(nst);
							self:sleep(AnimRatio);
							self:queuecommand("Animate");
							break;
						end;
						if x==33 then self:setstate(158); end;
					end;
				end;
			};
		};	
		
		t[#t+1] = Def.ActorFrame{
			LoadActor("_flash")..{
				OnCommand=cmd(x,PosX;y,SCREEN_CENTER_Y-122+(I*33);zoom,.5;diffusealpha,0;blend,"BlendMode_Add");
				CWPushModMessageCommand=cmd(queuecommand,"Update");
				CWPushModMessageCommand=function(self,params)
					if params.Menu == IntegerToMenu(I) and params.Player == PN then
						(cmd(stoptweening;zoom,.5;diffusealpha,.5;linear,.2;diffusealpha,1;zoom,.6;linear,.1;diffusealpha,0))(self);
					end;
				end;
			};
		};
		
	end;
	
end;
		
return t;
