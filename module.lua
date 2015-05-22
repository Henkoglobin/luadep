-- luadep.util.lua
-- 
-- Provides utility functions

local module = setmetatable({}, {
	__call = function(self, ...)
		return setmetatable(self.new(...), self)
	end
})

module.__index = module

local function parse(input)
	input = input or "1"

	local min, max = input:match("^([01]?)%.%.([1%*])")

	if not min then
		min = input:match("[01%*]")
		max = min == "*" and "*" or "1"
	end

	print("Parsed:", min or "(nil)", max or "(nil)")

	return {
		allowMultiple = max == "*",
		allowNone = min == "0"
	}
end

function module.new(mod)
	local temp = {
		name = "unknown module",
		version = "(unknown version)",
		module = mod,
		interfaces = {},
		dependencies = {},
		inject = function(self, interface, module, definition)
			if definition.allowMultiple then
				if not self[interface] then
					self[interface] = {}
				end

				table.insert(self[interface], module)
			else
				self[interface] = module
			end
		end
	}
	
	return setmetatable(temp, module)
end

function module:isA(interface)
	table.insert(self.interfaces, interface)

	return self
end

function module:dependsOn(interface, settings)
	local parsedSettings = parse(settings)

	table.insert(self.dependencies, {
		interface = interface,
		allowMultiple = parsedSettings.allowMultiple,
		allowNone = parsedSettings.allowNone
	})

	return self
end

function module:onInject(func)
	self.inject = func

	return self
end

function module:setName(name)
	self.name = name
	
	return self
end

function module:setVersion(version)
	self.version = version
	
	return self
end

return module
