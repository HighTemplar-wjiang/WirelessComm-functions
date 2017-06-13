%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created on Matlab 2013b
% Author: Weiwei Jiang (wjiang@jaist.ac.jp)
% Date: 20160304
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Channel test

clear; clc;

% Config
info_len   = 1000; % length of information sequence
% snr_array  = [-5 -2.5 0 2.5 5.0 10 15 20]; % SNR points to be simulated
snr_array = -5:1:20;
% snr_array  = 10;
frm_num    = 10000;
spec_eff   = [1 ; 2 ; 4];
chn_scheme = 'rayleigh';
mod_scheme = cellstr(['bpsk      ' ; ...
                      'qpsk_gray ' ; ...
                      '16qam_gray' ]);
                   
% Init
err_mtx = zeros(length(mod_scheme), length(snr_array));
ber_mtx = ones (length(mod_scheme), length(snr_array));

for idx_mod = 1:length(mod_scheme)
    
    fprintf('\nTesting %s...\n', char(mod_scheme(idx_mod)));

    for idx_snr = 1:length(snr_array)
        
        fprintf('\tSNR = %+03.1f dB\n', snr_array(idx_snr));

        for idx_frm = 1:frm_num

            % Generate random information sequence
            info_seq = randi([0 1], [1 info_len]);

            % Modulation
            modulated_seq = modulator(info_seq, char(mod_scheme(idx_mod)));
            
            % Channel
            [y_seq, h_seq] = rayleigh_channel(modulated_seq, snr_array(idx_snr), 'block');
%             y_seq = awgn_channel(modulated_seq, snr_array(idx_snr)); h_seq = 1;
            
            % Demodulation
            y_llr = soft_demodulator(y_seq, h_seq, snr_array(idx_snr), char(mod_scheme(idx_mod)), chn_scheme);
            
            % Hard decision
            info_est = (y_llr > 0);
            
            % BER
            err_num  = sum(info_seq ~= info_est);
            err_mtx(idx_mod, idx_snr) = err_mtx(idx_mod, idx_snr) + err_num;


        end

    end

end

ber_mtx = err_mtx / (info_len * frm_num);


% Plot
line_spec = ['ro-' ; 'bo-' ; 'rx-' ; 'bx-'];
for idx_mod = 1:length(mod_scheme)
    
    semilogy(snr_array, ber_mtx(idx_mod, :), line_spec(idx_mod, :)); hold on; grid on; % Es
%     semilogy(snr_array-10*log10(spec_eff(idx_mod)), ber_mtx(idx_mod, :), line_spec(idx_mod, :)); hold on; grid on; % Eb
    
end


