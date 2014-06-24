function [aa,status] = read_canada_sp(fdir,year)
%
%   Used to read in Canadian Spectral file to Matlab Structured array
%   created 11/16/2012  TJ Hesser
%
%   reads in a month of spectral files at a time
%   results in a structured array   
%   len = 1 entry per file
%   aa.
%         fname   :  file name (len) (String)
%         analyzed:  date file was analysized by CDIP (UTM) (String)
%         stnum   :  CDIP Station Number (Numeric) 
%         sennum  :  CDIP Sensor Number (Numeric)
%         date    :  Date  (YYYYMMDDHHMM) (len) (Numeric)
%         timemat :  Matlab Time (len) (Numeric)
%         stname  :  Station Name (String)
%         sensor  :  CDIP buoy type (String)
%         lat     :  Latitude (Numeric)  (S = negative)
%         lon     :  Longitude (Numeric) (W = negative)
%         dep     :  Depth relative to MLLW  (m) (Numeric)
%         senelev :  Sensor elevation (Nominal Depth) (m) (Numeric)
%         samplen :  Length of Sample  (sec)  (Numeric)
%         samprate:  Sample rate (Hz) (Numeric)
%         hs      :  Significant wave height (Hmo) (m) (len) (Numeric)
%         tp      :  Peak Period (s) (len) (Numeric)
%         dp      :  Wave direction at Peak Period (deg) (len) (Numeric)
%         ta      :  Average Period (Tm0/Tm1) (s) (len) (Numeric)
%         freq    :  Frequency (64 x len) (Hz) (Numeric)
%         bw      :  Bandwidth (64 x len) (Hz) (Numeric)
%         ef      :  Energy Density (64 x len) (m^2/Hz) (Numeric)
%         dmean   :  Mean Wave Direction (64 x len) (deg) (Numeric)
%         a1,b1,a2,b2 : Directional Fourier Coefficients (64 x len) (Numeric)
%         cf      :  Check Factor  = 1 for deep water (64 x len) (Numeric)
%         tm      :  Mean Wave Period (len) (s) (Numeric)
%         dtmean  :  Total mean wave direction (len) (deg) (met) (Numeric)
% -------------------------------------------------------------------------
%clear all
fname = dir([fdir,'*',year,'.fb']);
if isempty(fname)
    fnamezip = dir([fdir,'*',year,'.zip']);
    if size(fnamezip,1) == 0
        status = 0;aa = 0;
        return
    end
    for zz = 1:size(fnamezip,1)
        cd(fdir)
        unzip(fnamezip(zz).name);
    end
    fname = dir([fdir,'*',year,'.fb']);
    if isempty(fname)
        fname = dir([fdir,'*',year,'.FB']);
    end
end
dfold = 0;zf = 0;status = 1;
for zfile = 1:size(fname,1)
fid = fopen([fdir,fname(zfile).name]);                                                        % open file
data = fgetl(fid);
nn = 0;
while data ~= -1;
fname2 = data(41:46);                                                   % read 1st line
aa.stnum = str2double(fname2(2:end));
%data = textscan(fid,'%f%f%f%4.0f%1.0f%2.0f%1.0f%2.0f%f%f%f%f%f%f%f',1);
data = fgetl(fid);
aa.lat = str2num(data(1:10));aa.lon = str2num(data(11:20));
if aa.lon > 0
    aa.lon = -1.0 * aa.lon;
end
aa.dep = str2num(data(21:28));year = str2num(data(30:33));
mon = str2num(data(34:35));day = str2num(data(36:37));
hour = str2num(data(39:40));minu = str2num(data(41:42));
numopt = str2num(data(67:70));
numpar = str2num(data(71:73)) + str2num(data(74:76));
numfreq = str2num(data(77:80));
yearc = num2str(year);
if isempty(hour)
    hour = 0;
end
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
if hour < 10
    hourc = ['0',num2str(hour)];
else
    hourc = num2str(hour);
end
if minu < 10
    minc = ['0',num2str(minu)];
else
    minc = num2str(minu);
end
dates = [yearc,monc,dayc,hourc,minc];

for ii = 1:numopt
   datan = fscanf(fid,'%f',1);
   datac = fscanf(fid,'%4c',1);
   if strcmp(datac(4),'$')
       datac(4) = 'S';
   end
   eval(['bb.',datac,' = datan;']);
end

for ii = 1:numpar
    datan = fscanf(fid,'%f',1);
    datac = fscanf(fid,'%4c',1);
    if strcmp(datac(4),'$')
        datac(4) = 'S';
    end
    eval(['bb.',datac,' = datan;']);
end
for ii = 1:numfreq
    try
        freq(ii) = fscanf(fid,'%f',1);
    catch
        freq(ii)
    end
    df(ii) = fscanf(fid,'%f',1);
    ef(ii) = fscanf(fid,'%f',1);
end
if nn > 0 & size(freq,2) ~= oldfreq
    data = fgetl(fid);data = fgetl(fid);
    continue
end
nn = nn + 1;
oldfreq = size(freq,2);
aa.date(nn,:) = dates;
aa.timemat(nn,1) = datenum(year,mon,day,hour,minu,0);
aa.ef(:,nn) = ef';
aa.bw(:,nn) = df';
aa.freq(:,nn) = freq';
fmean = sum((aa.ef(:,nn).*aa.bw(:,nn))./aa.freq(:,nn));
etot = sum(aa.ef(:,nn).*aa.bw(:,nn));
fmean = etot/(fmean + 1.0e-10);
aa.tm(:,nn) = 1./fmean;
aa.hsb(:,nn) = bb.VCAR;
aa.tpb(:,nn) = bb.VTPK;
if isfield(bb,'WSPD')
    aa.wspd(:,nn) = bb.WSPD;
    aa.wdir(:,nn) = bb.WDIR;
    aa.gust(:,nn) = bb.GSPD;
    aa.airt(:,nn) = bb.DRYT;
    aa.seat(:,nn) = bb.SSTP;
else
    aa.wspd(:,nn) = -99.99;
    aa.wdir(:,nn) = -999.;
    aa.gust(:,nn) = -99.99;
    aa.airt(:,nn) = -99.99;
    aa.seat(:,nn) = -99.99;
end
if isfield(bb,'ATMS')
    aa.atms(:,nn) = bb.ATMS;
else
    aa.atms(:,nn) = -999.9;
end

data = fgetl(fid);data = fgetl(fid);
clear freq df ef
end
%delete([fdir,fname(zfile).name])
end
fclose(fid);
%delete(fname);
% fmean = sum((aa.ef(:,zf).*aa.bw(:,zf))./aa.freq(:,zf));
% etot = sum(aa.ef(:,zf).*aa.bw(:,zf));
% fmean = etot/(fmean + 1.0e-10);
% aa.tm(:,zf) = 1./fmean;
% end
% if any(strcmp('dtmean',fieldnames(aa)))
%     aa.dtmean(aa.dtmean >= 360) = aa.dtmean(aa.dtmean >= 360) - 360;
%     aa.dtmean(isnan(aa.dtmean) == 1) = -999.99;
% end