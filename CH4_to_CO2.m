function CO2_value=CH4_to_CO2(rawCH4_arr)
    ch4_MIN = 0;
    ch4_MAX = 1024;
    ch4_value_MIN = 0;
    ch4_value_MAX = 1000;           % in ppm
    ch4_co2_emission_factor = 25;   % 50-100 yr avg. global warming potential
    ch4_BASELINE = 10;              % 10ppm breathable CH4 ppm

    CH4_value = rawCH4_arr .* (ch4_value_MAX - ch4_value_MIN) / (ch4_MAX - ch4_MIN);
    CH4_value = CH4_value - ch4_BASELINE;
    CO2_value = CH4_value .* ch4_co2_emission_factor;
end
