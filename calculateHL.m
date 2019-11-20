function [hlScore] = calculateHL(val)
%CALCULATEHL 此处显示有关此函数的摘要
%   此处显示详细说
rounds=val.rounds;
rounds= transpose(rounds);
i=0;
hlScore = zeros(3600,3);
if length(rounds)==4
    
    rounds=rounds(:,2:4);
end
for k=1:3
    disp("round:"+k);
    %%%%%%data preparation
    tf=isa(rounds,"cell");
    if tf 
        round = rounds{k};
    else
    round =rounds(:,k);
    end
    hlData = round;
   
    p1HitAddEnergy=vertcat(hlData.p1hitAddEnergy);
    p2HitAddEnergy=vertcat(hlData.p2hitAddEnergy);
   
     p1GuardAddEnergy=vertcat(hlData.p1guardAddEnergy);
    p2GuardAddEnergy=vertcat(hlData.p2guardAddEnergy);
   
     p1GiveEnergy=vertcat(hlData.p1giveEnergy);
    p2GiveEnergy=vertcat(hlData.p2giveEnergy);
    p1ActionScore=normalize(p1HitAddEnergy+p1GuardAddEnergy+p1GiveEnergy,"range");
    p2ActionScore=normalize(p2HitAddEnergy+p2GuardAddEnergy+p2GiveEnergy,"range");
    
    p1Position = vertcat(hlData.p1Position);
    p2Position = vertcat(hlData.p2Position);
    frameNumber=vertcat(hlData.frameNumber);
    p1Damage=normalize(vertcat(hlData.p1Damage).*frameNumber,'range');
    p2Damage=normalize(vertcat(hlData.p2Damage).*frameNumber,'range');
    G = horzcat(p1ActionScore,p2ActionScore,p1Position,p2Position,p1Damage,p2Damage);
   %%%smooth 
    
   % w = kaiser(length(x),14);
    
    
    %HlScore = (p1ActionScore + p2ActionScore+ p1Position+p2Position+ p1Damage+p2Damage)/6;
    %p1EnergySmooth=smooth(p1Energy,0.2,'loess');
    %p2EnergySmooth = smooth(p2Energy,0.2,'loess');
    %difDisSmooth=smooth(difDis,0.2,'loess');
    %p1EnergyHat= max(p1Energy)/max(p1EnergySmooth)*p1EnergySmooth;
    %p2EnergyHat= max(p2Energy)/max(p2EnergySmooth)*p2EnergySmooth;
    %difDistanceHat = 1-(max(difDis)/max(difDisSmooth)*difDisSmooth); 
    % reverse distance, 1-far, 0-near
    %HlScore = (p1EnergyHat+p2EnergyHat+difDistanceHat)/3;
    
   
    %HlScore = smooth(HlScore,0.2,'loess');
    %HlScoreSmooth = smooth(HlScore,0.2,"loess");
    
    %HlScoreSmooth = w.*HlScore;
    %plot(x,HlScore,'b-',x,HlScoreSmooth,"r-");
    %plot(x,p1GiveEnergy,'b+',x,p1HitAddEnergy,"ro",x,p1GuardAddEnergy,"m*");
   x = 1:length(frameNumber);
    x = x/60;
    r=zeros(length(x),1);
    for i = 1:6
        xSmooth=smooth(G(:,i),0.2,"moving");
        xScale= (max(G(:,i))/max(xSmooth))*xSmooth;
        r=r+xScale;
    end
    % h = figure;
     result=r/6;
%    plot(x,result,"k-");
%     saveas(h,num2str(i),'fig');
%     i=i+1;
   hlScore(1:length(result),k) = result;
end
end

