close all
clear all
clc

Fs = 1e3;
t = 0:1/Fs:1-1/Fs;
pspec = [];
ZC_H = [];
for H = [0.2,0.5,0.8]
    tic
    ZC1 = [];
    spec1 = [];
    ffgnparam = [1,H,8,size(t,2),0];
    
    for i = 1:50
        close all
        imf = [];
        x = ffgn(1,H,8,size(t,2),0);
        % EMD
        for j=1:8
            imfbuff = emd(x(j,:));
            imf = cat(3,imf, imfbuff(1:8,:));
        end
        imf   = permute(imf,[3 1 2]);
        spec   = filt_bank(imf);
        [ZC]   = zero_crossing(imf);
        spec1   =  cat(4, spec1  , spec(1:8,1:500,1:8));
        ZC1    = [ZC1 ZC(1:8,:)];      
    end
    ZC_H = [ZC_H mean(ZC1,2)];
    outputFolder = 'C:\Users\ali.komaty\Dropbox\MATLAB'; % save data in this folder
    outputFilename = sprintf('%s/ZC1_EMD=%d.mat', outputFolder, H*10);
    save(outputFilename, 'ZC1')
    pspec = mean(spec1,4);
    outputFilename = sprintf('%s/pspec_EMD=%d.mat', outputFolder, H*10);
    save(outputFilename, 'pspec')
    plotSpect(pspec,'FGN',ffgnparam)  
    toc
end
plotSpect(pspec,'FGN',zeros(10,1))
set(gcf, 'PaperPosition', [0 0 70 50]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [70 50]); %Set the paper to have width 5 and height 5.
print(gcf, '-dpdf', '-r300', 'filename.pdf')

%%
%%% Plot of ZC line %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(100)
for i=0:399
    plot(log2(ZC1(:,i+1)),'color',0.8*[1 1 1])
    hold on,
end

m = log2(mean(ZC1,2));
a = [1 1;8 1];
b = [m(1) m(8)]';
slope = inv(a)*b;

hp = plot(m,'k.-','LineWidth',3,'MarkerSize', 30); 
legend(hp,['slope=' num2str(slope(1))]);
hx = xlabel('IMF index');
hy = ylabel('log_2(zero-crossing)');
axis tight; grid on
set(hx, 'FontSize', 14) 
set(hx,'FontWeight','bold')
set(hy, 'FontSize', 14) 
set(hy,'FontWeight','bold')
set(gca,'fontsize',14),hold off
% 
