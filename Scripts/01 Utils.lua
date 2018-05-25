themeVersion = 0.95;

--Because it's useful
function Actor:Cover()
	self:scaletocover(0,0,SCREEN_RIGHT,SCREEN_BOTTOM);
end;

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

--Called from ScreenInit background
function resetGame()
	inBasicMode = nil;
	all_channels_unlocked = nil;
end;

function ternary(cond, T, F)
    if cond then return T else return F end
end

function GetGradeFromDancePoints(dancepoints)
	 --SS aka perfect score
	if dancepoints == 100 then
		return "Tier00";
	--S
	elseif dancepoints >= 99 then
		return "Tier01";
	--Silver S
	elseif misses==0 then
		return "Tier02";
	--A
	elseif dancepoints >= 80 then
		return "Tier03";
	--B
	elseif dancepoints >= 70 then
		return "Tier04";
	--C
	elseif dancepoints >= 60 then
		return "Tier05";
	--D
	elseif dancepoints >= 50 then
		return "Tier06";
	--F
	else
		return "Tier07";
	end
end;


function ListActorChildren(frame)
	if frame:GetNumChildren() == 0 then
		return "No children in frame.";
	end
	local list = frame:GetNumChildren().." children: ";
	local children = frame:GetChildren()
	for key,value in pairs(children) do
		list = list..key..", ";
	end
	return list;
end

--PIU D.N.R. Credits!
local main_credits = {
	name="Pump It Up Delta NEX Rebirth",
	{logo= "RL", name= "Programmed by Rhythm Lunatic"},
	"Feature ideas by Jakub Throo Prymus",
	"New graphics by Joao Almeida",
	"Special Thanks to LogosPump",
	"Special Thanks to Midflight Digital (DDR SN3 TEAM)",
	"Special Thanks to Andamiro & Bemani"
};
StepManiaCredits.AddSection(main_credits);

local orig_credits = {
	name = "Pump It Up Delta",
	"Created by Luizsan"
}
StepManiaCredits.AddSection(orig_credits);

local prog_credits = {
	name = "Delta Programmers",
	"AJ",
	"Shakesoda",
	"Midiman",
	"TeruFSX",
	"DaisuMaster",
	"Saturn2888"
}
StepManiaCredits.AddSection(prog_credits);

local beta_credits = {
	name = "Delta Beta Testers",
	"Keoma",
	"Aegis",
	"[mDM] Cesar",
	"Meck",
	"Keb Kab"
}
StepManiaCredits.AddSection(beta_credits);

local noteskin_credits = {
	name = "Delta Noteskin",
	"Keoma",
	"Aegis"
}
StepManiaCredits.AddSection(noteskin_credits);

local sounds_credits = {
	name = "Delta & Delta NEX sounds",
    "D_Trucks",
    "Sanxion7 (flashkit.com)",
    "Andamiro",
    "Kors K as StripE"
}
StepManiaCredits.AddSection(sounds_credits);

local ideas_credits = {
	name = "Delta Ideas",
	"Keoma",
	"Meck",
	"Keb Kab"
}		
StepManiaCredits.AddSection(ideas_credits);

