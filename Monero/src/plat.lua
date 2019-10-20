
local plat = {
    DIR_SEP = string.sub(package.config, 1, 1),
    PATH_SEP = string.sub(package.config, 3, 3),
}

local PLATFORM_MAP = {
    ['\\'] = 'WINDOWS',
    ['/'] = 'UNIX',
}


local PLAT_PARAMS = {
    NULL_DEV = {
        WINDOWS = 'nul',
        UNIX = '/dev/null',
    },
}


function plat.getPlatform()
    return PLATFORM_MAP[plat.DIR_SEP]
end


function plat.getParam(name)
    return PLAT_PARAMS[name][plat.getPlatform()]
end


return plat
