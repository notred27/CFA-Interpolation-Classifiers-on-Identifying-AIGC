
function [R,G,B] = bayers(layout)
% bayers: Return 3 2x2 bit masks that represent a Bayer array configuration
%   layout: A string containing only the characters 'r','g', and 'b'
%       *NOTE: layout will only contain 2 'g', 1 'r', and 1 'b' in valid
%       Bayer configurations

% Create the 2x2 bit masks
R = zeros(2,2);
G = zeros(2,2);
B = zeros(2,2);

% Set bits corresponding to layout
for i = 1:4
    if(layout(i) == 'r')
        R(i) = 1;
    end

    if(layout(i) == 'g')
        G(i) = 1;
    end

    if(layout(i) == 'b')
        B(i) = 1;
    end

end

R = logical(R');
G = logical(G');
B = logical(B');
end