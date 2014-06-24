% read header file in NDBC
clear aa bb
year1 = 1979;year2 = 2012;
mon1 = 1;mon2 = 12;
monc = {'jan';'feb';'mar';'apr';'may';'jun';'jul';'aug'; ...
    'sep';'oct';'nov';'dec'};
for jj = year1:year2
    year = num2str(jj);
    for ii = mon1:mon2
        if ii < 10
            mon = ['0',num2str(ii)];
        else
            mon = num2str(ii);
        end
        if isunix
            cdir = '/mnt/CHL_WIS_1/NDBC/';
            fname = [cdir,year,'/',monc{ii},'/',year,'_',mon];
            if exist(fname,'file')
                fid = fopen(fname);
                data = textscan(fid,'%s%f%f%f%f%f%f%f%f%f%f%f%f%f');
            else
                continue
            end
        else
            cdir = 'X:\NDBC\';
            fname = [cdir,year,'\',monc{ii},'\',year,'_',mon];
            if exist(fname,'file')
                fid = fopen(fname);
                data = textscan(fid,'%s%f%f%f%f%f%f%f%f%f%f%f%f%f');
            else
                continue
            end
        end
        
        rt = isnan(data{2}) == 0;
        for rr = 2:size(data,2)
            bb(:,rr-1) = data{rr}(rt);
        end
        for kk = 1:size(bb,1)
            if ~exist('aa','var')
                eval(['aa.n',data{1}{kk},' = bb(kk,:);']);
            else
                nn = 1;
                if isfield(aa,['n',data{1}{kk}])
                    eval(['nn = size(aa.n',data{1}{kk},',1) + 1;']);
                end
                eval(['aa.n',data{1}{kk},'(nn,:) = bb(kk,:);']);
            end
        end
        
        clear bb
    end
end



