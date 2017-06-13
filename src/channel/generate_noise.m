%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created on Matlab 2013b
% Author: Weiwei Jiang (wjiang@jaist.ac.jp)
% Date: 20150310
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Gaussian noise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input
% snr: snr of channel
% size: size of noise arrays
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
% noise: noise output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function noise = generate_noise(snr, size)

    % AWGN: SNR = 1/ 2*sigma^2
    ebn0  = 10.0 ^ (snr / 10.0);
    sigma = 1.0 / sqrt(2.0*ebn0);
    noise = sigma * (randn(size) + 1i * randn(size));

end