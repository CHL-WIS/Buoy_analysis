function unzip_cdip(year,bb)

runcode = '/usr/bin/7z';

cd(['spc_',num2str(year)]);
%bo = ls('*');buoy = bo(3:end,:);
if bb < 100
   buoy = ['0',num2str(bb)];
else
   buoy = num2str(bb);
end
for zbuoy = 1:1%length(buoy)
    cd(buoy(zbuoy,:));fprintf(1,'Buoy number: %1s \n',buoy(zbuoy,:));pause(10);
    mo = dir('*'); 
    for jmon = 3:length(mo)
        mon = mo(jmon).name;
        cd(mon);fprintf(1,'Month: %1s \n',mon);pause(5);
        pay = dir('*'); 
        for ipay = 3:size(pay,1)
            payload = pay(ipay).name;
            cd(payload);
            fname = dir('*.Z');
            for qfile = 1:length(fname)
               ftext = [runcode,' e ',fname(qfile).name];               system(ftext);
            end
            delete *.Z;
            cd ../
        end
        cd ../
    end
    cd ../
end
cd ../