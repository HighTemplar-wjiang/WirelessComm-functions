%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created on Matlab 2013b
% Author: Weiwei Jiang (wjiang@jaist.ac.jp)
% Date: 20150206
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2x2 Zero forcing equalizer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input
% bit_seq: sequence to be transmitted
% snr: SNR of channel
% nTx: number of transmitters
% nRx: number of receivers
% sic_flag: flag of successive iterference cancellation
% opt_ord_flag: flag of optimal ordering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
% xHat: equalized channel outputs
% h: channel coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xHat, h] = zf_bpsk(bit_seq, snr, nTx, nRx, sic_flag, opt_ord_flag)

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
    
    % Zero forcing equalizer
    % Compute W = (H'H)^-1*H'
    w = zeros(nRx, sym_len);
    for idx = 0:1:(sym_len/nTx)-1
        
        hi = h(:, :, idx+1);
        wi = pinv(hi'*hi)*hi';
        
        w(:, idx*nTx+1:(idx+1)*nTx) = wi.'; % no conjugate transpose
        
    end
    
    % Estimate by using W
    yMod = kron(y, ones(1, nRx));
    xHat = sum(w .* yMod, 1);
    
    % SIC
    if (sic_flag ~= 0) % SIC
        
        ord = repmat(1:1:nTx, 1, sym_len/nTx);
        
        if (opt_ord_flag ~= 0) % SIC with optimal ordering
        
            hPow = squeeze(sum(h .* conj(h), 1));
            [~, ord] = sort(hPow, 1, 'descend');
        
        end
       
        % Perform SIC
        hCan  = h;
        xRhat = xHat;
        xHat  = zeros(1, sym_len);
        for ii = 1:1:nTx
            
            % Take the most reliable estimation
            iTx = [0:1:sym_len/nTx-1] .* nTx + ord(ii, :);
            xHat(iTx) = xRhat(iTx);
            xHat_mod  = reshape(kron(xHat, ones(nRx, 1)), [nRx nTx sym_len/nTx]);
            
            % Cancel the detected seq.
            yCan = y - squeeze(sum(h .* xHat_mod, 2));
            
            % De-flat the channel coefficient
            for iSym = 1:sym_len/nTx
                hCan(:, ord(ii, iSym), iSym) = 0;
            end
            
            % Re-calculate W
            for idx = 0:1:(sym_len/nTx)-1

                hi = hCan(:, :, idx+1);
                wi = pinv(hi'*hi)*hi';

                w(:, idx*nTx+1:(idx+1)*nTx) = wi.'; % no conjugate transpose

            end
            
            % Re-estimate sequence
            yMod  = kron(yCan, ones(1, nRx));
            xRhat = sum(w .* yMod, 1);
            
        end
        
    end
    
    

end
