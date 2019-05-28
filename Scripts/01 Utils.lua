themeVersion = "0.97 RC1";

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

--From https://stackoverflow.com/a/19263313
--This does not work with periods for some mysterious reason
function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end

--Called from ScreenInit background
function resetGame()
	inBasicMode = nil;
	all_channels_unlocked = nil;
	ActiveModifiers = {
		P1 = table.shallowcopy(PlayerDefaults),
		P2 = table.shallowcopy(PlayerDefaults),
		MACHINE = table.shallowcopy(PlayerDefaults),
	}
end;

--[[function ternary(cond, T, F)
    if cond then return T else return F end
end]]

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

--Adds commas to your score, apparently
function scorecap(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

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
StepManiaCredits.AddSection({
	name="Pump It Up Delta 2",
	{logo= "RL", name= "Programmed by Rhythm Lunatic"},
	"Ideas & testing by Jakub Throo Prymus",
	"New graphics by Joao Almeida",
	"Delta NEX Rebirth logo by LogosPump",
	"Autogen Basic Mode by Midflight Digital (DDR SN3 Team)",
	"Special Thanks to Andamiro & Bemani"
});

StepManiaCredits.AddSection({
	name="Pump It Up Delta NEX",
	"by Schranz Conflict"
})

StepManiaCredits.AddSection({
	name = "Pump It Up Delta",
	"Created by Luizsan"
});

StepManiaCredits.AddSection({
	name = "Delta Programmers",
	"AJ",
	"Shakesoda",
	"Midiman",
	"TeruFSX",
	"DaisuMaster",
	"Saturn2888"
});

StepManiaCredits.AddSection({
	name = "Delta Beta Testers",
	"Keoma",
	"Aegis",
	"[mDM] Cesar",
	"Meck",
	"Keb Kab"
});

StepManiaCredits.AddSection({
	name = "Delta Noteskin",
	"Keoma",
	"Aegis"
});

StepManiaCredits.AddSection({
	name = "Delta & Delta NEX sounds",
    "D_Trucks",
    "Sanxion7 (flashkit.com)",
    "Andamiro",
    "Kors K as StripE"
});

StepManiaCredits.AddSection({
	name = "Delta Ideas",
	"Keoma",
	"Meck",
	"Keb Kab"
});
