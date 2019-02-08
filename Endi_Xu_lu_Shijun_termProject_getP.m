%EE201C Spring2018 Term Project 
% Endi Xu, Lu shijun
% HSCS sampling

clear all;
clc;

% Get the parameters from previous
if (~exist('probCollector.txt','file'))
	%continue 
end

fid = fopen('probCollector.txt', 'r');
pPre = str2double(fgetl(fid));
failure_lines = str2double(fgetl(fid));
pass_lines = str2double(fgetl(fid));
fclose(fid);

disp(pPre);
disp(failure_lines);

% Get the result from column 4, 5 and 6 for passCollector and failCollector
if(~exist('failCollector.txt', 'file'))
	%continue;
end

failure_all = [];
failParameter = cell(60,3);
 
fid = fopen('failCollector.txt', 'r');
i = 1;
counter = 0;
while(1)
	line = fgetl(fid);
    counter = counter + 1;
	parameters = sscanf(line, '%e%e%e%e%e%e');
	failParameter(i,1) = {parameters(4)};
	failParameter(i,2) = {parameters(5)};
	failParameter(i,3) = {parameters(6)};
	i = i + 1;
	if (i > 60) 
		i = 1;
		failure_all = [failure_all; failParameter];
	end
    if(counter == failure_lines)
		break;
	end
end	

fclose(fid);

if(~exist('passCollector.txt', 'file'))
	%continue;
end

pass_all = [];
passParameter = cell(60,3);
 
fid = fopen('passCollector.txt', 'r');
i = 1;
counter = 0;
while(1)
	line = fgetl(fid);
    counter = counter + 1;
	parameters = sscanf(line, '%e%e%e%e%e%e');
	passParameter(i, 1) = {parameters(4)};
	passParameter(i, 2) = {parameters(5)};
	passParameter(i, 3) = {parameters(6)};
	i = i + 1;
	if (i > 60)
		i = 1;
		pass_all = [pass_all; passParameter];
    end
    if(counter == failure_lines * 2)
		break;
	end
end	
fclose(fid);

% Reform failure_all
[fr, fc] = size(failure_all);
failure_reform = zeros(fr/60,6);
for i = 1 : fr/60
	for j = (i-1)*10+1 : (i-1)*10+10
		% Vth for pmos
		failure_reform(i,1) = failure_reform(i,1) + failure_all{(j-1)*6+1,1}/30 + failure_all{(j-1)*6+2,1}/30 + failure_all{(j-1)*6+3,1}/30;
		% Vth for noms
		failure_reform(i,2) = failure_reform(i,2) + failure_all{(j-1)*6+4,1}/30 + failure_all{(j-1)*6+5,1}/30 + failure_all{(j-1)*6+6,1}/30;
		% u for pmos
		failure_reform(i,3) = failure_reform(i,3) + failure_all{(j-1)*6+1,2}/30 + failure_all{(j-1)*6+2,2}/30 + failure_all{(j-1)*6+3,2}/30;
		% u for noms
		failure_reform(i,4) = failure_reform(i,4) + failure_all{(j-1)*6+4,2}/30 + failure_all{(j-1)*6+5,2}/30 + failure_all{(j-1)*6+6,2}/30;
		% voff for pmos
		failure_reform(i,5) = failure_reform(i,5) + failure_all{(j-1)*6+1,3}/30 + failure_all{(j-1)*6+2,3}/30 + failure_all{(j-1)*6+3,3}/30;
		% voff for noms
		failure_reform(i,6) = failure_reform(i,6) + failure_all{(j-1)*6+4,3}/30 + failure_all{(j-1)*6+5,3}/30 + failure_all{(j-1)*6+6,3}/30;
	end
end


