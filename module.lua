-- luadep.util.lua
-- 
-- Provides utility functions

local module = setmetatable({}, {
	__call = function(self, ...)
		return setmetatable(self.new(...), self)
	end
})

module.__index = module

function module.new(mod)
	local temp = {
		name = "unknown module",
		version = "(unknown version)",
		module = mod,
		interfaces = {},
		dependencies = {},
		inject = function(self, interface, module, allowMultiple)
			if allowMultiple then
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

function module:isA(interfaceName)
	table.insert(self.interfaces, interfaceName)

	return self
end

function module:dependsOn(interfaceName, multiple)
	table.insert(self.dependencies, {
		interface = interfaceName,
		multiple = multiple or false
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
