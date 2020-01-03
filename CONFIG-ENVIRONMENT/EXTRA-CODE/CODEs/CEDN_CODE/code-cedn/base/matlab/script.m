clear, clc;
im_rgb = imread('im.png');

%% RGB = 0
rgb = color_convert( im_rgb, 'RGB' );

disp([sprintf('\r\n'), 'RGB-R']);
disp(num2str(rgb(:, :, 1)));

disp([sprintf('\r\n'), 'RGB-G']);
disp(num2str(rgb(:, :, 2)));

disp([sprintf('\r\n'), 'RGB-B']);
disp(num2str(rgb(:, :, 3)));


%% LAB = 1
bal = color_convert( im_rgb, 'LAB' );

disp([sprintf('\r\n'), 'LAB-L']);
disp(num2str(bal(:, :, 3)));

disp([sprintf('\r\n'), 'LAB-A']);
disp(num2str(bal(:, :, 2)));

disp([sprintf('\r\n'), 'LAB-B']);
disp(num2str(bal(:, :, 1)));

%% LUV = 2
vul = color_convert( im_rgb, 'LUV' );

disp([sprintf('\r\n'), 'LUV-L']);
disp(num2str(vul(:, :, 3)));

disp([sprintf('\r\n'), 'LUV-U']);
disp(num2str(vul(:, :, 2)));

disp([sprintf('\r\n'), 'LUV-V']);
disp(num2str(vul(:, :, 1)));

%% YO1O2 = 3
o2o1y = color_convert( im_rgb,'YO1O2' );

disp([sprintf('\r\n'), 'YO1O2-Y']);
disp(num2str(o2o1y(:, :, 3)));

disp([sprintf('\r\n'), 'YO1O2-O1']);
disp(num2str(o2o1y(:, :, 2)));

disp([sprintf('\r\n'), 'YO1O2-O2']);
disp(num2str(o2o1y(:, :, 1)));

%% I1I2I3 = 4
i3i2i1 = color_convert( im_rgb, 'I1I2I3' );

disp([sprintf('\r\n'), 'I1I2I3-I1']);
disp(num2str(i3i2i1(:, :, 3)));

disp([sprintf('\r\n'), 'I1I2I3-I2']);
disp(num2str(i3i2i1(:, :, 2)));

disp([sprintf('\r\n'), 'I1I2I3-I3']);
disp(num2str(i3i2i1(:, :, 1)));

%% dRdGdB = 5
dbdgdr = color_convert( im_rgb, 'dRdGdB' );

disp([sprintf('\r\n'), 'dRdGdB-dR']);
disp(num2str(dbdgdr(:, :, 3)));

disp([sprintf('\r\n'), 'dRdGdB-dG']);
disp(num2str(dbdgdr(:, :, 2)));

disp([sprintf('\r\n'), 'dRdGdB-dB']);
disp(num2str(dbdgdr(:, :, 1)));

%% RGBdRdGdB = 6
dbdgdrbgr = color_convert( im_rgb, 'RGBdRdGdB' );

disp([sprintf('\r\n'), 'RGBdRdGdB-R']);
disp(num2str(dbdgdrbgr(:, :, 6)));

disp([sprintf('\r\n'), 'RGBdRdGdB-G']);
disp(num2str(dbdgdrbgr(:, :, 5)));

disp([sprintf('\r\n'), 'RGBdRdGdB-B']);
disp(num2str(dbdgdrbgr(:, :, 4)));

disp([sprintf('\r\n'), 'RGBdRdGdB-dR']);
disp(num2str(dbdgdrbgr(:, :, 3)));

disp([sprintf('\r\n'), 'RGBdRdGdB-dG']);
disp(num2str(dbdgdrbgr(:, :, 2)));

disp([sprintf('\r\n'), 'RGBdRdGdB-dB']);
disp(num2str(dbdgdrbgr(:, :, 1)));

%% HSV = 7
vsh = color_convert( im_rgb, 'HSV' );

disp([sprintf('\r\n'), 'HSV-H']);
disp(num2str(vsh(:, :, 3)));

disp([sprintf('\r\n'), 'HSV-S']);
disp(num2str(vsh(:, :, 2)));

disp([sprintf('\r\n'), 'HSV-V']);
disp(num2str(vsh(:, :, 1)));