% Reform pass_all
[pr, pc] = size(pass_all);
pass_reform = zeros(pr/60,6);
for i = 1 : pr/60
	for j = (i-1)*10+1 : (i-1)*10+10
		% Vth for pmos
		pass_reform(i,1) = pass_reform(i,1) + pass_all{(j-1)*6+1,1}/30 + pass_all{(j-1)*6+2,1}/30 + pass_all{(j-1)*6+3,1}/30;
		% Vth for noms
		pass_reform(i,2) = pass_reform(i,2) + pass_all{(j-1)*6+4,1}/30 + pass_all{(j-1)*6+5,1}/30 + pass_all{(j-1)*6+6,1}/30;
		% u for pmos
		pass_reform(i,3) = pass_reform(i,3) + pass_all{(j-1)*6+1,2}/30 + pass_all{(j-1)*6+2,2}/30 + pass_all{(j-1)*6+3,2}/30;
		% u for noms
		pass_reform(i,4) = pass_reform(i,4) + pass_all{(j-1)*6+4,2}/30 + pass_all{(j-1)*6+5,2}/30 + pass_all{(j-1)*6+6,2}/30;
		% voff for pmos
		pass_reform(i,5) = pass_reform(i,5) + pass_all{(j-1)*6+1,3}/30 + pass_all{(j-1)*6+2,3}/30 + pass_all{(j-1)*6+3,3}/30;
		% voff for noms
		pass_reform(i,6) = pass_reform(i,6) + pass_all{(j-1)*6+4,3}/30 + pass_all{(j-1)*6+5,3}/30 + pass_all{(j-1)*6+6,3}/30;
	end
end

figure;
all_reform = [failure_reform; pass_reform];
h1(1:2) = gscatter(all_reform(:,1), all_reform(:,2), [ones(fr/60,1); zeros(pr/60,1)], 'rb', '.');

%Remove useless points
w = zeros(fr/60,2);
nearMiss = 1;
nearHit = 1;
for m = 1 : fr/60
    for n = 1 : pr/60
        eDistance = sqrt(abs(failure_reform(m,1) - pass_reform(n,1))^2+abs(failure_reform(m,2) - pass_reform(n,2))^2);
        if nearMiss > eDistance
           nearMiss = eDistance; 
        end
    end
    for l = 1 : fr/60
        if m ~= l
           eDistance = sqrt(abs(failure_reform(m,1) - failure_reform(l,1))^2+abs(failure_reform(m,2) - failure_reform(l,2))^2);
           if nearHit > eDistance
               nearHit = eDistance;
           end
		end
    end 
	w(m,1) = nearMiss;
	w(m,2) = nearHit;
	nearMiss = 1;
    nearHit = 1;
end

% Pick useful points 
failure_select = [];
w_select = [];

for i = 1:fr/60
    if (w(i,1) > 0.0004 && w(i,2) > 0.0001) && (w(i,2) < 0.0008)
        failure_select = [failure_select; failure_reform(i, 1:2)];
		w_select = [w_select; w(i,1:2)];
    end
end

figure;
[fsr, fsc] = size(failure_select);
h1(1:2) = gscatter([failure_select(:,1); pass_reform(:,1)], [failure_select(:,2); pass_reform(:,2)],...
    [ones(fsr,1); zeros(pr/60,1)], 'rb', '.');

