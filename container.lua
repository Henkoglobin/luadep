-- container.lua
-- 
-- Provides a form of dependency injection for Lua projects

local container = setmetatable({}, {
	__call = function(self, ...)
		return setmetatable(self.new(...), self)
	end
})

container.__index = container

function container.new()
	return {
		modules = {}
	}
end

function container:collect(module)
	for _, v in pairs(module.interfaces) do
		if self.modules[v] == nil then
			self.modules[v] = {}
		end
		
		table.insert(self.modules[v], module)
	end
end

function container:get(interfaceName)
	local possibleModules = self.modules[interfaceName] or {}
	
	print("get " .. interfaceName)
	
	for _, module in pairs(possibleModules) do
		-- Get dependencies of this module 
		local dependencies = module.dependencies
		
		for _, dependency in pairs(dependencies) do
			local resolved = self:get(dependency)
			
			if not resolved then
				error(string.format("Cannot resolve dependency '%s'", dependency))
			end
			
			module:inject(dependency, resolved)
		end
		
		return module.module
	end
end

return container
