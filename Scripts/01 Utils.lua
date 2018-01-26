themeVersion = 0.9;

--Because it's useful
function Actor:Cover()
	self:scaletocover(0,0,SCREEN_RIGHT,SCREEN_BOTTOM);
end;

--PIU D.N.R. Credits!
local main_credits = {
	name="Pump It Up Delta NEX Rebirth",
	{logo= "RL", name= "Programmed by Rhythm Lunatic"},
	"New graphics by Joao Almeida",
	"Advertisement & Ideas by Jakub Throo Prymus",
	"Special Thanks to LogosPump",
	"Special Thanks to DDR SN3 Team",
	"Special Thanks to Andamiro & Bemani"
};
StepManiaCredits.AddSection(main_credits);

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

