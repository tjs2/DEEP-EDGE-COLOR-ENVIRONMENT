function [ converted ] = color_convert( rgb, color )

    color = lower(color);

    if (strcmp('rgb', color))
        converted = double(rgb); % RGB -> RGB
    elseif (strcmp('rgbdrdgdb', color))
        converted = rgb2rgbdrdgdb( rgb );
        converted = converted(:, :, [6,5,4,3,2,1]); % RGBdRdGdB -> dBdGdRBGR
    else
        converted = feval(['rgb2', color], rgb);
        converted = converted(:, :, [3,2,1]); % ABC -> CBA
    end

end

function [ lab ] = rgb2lab( rgb )

    lab = colorspace('lab<-', rgb);

end

function [ luv ] = rgb2luv( rgb )

    luv = colorspace('luv<-', rgb);

end

function [ yo1o2 ] = rgb2yo1o2( rgb )

    rgb = double(rgb);
    yo1o2 = zeros(size(rgb));

    y=1; o1=2; o2=3;

    r = rgb(:,:, 1);
    g = rgb(:,:, 2);
    b = rgb(:,:, 3);

    yo1o2(:,:, y) = (0.2857 .* r) + (0.5714 .* g) + (0.1429 .* b);
    yo1o2(:,:, o1) = r - g;
    yo1o2(:,:, o2) = (2.0 .* b) - r - g;

end

function [ i1i2i3 ] = rgb2i1i2i3( rgb )

    rgb = double(rgb);
    i1i2i3 = zeros(size(rgb));

    i1=1; i2=2; i3=3;

    r = rgb(:,:, 1);
    g = rgb(:,:, 2);
    b = rgb(:,:, 3);

    i1i2i3(:,:, i1) = (r + g + b) ./ 3;
    i1i2i3(:,:, i2) = (r - b) ./ 2;
    i1i2i3(:,:, i3) = (2.*g - r - b) ./ 4;

end

function [ drdgdb ] = rgb2drdgdb( rgb )

    rgb = double(rgb);
    drdgdb = zeros(size(rgb));

    dr=1; dg=2; db=3;

    r = rgb(:,:, 1);
    g = rgb(:,:, 2);
    b = rgb(:,:, 3);

    drdgdb(:,:, dr) = (r - g) + (r - b);
    drdgdb(:,:, dg) = (g - r) + (g - b);
    drdgdb(:,:, db) = (b - r) + (b - g);

end

function [ rgbdrdgdb ] = rgb2rgbdrdgdb( rgb )

    drdgdb = rgb2drdgdb(rgb);
    rgbdrdgdb = cat(3, double(rgb), drdgdb);

end

function [ converted ] = rgb2hsv( rgb )

    converted = colorspace('hsv<-', rgb);
    converted(:, :, 1) = converted(:, :, 1) ./ 180;
    converted(:, :, 1) = converted(:, :, 1) .* pi;

end
