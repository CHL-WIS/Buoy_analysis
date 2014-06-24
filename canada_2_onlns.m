function canada_2_onlns(canada,year,varargin)
p = inputParser;
p.addRequired('canada');
p.addRequired('year');
p.addOptional('ndbc',0);
parse(p,canada,year,varargin{:})
ndbc = p.Results.ndbc;
if ndbc == 0
    ndbc = canada;
end
if isunix
   cdir = '/mnt/CHL_WIS_1/CANADIAN_BUOY_PAC/';
    %cdir = '/mnt/CHL_WIS_1/CANADIAN_BUOY_GRLAKES/';
    slash = '/';
else
    cdir = 'X:\CANADIAN_BUOY_GRLAKES\';
    slash = '\';
end
if ischar(canada)
    canadac = canada;
else
    if canada < 100
       canadac = ['0',num2str(canada)];
    else
       canadac = num2str(canada);
    end
end
if ischar(ndbc)
    ndbcc = ndbc;
else
    ndbcc = num2str(ndbc);
end
if ischar(year)
    yearc = year;
else
    yearc = num2str(year);
end
mont = ['jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct'; ...
    'nov';'dec'];
cdiry = [cdir,canadac,slash];
if exist(cdiry,'dir')
    [aa,status] = read_canada_sp(cdiry,yearc);
    if status == 0
        return
    end
    aa = adjust_canada_spec(aa);
else
    return
end
time = aa.date;
tt = str2num(time(:,1:6));
for mon = 1:12
    if ischar(mon)
        monnc = mon;
        monn = str2num(mon);
        monc = mont(monn,:);
    else
        if mon < 10
            monnc = ['0',num2str(mon)];
        else
            monnc = num2str(mon);
        end
        monc = mont(mon,:);
    end
    
    if isunix
        ndbcd = ['/mnt/CHL_WIS_1/NDBC_CANADA/'];
    else
        ndbcd = ['X:\NDBC_CANADA\'];
    end
    ndbct = [ndbcd,yearc,slash,monc,slash];
    
    nfile = [ndbct,'n',ndbcc,'_',yearc,'_',monnc,'.onlns'];
    %if exist(nfile,'file')
    %    continue
    %end
    
    
    %         if status == 0
    %             return
    %         end
    yrmon = [yearc,monnc];
    ii = str2num(yrmon) == tt;
    if any(ii)
        bb1(:,1) = str2num(time(ii,1:4));
        bb1(:,2) = str2num(time(ii,5:6));
        bb1(:,3) = str2num(time(ii,7:8));
        bb1(:,4) = str2num(time(ii,9:10));
        bb1(:,5) = str2num(time(ii,11:12));
        [latd,latm,lats] = ddeg2dms(aa.lat);
        [lond,lonm,lons] = ddeg2dms(aa.lon);
        if aa.lon < 0 & lond > 0
            lond = -1.0*lond;
        end
        if aa.lat < 0 & latd > 0
            latd = -1.0*latd;
        end
        loc = [latd,abs(latm),round(abs(lats)),lond,abs(lonm),round(abs(lons))];
        bb1(:,6:11) = repmat(loc,size(bb1,1),1);
        bb1(:,12) = aa.dep;
        bb1(:,13) = -99.99;
        bb1(:,14) = aa.wspd(ii);
        bb1(:,15) = aa.gust(ii);
        bb1(:,16) = aa.wdir(ii);
        bb1(:,17) = aa.airt(ii);
        bb1(:,18) = aa.seat(ii);
        bb1(:,19) = aa.atms(ii); 
        %bb1(:,13:15) = -99.99;
        %bb1(:,16) = -999.9;
        %bb1(:,17:18) = -99.99;
        %bb1(:,19) = -999.9;
        
        ab.c11 = aa.ef(:,ii);
        if any(strcmp('a1',fieldnames(aa)))
            ab.a1=aa.a1;ab.a2=aa.a2;
            ab.b1 = aa.b1;ab.b2 = aa.b2;
        end
        ab.df = aa.bw(:,1);
        ab.freq = aa.freq(:,1);ab.dep = aa.dep;
        bb2 = convert_2_onlns(ab);
        bb = horzcat(bb1,bb2);
        create_onlns(ndbcc,yearc,monnc,bb,ndbct);
    end
    clear bb1 bb2 ab bb
end