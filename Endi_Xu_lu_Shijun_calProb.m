function [failProb, fail_collector,pass_collector, error_counter_mc, error_counter_cond]=Endi_Xu_lu_Shijun_calProb(p_mean,n_mean,p_sigma,n_sigma,sample_max,proposedDelay,condDelay,stop_fom,pa)
	% Set parameters
	seed = 20160229;
	rng(seed)
	error_counter_mc = 0;
	error_counter_cond = 0;
	sample_n = 0;
	pfail = [];
	fom = [];
    if pa == 'n'
        fail_collector = [];
        pass_collector = [];
    else
        fail_collector = 0;
        pass_collector = 0;
    end
    failProb = 0;
	% replace HSPICE_PATH with your HSPICE path 
	hspice_path = 'hspice';
	
	% generate the parameters for the entire circuits
	mean_vals=zeros(1,360);
	sigma_vals=zeros(1,360);

	for i=1:10
		mean_vals(:,36*(i-1)+1:36*(i-1)+18)=[p_mean p_mean p_mean];
		mean_vals(:,36*(i-1)+19:36*(i-1)+36)=[n_mean n_mean n_mean];
		sigma_vals(:,36*(i-1)+1:36*(i-1)+18)=[p_sigma p_sigma p_sigma];
		sigma_vals(:,36*(i-1)+19:36*(i-1)+36)=[n_sigma n_sigma n_sigma];
    end
	
	while (sample_n < sample_max) 
		% first, by using MC methods to generate some samples to location the fail area
		samples = cell(60, 6);		%generate each samples 60 mosfets 
		for i = 1:60
			for j = 1:6
				random_value = rand(1);
				samples(i,j) = {norminv(random_value, mean_vals((i-1)*6+j), sigma_vals((i-1)*6+j))};
			end
		end

		%----------------------------------------------------------------------------------------------
    
		% Load the data into sweep_data_mc
		fid1 = fopen('sweep_data_mc','w');
		fprintf(fid1, '.DATA data \n');
		fprintf(fid1, 'toxe_p11 xl_p11 xw_p11 vth0_p11 u0_p11 voff_p11 \n');
		fprintf(fid1, 'toxe_p12 xl_p12 xw_p12 vth0_p12 u0_p12 voff_p12 \n');
		fprintf(fid1, 'toxe_p13 xl_p13 xw_p13 vth0_p13 u0_p13 voff_p13 \n');
		fprintf(fid1, 'toxe_n11 xl_n11 xw_n11 vth0_n11 u0_n11 voff_n11 \n');
		fprintf(fid1, 'toxe_n12 xl_n12 xw_n12 vth0_n12 u0_n12 voff_n12 \n');
		fprintf(fid1, 'toxe_n13 xl_n13 xw_n13 vth0_n13 u0_n13 voff_n13 \n');
		fprintf(fid1, 'toxe_p21 xl_p21 xw_p21 vth0_p21 u0_p21 voff_p21 \n');
		fprintf(fid1, 'toxe_p22 xl_p22 xw_p22 vth0_p22 u0_p22 voff_p22 \n');
		fprintf(fid1, 'toxe_p23 xl_p23 xw_p23 vth0_p23 u0_p23 voff_p23 \n');
		fprintf(fid1, 'toxe_n21 xl_n21 xw_n21 vth0_n21 u0_n21 voff_n21 \n');
		fprintf(fid1, 'toxe_n22 xl_n22 xw_n22 vth0_n22 u0_n22 voff_n22 \n');
		fprintf(fid1, 'toxe_n23 xl_n23 xw_n23 vth0_n23 u0_n23 voff_n23 \n');
		fprintf(fid1, 'toxe_p31 xl_p31 xw_p31 vth0_p31 u0_p31 voff_p31 \n');
		fprintf(fid1, 'toxe_p32 xl_p32 xw_p32 vth0_p32 u0_p32 voff_p32 \n');
		fprintf(fid1, 'toxe_p33 xl_p33 xw_p33 vth0_p33 u0_p33 voff_p33 \n');
		fprintf(fid1, 'toxe_n31 xl_n31 xw_n31 vth0_n31 u0_n31 voff_n31 \n');
		fprintf(fid1, 'toxe_n32 xl_n32 xw_n32 vth0_n32 u0_n32 voff_n32 \n');
		fprintf(fid1, 'toxe_n33 xl_n33 xw_n33 vth0_n33 u0_n33 voff_n33 \n');
		fprintf(fid1, 'toxe_p41 xl_p41 xw_p41 vth0_p41 u0_p41 voff_p41 \n');
		fprintf(fid1, 'toxe_p42 xl_p42 xw_p42 vth0_p42 u0_p42 voff_p42 \n');
		fprintf(fid1, 'toxe_p43 xl_p43 xw_p43 vth0_p43 u0_p43 voff_p43 \n');
		fprintf(fid1, 'toxe_n41 xl_n41 xw_n41 vth0_n41 u0_n41 voff_n41 \n');
		fprintf(fid1, 'toxe_n42 xl_n42 xw_n42 vth0_n42 u0_n42 voff_n42 \n');
		fprintf(fid1, 'toxe_n43 xl_n43 xw_n43 vth0_n43 u0_n43 voff_n43 \n');
		fprintf(fid1, 'toxe_p51 xl_p51 xw_p51 vth0_p51 u0_p51 voff_p51 \n');
		fprintf(fid1, 'toxe_p52 xl_p52 xw_p52 vth0_p52 u0_p52 voff_p52 \n');
		fprintf(fid1, 'toxe_p53 xl_p53 xw_p53 vth0_p53 u0_p53 voff_p53 \n');
		fprintf(fid1, 'toxe_n51 xl_n51 xw_n51 vth0_n51 u0_n51 voff_n51 \n');
		fprintf(fid1, 'toxe_n52 xl_n52 xw_n52 vth0_n52 u0_n52 voff_n52 \n');
		fprintf(fid1, 'toxe_n53 xl_n53 xw_n53 vth0_n53 u0_n53 voff_n53 \n');
		fprintf(fid1, 'toxe_p61 xl_p61 xw_p61 vth0_p61 u0_p61 voff_p61 \n');
		fprintf(fid1, 'toxe_p62 xl_p62 xw_p62 vth0_p62 u0_p62 voff_p62 \n');
		fprintf(fid1, 'toxe_p63 xl_p63 xw_p63 vth0_p63 u0_p63 voff_p63 \n');
		fprintf(fid1, 'toxe_n61 xl_n61 xw_n61 vth0_n61 u0_n61 voff_n61 \n');
		fprintf(fid1, 'toxe_n62 xl_n62 xw_n62 vth0_n62 u0_n62 voff_n62 \n');
		fprintf(fid1, 'toxe_n63 xl_n63 xw_n63 vth0_n63 u0_n63 voff_n63 \n');
		fprintf(fid1, 'toxe_p71 xl_p71 xw_p71 vth0_p71 u0_p71 voff_p71 \n');
		fprintf(fid1, 'toxe_p72 xl_p72 xw_p72 vth0_p72 u0_p72 voff_p72 \n');
		fprintf(fid1, 'toxe_p73 xl_p73 xw_p73 vth0_p73 u0_p73 voff_p73 \n');
		fprintf(fid1, 'toxe_n71 xl_n71 xw_n71 vth0_n71 u0_n71 voff_n71 \n');
		fprintf(fid1, 'toxe_n72 xl_n72 xw_n72 vth0_n72 u0_n72 voff_n72 \n');
		fprintf(fid1, 'toxe_n73 xl_n73 xw_n73 vth0_n73 u0_n73 voff_n73 \n');
		fprintf(fid1, 'toxe_p81 xl_p81 xw_p81 vth0_p81 u0_p81 voff_p81 \n');
		fprintf(fid1, 'toxe_p82 xl_p82 xw_p82 vth0_p82 u0_p82 voff_p82 \n');
		fprintf(fid1, 'toxe_p83 xl_p83 xw_p83 vth0_p83 u0_p83 voff_p83 \n');
		fprintf(fid1, 'toxe_n81 xl_n81 xw_n81 vth0_n81 u0_n81 voff_n81 \n');
		fprintf(fid1, 'toxe_n82 xl_n82 xw_n82 vth0_n82 u0_n82 voff_n82 \n');
		fprintf(fid1, 'toxe_n83 xl_n83 xw_n83 vth0_n83 u0_n83 voff_n83 \n');
		fprintf(fid1, 'toxe_p91 xl_p91 xw_p91 vth0_p91 u0_p91 voff_p91 \n');
		fprintf(fid1, 'toxe_p92 xl_p92 xw_p92 vth0_p92 u0_p92 voff_p92 \n');
		fprintf(fid1, 'toxe_p93 xl_p93 xw_p93 vth0_p93 u0_p93 voff_p93 \n');
		fprintf(fid1, 'toxe_n91 xl_n91 xw_n91 vth0_n91 u0_n91 voff_n91 \n');
		fprintf(fid1, 'toxe_n92 xl_n92 xw_n92 vth0_n92 u0_n92 voff_n92 \n');
		fprintf(fid1, 'toxe_n93 xl_n93 xw_n93 vth0_n93 u0_n93 voff_n93 \n');
		fprintf(fid1, 'toxe_p101 xl_p101 xw_p101 vth0_p101 u0_p101 voff_p101 \n');
		fprintf(fid1, 'toxe_p102 xl_p102 xw_p102 vth0_p102 u0_p102 voff_p102 \n');
		fprintf(fid1, 'toxe_p103 xl_p103 xw_p103 vth0_p103 u0_p103 voff_p103 \n');
		fprintf(fid1, 'toxe_n101 xl_n101 xw_n101 vth0_n101 u0_n101 voff_n101 \n');
		fprintf(fid1, 'toxe_n102 xl_n102 xw_n102 vth0_n102 u0_n102 voff_n102 \n');
		fprintf(fid1, 'toxe_n103 xl_n103 xw_n103 vth0_n103 u0_n103 voff_n103 \n');
		for i = 1:60
			for j = 1:6
				fprintf(fid1, '%e\t', samples{i,j});
			end
			fprintf(fid1, '\n');    
		end
		fprintf(fid1, '.ENDDATA\n');
		fclose(fid1);
    
		% call HSPICE simulation
		[~,~] = dos([hspice_path, ' -i path_new.sp -o path_new.lis']);
		if(~exist('path_new.lis', 'file'))
			%continue;
		end
    
		% Get the time of delay
		fid = fopen('path_new.lis', 'r');
		while(1)
			line = fgetl(fid);
			if(~ischar(line))
				break;
			end
			if(strcmp(line,'  ******  transient analysis tnom=  25.000 temp=  25.000 *****'))
				line = strtrim(fgetl(fid));
				[part1,~]=strtok(line, 'p');
				[~,part4]=strtok(part1, ' ');
				time_delay = str2double(part4);
				time_delay = time_delay * 1e-12;
			end
		end
	
		fclose(fid);
		
		if	(time_delay >= condDelay)
			error_counter_cond = error_counter_cond + 1;
		end
		
		% convergency test 
		if (time_delay >= proposedDelay)
			error_counter_mc = error_counter_mc + 1;
			% get the failure samples, for further use
            if pa == 'n'
                fail_collector = [fail_collector, samples];
            end
        else
            if pa == 'n'
                pass_collector = [pass_collector, samples];
            end
		end
	
		sample_n = sample_n+1;

		pfail = [pfail error_counter_mc/sample_n];
		fom = [fom std(pfail)/mean(pfail)];
	
		str1 = sprintf('the time delay is %e, the error_counter_mc is %d, the sample_n is %d', time_delay, error_counter_mc, sample_n);
		disp(str1);

		str2 = sprintf('failure rate = %e, FOM = %e', pfail(end), fom(end));
		disp(str2);

		if(fom(end)<=stop_fom)
			failProb = pfail(end);
			break;
		end
	end
end