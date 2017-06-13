%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created on Matlab 2013b
% Author: Weiwei Jiang (wjiang@jaist.ac.jp)
% Date: 20150206
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2x2 Maximum Likelihood Receiver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input
% bit_seq: sequence to be transmitted
% snr: SNR of channel
% nTx: number of transmitters
% nRx: number of receivers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
% xHat: equalized channel outputs
% h: channel coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xHat, h] = ml_bpsk(bit_seq, snr, nTx, nRx)

    % BPSK
    x = bit_seq * 2 - 1;

    % Get symbol length
    sym_len = length(x);
    
    % Group symbos
    xMod = reshape(kron(x, ones(nRx, 1)), [nRx, nTx, sym_len/nTx]);
    
    % Rayleigh channel
    h = (randn(nRx, nTx, sym_len/nTx) + j*randn(nRx, nTx, sym_len/nTx)) ...
        / sqrt(2);
    
    % AWGN: SNR = 1/ 2*sigma^2
    ebn0  = 10.0 ^ (snr / 10.0);
    sigma = 1.0 / sqrt(2.0*ebn0);
    noise = sigma * (randn(nRx, sym_len/nTx) + ...
               1i * randn(nRx, sym_len/nTx));
           
    % Transmit
    y = squeeze(sum(h.*xMod, 2)) + noise;

    % Maximum Likelihood equalizer
    sym_alphabet = [-1 +1];
    sym_set      = rep_perms(sym_alphabet, nTx)';
    nPerms       = length(sym_alphabet)^nTx; % number of possible symbols
    J = zeros(nPerms, sym_len/nTx);
    for iPerm = 1:nPerms
        
        xHat     = repmat(sym_set(:, iPerm), [1 sym_len/nTx]);
        xHat_mod = kron(xHat, ones(nRx, 1));
        xHat_mod = reshape(xHat_mod, [nRx, nTx, sym_len/nTx]);
        zHat     = squeeze(sum(h.*xHat_mod, 2));
        J(iPerm, :) = sum(abs(y-zHat), 1);
        
    end
    
    % Decision
    [~, iHat] = min(J, [], 1);
    
    % Get estimation sequence
    all_seq = repmat(sym_set, [1 sym_len/nTx]);
    iHat    = iHat + nPerms*(0:1:sym_len/nTx-1);
    xHat    = all_seq(:, iHat);
    xHat    = reshape(xHat, 1, sym_len);
    

end
