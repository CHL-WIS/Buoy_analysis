function frf_2_onlns(frf,ndbc,year,mon)
%
%    INPUT: 
%       frf    : FRF buoy number should be 3 digits
%       ndbc   : NDBC number, I can't remember what this is right now
%       year   : year of processing
%       mon    : month of processing
%
if isunix
    %cdir = '/mnt/CHL_WIS_1/CDIP/';
    cdir = '/mnt/CHL_WIS_1/FRF_WR/';
else
    cdir = 'X:\FRF_WR\';
end

if ischar(frf)
    frf = frf;
else
    if frf < 100
       frf = ['0',num2str(frf)];
    else
       frf = num2str(frf);
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
    fname = ['waverdr',frf,'_',yearc,'_',monnc,'.spec'];
    frfy = [cdir,fname];
else
    fname = ['waverdr',frf,'_',yearc,'_',monnc,'.spec'];
    frfy = [cdir,fname];
end
if exist(frfy,'file')
    if isunix
        %ndbcd = ['/mnt/CHL_WIS_1/NDBC_CDIP'];
        ndbcd = ['/mnt/CHL_WIS_1/NDBC_FRF'];
        ndbct = [ndbcd,yearc,'/',monc,'/'];
    else
        ndbcd = ['X:\NDBC_FRF\'];
        ndbct = [ndbcd,yearc,'\',monc,'\'];
    end
    
    
    nfile = [ndbct,'n',ndbcc,'_',yearc,'_',monnc,'.onlns'];
    if exist(nfile,'file')
        return
    end
    
    [aa]= read_frf_spc(cdir,fname);
%     if status == 0
%         return
%     end
    time = num2str(aa.date);
    bb1(:,1) = str2num(time(:,1:4));
    bb1(:,2) = str2num(time(:,5:6));
    bb1(:,3) = str2num(time(:,7:8));
    bb1(:,4) = str2num(time(:,9:10));
    bb1(:,5) = str2num(time(:,11:12));
    [latd,latm,lats] = ddeg2dms(aa.lat);
    [lond,lonm,lons] = ddeg2dms(aa.lon);
    loc = [latd,abs(latm),round(abs(lats)),lond,abs(lonm),round(abs(lons))];
    bb1(:,6:11) = repmat(loc,size(bb1,1),1);
    bb1(:,12) = aa.dep;
    bb1(:,13:15) = -99.99;
    bb1(:,16) = -999.9;
    bb1(:,17:18) = -99.99;
    bb1(:,19) = -999.9;
    
    ab.c11 = aa.ef;
    ab.a0 = aa.ef.*pi;
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
