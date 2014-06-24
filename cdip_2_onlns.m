function cdip_2_onlns(cdip,ndbc,year,mon)
%
%  converts cdip spectral file to WIS onlns
%    created 05/14/2013 by TJ Hesser
%
%  INPUT: 
%    cdip    NUM/STR  : CDIP ID ex (071)
%    ndbc    NUM/STR  : NDBC ID ex (46001)
%    year    NUM/STR  : year for evaluation (YYYY)
%    mon     NUM/STR  : month for evaluation (MM) 
%
%  OUTPUT:
%    writes *.onlns file to raid NDBC_CDIP as described in file
%
% ----------------------------------------------------------

% sets input directory (set to raid CDIP directory)
if isunix
    cdir = '/mnt/CHL_WIS_1/CDIP/';
    %cdir = '/home/thesser1/NODC/';
else
    cdir = 'X:\CDIP\';
end
% converts cdip to string if given in numeric form
if ischar(cdip)
    cdipc = cdip;
else
    if cdip < 100
       cdipc = ['0',num2str(cdip)];
    else
       cdipc = num2str(cdip);
    end
end
% converts ndbc to string if given in numeric format
if ischar(ndbc)
    ndbcc = ndbc;
else
    ndbcc = num2str(ndbc);
end
% converts year to string if given in nummeric
if ischar(year)
    yearc = year;
else
    yearc = num2str(year);
end
mont = ['jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct'; ...
    'nov';'dec'];
% converts mon to string and character form 
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
% finds full directory listing with year, month
if isunix
    cdiry = [cdir,'spc_',yearc,'/',cdipc,'/',monc,'/01/'];
else
    cdiry = [cdir,'spc_',yearc,'\',cdipc,'\',monc,'\01\'];
end
% looks for output directory to determin if it exists
if exist(cdiry,'dir')
    if isunix
        ndbcd = ['/mnt/CHL_WIS_1/NDBC_CDIP/'];
        %ndbcd = ['/home/thesser1/NDBC/'];
        ndbct = [ndbcd,yearc,'/',monc,'/'];
    else
        ndbcd = ['X:\NDBC_CDIP\'];
        ndbct = [ndbcd,yearc,'\',monc,'\'];
    end
    
    % name of WIS onlns file for output
    nfile = [ndbct,'n',ndbcc,'_',yearc,'_',monnc,'.onlns'];
   % if exist(nfile,'file')
   %     return
   % end
    
    % read cdip spectral files
    [aa,status]= read_cdip_sp(cdiry);
    if status == 0
        return
    end
    % set all the array parametersf from aa sturct
    time = num2str(aa.date');
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
    ab.a0 = aa.ef./pi;
    if any(strcmp('a1',fieldnames(aa)))
        ab.a1=aa.a1;ab.a2=aa.a2;
        ab.b1 = aa.b1;ab.b2 = aa.b2;
    end
    ab.df = aa.bw(:,1);
    ab.freq = aa.freq(:,1);ab.dep = aa.dep;
    % converts to onlns included MEM generation
    bb2 = convert_2_onlns(ab);
    % concatinates two arrays
    bb = horzcat(bb1,bb2);
    % writes out the onlns file
    create_onlns(ndbcc,yearc,monnc,bb,ndbct);
end