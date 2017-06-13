%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created on Matlab 2013b
% Author: Weiwei Jiang (wjiang@jaist.ac.jp)
% Date: 20160304
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M-QAM gray code demodulator
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

function y_llr = dem_16qam_gray(y, var)

    sym_len = length(y);

    norm_scale = sqrt((2/3) * (16-1)); % avg. energy = 2/3 * (M-1) 
    %map_table  = [-3 -1 +3 +1];  % 00 01 10 11
    
    y_scale = norm_scale*y;
    
    y_real = real(y_scale);
    y_imag = imag(y_scale);
    
    % Init for bits
    y0_seq = zeros(1, sym_len);
    y1_seq = zeros(1, sym_len);
    y2_seq = zeros(1, sym_len);
    y3_seq = zeros(1, sym_len);
    
    % soft bit 0
    idx_rg2 = y_real >  2; % binary index that greater than  2
    idx_rl2 = y_real < -2; % binary index that less    than -2
    idx_rgl = ~(idx_rg2 | idx_rl2);
    
    y0_seq(idx_rg2) = 2*(y_real(idx_rg2)-1);
    y0_seq(idx_rl2) = 2*(y_real(idx_rl2)+1);
    y0_seq(idx_rgl) = y_real(idx_rgl);
%     
%     if (y_real > 2)
%         
%         y0_seq = 2*(y_real-1);
%         
%     elseif (y_real < -2)
%         
%         y0_seq = 2*(y_real+1);
%         
%     else
%         
%         y0_seq = y_real;
%         
%     end
    
    % soft bit 1
    y1_seq = -abs(y_real) + 2;
    
    % soft bit 2
    idx_ig2 = y_imag >  2; % binary index that greater than  2
    idx_il2 = y_imag < -2; % binary index that less    than -2
    idx_igl = ~(idx_ig2 | idx_il2);
    
    y2_seq(idx_ig2) = 2*(y_imag(idx_ig2)-1);
    y2_seq(idx_il2) = 2*(y_imag(idx_il2)+1);
    y2_seq(idx_igl) = y_imag(idx_igl);
%     
%     if (y_imag > 2)
%         
%         y2_seq = 2*(y_imag-1);
%         
%     elseif (y_imag < -2)
%         
%         y2_seq = 2*(y_imag+1);
%         
%     else
%         
%         y2_seq = y_imag;
%         
%     end
%     
    % soft bit 3
    y3_seq = -abs(y_imag) + 2;
    
    y_llr = [y0_seq ; y1_seq ; y2_seq ; y3_seq];
    y_llr = 2*y_llr(:)'/var;
    
    
end


