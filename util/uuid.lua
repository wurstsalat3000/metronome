-- * Metronome IM *
--
-- This file is part of the Metronome XMPP server and is released under the
-- ISC License, please see the LICENSE file in this source package for more
-- information about copyright and licensing.
--
-- As per the sublicensing clause, this file is also MIT/X11 Licensed.
-- ** Copyright (c) 2008-2010, Matthew Wild, Waqas Hussain

local m_random = math.random;
local tostring = tostring;
local os_time = os.time;
local os_clock = os.clock;
local sha1 = require "util.hashes".sha1;

local _ENV = nil;

local last_uniq_time = 0;
local function uniq_time()
	local new_uniq_time = os_time();
	if last_uniq_time >= new_uniq_time then new_uniq_time = last_uniq_time + 1; end
	last_uniq_time = new_uniq_time;
	return new_uniq_time;
end

local function new_random(x)
	return sha1(x..os_clock()..tostring({}), true);
end

local buffer = new_random(uniq_time());
local function _seed(x)
	buffer = new_random(buffer..x);
end
local function get_nibbles(n)
	if #buffer < n then _seed(uniq_time()); end
	local r = buffer:sub(0, n);
	buffer = buffer:sub(n+1);
	return r;
end
local function get_twobits()
	return ("%x"):format(get_nibbles(1):byte() % 4 + 8);
end

local function generate()
	-- generate RFC 4122 complaint UUIDs (version 4 - random)
	return get_nibbles(8).."-"..get_nibbles(4).."-4"..get_nibbles(3).."-"..(get_twobits())..get_nibbles(3).."-"..get_nibbles(12);
end

return { generate = generate, seed = _seed };
