close all
clear all
clc

Fs = 1e3;
t = 0:1/Fs:1-1/Fs;
pspec = [];
for H = [0.6:0.1:0.9]
    spec1 = [];
    all_imfs =[];
    ffgnparam = [1,H,8,size(t,2),0];
    
    for i = 1:500
        x = ffgn(1,H,8,size(t,2),0);
        imf1 = [];
        % EMD
        for j=1:8
            imf1buff = emd(x(j,:));
            imf1 = cat(3,imf1, imf1buff(1:7,:));            
        end
        imf1   = permute(imf1,[3 1 2]);
        all_imfs = cat(4,all_imfs, imf1(1:8,1:7,:));        
    end
    outputFolder = 'C:\Users\ZeinAli\Documents\Dropbox\MATLAB'; % save data in this folder
        outputFilename = sprintf('%s/IMFs_4D_EMD=%d.mat', outputFolder, H*10);
    save(outputFilename, 'all_imfs')
end
