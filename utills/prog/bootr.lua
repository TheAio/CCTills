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

local args = {...} --since CC hates having programs being aware of the dir theyre in and always starts searches from root, the only arg to supply is the path that bootr.cfg is in

term.clear()
term.setCursorPos(1,1)
print("#### ")
print("#   #")
print("#   #")
print("#  #")
print("#   #")
print("#   #")
print("#### bootr",bootr_ver,"| By Dusk")

local cfgFilePath = args[1]

local cfg = require(cfgFilePath.."/bootr-cfg")

if cfg.kernel_mode == 0 then
	print("Automatically assume init and assorted os files require the kernel when needed, autorun init.")
	sleep(1)
	shell.run(cfg.initfile)
elseif cfg.kernel_mode == 1 then
	print("Kernel file ("..cfg.kernelfile..") is set to mode 1 (prog)")
	if cfg.add_args == nil then
		print("Running the kernel file with no args.")
		print("Running init first though, and assuming init handles setup before kernel.")
		sleep(1)
		shell.run(cfg.initfile)
		shell.run(cfg.kernelfile)
	else
		print("Running the kernel file with the given args.")
		print("Running init first though, and assuming init handles setup before kernel.") --this is gonna bite me in the a** later lmao
		print(cfg.add_args)
		sleep(1)
		shell.run(cfg.kernelfile,cfg.add_args)
	end
else
	error("cfg.kernel_mode is not 1 or 0",0)
end
