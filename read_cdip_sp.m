function [aa,status] = read_cdip_sp(fdir)
%
%   Used to read in Cdip Spectral file to Matlab Structured array
%   created 08/17/2012  TJ Hesser
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
delete([fdir,'*.Z']);
fname = dir([fdir,'sp*']);
if isempty(fname)
    status = 0;aa = 0;
    return
end
dfold = 0;zf = 0;status = 1;
for zfile = 1:size(fname,1)
fid = fopen([fdir,fname(zfile).name]);                                                        % open file
data = fgetl(fid);fname2 = data(12:30);aa.analyzed = data(51:69);        % read 1st line
aa.stnum = str2double(data(14:16));
aa.sennum = str2double(data(17:18));
date = data(19:30);
daten = str2double(date);
timemat = datenum(str2double(date(1:4)),str2double(date(5:6)), ...
    str2double(date(7:8)),str2double(date(9:10)),str2double(date(11:12)),0);
data = fgetl(fid);aa.stname = data(15:41);                                 % read 2nd line
data = fgetl(fid);latc = data(10:20);lonc = data(22:32);                   % read 3rd line
aa.sensor = data(49:70);                                 % record sensor type
lat = str2double(latc(1:3)) + str2double(latc(4:8))./60;                   % calc latitude
if strcmp(latc(11),'N')                                                    %   neg if south
    aa.lat = lat;
else
    aa.lat = -lat;
end
lon = str2double(lonc(1:3)) + str2double(lonc(4:8))./60;                   % calc longitude
if strcmp(lonc(11),'W')                                                    %   neg if west
    aa.lon = -lon;
else
    aa.lon = lon;
end
data = fgetl(fid);
aa.dep = str2double(data(17:21));
                  aa.senelev = str2double(data(73:78));                    % read 4th line
data = fgetl(fid);                                                         % skip 5th line
data = fgetl(fid);aa.samplen = str2double(data(20:23));                    % read 5th line
                  aa.samprate = str2double(data(48:52));
data = fgetl(fid);hs = str2double(data(8:12));                          % read 6th line
                  tp = str2double(data(23:27));
                  dp = str2double(data(40:42));
                  ta = str2double(data(53:57));
data = fgetl(fid);data = fgetl(fid);data = fgetl(fid);
data = textscan(fid,'%f%f%f%f%f%f%f%f%s');
if zfile > 1 & data{2}(1) ~= dfold
    continue
end
zf = zf + 1;
aa.fname(zf,:) = fname2;
aa.date(zf) = daten;aa.timemat(zf) = timemat;
aa.hs(zf) = hs;aa.tp(zf) = tp;
aa.dp(zf) = dp;aa.ta(zf) = ta;
aa.freq(:,zf) = data{1};aa.bw(:,zf) = data{2};
aa.ef(:,zf) = data{3};dfold = data{2}(1);
ii = ~isnan(data{4});
if sum(ii) > 0
aa.dmean(:,zf) = data{4};
aa.a1(:,zf) = data{5};aa.b1(:,zf) = data{6};
aa.a2(:,zf) = data{7};aa.b2(:,zf) = data{8};
%aa.cf(:,zf) = data{9};
aa.dtmean(zf) = 180 + mean(aa.dmean(:,zf));
end
fclose(fid);
fmean = sum((aa.ef(:,zf).*aa.bw(:,zf))./aa.freq(:,zf));
etot = sum(aa.ef(:,zf).*aa.bw(:,zf));
fmean = etot/(fmean + 1.0e-10);
aa.tm(:,zf) = 1./fmean;
end
if any(strcmp('dtmean',fieldnames(aa)))
    aa.dtmean(aa.dtmean >= 360) = aa.dtmean(aa.dtmean >= 360) - 360;
    aa.dtmean(isnan(aa.dtmean) == 1) = -999.99;
end