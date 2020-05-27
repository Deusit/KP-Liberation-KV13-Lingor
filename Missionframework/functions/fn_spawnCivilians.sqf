/*
    File: fn_spawnCivilians.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-12-03
    Last Update: 2020-05-25
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns civilians at given sector.

    Parameter(s):
        _sector - Sector to spawn the civilians at [STRING, defaults to ""]

    Returns:
        Spawned civilian units [ARRAY]
*/

params [
    ["_sector", "", [""]]
];

if (_sector isEqualTo "") exitWith {["Empty string given"] call BIS_fnc_error; []};

private _civs = [];
private _sPos = markerPos _sector;

// Amount and spread depending if capital or city/factory
private _amount = round ((3 + (floor (random 7))) * KPLIB_param_civActivity);
private _spread = 1;
if (_sector in KPLIB_sectors_capital) then {
    _amount = _amount + 10;
    _spread = 2.5;
};
_amount = _amount * (sqrt (KPLIB_param_unitcap));

// Spawn civilians
private _grp = grpNull;
for "_i" from 1 to _amount do {
    _grp = createGroup [KPLIB_side_civilian, true];

    _civs pushBack (
        [
            selectRandom KPLIB_c_units,
            [(((_sPos select 0) + (75 * _spread)) - (random (150 * _spread))), (((_sPos select 1) + (75 * _spread)) - (random (150 * _spread))), 0],
            _grp
        ] call KPLIB_fnc_createManagedUnit
    );

    [_grp] call add_civ_waypoints;
};

_civs
