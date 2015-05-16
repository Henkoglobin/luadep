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
		module = mod,
		interfaces = {},
		dependencies = {},
		inject = function(self, interface, module)
			self.module[interface] = module
		end
	}
	
	return setmetatable(temp, module)
end

function module:isA(interfaceName)
	table.insert(self.interfaces, interfaceName)
	
	return self
end

function module:dependsOn(interfaceName)
	table.insert(self.dependencies, interfaceName)
	
	return self
end

function module:onInject(func)
	module.inject = func
	
	return self
end

return module
