value_MIN = 1;
theta_MIN = -40;

co2_MAX = 80;
ch4_MAX = 1024;
uv_MAX = 255;
h2o_MAX = 600;
theta_MAX = 125;
humid_MAX = 100;

co2ppm_to_Gtco2_factor = 7.8;
preIndustrial_co2_ppm = 290;
earth_surface_area = 148.9;             % in mil.m^2
CARBON_TAX = 10;                        % in $/tCO2
CARBON_CREDITS = 30;                    % in $/tCO2

RAW_DATA_URL = 'https://us-central1-aiot-fit-xlab.cloudfunctions.net/acchawalaproject';
options = weboptions('RequestMethod', 'get', 'ContentType', 'json', 'ArrayFormat','json', 'Timeout', 60);

raw_data = webread(RAW_DATA_URL, options).data;
% raw_data -> raw_table
% % raw_table = table( ...
% %     timestamps, co2_values, ch4_values, uv_values, ...
% %     h2o_values, theta_values, humid_values);

num_rows = length(raw_data);
num_cols = length(fieldnames(raw_data));
fields = fieldnames(raw_data);

input_data = zeros(num_rows, num_cols - 1);
% timestamps_data = zeros(num_rows, 1);
for j = 1:numel(fields)
    field_data = {raw_data.(fields{j,1})}';
    if strcmp(fields{j, 1}, 'ts')
        ts_data = string({raw_data.ts}');
        for k = 1:length(ts_data)
            ts_num = str2num(ts_data{k});
            timestamps_data(k, 1) = datetime( ...
                ts_num,'ConvertFrom','posixtime','Format', 'yyyy-MM-dd HH:mm:ss');
        end
    else
        input_data(:, j) = str2double(field_data);
    end
end

for i = 1:length(timestamps_data)
    input_data(i, j) = hour(timestamps_data(i));
end

grps = unique(input_data(:,j));
hrly_grouped_data = arrayfun( ...
    @(m) input_data(input_data(:,j)==m, 1:j-1), grps, 'UniformOutput', false);
hrly_agg_data = zeros(length(hrly_grouped_data), j-1);
for z=1:length(hrly_grouped_data)
    hrly_grouped_data{z,1} = mean(hrly_grouped_data{z,1});
    hrly_agg_data(z,:) = hrly_grouped_data{z,1};
end

% CO2_to_CO2 -> get co2_value in tCO2
% CH4_to_CO2 -> get co2_value in tCO2
% UV_to_CO2 -> get co2_value in tCO2
% theta (temp) & RH -> values as it is
% co2_emission_estimates = zeros(length(hrly_grouped_data), 3);
co2_emission_estimates(:,1) = grps;
co2_emission_estimates(:,2) = CO2_to_CO2(hrly_agg_data(:,5));
co2_emission_estimates(:,3) = CH4_to_CO2(hrly_agg_data(:,6));
co2_emission_estimates(:,4) = UV_to_CO2( ...
    hrly_agg_data(:,1), hrly_agg_data(:,2));
co2_emission_estimates(:,5) = sum(co2_emission_estimates(:, (2:4)), 2);
co2_emission_estimates(:,6) = co2_emission_estimates(:,5) * co2ppm_to_Gtco2_factor / earth_surface_area;

BASELINE_CO2_EMISSION = mean(co2_emission_estimates(1:3,6));
% get total_co2_value
co2_emission_estimates(:,7) = co2_emission_estimates(:,6) - BASELINE_CO2_EMISSION;
final_estimates = co2_emission_estimates(:,7);
co2_emission_estimates(:,8) = (-1*final_estimates*CARBON_CREDITS).*(final_estimates <= 0) + (-1*final_estimates*CARBON_TAX).*(final_estimates > 0);

% CO2_to_CC -> get final CC for that instant
co2_emission_estimates_table = array2table( ...
    co2_emission_estimates, 'VariableNames', ...
    {'time (hour)', 'CO2 (CO2 ppm)', 'CH4 (CO2 ppm)', 'Albedo (CO2 ppm)', ...
     'Effective CO2 (ppm)', 'Effective CO2 (kiloton)', 'ΔCO2 wrt avg.baseline (kiloton)', ...
     'Net Carbon Credit/Tax ($grand)'});

