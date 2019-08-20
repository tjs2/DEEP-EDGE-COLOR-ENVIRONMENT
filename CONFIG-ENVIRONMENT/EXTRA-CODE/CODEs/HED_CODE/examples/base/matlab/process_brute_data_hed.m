function process_brute_data_hed(foldersToEval, bruteResDir, resDir)

    for i = 1 : length(foldersToEval)

        tic;

        currentbruteResDir = [bruteResDir, foldersToEval{i}, '/'];
        fileListMats = java.io.File([bruteResDir, foldersToEval{i}, '/IN/fuse/']);
        matsToProcessNames = fileListMats.list;
        amountMats = size(matsToProcessNames, 1);

        mkdir([bruteResDir, foldersToEval{i}, '/OUT/average1-5-brute/']);
        mkdir([bruteResDir, foldersToEval{i}, '/OUT/fuse-brute/']);

        mkdir([bruteResDir, foldersToEval{i}, '/OUT/average1-5-thinning/']);
        mkdir([bruteResDir, foldersToEval{i}, '/OUT/fuse-thinning/']);

        mkdir([bruteResDir, foldersToEval{i}, '/OUT/merge-brute/']);
        mkdir([bruteResDir, foldersToEval{i}, '/OUT/merge-thinning/']);

        mkdir([resDir, foldersToEval{i}]);

        for j = 1 : amountMats

            currentImageName = matsToProcessNames(j).toCharArray';
            currentImageName = currentImageName(1:find(currentImageName == '.')-1);

            disp(['    Image: ', currentImageName]);

            currentFuseMat = [bruteResDir, foldersToEval{i}, '/IN/fuse/', currentImageName, '.mat'];
            matObj = matfile(currentFuseMat);
            varList = who(matObj);
            currentFuseImg = matObj.(char(varList));

            currentFuseMat = [bruteResDir, foldersToEval{i}, '/IN/average1-5/', currentImageName, '.mat'];
            matObj = matfile(currentFuseMat);
            varList = who(matObj);
            currentAverage1_5Img = matObj.(char(varList));

            imwrite(uint8(round(currentAverage1_5Img*255)), [bruteResDir, foldersToEval{i}, '/OUT/average1-5-brute/', currentImageName, '.png']);
            imwrite(uint8(round(currentFuseImg*255)), [bruteResDir, foldersToEval{i}, '/OUT/fuse-brute/', currentImageName, '.png']);

            currentAverage1_5Img_brute = currentAverage1_5Img;
            currentFuseImg_brute = currentFuseImg;

            currentAverage1_5Img = thinning(currentAverage1_5Img);
            currentFuseImg = thinning(currentFuseImg);

            imwrite(uint8(round(currentAverage1_5Img*255)), [bruteResDir, foldersToEval{i}, '/OUT/average1-5-thinning/', currentImageName, '.png']);
            imwrite(uint8(round(currentFuseImg*255)), [bruteResDir, foldersToEval{i}, '/OUT/fuse-thinning/', currentImageName, '.png']);

            mergeImg = (currentFuseImg_brute + currentAverage1_5Img_brute) / 2;

            imwrite(uint8(round(mergeImg*255)), [bruteResDir, foldersToEval{i}, '/OUT/merge-brute/', currentImageName, '.png']);

            mergeImg = thinning(mergeImg);

            imwrite(uint8(round(mergeImg*255)), [bruteResDir, foldersToEval{i}, '/OUT/merge-thinning/', currentImageName, '.png']);
            imwrite(uint8(round(mergeImg*255)), [resDir, foldersToEval{i}, '/', currentImageName, '.png']);

        end

        time = toc;
        disp(['Iteration: ', int2str(i), ' - Folder: ', foldersToEval{i}, ' - Time: ', num2str(time)]);

    end

end
