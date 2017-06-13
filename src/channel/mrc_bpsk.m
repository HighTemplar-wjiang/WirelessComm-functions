%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created on Matlab 2013b
% Author: Weiwei Jiang (wjiang@jaist.ac.jp)
% Date: 20150206
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MRC for bpsk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input
% bit_seq: sequence to be transmitted
% snr: SNR of channel
% nRx: number of receivers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
% llr_ch: channel llr
% xHat: demapped sequence
% h: channel coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [llr_ch, xHat, h] = mrc_bpsk(bit_seq, snr, nRx)

    % BPSK
    x = bit_seq * 2 - 1;

    % Get symbol length
    sym_len = length(x);
    
    % Rayleigh channel
    h = (randn(nRx, sym_len) + j*randn(nRx, sym_len)) / sqrt(2);
    
    % AWGN: SNR = 1/ 2*sigma^2
    ebn0  = 10.0 ^ (snr / 10.0);
    sigma = 1.0 / sqrt(2.0*ebn0);
    noise = sigma * (randn(nRx, sym_len) + 1i * randn(nRx, sym_len));
    
    % Transmit
    xD = kron(ones(nRx, 1), x);
    y  = h.*xD + noise;
    
    % Equalization
    xHat = sum(conj(h).*y, 1) ./ sum(h.*conj(h), 1);
    
    % Soft demodulation
    llr_ch = soft_demodulator(xHat, 1, snr, 'bpsk', 'awgn');

end
