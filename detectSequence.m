%% Object detection in Video by Using trained Network
% detector is trained Network (Yolo v2, R-CNN, SDD, GoogleNet etc.)
% directory is working space has sequence picture
% the Video is saved in MATLAB folder in doucument
function detectSequence(detector, directory, saveFileName, frameRate)
cnt = dir(fullfile(directory,'*.png'));
cnt = {cnt.name}';
cntsize = size(cnt,1);
fps = 0;
avgfps = [];

outputVideo = VideoWriter(fullfile('C:\Users\user\Documents\MATLAB\',saveFileName));
outputVideo.FrameRate = frameRate;
open(outputVideo)

for i = 1:cntsize
    name = strcat(directory,'\', cnt(i));
    img = imread([name{:}]);
    tic;
    [bboxes,scores,labels] = detect(detector,img);
    newt = toc;
    % fps calculation
    fps = 1/newt;
    avgfps = [avgfps fps];
    avgfps_cal = sum(avgfps)/i;
    filter = (scores<0.5);
    V = [string(labels) string(scores)];
    V(filter,:) = [];
    V = categorical(strcat(V(:,1),',',V(:,2)));
    if ~isempty(bboxes)
        img = insertObjectAnnotation(img,'rectangle',bboxes,V);
    end
    printfps = ['FPS: ' num2str(fps,'%2.2f') '  /  ' 'avgFPS: ', num2str(avgfps_cal,'%2.2f')];
    img = insertText(img, [1,1], printfps, 'FontSize', 26, 'BoxColor', 'y');
    writeVideo(outputVideo,img)
end
close(outputVideo)

%% Video Play in matlab
savedFileName = strcat(saveFileName);
implay(savedFileName)
% savedVideo = VideoReader(fullfile('C:\Users\user\Documents\MATLAB',savedFileName));
% ii = 1;
% while hasFrame(shuttleAvi)
%     mov(ii) = im2frame(readFrame(savedVideo));
%     ii = ii+1;
% end
% figure
% imshow(mov(1).cdata, 'Border', 'tight')
% movie(mov,1,savedVideo.FrameRate)
