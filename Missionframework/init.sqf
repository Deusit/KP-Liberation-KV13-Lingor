
KPLIB_init = false;

// Version of the KP Liberation framework
KP_liberation_version = [0, 96, "7a"];

enableSaving [ false, false ];

if (isDedicated) then {debug_source = "Server";} else {debug_source = name player;};

[] call KPLIB_fnc_initSectors;
if (!isServer) then {waitUntil {!isNil "KPLIB_initServer"};};
[] call compileFinal preprocessFileLineNumbers "scripts\shared\fetch_params.sqf";
[] call compileFinal preprocessFileLineNumbers "kp_liberation_config.sqf";
[] call compileFinal preprocessFileLineNumbers "presets\init_presets.sqf";
[] call compileFinal preprocessFileLineNumbers "kp_objectInits.sqf";

// Activate selected player menu. If CBA isn't loaded -> fallback to GREUH
if (KPPLM_CBA && KP_liberation_playermenu) then {
    [] call KPPLM_fnc_postInit;
} else {
    [] execVM "GREUH\scripts\GREUH_activate.sqf";
};

[] call compileFinal preprocessFileLineNumbers "scripts\shared\init_shared.sqf";

if (isServer) then {
    [] call compileFinal preprocessFileLineNumbers "scripts\server\init_server.sqf";
};

if (!isDedicated && !hasInterface && isMultiplayer) then {
    execVM "scripts\server\offloading\hc_manager.sqf";
};

if (!isDedicated && hasInterface) then {
    // Get mission version and readable world name for Discord rich presence
    [
        ["UpdateDetails", [localize "STR_MISSION_VERSION", "on", getText (configfile >> "CfgWorlds" >> worldName >> "description")] joinString " "]
    ] call (missionNamespace getVariable ["DiscordRichPresence_fnc_update", {}]);

    // Add EH for curator to add kill manager and object init recognition for zeus spawned units/vehicles
    {
        _x addEventHandler ["CuratorObjectPlaced", {[_this select 1] call KPLIB_fnc_handlePlacedZeusObject;}];
    } forEach allCurators;

    waitUntil {alive player};
    if (debug_source != name player) then {debug_source = name player};
    [] call compileFinal preprocessFileLineNumbers "scripts\client\init_client.sqf";
} else {
    setViewDistance 1600;
};

// Execute fnc_reviveInit again (by default it executes in postInit)
if ((isNil {player getVariable "bis_revive_ehHandleHeal"} || isDedicated) && !(bis_reviveParam_mode == 0)) then {
    [] call bis_fnc_reviveInit;
};

// MilSimUnited ===========================================================================

