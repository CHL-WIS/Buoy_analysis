function buoy = frf_cliff_2_struct(fname)
%
%     frf_cliff_2_struct
%       created by TJ Hesser 06/06/14
%       reads frf files from Cliff to a structured array format
%
%   INPUT:
%     fname      STRING      : file name to read in
%
%   OUTPUT:
%     buoy:      STRUCT      : structured array
%       date     ARRAY       : 14 char date
%       stat     VALUE       : station id
%       wvht     ARRAY       : wave heights
%       wvtp     ARRAY       : wave period
%       wvdir    ARRAY       : wave direction
%
% -------------------------------------------------------------------------
fid = fopen(fname);
data = textscan(fid,'%s%s%s%s%s%f%f%f');
fclose(fid);

for jj = 1:length(data{6})  
    date(jj,:) = [data{1}{jj},data{2}{jj},data{3}{jj},data{4}{jj},'00'];
end
buoy.date = date;
buoy.stat = data{5}{1};
buoy.wvht = data{7};
buoy.wvdir = data{6};
buoy.wvtp = data{8};