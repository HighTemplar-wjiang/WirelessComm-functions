%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created on Matlab 2013b
% Author: Weiwei Jiang (wjiang@jaist.ac.jp)
% Date: 20150206
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Beam-forming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input
% bit_seq: sequence to be transmitted
% snr: SNR of channel
% nTx: number of transmitters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
% yHat: equalized channel outputs
% h: channel coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [yHat, h] = beam_forming_bpsk(bit_seq, snr, nTx)

    % BPSK
    x = bit_seq * 2 - 1;

    % Get symbol length
    sym_len = length(x);
    
    % Rayleigh channel
    h    = (randn(nTx, sym_len) + j*randn(nTx, sym_len)) / sqrt(2);
    hEff = h .* exp(-j*angle(h)); % erase phase distortion 
    
    % AWGN: SNR = 1/ 2*sigma^2
    ebn0  = 10.0 ^ (snr / 10.0);
    sigma = 1.0 / sqrt(2.0*ebn0);
    noise = sigma * (randn(nTx, sym_len) + 1i * randn(nTx, sym_len));
    
    % Perform beam-forming in transmitter
    xr = kron(ones(nTx, 1), x);
    y  = sum(hEff.*xr + noise, 1);
    
    % Equaliztion
    yHat = y ./ sum(hEff, 1);

end