clear;
clc;

% preset descriptors of matrix

%number of participants
num_part = 64;

% electrodes
Fz = 1;
F1 = 2;
F3 = 3;
F5 = 4;
FC1 = 5;
FC3 = 6;
FC5 = 7;
Cz = 8;
C1 = 9;
C3 = 10;
C5 = 11;
CP1 = 12;
CP3 = 13;
CP5 = 14;
Pz = 15;
P1 = 16;
P3 = 17;
P5 = 18;
P7 = 19;
PO3 = 20;
PO7 = 21;
F2 = 22;
F4 = 23;
F6 = 24;
FC2 = 25;
FC4 = 26;
FC6 = 27;
C2 = 28;
C4 = 29;
C6 = 30;
CPz = 31;
CP2 = 32;
CP4 = 33;
CP6 = 34;
P2 = 35;
P4 = 36;
P6 = 37;
P8 = 38;
PO4 = 39;
PO8 = 40;
FCz = 41;
num_elec = 41;

% condition
easy = 1;
hard = 2;
num_cond = 2;

% frequency bands
theta = 1;
lo_alpha = 2;
hi_alpha = 3;
alpha = 4;
beta = 5;
lo_beta = 6;
hi_beta = 7;
gamma = 8;
t_over_a = 9;
engagement = 10;
num_band = 10;



num_samp_FFT = 1000;

%% To assess changes in performance

% % change directory to make sure we're in the correct folder
% cd('C:\Users\Cogmo Lab\Desktop\Diss\EEG\Export\B0');
% 
% 
% % get number of .dat files in folder
% a = dir('*.dat');

 

% space holder for matrix of exported data (person, condition, electrode, frequency bands)
poop = zeros(num_cond, num_part, num_elec, num_band);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Organize data into a 4-D matrix

for cond_idx = 1:num_cond;
    if cond_idx == 1;
        cd('F:\Exp6_07222016\out_task\FFT\c1');
    elseif cond_idx == 2;
        cd('F:\Exp6_07222016\out_task\FFT\c2');
    end
    
    a = dir('*.dat');
    x = size(a);
    
    for idx = 1:x(1);
        EEG = importdata (a(idx).name);
        
        for elec_idx = 1:num_elec;
            
            % calc theta power variable
            poop(cond_idx, idx, elec_idx, theta) = log(sum(EEG.data(5:8,elec_idx)));

            % calc low alpha power variable
            poop(cond_idx, idx, elec_idx, lo_alpha) = log(sum(EEG.data(9:10,elec_idx)));
    
            % calc high alpha power variable
            poop(cond_idx, idx, elec_idx, hi_alpha) = log(sum(EEG.data(11:13,elec_idx)));
    
            % calc total alpha power variable
            poop(cond_idx, idx, elec_idx, alpha) = log(sum(EEG.data(9:13,elec_idx)));
    
            % calc beta power variable
            poop(cond_idx, idx, elec_idx, beta) = log(sum(EEG.data(14:30,elec_idx)));
            
            % calc lo beta power variable
            poop(cond_idx, idx, elec_idx, lo_beta) = log(sum(EEG.data(14:23,elec_idx)));
            
            % calc hi beta power variable
            poop(cond_idx, idx, elec_idx, hi_beta) = log(sum(EEG.data(23:30,elec_idx)));
            
            % calc gamma power variable
            poop(cond_idx, idx, elec_idx, gamma) = log(sum(EEG.data(31:44,elec_idx)));
            
            % calc theta/alpha ratio
            poop(cond_idx, idx, elec_idx, t_over_a) = log((sum(EEG.data(5:8,elec_idx))) / (sum(EEG.data(9:13,elec_idx))));

            % calc EEG engagement
            poop(cond_idx, idx, elec_idx, engagement) = log((sum(EEG.data(14:30,elec_idx))) / (sum(EEG.data(9:13,elec_idx)) + sum(EEG.data(5:8,elec_idx))));
        
          
        end
        
    end
end


% Put into 2D matrix   poop = zeros(num_cond, num_part, num_elec, num_band);
% col_idx = 1;
% row_idx = 1;
FFT_matrix_2d = zeros(num_band * idx, num_elec * num_cond);
for band_idx = 1 : num_band;
    for idx = 1: num_part;
        for cond_idx = 1: num_cond;
            for elec_idx = 1: num_elec;
               
               row_idx = num_part * (band_idx - 1) + idx;
               col_idx = num_elec * (cond_idx - 1) + elec_idx; 
               FFT_matrix_2d(row_idx, col_idx) = poop(cond_idx, idx, elec_idx, band_idx);
                    
            end
        end
    end
end

     


        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Export to Excel
cd('F:\Exp6_07222016\out_task\FFT');
xlswrite('FFT_2d_notitle.xlsx',FFT_matrix_2d);
                        



%%% add titles for the SPSS
% row title first condition(easy & hard) by electronics (41 in all)
% rowtitle = zeros(1, num_cond * num_elec);
% rowtitle1 = ({'easy', 'hard'});
% rowtitle2 = ({'FZ','F1','F3','F5','FC1','FC3','FC5','CZ','C1','C3', ...,
%     'C5','CP1','CP3','CP5','PZ','P1','P3','P5','P7','PO3','PO7', ...,
%     'F2','F4','F6','FC2','FC4','FC6','C2','C4','C6', ...,
%     'CPZ','CP2','CP4','CP6','P2','P4','P6','P8','PO4','PO8','FCZ'});
