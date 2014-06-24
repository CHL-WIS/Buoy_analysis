clear all

%Each lake is given a number
%0 --- Superior
%1 --- Michigan
%2 --- Huron
%3 --- St. Clair
%4 --- Erie
%6 --- Ontario

lake = input('What lake is being processes:  ');

%Load in .onlns files
files = dir('*.onlns');
filename = getfield(files(1,1),'name');
Outf = filename(1:11);
fullout = [Outf,'.ALL'];

%Put all months into a single file .ALL
comm = ['type *.onlns > ',fullout];
system(comm)

%Create a fort.5 to be used by buoy2ISH_format.exe
year = filename(8:11);
station = filename(2:6);

fid = fopen('fort.5','wt');
fprintf(fid,'%4s \n',year);
fprintf(fid,'%5s \n',station);
fprintf(fid,'%1i \n',lake);
fclose(fid);

%Run buoy2ISH_format.exe
buoyconvert = ['C:\Great_lakes\ISH_Processing\src\buoy2ISH_format.exe < fort.5'];
system(buoyconvert)