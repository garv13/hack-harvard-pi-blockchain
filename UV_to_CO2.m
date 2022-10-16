function CO2_value=UV_to_CO2(rawUV1_arr, rawUV2_arr)
    albedo_co2_emission_factor = 2;
    albedo_BASELINE = 0.2;

    Albedo_value = (rawUV2_arr - rawUV1_arr) ./ rawUV2_arr;
    Albedo_value = Albedo_value - albedo_BASELINE;
    CO2_value = -1 * Albedo_value .* albedo_co2_emission_factor;
end
