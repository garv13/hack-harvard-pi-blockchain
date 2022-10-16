function CO2_value=CO2_to_CO2(rawCO2_arr)
    co2_MIN = 0;
    co2_MAX = 80;
    co2_value_MIN = 400.0;      % in ppm
    co2_value_MAX = 8192.0;     % in ppm
    co2_BASELINE = 1000.0;      % 400ppm avg. outdoor co2 ppm level

    CO2_value = rawCO2_arr .* (co2_value_MAX - co2_value_MIN) / (co2_MAX - co2_MIN);
    CO2_value = CO2_value - co2_BASELINE;
end
