-- the new protiming (originally implemented in sm-ssc test theme 1)
local Player = ...
assert(Player,"Needs player")

local timingWindows = {
	W1 = { Secs = PREFSMAN:GetPreference("TimingWindowSecondsW1"), Color = TapNoteScoreColor('TapNoteScore_W1'), Layer = 90 },
	W2 = { Secs = PREFSMAN:GetPreference("TimingWindowSecondsW2"), Color = TapNoteScoreColor('TapNoteScore_W2'), Layer = 89 },
	W3 = { Secs = PREFSMAN:GetPreference("TimingWindowSecondsW3"), Color = TapNoteScoreColor('TapNoteScore_W3'), Layer = 88 },
	W4 = { Secs = PREFSMAN:GetPreference("TimingWindowSecondsW4"), Color = TapNoteScoreColor('TapNoteScore_W4'), Layer = 87 },
	W5 = { Secs = PREFSMAN:GetPreference("TimingWindowSecondsW5"), Color = TapNoteScoreColor('TapNoteScore_W5'), Layer = 86 },
	Miss = { Secs = 0, Color = TapNoteScoreColor('TapNoteScore_Miss'), Layer = 0 },
};

local timingScale = PREFSMAN:GetPreference("TimingWindowScale")
local maxWidth = SCREEN_WIDTH; -- this is scaled by REALLY LOW NUMBERS! omg.
local realMaxWidth = (timingWindows.W5.Secs*maxWidth)/1.5;
local barHeight = 2.5;

local c;
local t = Def.ActorFrame{};

local judge = Def.ActorFrame {
	Def.Quad{
		Name="JudgeFrame";
		InitCommand=cmd(diffuse,color("0,0,0,1");zoomto,((realMaxWidth)*1.5)+4,barHeight+4;visible,false);
	};
	Def.Quad{
		Name="TimingDot";
		InitCommand=function(self)
			self:zoomto(2.5,8);
			self:draworder(99);
			self:diffusealpha(0);	
		end;
	};
	LoadFont("venacti/_venacti 15px bold")..{
		Text="EARLY";
		InitCommand=cmd(diffusealpha,0;x,-(realMaxWidth/2);y,barHeight+2;halign,0;valign,0;zoom,0.5;shadowlength,1);
		JudgmentMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,1;decelerate,0.25;diffusealpha,0);
	};
	LoadFont("venacti/_venacti 15px bold")..{
		Text="LATE";
		InitCommand=cmd(diffusealpha,0;x,(realMaxWidth/2);y,barHeight+2;halign,1;valign,0;zoom,0.5;shadowlength,1);
		JudgmentMessageCommand=cmd(stoptweening;diffusealpha,1;sleep,1;decelerate,0.25;diffusealpha,0);
	};
	InitCommand = function(self)
		c = self:GetChildren();
	end;
	OnCommand=function(self)
		if TopScreen():GetName() ~= "ScreenEdit" or TopScreen():GetName() ~= "ScreenPractice" then
			(cmd(addy,-SCREEN_HEIGHT;sleep,5;decelerate,1;addy,SCREEN_HEIGHT))(self)
		end;
	end;
	OffCommand=cmd(sleep,1.25;accelerate,1;addy,SCREEN_HEIGHT);

	JudgmentMessageCommand=function(self, param)
		if param.Player ~= Player then return end;
		if param.HoldNoteScore then
		c.TimingDot:x(0);
		end;
		if not param.TapNoteScore then return end;
		local TapNoteOffset = param.TapNoteOffset;

		--[[
		c.JudgeFrame:stoptweening();
		c.JudgeFrame:diffusealpha(1);
		c.JudgeFrame:decelerate(0.1);
		c.JudgeFrame:sleep(1);
		c.JudgeFrame:decelerate(0.25);
		c.JudgeFrame:diffusealpha(0);
		]]


		c.TimingDot:stoptweening();
		c.TimingDot:diffusealpha(1);
		c.TimingDot:decelerate(0.1);
		c.TimingDot:x( scale(TapNoteOffset, -timingWindows.W5.Secs, timingWindows.W5.Secs, -realMaxWidth/2, realMaxWidth/2) );
		c.TimingDot:sleep(1);
		c.TimingDot:decelerate(0.25);
		c.TimingDot:diffusealpha(0);
	end;
};

for k,v in pairs(timingWindows) do



	judge[#judge+1] = Def.Quad{
		Name=k.."WindowBack";
		InitCommand=function(self)
			--self:diffuse(v.Color);
			self:diffuse(0.3,0.5,1,1);
			self:faderight(0.2);
			self:fadeleft(0.2);
			self:draworder(v.Layer);
			self:zoomto((v.Secs*maxWidth)*timingScale,2);
			self:diffusealpha(0);
			self:blend(Blend.Add);
		end;
		JudgmentMessageCommand=cmd(stoptweening;diffusealpha,0.8;sleep,1;decelerate,0.25;diffusealpha,0);
	};



end;

t[#t+1] = judge;

return t;