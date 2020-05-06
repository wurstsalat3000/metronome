-- * Metronome IM *
--
-- This file is part of the Metronome XMPP server and is released under the
-- ISC License, please see the LICENSE file in this source package for more
-- information about copyright and licensing.
--
-- This metronomectl extension helps exporting a single datastore in JSON 
-- format to be used with external applications.

if not rawget(_G, "metronomectl") then
	module:log("error", "mod_dump_json can only be loaded from metronomectl!");
	return;
end

local datamanager = require "util.datamanager";
local storagemanager = require "core.storagemanager";
local json = require "util.json";
local unpack = table.unpack or unpack;
	
function module.command(arg)
	local node, host, store = unpack(arg);
	if not node or not host or not store then
		return "Incorrect syntax please use:\nmetronomectl mod_dump_json <node name or nil> <host> <store name>";
	end
	
	storagemanager.initialize_host(host); -- initialize host storage
	if node == "nil" then node = nil; end -- allows checking inner pathed stores
	
	local data = datamanager.load(node, host, store);
	if data then
		return json.encode(data);
	else
		return "Datastore is empty";
	end
end