["CargoNet_01_box_F", "InitPost", {
    params ["_vehicle"];
	[_vehicle,3] call ace_cargo_fnc_setSize;
	[_vehicle,2] call ace_cargo_fnc_setSpace;
	["ACE_Wheel", _vehicle] call ace_cargo_fnc_addCargoItem;
	["ACE_Track", _vehicle] call ace_cargo_fnc_addCargoItem;
	[_vehicle, true, [0, 1.5, 0], 0] call ace_dragging_fnc_setCarryable; 
	[_vehicle, true, [0, 1.5, 0], 0] call ace_dragging_fnc_setDraggable; 
	_vehicle setVariable ["ACE_isRepairFacility",1];
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["B_CargoNet_01_ammo_F", "InitPost", {
    params ["_vehicle"];
	[_vehicle,3] call ace_cargo_fnc_setSize;
	[_vehicle, 1200] call ace_rearm_fnc_makeSource;
	[_vehicle, true, [0, 1.5, 0], 0] call ace_dragging_fnc_setCarryable;
	[_vehicle, true, [0, 1.5, 0], 0] call ace_dragging_fnc_setDraggable;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["CargoNet_01_barrels_F", "InitPost", {
    params ["_vehicle"];
	[_vehicle,3] call ace_cargo_fnc_setSize;
    [_vehicle, 1200] call ace_refuel_fnc_makeSource;
	[_vehicle, true, [0, 1.5, 0], 0] call ace_dragging_fnc_setCarryable;
	[_vehicle, true, [0, 1.5, 0], 0] call ace_dragging_fnc_setDraggable;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["RHS_MELB_MH6M", "InitPost", {
    params ["_vehicle"];
	[_vehicle,4] call ace_cargo_fnc_setSpace;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["RHS_MELB_AH6M", "InitPost", {
    params ["_vehicle"];
	[_vehicle,4] call ace_cargo_fnc_setSpace;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["rhsusf_M977A4_BKIT_M2_usarmy_wd", "InitPost", {
    params ["_vehicle"];
	[_vehicle,12] call ace_cargo_fnc_setSpace;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["B_Heli_Transport_03_unarmed_F", "InitPost", {
    params ["_vehicle"];
	[_vehicle,12] call ace_cargo_fnc_setSpace;
	[
		_vehicle,
		["Green",1], 
		true
	] call BIS_fnc_initVehicle;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["RHS_CH_47F", "InitPost", {
    params ["_vehicle"];
	[_vehicle,12] call ace_cargo_fnc_setSpace;
	[
		_vehicle,
		["Green",1], 
		true
	] call BIS_fnc_initVehicle;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["RHS_Mi8mt_vdv", "InitPost", {
    params ["_vehicle"];
	[_vehicle,8] call ace_cargo_fnc_setSpace;
	[
		_vehicle,
		["Green",1], 
		true
	] call BIS_fnc_initVehicle;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["RHS_UH60M", "InitPost", {
    params ["_vehicle"];
	[_vehicle,4] call ace_cargo_fnc_setSpace;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["RHS_Mi8MTV3_heavy_vdv", "InitPost", {
    params ["_vehicle"];
	[_vehicle,4] call ace_cargo_fnc_setSpace;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["B_Boat_Transport_01_F", "InitPost", {
    params ["_vehicle"];
	[_vehicle,3] call ace_cargo_fnc_setSize;
	[_vehicle,3] call ace_cargo_fnc_setSpace;
	[_vehicle, true, [0, 3, 0], 0] call ace_dragging_fnc_setCarryable;
	[_vehicle, true, [0, 3, 0], 0] call ace_dragging_fnc_setDraggable;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["I_C_Boat_Transport_02_F", "InitPost", {
    params ["_vehicle"];
	[_vehicle,4] call ace_cargo_fnc_setSpace;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["B_Boat_Armed_01_minigun_F", "InitPost", {
    params ["_vehicle"];
	[_vehicle,4] call ace_cargo_fnc_setSpace;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["rhsusf_mkvsoc", "InitPost", {
    params ["_vehicle"];
	[_vehicle,12] call ace_cargo_fnc_setSpace;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["rhs_kamaz5350_open_msv", "InitPost", {
    params ["_vehicle"];
	[_vehicle,10] call ace_cargo_fnc_setSpace;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["O_T_MBT_04_command_F", "InitPost", {
    params ["_vehicle"];
	[
	_vehicle,
		["Jungle",1], 
		["showCamonetHull",0,"showCamonetTurret",0]
	] call BIS_fnc_initVehicle;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["rhs_btr80a_msv", "InitPost", {
    params ["_vehicle"];
	_vehicle addEventHandler ["HandleDamage", {  
		private _unit = _this select 0;
		private _hitSelection = _this select 1;
		private _damage = _this select 2;
		if (_hitSelection isEqualTo "") then {(damage _unit) + (_damage * 0.04)} else {(_unit getHit _hitSelection) + (_damage * 0.04)};
	}];
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["O_T_APC_Tracked_02_cannon_ghex_F", "InitPost", {
    params ["_vehicle"];
	_vehicle addEventHandler ["HandleDamage", {  
		private _damage = _this select 2;
		_damage = _damage * 1.25;
		_damage;
	}];
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["I_LT_01_cannon_F", "InitPost", {
    params ["_vehicle"];
	_vehicle setObjectTextureGlobal [0,"A3\armor_f_tank\lt_01\data\lt_01_main_olive_co.paa"];
	_vehicle setObjectTextureGlobal [1,"A3\armor_f_tank\lt_01\data\lt_01_cannon_olive_co.paa"];
	_vehicle setObjectTextureGlobal [2,"A3\Armor_F\Data\camonet_aaf_digi_green_co.paa"];
	_vehicle setObjectTextureGlobal [3,"A3\armor_f\data\cage_olive_co.paa"];
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["I_LT_01_AT_F", "InitPost", {
    params ["_vehicle"];
	_vehicle setObjectTextureGlobal [0,"A3\armor_f_tank\lt_01\data\lt_01_main_olive_co.paa"];
	_vehicle setObjectTextureGlobal [1,"A3\armor_f_tank\lt_01\data\lt_01_at_olive_co.paa"];
	_vehicle setObjectTextureGlobal [2,"A3\Armor_F\Data\camonet_aaf_digi_green_co.paa"];
	_vehicle setObjectTextureGlobal [3,"A3\armor_f\data\cage_olive_co.paa"];
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["I_LT_01_AA_F", "InitPost", {
    params ["_vehicle"];
	_vehicle setObjectTextureGlobal [0,"A3\armor_f_tank\lt_01\data\lt_01_main_olive_co.paa"];
	_vehicle setObjectTextureGlobal [1,"A3\armor_f_tank\lt_01\data\lt_01_at_olive_co.paa"];
	_vehicle setObjectTextureGlobal [2,"A3\Armor_F\Data\camonet_aaf_digi_green_co.paa"];
	_vehicle setObjectTextureGlobal [3,"A3\armor_f\data\cage_olive_co.paa"];
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["Box_NATO_Equip_F", "InitPost", {
    params ["_vehicle"];
	clearItemCargoGlobal _vehicle;
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["B_Slingload_01_Medevac_F", "InitPost", {
    params ["_vehicle"];
	clearItemCargoGlobal _vehicle;
	_vehicle addAction	["Endheilen",{ params ["_target", "_caller", "_actionId", "_arguments"]; [_caller,true] execVM "MilSimUnited\heal.sqf";},nil,1.5,false,true,"","true",5,false,"",""];
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["LOP_SLA_BTR60", "InitPost", {
    params ["_vehicle"];
	_vehicle setObjectTextureGlobal [0,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\btr60_body_cdf_co.paa"];
	_vehicle setObjectTextureGlobal [1,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\btr60_details_cdf_co.paa"];
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["LOP_SLA_BTR70", "InitPost", {
    params ["_vehicle"];
	_vehicle setObjectTextureGlobal [0,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\btr70_cdf_1_co.paa"];
	_vehicle setObjectTextureGlobal [1,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\btr70_cdf_2_co.paa"];
	_vehicle setObjectTextureGlobal [3,"rhsafrf\addons\rhs_btr70\habar\data\sa_gear_02_co.paa"];
	_vehicle setObjectTextureGlobal [4,"rhsafrf\addons\rhs_btr70\habar\data\sa_gear_02_co.paa"];
	_vehicle setObjectTextureGlobal [19,"rhsafrf\addons\rhs_decals\data\numbers\cdf\8_ca.paa"];
	_vehicle setObjectTextureGlobal [20,"rhsafrf\addons\rhs_decals\data\numbers\cdf\5_ca.paa"];
	_vehicle setObjectTextureGlobal [21,"rhsafrf\addons\rhs_decals\data\numbers\cdf\3_ca.paa"];
	_vehicle setObjectTextureGlobal [22,"rhsafrf\addons\rhs_decals\data\numbers\cdf\5_ca.paa"];
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["LOP_SLA_BMP1D", "InitPost", {
    params ["_vehicle"];
	_vehicle setObjectTextureGlobal [0,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_1_cdf_co.paa"];
	_vehicle setObjectTextureGlobal [1,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_2_cdf_co.paa"];
	_vehicle setObjectTextureGlobal [2,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_3_cdf_co.paa"];
	_vehicle setObjectTextureGlobal [3,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_4_cdf_co.paa"];
	_vehicle setObjectTextureGlobal [4,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_5_cdf_co.paa"];
	_vehicle setObjectTextureGlobal [5,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_6_cdf_co.paa"];
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["LOP_SLA_BMP2D", "InitPost", {
    params ["_vehicle"];
	_vehicle setObjectTextureGlobal [0,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_1_cdf_co.paa"];
	_vehicle setObjectTextureGlobal [1,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_2_cdf_co.paa"];
	_vehicle setObjectTextureGlobal [2,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_3_cdf_co.paa"];
	_vehicle setObjectTextureGlobal [3,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_4_cdf_co.paa"];
	_vehicle setObjectTextureGlobal [4,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_5_cdf_co.paa"];
	_vehicle setObjectTextureGlobal [5,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\bmp_6_cdf_co.paa"];
	_vehicle setObjectTextureGlobal [6,"rhsafrf\addons\rhs_decals\data\numbers\cdf\4_ca.paa"];
	_vehicle setObjectTextureGlobal [7,"rhsafrf\addons\rhs_decals\data\numbers\cdf\8_ca.paa"];
	_vehicle setObjectTextureGlobal [8,"rhsafrf\addons\rhs_decals\data\numbers\cdf\8_ca.paa"];
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

["LOP_SLA_T72BA", "InitPost", {
    params ["_vehicle"];
	_vehicle setObjectTextureGlobal [0,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\rhs_t72b_01_co.paa"];
	_vehicle setObjectTextureGlobal [1,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\rhs_t72b_02_co.paa"];
	_vehicle setObjectTextureGlobal [2,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\rhs_t72b_03_co.paa"];
	_vehicle setObjectTextureGlobal [3,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\rhs_t72b_04_co.paa"];
	_vehicle setObjectTextureGlobal [4,"rhsgref\addons\rhsgref_vehicles_ret\data\cdf\rhs_t72b_05b_cdf_co.paa"];
	_vehicle setObjectTextureGlobal [5,"#(argb,8,8,3)color(0.92,0.87,0.92,1)"];
	_vehicle setObjectTextureGlobal [6,"#(argb,8,8,3)color(0.92,0.87,0.92,1)"];
	_vehicle setObjectTextureGlobal [7,"#(argb,8,8,3)color(0.92,0.87,0.92,1)"];
}, nil, nil, true] call CBA_fnc_addClassEventHandler;


// Advanced Singloading
ASL_SLING_RULES_OVERRIDE = [ 
	["Air", "CAN_SLING", "All"]
];
// ["Air", "CANT_SLING", "Tank"],

// Advanced Towing
SA_MAX_TOWED_CARGO = 1;
SA_TOW_RULES_OVERRIDE =[
	["All", "CAN_TOW", "All"]
];
// ["Car", "CANT_TOW", "Tank"],
// ["Air", "CANT_TOW", "Air"]
//[AiCacheDistance(players),TargetFPS(-1 for Auto),Debug,CarCacheDistance,AirCacheDistance,BoatCacheDistance]execvm "zbe_cache\main.sqf";

if (isServer) then {[2000,-1,false,100,100,100]execvm "zbe_cache\main.sqf"};

// MilSimUnited ===========================================================================

KPLIB_init = true;

// Notify clients that server is ready
if (isServer) then {
    KPLIB_initServer = true;
    publicVariable "KPLIB_initServer";
};
