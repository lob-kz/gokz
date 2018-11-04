#include <sourcemod>

#include <sdktools>
#include <geoip>
#include <regex>

#include <gokz>

#include <gokz/core>
#include <gokz/localdb>

#undef REQUIRE_EXTENSIONS
#undef REQUIRE_PLUGIN
#include <gokz/jumpstats>
#include <updater>

#pragma newdecls required
#pragma semicolon 1



public Plugin myinfo = 
{
	name = "GOKZ Local DB", 
	author = "DanZay", 
	description = "GOKZ Local Database Module", 
	version = GOKZ_VERSION, 
	url = "https://bitbucket.org/kztimerglobalteam/gokz"
};

#define UPDATE_URL "http://updater.gokz.org/gokz-localdb.txt"

Regex gRE_BonusStartButton;
Database gH_DB = null;
DatabaseType g_DBType = DatabaseType_None;
bool gB_ClientSetUp[MAXPLAYERS + 1];
bool gB_Cheater[MAXPLAYERS + 1];
bool gB_MapSetUp;
int gI_DBCurrentMapID;

#include "gokz-localdb/api.sp"
#include "gokz-localdb/commands.sp"
#include "gokz-localdb/database.sp"

#include "gokz-localdb/database/sql.sp"
#include "gokz-localdb/database/create_tables.sp"
#include "gokz-localdb/database/save_time.sp"
#include "gokz-localdb/database/setup_client.sp"
#include "gokz-localdb/database/setup_database.sp"
#include "gokz-localdb/database/setup_map.sp"
#include "gokz-localdb/database/setup_map_courses.sp"
#include "gokz-localdb/database/set_cheater.sp"



// =====[ PLUGIN EVENTS ]=====

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	if (GetEngineVersion() != Engine_CSGO)
	{
		SetFailState("This plugin is only for CS:GO.");
	}
	
	CreateNatives();
	RegPluginLibrary("gokz-localdb");
	return APLRes_Success;
}

public void OnPluginStart()
{
	CreateGlobalForwards();
	CreateRegexes();
	CreateCommands();
}

public void OnAllPluginsLoaded()
{
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin(UPDATE_URL);
	}
	
	DB_SetupDatabase();
	
	for (int client = 1; client <= MaxClients; client++)
	{
		if (GOKZ_IsClientSetUp(client))
		{
			GOKZ_OnClientSetup(client);
		}
	}
}

public void OnLibraryAdded(const char[] name)
{
	if (StrEqual(name, "updater"))
	{
		Updater_AddPlugin(UPDATE_URL);
	}
}



// =====[ OTHER EVENTS ]=====

public void OnConfigsExecuted()
{
	DB_SetupMap();
}

public void GOKZ_DB_OnMapSetup(int mapID)
{
	DB_SetupMapCourses();
}

public void GOKZ_OnClientSetup(int client)
{
	if (IsFakeClient(client) || gH_DB == null)
	{
		return;
	}
	
	DB_SetupClient(client);
}

public void OnClientDisconnect(int client)
{
	if (IsFakeClient(client))
	{
		return;
	}
	
	gB_ClientSetUp[client] = false;
}

public void GOKZ_OnTimerEnd_Post(int client, int course, float time, int teleportsUsed)
{
	if (IsFakeClient(client))
	{
		return;
	}
	
	int mode = GOKZ_GetCoreOption(client, Option_Mode);
	int style = GOKZ_GetCoreOption(client, Option_Style);
	DB_SaveTime(client, course, mode, style, time, teleportsUsed);
}



// =====[ PRIVATE ]=====

static void CreateRegexes()
{
	gRE_BonusStartButton = CompileRegex("^climb_bonus(\\d+)_startbutton$");
} 