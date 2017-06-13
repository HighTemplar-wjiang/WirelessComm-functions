%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created on Matlab 2013b
% Author: Weiwei Jiang (wjiang@jaist.ac.jp)
% Date: 20160302
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modulator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function modulated_seq = modulator(input_seq, scheme_str)

    switch scheme_str
        
        case 'bpsk'
            
            modulated_seq = input_seq * 2 - 1; % 1 -> +1, 0 -> -1
            
        case 'qpsk_gray'
            
            modulated_seq = mod_qpsk_gray(input_seq);
            
        case '16qam_gray'
            
            modulated_seq = mod_16qam_gray(input_seq);
            
        otherwise
            error('Demodulator "%s" is not implemented yet.\n', scheme_str);
    end

end