%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created on Matlab 2013b
% Author: Weiwei Jiang (wjiang@jaist.ac.jp)
% Date: 20160302
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QPSK demodulator
% Map the bits to be transmitted into QPSK symbols using Gray coding. The
% resulting QPSK symbol is complex-valued, where one of the two bits in each
% QPSK symbol affects the real part (I channel) of the symbol and the other
% bit the imaginary part (Q channel). Each part is subsequently
% modulated to form the complex-valued QPSK symbol.
%
% The Gray mapping resulting from the two branches are shown where
% one symbol error corresponds to one bit error going counterclockwise.
% imaginary part (Q channel)
%         ^
%         |
%  10 x   |   x 00   (odd bit, even bit)
%         |
%  -------+------->  real part (I channel)
%         |
%  11 x   |   x 01
%         |
% Input:
%   b = bits {0, 1} to be mapped into QPSK symbols
%
% Output:
%   d = complex-valued QPSK symbols  0.7071 + 0.7071i, etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y_llr = dem_qpsk_gray(y, var)

    seq_len  = length(y);
    
    odd_seq  = 2 * real(y) / var;
    even_seq = 2 * imag(y) / var;
    
    y_llr    = [odd_seq ; even_seq];
    y_llr    = -y_llr(:);
%     y_llr    = -reshape(y_llr(:), size(y)); % +x -> 0, -x -> 1
    
end






