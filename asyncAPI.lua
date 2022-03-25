local yaml = require "yaml"


local configs = {}
for i, file in ipairs(arg) do
    configs[i] = yaml.loadpath(file)
    print( ("loaded file %s \t - %s"):format(file, configs[i].info.title) )
end

local channels = {}

local function parse_config(config)
    if not config.channels then return end
    for name, channel in pairs(config.channels) do
        if not channels[name] then
            channels[name] = { publishers = {}, subscribers = {}}
        end

        if channel.publish then
            table.insert(channels[name].publishers, config.info.title)
        end
        if channel.subscribe then
            table.insert(channels[name].subscribers, config.info.title)
        end
    end
end

for _, config in ipairs(configs) do
    parse_config(config)
end

for channel, APIs in pairs(channels) do
    print()
    print("--------------------------------------")
    print( ("Channel: \t%s"):format(channel) )

    print("Publishers:")
    for _, API in pairs(APIs.publishers) do
        print("\t", API)
    end

    print("Subscribers:")
    for _, API in pairs(APIs.subscribers) do
        print("\t", API)
    end
end
