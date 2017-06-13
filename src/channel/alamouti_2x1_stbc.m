% Created on Matlab 2013b
% Author: Weiwei Jiang (weiweijiangcn@gmail.com)
% Create Date: 20140922
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transmit signals in a 2x1 alamouti STBC channel

function [llr_ch, h] = alamouti_2x1_stbc(modulated_data, snr, type)
    
    % Length of transmit data
    len = length(modulated_data);

    % Create Rayleigh distributed channel response matrix
    switch type
        case 'block'
            
            h = reshape(generate_channel_coeff([2 len/2], 'block'), 1, len);
            
        case 'fast'
            
            h = generate_channel_coeff([1 len], 'fast');
            
        otherwise
            
            error('Type %s is not implemented yet.\n', type);
    
    end
    hMod = kron(reshape(h, 2, len/2), ones(1, 2));
    
    % Alamouti STBC
    sCode = zeros(2, len);
    sCode(:, 1:2:end) = (1/sqrt(2)) * reshape(modulated_data, 2, len/2);
    sCode(:, 2:2:end) = (1/sqrt(2)) * (kron(ones(1, len/2), [-1;1]) ...
        .* flipud(reshape(conj(modulated_data), 2, len/2)));
    
    % Transmit signals
    y = awgn_channel(sum(hMod.*sCode, 1), snr);
    
    % Form y matrix [y1 y1 ... ; y2* y2* ...]
    yMod = kron(reshape(y, 2, len/2), ones(1,2));
    yMod(2, :) = conj(yMod(2, :));
    
    % Form equalization matrix [h1* h2* ... ; h2 -h1 ...]
    hEq = zeros(2, len);
    hEq(:, 1:2:end) = reshape(h, 2, len/2);
    hEq(:, 2:2:end) = kron(ones(1,len/2), [1;-1]) .* ...
        flipud(reshape(h, 2, len/2));
    hEq(1, :) = conj(hEq(1,:));
    hEqPower = sum(hEq.*conj(hEq), 1);
    
    % Equalization
    xHat = sum(hEq.*yMod, 1) ./ hEqPower;
        
    % Output
    llr_ch = soft_demodulator(xHat, 1, snr, 'bpsk', 'awgn');

end