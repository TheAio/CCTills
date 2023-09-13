--General disk-based utility functions
--Made by Dusk
-- disklib is a CC:T library for general disk utility functions
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
--  along with this program.  If not, see <https://www.gnu.org/licenses/>.

local drive = peripheral.find("drive") or error("There is no present disk drive.",0)

local d = {}

function d.list() --list all present disks
	local periphPresent = peripheral.getNames()

	for k,v in pairs(periphPresent) do
		local t = peripheral.getType(v)
		
		if t == "drive" then
			local present = drive.isDiskPresent(v)
			
			if present then
				local l = disk.getLabel(v)
				local m = disk.getMountPath(v)
				local audio = disk.hasAudio(v)
					if audio then
						print("Music disc '"..l.."' on side",v)
					else
						print("Disk",l,"on side",v,"at",m)
					end
			end
		end
	end
end

return d
