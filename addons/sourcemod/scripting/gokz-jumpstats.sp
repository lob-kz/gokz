#include <sourcemod>

#include <sdkhooks>
#include <sdktools>

#include <gokz/core>
#include <gokz/localdb>
#include <gokz/jumpstats>

#undef REQUIRE_EXTENSIONS
#undef REQUIRE_PLUGIN
#include <updater>

#include <gokz/kzplayer>

#pragma newdecls required
#pragma semicolon 1



public Plugin myinfo = 
{
	name = "GOKZ Jumpstats", 
	author = "DanZay", 
	description = "Tracks and outputs movement statistics", 
	version = GOKZ_VERSION, 
	url = "https://bitbucket.org/kztimerglobalteam/gokz"
};

#define UPDATER_URL GOKZ_UPDATER_BASE_URL..."gokz-jumpstats.txt"

#include "gokz-jumpstats/api.sp"
#include "gokz-jumpstats/commands.sp"
#include "gokz-jumpstats/distance_tiers.sp"
#include "gokz-jumpstats/jump_reporting.sp"
#include "gokz-jumpstats/jump_tracking.sp"
#include "gokz-jumpstats/options.sp"
#include "gokz-jumpstats/options_menu.sp"



// =====[ PLUGIN EVENTS ]=====

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNatives();
	RegPluginLibrary("gokz-jumpstats");
	return APLRes_Success;
}

public void OnPluginStart()
{
	LoadTranslations("gokz-common.phrases");
	LoadTranslations("gokz-jumpstats.phrases");
	
	CreateGlobalForwards();
	RegisterCommands();
}

public void OnAllPluginsLoaded()
{
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin(UPDATER_URL);
	}
	
	TopMenu topMenu;
	if (LibraryExists("gokz-core") && ((topMenu = GOKZ_GetOptionsTopMenu()) != null))
	{
		GOKZ_OnOptionsMenuReady(topMenu);
	}
	
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			OnClientPutInServer(client);
		}
	}
}

public void OnLibraryAdded(const char[] name)
{
	if (StrEqual(name, "updater"))
	{
		Updater_AddPlugin(UPDATER_URL);
	}
}



// =====[ CLIENT EVENTS ]=====

public void OnClientPutInServer(int client)
{
	HookClientEvents(client);
	OnClientPutInServer_Options(client);
	OnClientPutInServer_JumpTracking(client);
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
	OnPlayerRunCmd_JumpTracking(client);
	return Plugin_Continue;
}

public void OnPlayerRunCmdPost(int client, int buttons, int impulse, const float vel[3], const float angles[3], int weapon, int subtype, int cmdnum, int tickcount, int seed, const int mouse[2])
{
	OnPlayerRunCmdPost_JumpTracking(client, cmdnum);
}

public void Movement_OnStartTouchGround(int client)
{
	OnStartTouchGround_JumpTracking(client);
}

public void Movement_OnPlayerJump(int client, bool jumpbug)
{
	OnPlayerJump_JumpTracking(client, jumpbug);
}

public void GOKZ_OnJumpValidated(int client, bool jumped, bool ladderJump)
{
	OnJumpValidated_JumpTracking(client, jumped, ladderJump);
}

public void GOKZ_OnJumpInvalidated(int client)
{
	OnJumpInvalidated_JumpTracking(client);
}

public void GOKZ_OnOptionChanged(int client, const char[] option, any newValue)
{
	OnOptionChanged_JumpTracking(client, option);
	OnOptionChanged_Options(client, option, newValue);
}

public void GOKZ_JS_OnLanding(int client, int jumpType, float distance, float offset, float height, float preSpeed, float maxSpeed, int strafes, float sync, float duration, int block, float width, int overlap, int deadair, float deviation, float edge, int releaseW)
{
	OnLanding_JumpReporting(client, jumpType, distance, offset, height, preSpeed, maxSpeed, strafes, sync, duration, block, width, overlap, deadair, deviation, edge, releaseW);
}

public void GOKZ_JS_OnFailstat(int client, int jumpType, float distance, float height, float preSpeed, float maxSpeed, int strafes, float sync, float duration, int block, float width, int overlap, int deadair, float deviation, float edge, int releaseW)
{
	OnFailstat_FailstatReporting(client, jumpType, distance, height, preSpeed, maxSpeed, strafes, sync, duration, block, width, overlap, deadair, deviation, edge, releaseW);
}

public void SDKHook_StartTouch_Callback(int client, int touched) // SDKHook_StartTouchPost
{
	OnStartTouch_JumpTracking(client);
}

public void SDKHook_EndTouch_Callback(int client, int touched) // SDKHook_EndTouchPost
{
	OnEndTouch_JumpTracking(client);
}



// =====[ OTHER EVENTS ]=====

public void OnMapStart()
{
	OnMapStart_JumpReporting();
	OnMapStart_DistanceTiers();
}

public void GOKZ_OnOptionsMenuCreated(TopMenu topMenu)
{
	OnOptionsMenuCreated_OptionsMenu(topMenu);
}

public void GOKZ_OnOptionsMenuReady(TopMenu topMenu)
{
	OnOptionsMenuReady_Options();
	OnOptionsMenuReady_OptionsMenu(topMenu);
}



// =====[ PRIVATE ]=====

static void HookClientEvents(int client)
{
	SDKHook(client, SDKHook_StartTouchPost, SDKHook_StartTouch_Callback);
	SDKHook(client, SDKHook_EndTouchPost, SDKHook_EndTouch_Callback);
} 