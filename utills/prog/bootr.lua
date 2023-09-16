-- bootr is a CC:T program for booting a CC OS in the simplest steps possible.
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

-- bootr expects a bootr.cfg file in either the same
-- directory or in a 'bootr/' subdirectory.
-- bootr.cfg format is as follows
-- (lines with # are comments in the example.)
--
----------------------------------------------
--
-- {
-- 	# paths to init and kernel
--	[ initfile ] = "/example/example.lua"
--	[ kernelfile ] = "/example/example.lua"
--	# is the kernel treated as a lib (0)
--	# or a prog that runs things ontop? (1)
--	[ kernel_mode ] = 0
--	# additional arguments
--	[ add_args ] = nil
-- }
--
----------------------------------------------

local bootr_ver = 1

term.clear()
term.setCursorPos(1,1)
print("#### ")
print("#   #")
print("#   #")
print("#  #")
print("#   #")
print("#   #")
print("#### bootr",bootr_ver)

local cfg_file

if not fs.exists("bootr.cfg") then
	error("'bootr.cfg' not found")
else
	local handle = fs.open("bootr.cfg","r")
	cfg_file = textutils.unserialize(handle.readAll)
end

for k,v in pairs(cfg_file) do --cant forget that do :kek:
	print(k,v)
end
