fname = 'HPMode_JayBot_GM_NewHighlightmcts_2019.11.06-00.58.47.json'; 
fid = fopen(fname); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);
rounds=val.rounds;
i=0;
for k=1:length(rounds)
    
    round = rounds(k);
    hlData = round{1};
    p1Energy = vertcat(hlData.p1Energy);
    p2Energy= vertcat(hlData.p2Energy);
    difDis = vertcat(hlData.difDistance);
    p1EnergySmooth=smooth(p1Energy,0.2,'loess');
    p2EnergySmooth = smooth(p2Energy,0.2,'loess');
    difDisSmooth=smooth(difDis,0.2,'loess');
    p1EnergyHat= max(p1Energy)/max(p1EnergySmooth)*p1EnergySmooth;
    p2EnergyHat= max(p2Energy)/max(p2EnergySmooth)*p2EnergySmooth;
    difDistanceHat = 1-(max(difDis)/max(difDisSmooth)*difDisSmooth); 
    % reverse distance, 1-far, 0-near
    HlScore = (p1EnergyHat+p2EnergyHat+difDistanceHat)/3;
    x = 1:length(HlScore);
    h = figure;
    plot(x,p1EnergyHat,'b-',x,p2EnergyHat,'y-',x,difDistanceHat,'g-',x,HlScore,'r-');
    saveas(h,num2str(i),'fig');
    i=i+1;
end