% Spherical K-means Algorithm
% Normalization
% Get all the reform points
all_points = [failure_select; pass_reform(:,1:2)];
bufferUnit = mapminmax(all_points',-6,+6);
unitfs = bufferUnit(:,1:fsr)';
disp(unitfs);
[fClass,cPoint] = kmeans(unitfs,3,'Distance', 'cosine', 'Start' ,'uniform', 'Replicates', 10);
figure;
hold on;
plot(unitfs(fClass==1,1),unitfs(fClass==1,2),'r.','MarkerSize',12);
plot(unitfs(fClass==2,1),unitfs(fClass==2,2),'y.','MarkerSize',12);
plot(unitfs(fClass==3,1),unitfs(fClass==3,2),'b.','MarkerSize',12);
plot(cPoint(:,1),cPoint(:,2),'kx','MarkerSize',15,'LineWidth',3); 
legend('Cluster 1','Cluster 2','Cluster 3','Centroids','Location','NW');
title 'Vth Cluster Assignments and Centroids';
hold off;
disp(cPoint);
% Collect clusterprob
clusterP = zeros(3,1);
cMean = zeros(3,2);
counterM = zeros(3,1);

for i = 1 : fsr
	if fClass(i,1) == 1
		clusterP(1,1) = clusterP(1,1) + 1/fr;
        cMean(1,1) = cMean(1,1) + failure_select(i,1);
        cMean(1,2) = cMean(1,2) + failure_select(i,2);
        counterM(1,1) = counterM(1,1)+1;
	elseif fClass(i,1) == 2
		clusterP(2,1) = clusterP(2,1) + 1/fr;
        cMean(2,1) = cMean(2,1) + failure_select(i,1);
        cMean(2,2) = cMean(2,2) + failure_select(i,2);
        counterM(2,1) = counterM(2,1)+1;
    else
		clusterP(3,1) = clusterP(3,1) + 1/fr ;
        cMean(3,1) = cMean(3,1) + failure_select(i,1);
        cMean(3,2) = cMean(3,2) + failure_select(i,2);
        counterM(3,1) = counterM(3,1)+1;
	end
end

for i = 1 : 3
    cMean(i,:) = cMean(i,:)/counterM(i,1);
end

disp('The following is the clusterP');
disp(clusterP);
disp('The following is the cMean');
disp(cMean);

% The delay
fail_delay = 1.395e-10;
cond_delay = 1.35e-10;
% The pmos sigma and nmos sigma
p_sigma=[3.376e-20 4.277e-21 5.687e-20 1.15e-2 4.196e-5 1.797e-3];
n_sigma=[3.602e-22 4.681e-20 1.156e-19 1.094e-2 5.942e-6 1.367e-2];
% Maximum samples
sample_max = 30000;
sample_test = 30;
% Set FOM
stop_fom = 0.1;
% Set meanVth 
meanVth = [-0.39601 0.328977];
% Set Rth 
Rth = 0.0005;

mnPoint = [];

% For Cluster 1
disp('Cluster 1 start...');
flag = 0;
Rmax = 0.05;
Rmin = 0;
while(1)
	R = (Rmax + Rmin)/2;
	% New pmos mean and nmos mean for cluster 1
	p_mean=[2.7e-9 5.1e-9 1.8e-8 meanVth(1,1)+R*cPoint(1,1) 8.80736e-3 -0.15];
	n_mean=[2.37e-9 5.8e-9 1.7e-8 meanVth(1,2)+R*cPoint(1,2) 0.026049 -0.154];
    disp(meanVth(1,1)+R*cPoint(1,1));
    disp(meanVth(1,2)+R*cPoint(1,2));
	[~, ~, ~,error_count_test, ec]=Endi_Xu_lu_Shijun_calProb(p_mean,n_mean,p_sigma,n_sigma,sample_test,fail_delay, cond_delay, stop_fom, 'x');
	if error_count_test >= 1
		Rmax = R;
        flag = 1;
	else
		Rmin = R;
	end
	if Rmax - Rmin < Rth
		bufferPoint = [meanVth(1,1)+R*cPoint(1,1) meanVth(1,2)+R*cPoint(1,2)];
		break;
	end
end

if flag == 1
	mnPoint = [mnPoint; bufferPoint];
end 

% For Cluster 2
disp('Cluster 2 start...');
flag = 0;
Rmax = 0.05;
Rmin = 0;
while(1)
	R = (Rmax + Rmin)/2;
    % New pmos mean and nmos mean for cluster 1
    p_mean=[2.7e-9 5.1e-9 1.8e-8 meanVth(1,1)+R*cPoint(2,1) 8.80736e-3 -0.15];
	n_mean=[2.37e-9 5.8e-9 1.7e-8 meanVth(1,2)+R*cPoint(2,2) 0.026049 -0.154];
    disp(meanVth(1,1)+R*cPoint(2,1));
    disp(meanVth(1,2)+R*cPoint(2,2));
	[~, ~, ~,error_count_test, ec]=Endi_Xu_lu_Shijun_calProb(p_mean,n_mean,p_sigma,n_sigma,sample_test,fail_delay, cond_delay, stop_fom,'x');
	if error_count_test >= 1
		Rmax = R;
		flag = 1;
	else
		Rmin = R;
	end
	if Rmax - Rmin < Rth
        bufferPoint = [meanVth(1,1)+R*cPoint(2,1) meanVth(1,2)+R*cPoint(2,2)];
		break;
	end
end

if flag == 1
	mnPoint = [mnPoint; bufferPoint];
end 

% For Cluster 3
disp('Cluster3 start...');
flag = 0;
Rmax = 0.05;
Rmin = 0;
while(1)
	R = (Rmax + Rmin)/2;
	% New pmos mean and nmos mean for cluster 1
    p_mean=[2.7e-9 5.1e-9 1.8e-8 meanVth(1,1)+R*cPoint(3,1) 8.80736e-3 -0.15];
	n_mean=[2.37e-9 5.8e-9 1.7e-8 meanVth(1,2)+R*cPoint(3,2) 0.026049 -0.154];
    disp(meanVth(1,1)+R*cPoint(3,1));
    disp(meanVth(1,2)+R*cPoint(3,2));
	[~, ~, ~,error_count_test, ec]=Endi_Xu_lu_Shijun_calProb(p_mean,n_mean,p_sigma,n_sigma,sample_test,fail_delay, cond_delay, stop_fom, 'x');
	if error_count_test >= 1
		flag = 1;
		Rmax = R;
	else
		Rmin = R;
	end
	if Rmax - Rmin < Rth
        bufferPoint = [meanVth(1,1)+R*cPoint(3,1) meanVth(1,2)+R*cPoint(3,2)];
		break;
    end
end

if flag == 1
	mnPoint = [mnPoint; bufferPoint];
end 


% disp('mnPoint')
disp(mnPoint);

[mnr, ~] = size(mnPoint);

failIS = zeros(mnr,1);



% Do important sampling
for i = 1 : mnr
    % Set mean
	p_mean=[2.7e-9 5.1e-9 1.8e-8 mnPoint(i,1) 8.80736e-3 -0.15];
	n_mean=[2.37e-9 5.8e-9 1.7e-8 mnPoint(i,2) 0.026049 -0.154];

	% Set Sigma
	if abs(mnPoint(i,1)-cMean(i,1)) > 1.15e-2
		psigmaVth = abs(mnPoint(i,1)-cMean(i,1));
	else
		psigmaVth = 1.15e-2;
    end
	
    if abs(mnPoint(i,2)-cMean(i,2)) > 1.094e-2
		nsigmaVth = abs(mnPoint(i,2)-cMean(i,2));
	else
		nsigmaVth = 1.094e-2;
	end
    
	p_sigma=[3.376e-20 4.277e-21 5.687e-20 psigmaVth 4.196e-5 1.797e-3];
    n_sigma=[3.602e-22 4.681e-20 1.156e-19 nsigmaVth 5.942e-6 1.367e-2];
    [failIS(i,1), ~, ~,error_count_test, ec]=Endi_Xu_lu_Shijun_calProb(p_mean,n_mean,p_sigma,n_sigma,sample_max,fail_delay, cond_delay, stop_fom, 'x');
	disp(failIS(i,1));
end

disp(failIS);

% Calculate final
pFinal = 0;
for i = 1:mnr
    pFinal = pFinal + pPre * clusterP(i,1) * failIS(i,1);
end

disp(pFinal);