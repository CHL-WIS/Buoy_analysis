function buoybin = buoy_time_2_hourly(buoy)
%
%    buoy_time_2_hourly
%      created by TJ Hesser 06/06/14
%      converts from variable buoy time to a hourly 
%
%   INPUT:
%     buoy:     STRUCT    : buoy structure
%       date     OPT/REQ  : 14 char date string
%       mtime    REQ/OPT  : matlab time
%       wvht     REQ      : wave height array
%       wvtp     REQ      : wave period array
%       wvdir    REQ      : wave direction array
%
%   OUTPUT:
%     buoybin:  STRUCT    : buoy binned structure
%       mtime   ARRAY     : matlab time binned
%       wvht    ARRAY     : wave height binned
%       wvtp    ARRAY     : wave period binned
%       wvdir   ARRAY     : wave direction binned
% 
% -------------------------------------------------------------------------

if ~isfield(buoy,'mtime')
    year = str2num(buoy.date(:,1:4));
    mont = str2num(buoy.date(:,5:6));
    day = str2num(buoy.date(:,7:8));
    hour = str2num(buoy.date(:,9:10));
    minc = str2num(buoy.date(:,11:12));

    buoy.mtime = datenum(year,mont,day,hour,minc,0);

    dateb = datenum(year(1),mont(1),day(1),hour(1),0,0);
    datee = datenum(year(end),mont(end),day(end),hour(end)+1,0,0);
else
    [y,m,d,h,mi,s] = datevec(buoy.mtime(1));
    dateb = datenum(y,m,d,h,0,0);
    [y,m,d,h,mi,s] = datevec(buoy.mtime(end));
    datee = datenum(y,m,d,h+1,0,0);
end

dt = datenum(0,0,0,1,0,0);
datearr = dateb:dt:datee;
dthalf = datenum(0,0,0,0,30,0);

for jtime = 1:length(datearr)
    ii = dates >= datearr(jtime)-dthalf & dates < datearr(jtime)+dthalf;
    wvht = buoy.wvht(ii);
    tp = buoy.wvtp(ii);
    dir = buoy.wvdir(ii);
    
    buoybin.wvht(jtime) = mean(wvht);
    buoybin.wvtp(jtime) = mean(tp);
    buoybin.wvdir(jtime) = mean(dir);
    buoybin.mtime(jtime) = datearr(jtime);
    clear wvht tp dir
end
