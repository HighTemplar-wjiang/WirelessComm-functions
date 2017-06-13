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

    if(snr == Inf)
        
        llr_ch = sign(y) .* repmat(100, size(y));
        return;
        
    elseif(snr == -Inf)
        
        llr_ch = zeros(size(y));
        return;
        
    end

    var     = 0;
    seq_len = length(y);
    
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
            
        case 'qpsk_gray'
            
            llr_ch = dem_qpsk_gray(llr_y, var);
            
        case '16qam_gray'
            
            llr_y  = llr_y ./ (abs(h).^2);
            llr_ch = dem_16qam_gray(llr_y, var);
            
        otherwise
            error('Demodulator "%s" is not implemented yet.\n', scheme_str);
    end
    
    llr_ch = llr_ch * 1.0; % scale
    llr_ch = Limit(llr_ch, 100);
       
end
