%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created on Matlab 2013b
% Author: Weiwei Jiang (wjiang@jaist.ac.jp)
% Date: 20150122
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Soft demodulator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input
% y: received signals
% h: channel coefficient
% snr: SNR of channel
% scheme_str: modulation scheme
% channel_str: channel scheme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
% llr_ch: channel LLR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function llr_ch = soft_demodulator(y, h, snr, scheme_str, channel_str)

    var = 0;
    
    switch channel_str
        case 'awgn'
            ebn0  = 10.0 ^ (snr/10.0);
            var   = 1.0 / (2.0*ebn0);
            llr_y = y;
        case 'rayleigh'
            ebn0  = 10.0 ^ (snr/10.0);
            var   = 1.0 / (2.0*ebn0);
            llr_y = y .* conj(h);
        otherwise
            error('Channel "%s" is not implemented yet.\n', channel_str);
    end

    switch scheme_str
        case 'bpsk'
            llr_ch = 2 * real(llr_y / var);
        otherwise
            error('Demodulator "%s" is not implemented yet.\n', scheme_str);
    end
    
    llr_ch = llr_ch * 1.0; % scale
       
end
