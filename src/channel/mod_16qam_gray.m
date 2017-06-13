%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created on Matlab 2013b
% Author: Weiwei Jiang (wjiang@jaist.ac.jp)
% Date: 20160304
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M-QAM gray code modulator
% imaginary part (Q channel)
%              ^
%              |
%  0010  0110  |  1110  1010
%              |
%  0011  0111  |  1111  1011   
%              |
% -------------+-------------->  real part (I channel)
%              |
%  0001  0101  |  1101  1001 
%              |
%  0000  0100  |  1100  1000
%              |
%

function modulated_seq = mod_16qam_gray(input_seq)

    seq_len    = length(input_seq);
    
    if (mod(seq_len, 4) ~= 0)
        
        error('16QAM: Sequence lenth must be fourfold!\n');
        
    end
        
    input_seq  = input_seq(:)'; 
    
    norm_scale = sqrt((2/3) * (16-1)); % avg. energy = 2/3 * (M-1) 
    map_table  = [-3 -1 +3 +1];  % 00 01 10 11
    
    real_seq = [input_seq(1:4:end) ; input_seq(2:4:end)]';
    imag_seq = [input_seq(3:4:end) ; input_seq(4:4:end)]';
    
    real_idx = int32(bi2de(real_seq, 'left-msb')) + 1;
    imag_idx = int32(bi2de(imag_seq, 'left-msb')) + 1;
    
    modulated_seq = (1.0/norm_scale) * ...
        (map_table(real_idx) + map_table(imag_idx) * 1i);
    
end



