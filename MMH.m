classdef MMH < handle
    properties
        mmc
        pixelType
        workDir
        rect
        img
        saveDir
    end
    
    methods
        
        function mmh = MMH(pixelType, workDir)

            import mmcorej.*
            mmh.mmc = CMMCore;
            mmh.mmc.loadSystemConfiguration ('C:\Program Files\Micro-Manager-1.4\DSLR.cfg');

            mmh.mmc.setProperty('CanonDSLRCam', 'PixelType', pixelType);
            mmh.mmc.setProperty('PIZStage', 'Interface', 'Remote: Interface commands mode');
            mmh.workDir = workDir;
            mmh.saveDir = workDir;
            mmh.pixelType = pixelType;
            mmh.img = [];
        end
        
        function Snap(mmh, show)

            mmh.mmc.snapImage();
            mmh.img = mmh.mmc.getImage();
            width = mmh.mmc.getImageWidth();
            height = mmh.mmc.getImageHeight();
            mmh.img = typecast(mmh.img, 'uint8');

            if strcmp(mmh.pixelType, 'Color')
                imgR = mmh.img(1:4:end);
                imgG = mmh.img(2:4:end);
                imgB = mmh.img(3:4:end);

                imgR = reshape(imgR, [width, height]);
                imgR = transpose(imgR);

                imgG = reshape(imgG, [width, height]);
                imgG = transpose(imgG);

                imgB = reshape(imgB, [width, height]);
                imgB = transpose(imgB);

                mmh.img = cat(3, imgB, imgG, imgR);
            else
                mmh.img = reshape(mmh.img, [width, height]);
            end

            if show == true
                figure(1);
                imshow(mmh.img);
            end
            
            if  isequal(mmh.rect, [0 0 0 0])
                mmh.rect = [0,0,mmh.mmc.getImageWidth(), mmh.mmc.getImageHeight()];
            end
        
        end
        function SaveImg(mmh, dir, fileName)
            path = fullfile(mmh.saveDir, dir, strcat(fileName, '.jpg'));
            imwrite(mmh.img, path, 'jpg');
        end
        function SetRect(mmh)
            h = figure(1);
            imshow(mmh.img);
            [imgT, mmh.rect] = imcrop(h);
            close(h);
        end
        function ZStack(mmh, vector, stackName)
            mkdir(mmh.saveDir, stackName);
            for i = 1:length(vector)
                mmh.mmc.setPosition('PIZStage', vector(i) );
                mmh.Snap(false);
                mmh.img = imcrop(mmh.img, mmh.rect);
                mmh.SaveImg(stackName, strcat(stackName,'_', int2str(i)));
            end
        end
        function Timer(mmh, delay, cycles, actions, timerName)
            for t = 1:cycles
                mkdir(mmh.workDir,timerName);
                mmh.saveDir = fullfile(mmh.workDir,timerName);
                for i=1:length(actions)
                    actions{i}(t);
                end
                pause(delay);
            end
            
            mmh.saveDir = mmh.workDir;
        end
    end
end