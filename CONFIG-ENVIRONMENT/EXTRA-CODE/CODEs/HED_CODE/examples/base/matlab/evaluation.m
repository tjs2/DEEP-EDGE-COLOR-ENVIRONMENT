function evaluation(foldersToEval, resDir, gtDir)

    for i = 1 : length(foldersToEval)

        tic;

        currentResDir = [resDir, foldersToEval{i}, '/'];
        [odsF,odsP,odsR,odsT,oisF,oisP,oisR,AP,R50] = edgesEvalDir('resDir', currentResDir, 'gtDir', gtDir);
        
        ret = [ ...
        'odsT = ' , num2str(odsT), ...
        ' odsR = ', num2str(odsR), ...
        ' odsP = ', num2str(odsP), ...
        ' odsF = ', num2str(odsF), ...
        ' oisR = ', num2str(oisR), ...
        ' oisP = ', num2str(oisP), ...
        ' oisF = ', num2str(oisF), ...
        ' AP = '  , num2str(AP),   ...
        ' R50 = ' , num2str(R50)   ...
        ];

        disp(ret);
        fp = fopen([currentResDir, '/-eval/r-', foldersToEval{i}, '.txt'],'w');
        fprintf(fp, ret);
        fclose(fp);

        edgesEvalPlot(currentResDir, [foldersToEval{i}]);
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        saveas(gcf, [currentResDir, '/-eval/r-', foldersToEval{i}], 'png');
        close all;

        time = toc;
        disp(['Iteration: ', int2str(i), ' - Time: ', num2str(time)]);

    end

end
