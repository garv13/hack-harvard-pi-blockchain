function CO2_value=Albedo_to_CO2(rawAlbedo_arr)
T = 0;  %initialize sum of exponential variables as zero
j = -1; %initialize counting variable as negative one
while (T < 1)
Y = -(1/rawUV_arr)*log(rand(1));
% generate exponential random variable using the
% inverse transform method; note that ‘log’ in Matlab means natural log (‘ln’)
T = T + Y; %update sum of exponential variables
j = j + 1; %update number of exponential variables
end
J=j;
end