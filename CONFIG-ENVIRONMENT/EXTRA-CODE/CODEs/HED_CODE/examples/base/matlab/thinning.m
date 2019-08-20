function [ imThinning ] = thinning( im )

    E = convTri(single(im), 1);
    
    [Ox, Oy] = gradient2(convTri(E, 4));
    
    [Oxx, ~] = gradient2(Ox); 
    [Oxy, Oyy] = gradient2(Oy);
    
    O = mod(atan(Oyy.*sign(-Oxy) ./ (Oxx+1e-5)), pi);
    
    imThinning = edgesNmsMex(E, O, 1, 5, 1.01, 4);

end
