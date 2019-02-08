%EE201C Spring2018 Term Project 
% Endi Xu, Lu shijun
% Pre-sampling and parameter pruning

clear all;
clc;

% Configurations
max_timeDelay = 1.395e-10;
condDelay = 1.395e-10;
d_timeDelay = 1.35e-10;
sample_max = inf;
stop_fom = 0.08;
pa = 'n';

% replace HSPICE_PATH with your HSPICE path 
hspice_path = 'hspice';

% The pmos mean and nmos mean
p_mean=[2.7e-9 5.1e-9 1.8e-8 -0.39601 8.80736e-3 -0.15];
n_mean=[2.37e-9 5.8e-9 1.7e-8 0.328977 0.026049 -0.154];
% The pmos sigma and nmos sigma
p_sigma=[3.376e-20 4.277e-21 5.687e-20 1.15e-2 4.196e-5 1.797e-3];
n_sigma=[3.602e-22 4.681e-20 1.156e-19 1.094e-2 5.942e-6 1.367e-2];

%% Step1: Presampling
[failProb, fail_collector,pass_collector, error_counter_mc, error_counter_cond]=Endi_Xu_lu_Shijun_calProb(p_mean,n_mean,p_sigma,n_sigma,sample_max,d_timeDelay,condDelay,stop_fom,pa);

[~,cf] = size(fail_collector);
[~,cp] = size(pass_collector);

%% Step2: load failure cases to failCollector.txt load pass cases to passCollector.txt
fidF = fopen('failCollector.txt','w');
for i = 1 : cf/6
	for j = 1 : 60
		for k = 1 : 6
			fprintf(fidF, '%e\t', fail_collector{j,k + (i-1) * 6});
		end
		fprintf(fidF, '\n');    
	end
end
fclose(fidF);

fidP = fopen('passCollector.txt','w');
for i = 1 : cp/6
	for j = 1 : 60
		for k = 1 : 6
			fprintf(fidP, '%e\t', pass_collector{j,k + (i-1) * 6});
		end
		fprintf(fidP, '\n');    
	end
end
fclose(fidP);

% Load probability and p/f size to probCollector.txt
fidProb = fopen('probCollector.txt','w');
fprintf(fidProb, '%e\n', failProb);
fprintf(fidProb, '%d\n', cf*10);
fprintf(fidProb, '%d\n', cp*10);
fclose(fidProb);

disp(failProb);

