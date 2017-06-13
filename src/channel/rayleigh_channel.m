%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created on Matlab 2013b
% Author: Weiwei Jiang (wjiang@jaist.ac.jp)
% Date: 20150120
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rayleigh fading channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input
% x: modulated sequence
% snr: SNR of channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
% y: channel output
% h: channel gain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [y, h] = rayleigh_channel(x, snr, type)

    size_x = size(x);
    
    % Create channel coefficients
    switch type
        
        case 'fast'
            
            h = (randn(size_x) + ...
                1i * randn(size_x)) / sqrt(2);
            
        case 'block'
            
            h = (randn(1, 1) + 1i * randn(1, 1)) / sqrt(2);
            h = repmat(h, size_x);
            
    end
    
    % AWGN: SNR = 1/ 2*sigma^2
    ebn0  = 10.0 ^ (snr / 10.0);
    sigma = 1.0 / sqrt(2.0*ebn0);
    noise = sigma * (randn(size_x) + 1i * randn(size_x));
    
    y = repmat(x, 1) .* h + repmat(noise, 1);

end