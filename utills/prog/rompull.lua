-- rompull is a CC:T program for pulling programs from rom
--    Copyright (C) 2023  Dusk
--
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <https://www.gniu.org/licenses/>.

local function e(s)
	return s == nil or s == ""
end

local args = {...}
local toCopy
local toWhere
local keywords = { --no shorthands
	[ "about" ] = "/rom/programs/about.lua",
	[ "alias" ] = "/rom/programs/alias.lua",
	[ "apis" ] = "/rom/programs/apis.lua",
	[ "api" ] = "/rom/programs/apis.lua",
	[ "cd" ] = "/rom/programs/cd.lua",
	[ "clear" ] = "/rom/programs/clear.lua",
	[ "copy" ] = "/rom/programs/copy.lua",
	[ "delete" ] = "/rom/programs/delete.lua",
	[ "drive" ] = "/rom/programs/drive.lua",
	[ "edit" ] = "/rom/programs/edit.lua",
	[ "eject" ] = "/rom/programs/eject.lua",
	[ "exit" ] = "/rom/programs/exit.lua",
	[ "gps" ] = "/rom/programs/gps.lua",
	[ "help" ] = "/rom/programs/help.lua",
	[ "id" ] = "/rom/programs/id.lua",
	[ "import" ] = "/rom/programs/import.lua",
	[ "label" ] = "/rom/programs/label.lua",
	[ "list" ] = "/rom/programs/list.lua",
	[ "lua" ] = "/rom/programs/lua.lua",
	[ "mkdir" ] = "/rom/programs/mkdir.lua",
	[ "monitor" ] = "/rom/programs/monitor.lua",
	[ "motd" ] = "/rom/programs/motd.lua",
	[ "move" ] = "/rom/programs/move.lua",
	[ "peripherals" ] = "/rom/programs/peripherals.lua",
	[ "programs" ] = "/rom/programs/programs.lua",
	[ "reboot" ] = "/rom/programs/reboot.lua",
	[ "redstone" ] = "/rom/programs/redstone.lua",
	[ "rename" ] = "/rom/programs/rename.lua",
	[ "set" ] = "/rom/programs/set.lua",
	[ "shell" ] = "/rom/programs/shell.lua",
	[ "shutdown" ] = "/rom/programs/shutdown.lua",
	[ "time" ] = "/rom/programs/time.lua",
	[ "type" ] = "/rom/programs/type.lua"
}

if e(args[1]) or e(args[2]) then
	error("rompull <toCopy> <toWhere>",0)
end
