%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Created on Matlab 2013b
% Author: Weiwei Jiang (wjiang@jaist.ac.jp)
% Date: 20150310
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate channel coefficients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input
% size: size of channel coefficients arrays
% type: type of channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
% h: channel coefficient output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h = generate_channel_coeff(channel_size, channel_type)

    switch channel_type
        
        case 'fast'
            
            h = (randn(channel_size) + 1i * randn(channel_size)) / sqrt(2.0);
            
        case 'block'
            
            h = (randn(channel_size(1),1) + 1i * randn(channel_size(1),1)) / sqrt(2.0);
            h = repmat(h, 1, channel_size(2));
            
    end

end