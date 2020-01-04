# GOKZ SourceMod Plugins (CS:GO)

GOKZ a set of [SourceMod](https://www.sourcemod.net/about.php) plugins exclusively for Counter-Strike: Global Offensive servers. It implements the KZ (Kreedz) game mode, which involves [speedrunning](https://en.wikipedia.org/wiki/Speedrun) through custom maps.

## Features

 * **Timer** - Times runs by automatically detecting the use of start and end buttons in KZ maps.
 * **Movement Modes** - Custom movement mechanics. Includes Vanilla, SimpleKZ, and KZTimer modes.
    * Mode plugins can be used alone (with only MovementAPI) to apply their mechanics at all times.
 * **Jumpstats** - Detailed statistics of your jumps and each individual air strafe.
 * **Customisable Experience** - Tonnes of options to provide the best possible experience for players. 
 * **Database Support** - Store run times and more using either a MySQL or SQLite database. 
    * Player options are stored using the clientprefs extension.
 * **GlobalAPI Support** - Submit run times to the GlobalAPI so that players may compete across servers.
 * **Replays** - Record replays of the server's fastest times and use bots to play them back.
 * **Anti-Macro** - Detect and auto-ban blatant users of bhop macros and cheats (SourceBans++ supported).
 * Map bonus support, HUD, teleport menu, noclip, !goto, !measure, !race and much, much more.

For more information about what each plugin does, please see [PLUGINS.md](PLUGINS.md).

## Usage

### Server Requirements

 * 128 Tick (`-tickrate 128`)
 * [SourceMod ^1.10](https://www.sourcemod.net/downloads.php?branch=stable)
 * [DHooks Extension ^2.2.0](https://forums.alliedmods.net/showpost.php?p=2588686&postcount=589)
 * [MovementAPI Plugin ^2.1.0](https://github.com/danzayau/MovementAPI)
 * Optional - [GlobalAPI Plugin](https://bitbucket.org/kztimerglobalteam/globalrecordssmplugin) (required for gokz-globals plugin)
 * Optional - A "console cleaner" extension to prevent `Datatable warning` server console spam
 * Optional - [Updater Plugin](https://forums.alliedmods.net/showthread.php?t=169095) (automatically install minor GOKZ updates)

### Installing

 * Ensure your server is up to date and meets the above requirements.
 * Download and extract `GOKZ-latest.zip` from [Downloads](https://bitbucket.org/kztimerglobalteam/gokz/downloads/) to `csgo`.
 * Add a MySQL or SQLite database called `gokz` to `csgo/addons/sourcemod/configs/databases.cfg`.
 * When the plugins first load, various configuration files will be auto-generated and can be found in `csgo/cfg/sourcemod/gokz`.
 * Use `sm_updatemappool` to populate the ranked map pool with those in `csgo/cfg/sourcemod/gokz/gokz-localranks-mappool.cfg`.

Please refer to the forum for a [more detailed installation guide](https://forum.gokz.org/p/guide-gokz).

### Updating

 * Minor updates - Download and extract `GOKZ-latest-upgrade.zip` from [Downloads](https://bitbucket.org/kztimerglobalteam/gokz/downloads/) to `csgo`.
 * Major updates - Check the new version's release notes for specific instructions.

### Commands

Please see [COMMANDS.md](COMMANDS.md) for a list of player and admin commands.

### Mapping

Please see [MAPPING.md](MAPPING.md) to see how to make maps that work with GOKZ.

## Contributing

GOKZ is an open-source, community-driven project. If you are interested in helping out, please see [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

## Authors

 * **DanZay** - *Lead Developer* - [Steam](https://steamcommunity.com/id/DanZay/)
 * **KZTimerGlobal Team** - [BitBucket](https://bitbucket.org/kztimerglobalteam/profile/members)

## Links

[Wiki](https://bitbucket.org/kztimerglobalteam/gokz/wiki)

[Forum](https://forum.gokz.org)

[Steam Group](https://steamcommunity.com/groups/GOKZTimer)

[Discord](https://www.discord.gg/csgokz)