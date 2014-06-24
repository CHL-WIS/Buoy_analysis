function aa = read_frf_spc(cdir,fname)
%
%  function to read the frf spectral file 
%    created 05/09/2013 by TJ Hesser
%
%  INPUT:
%    cdir    STRING  : Directory where spectral file resides
%    fname   STRING  : Name of spectral file 
%
%  OUTPUT:
%    aa      STRUCT  : Structered array with the following variables
%      stat   NUMERIC :  Name of the station
%      lon    NUMERIC :  Longitude  - for West
%      lat    NUMERIC :  Latitude 
%      date   STRING A :  dates UTC yyyymmddhhmmss [1 numofdates]
%      timemat NUMERIC : Matlab time UTC
%      dep    NUMERIC :  depth (m)
%      hs     ARRAY   :  wave height (m) [1 x numofdates]
%      tp     ARRAY   :  peak period (s) [1 x numofdates]
%      wdir   ARRAY   :  wave direction (deg) [1 x numofdates]
%      freq   ARRAY   :  Frequency (Hz) [numfreq x 1]
%      bw     ARRAY   :  Frequency Spacing (Hz) [numfreq x 1]
%      ef     ARRAY   :  Energy Density (m^2/Hz) [numfreq x numofdates]
%      a1     ARRAY   :  A1 direction  [numfreq x numofdates]
%      a2     ARRAY   :  A2 direction  [numfreq x numofdates]
%      b1     ARRAY   :  B1 direction  [numfreq x numofdates]
%      b2     ARRAY   :  B2 direction  [numfreq x numofdates]
%
%--------------------------------------------------------------------------
fid = fopen([cdir,fname]);
data = textscan(fid,'%f%f%f%f%f%f%f%f%f%f',1);
nn = 0;
while ~isempty(data{1});
    nn = nn+1;
    stat = data{1};
    year = data{2};mon = data{3};day = data{4};hmin = data{5};
    hmo(nn,1) = data{6};tp(nn,1) = data{7};idir(nn,1) = data{8};
    sfratio = data{9};qflag = data{10};
    
    if mon < 10
        monc = ['0',num2str(mon)];
    else
        monc = num2str(mon);
    end
    if day < 10
        dayc = ['0',num2str(day)];
    else
        dayc = num2str(day);
    end
    hminc = num2str(hmin);
    if hmin < 100
        hourc1 = '0';
        minc = '00';
    elseif hmin < 1000
        hourc1 = hminc(1);
        minc = hminc(2:3);
    else
        hourc1 = hminc(1:2);
        minc = hminc(3:4);
    end
    hour = str2num(hourc1);
    if hour < 10
        hourc = ['0',num2str(hour)];
    else
        hourc = num2str(hour);
    end
    minut = str2num(minc);
    if minut < 10
        minutc = ['0',num2str(minut)];
    else
        minutc = num2str(minut);
    end
    
    %dates(nn,:) = [num2str(year),monc,dayc,hourc, minutc];
    timemat(nn) = datenum(year,mon,day,hour,minut,0);
    
    if nn == 1
        %load('/home/thesser1/My_Matlab/Buoy_analysis/frf_loc.mat');
        if isunix
            load('/home/thesser1/My_Matlab/Buoy_analysis/frf_loc.mat');
        else
            load('C:\matlab\My_Matlab\Buoy_analysis\frf_loc.mat');
        end
        ii = timeref > timemat(nn);
        if ~isempty(timeref(ii))
            jj = find((ii == 1), 1 );
            lat = latref(jj);
            lon = lonref(jj);
        else
            lat = latref(end); %#ok<*COLND>
            lon = lonref(end);
        end
    end
    
    data = textscan(fid,'%f%f%f%f%f%f%f%f',1);
    nrec(nn) = data{1};isegrec = data{2};
    ensembles = data{3};ibandw = data{4};
    deltaf = data{5};idof = data{6};depth = data{7};
    anglefrf = data{8};
    
    data = textscan(fid,'%f%f%f%f%f%f%f',1);
    f1 = data{1};df = data{2};
    nfreq = data{3};
    cohvn = data{4};cohvw = data{5};
    cohnw = data{6};stdk = data{7};
    
    data = textscan(fid,'%f%f%f%f%f%f',nfreq);
    ef(:,nn) = data{1};
    a1(:,nn) = data{2};b1(:,nn) = data{3};
    a2(:,nn) = data{4};b2(:,nn) = data{5};kfac(:,nn) = data{6};
    
    data = textscan(fid,'%f%f%f%f%f%f%f%f%f%f',1);
end
freq = f1:df:f1+((nfreq-1)*df);
aa.stat = stat;
aa.lon = lon;aa.lat = lat;

% adjust date and time from EST with daylight savings to UTM
for jj = 1:size(timemat,2)
    btemp = datestr(timemat(jj),23);
    if is_Daylight_Savings(btemp);
        iadd = 4;
    else
        iadd = 5;
    end
    timemat(jj) = timemat(jj) + datenum(0,0,0,iadd,0,0);
    tt1 = datestr(timemat(jj),30);
    dates(jj,:) = [tt1(1:8),tt1(10:end)];
end
aa.date = dates;
aa.timemat = timemat;
aa.dep = depth;
aa.hs = hmo';aa.tp = tp';aa.wdir = idir';
aa.freq = freq';aa.bw = repmat(df,size(freq))';
aa.ef = ef;aa.a1 = a1;aa.a2 = a2;
aa.b1 = b1;aa.b2 = b2;
