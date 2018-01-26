--global variables
Global = {
    realW = 0, realH = 0,
    delta = 0, debounce = 0,
    mouseX = 0, mouseY = 0, wheel = 0,
    screen = "",
    ratio = "",
    state = "",
    substate = {
        [PLAYER_1] = "",
        [PLAYER_2] = "",
    },
    oplist = {
        [PLAYER_1] = false,
        [PLAYER_2] = false,
    },
    allgroups = {
        -- ["Name"] = "string"
        -- ["Songs"] = { Songs }
        -- ["Count"] = 0
    },
    songgroup = "",
    songlist = {},
    song = nil,
    selection = 1,
    level = 1,
    confirm = {
        [PLAYER_1] = 0,
        [PLAYER_2] = 0,
    },
    players = 1,
    master = "",
    mastersteps = nil,
    steps = {},
    pnsteps = {
        [PLAYER_1] = 1,
        [PLAYER_2] = 1,
    },
    pnselection = {
        [PLAYER_1] = 1,
        [PLAYER_2] = 1,
    },
    pncursteps = {
        [PLAYER_1] = nil,
        [PLAYER_2] = nil,
    },
    pnskin = {
        [PLAYER_1] = -1,
        [PLAYER_2] = -1,
    },
    piuscoring = {
        [PLAYER_1] = 0,
        [PLAYER_2] = 0,
    },
    volume = 1,
    blockjoin = false,
    prevstate = "",
    toggle = false,
    bgcolor = {0.66,0.68,0.7,1},
    lockinput = false,
    disqualify = false,
};

function ResetState()
    Global.confirm = {
        [PLAYER_1] = 0,
        [PLAYER_2] = 0,
    };
    Global.oplist = {
        [PLAYER_1] = false,
        [PLAYER_2] = false,
    };
    Global.mastersteps = nil;
    Global.steps = {};
    Global.pnselection = {
        [PLAYER_1] = 1,
        [PLAYER_2] = 1,
    };
    Global.pnskin = {
        [PLAYER_1] = -1,
        [PLAYER_2] = -1,
    };
    Global.piuscoring = {
        [PLAYER_1] = 0,
        [PLAYER_2] = 0,
    };
    Global.volume = 1;
    Global.disqualify = false;
    Global.blockjoin = false;

end;