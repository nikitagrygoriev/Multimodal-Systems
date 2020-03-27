files = dir('SystemyMultimodalneLab5/LabMM3_plikiDoćwiczenia/myaudio');
fileNames = [];
for name = 3:20
    fileNames = [fileNames, string(files(name).name)];
end

table = [];
for file = fileNames
   track = load_audio(file);
   record = estimate_formants(track.s, track.Fs);
   table = [table, record(1:3)'];
end

clrs=['r','g','b','c','m','k'];
hold all
grid on
tablesNew = reshape(table,[3,3,6]);
for i = 1:6
    x = (tablesNew(1,1,i) + tablesNew(1,2,i) + tablesNew(1,3,i))/3;
    y = (tablesNew(2,1,i) + tablesNew(2,2,i) + tablesNew(2,3,i))/3;
    z = (tablesNew(3,1,i) + tablesNew(3,2,i) + tablesNew(3,3,i))/3;
    scatter3(x,y,z,clrs(i),'x')
    scatter3(tablesNew(1,1,i),tablesNew(2,1,i),tablesNew(3,1,i),clrs(i),'filled')
    scatter3(tablesNew(1,2,i),tablesNew(2,2,i),tablesNew(3,2,i),clrs(i),'filled')
    scatter3(tablesNew(1,3,i),tablesNew(2,3,i),tablesNew(3,3,i),clrs(i),'filled')
    name = char(fileNames(i*3));
    text(x+50,y,z,name(1),'FontSize',12)
end

T = array2table(table(:,1:6),'VariableNames',fileNames(1:6),'RowNames',{'F1','F2','F3'});
T1 = array2table(table(:,7:12),'VariableNames',fileNames(7:12),'RowNames',{'F1','F2','F3'});
T2 = array2table(table(:,13:18),'VariableNames',fileNames(13:18),'RowNames',{'F1','F2','F3'});

means = array2table(reshape(mean(tablesNew,2),[3 6]),'VariableNames',{'a','e','i','o','u','y'});