function res = computeParForSimiBisque(datafile,datanum,dpathsim,param,numzero,type)
%datanum
load(datafile{datanum})
datanum
disp('in loop \n')
if type==1
    D1   = D_salF.D;
    S1   = D_salF.salval;
    Y1       = D_salF.Y;
    nm1 = 'Sal'
else if type == 2
        D1 = D_salW.D;
        S1 = D_salW.weightf;
        Y1 = D_salW.Y;
        nm1 = 'SalW'
    else if type ==3
            D1  = D_Full.D;
            S1  = D_Full.salval;
            Y1  = D_Full.Y;
            nm1 = 'Full'
        end
    end
end


for data2 = 1:1:length(datafile)
    
    %trndataid = train_data(data_truncated_id(data2));
    load(datafile{data2})
    if type==1
        D2{1,data2}   = D_salF.D;
        S2{1,data2}   = D_salF.salval;
        Y2{1,data2}   = D_salF.Y;
    else if type == 2
            D2{1,data2} = D_salW.D;
            S2{1,data2} = D_salW.weightF;
            Y2{1,data2} = D_salW.Y;
        else if type ==3
                D2{1,data2}  = D_Full.D;
                S2{1,data2}  = D_Full.salval;
                Y2{1,data2}  = D_Full.Y;
            end
        end
    end
    
    x1d1{1,data2}   = OMPerrSal(D1,Y1,param.errorGoal,diag(S1));
    x1d2{1,data2}   = OMPerrSal(D2{data2},Y1,param.errorGoal,diag(S1));
    x2d1{1,data2}   = OMPerrSal(D1,Y2{data2},param.errorGoal,diag(S2{data2}));
    x2d2{1,data2}   = OMPerrSal(D2{data2},Y2{data2},param.errorGoal,diag(S2{data2}));
    dataid(1,data2) = data2;
    data2
end
savefnameFea   = strcat(dpathsim,'/','spCodes',nm1,'_',...
    num2str(datanum,numzero),'.mat')

save(savefnameFea,'x1d1','x1d2','x2d1','x2d2','D2','Y2','S2','D1','Y1','S1','datanum','dataid');

res = savefnameFea;
