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

local args = {...}

local keywords = {
	[ "about" ] == "/rom/programs/about.lua",
	[ "alias" ] == "/rom/programs/alias.lua",
	[ "apis" ] == "/rom/programs/apis.lua",
	[ "api" ] == "/rom/programs/apis.lua",
	[ "cd" ] == "/rom/programs/cd.lua",
	[ "clear" ] == "/rom/programs/clear.lua"
	[ "cls" ] == "/rom/programs/clear.lua"
	[ "copy" ] == "/rom/programs/copy.lua"
	[ "cp" ] == "/rom/programs/copy.lua"
}
