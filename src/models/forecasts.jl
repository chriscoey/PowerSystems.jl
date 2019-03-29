abstract type
    Forecast
end

"""
    Deterministic
        A deterministic forecast for a particular data field in a PowerSystemDevice.

"""
struct Deterministic <: Forecast
    device::PowerSystemDevice       # device
    id::String                      # identifier
    resolution::Dates.Period        # resolution
    initialtime::Dates.DateTime     # forecast availability time
    data::TimeSeries.TimeArray      # TimeStamp - scalingfactor
end


function Deterministic(device::PowerSystemDevice, id::String, resolution::Dates.Period, initialtime::Dates.DateTime, time_steps::Int; kwargs...)
    data = TimeSeries.TimeArray(initialtime:Dates.Hour(1):initialtime+resolution*(time_steps-1), ones(time_steps))
    Deterministic(device, id, resolution, initialtime, data; kwargs...)
end

function Deterministic(device::PowerSystemDevice, id::String, data::TimeSeries.TimeArray; kwargs...)
    resolution = getresolution(data)
    initialtime = TimeSeries.timestamp(data)[1]
    time_steps = length(data)
    Deterministic(device, id, resolution, initialtime, data; kwargs...)
end

struct Scenarios <: Forecast
    horizon::Int
    resolution::Dates.Period
    interval::Dates.Period
    initialtime::Dates.DateTime
    scenarioquantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
end

struct Probabilistic <: Forecast
    horizon::Int
    resolution::Dates.Period
    interval::Dates.Period
    initialtime::Dates.DateTime
    percentilequantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
end
