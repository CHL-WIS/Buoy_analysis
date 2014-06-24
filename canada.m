clear all

%Determine station name and lake number
%Each lake is given a number
%0 --- Superior
%1 --- Michigan
%2 --- Huron
%3 --- St. Clair
%4 --- Erie
%6 --- Ontario
stat = input('What is the name of the station:  ','s');
lake = input('What lake is being processed:  ');
cutoff = input('What is the cutoff frequency for the data set :');

%Unzip files (unzip_files.m is a code which should be in the directory)
fileToRead1 = [stat,'.csv'];
fprintf(1,'Step 1: unzip files \n')
%unzip_files

newData1 = importdata(fileToRead1);

%Read in the .csv file to get the wind data
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end
fprintf(1,'Step 2: Analyze csv file \n')

%Seperate each variable for date and time to make the proper format 
for ii = 1:size(data,1)
    date = char(textdata{ii+1,2});
    month = date(1:2);
    day = date(4:5);
    year = date(7:10);
    hour = date(12:13);
    minute = date(15:16);
    
    dateout{ii,1} = [year,month,day,hour,minute];
    
%     for jj = 1:numyearst
%         if str2double(year(1:2)) > 19
%             dateyear{str2double(year(3:4))+1}(:) = dateout{ii,1};
%         end
%     end
    yrs(ii,1) = str2double(year);
end

%Determine the number of years to process
numyears = [min(yrs):1:max(yrs)];
numyearst = size(numyears,2);

%Remove any NaN's from the files and repalce with -99
for jj = 1:size(data,2)
    check1 = isnan(data(:,jj));
    a = find(check1(:,1) == 1);
    data(a,jj) = -99;
    clear a check1
end
blahblah = data;
latdd = data(:,2);
londd = data(:,3);
depth = data(:,4);
wdir = data(:,10);
wspd = data(:,11);
gspd = data(:,13);
atms = data(:,18);
dryt = data(:,20);
sstp = data(:,21);

%Convert decimal degrees to degrees, minutes, seconds
for ii = 1:size(data,1)
    latd(ii,1) = fix(latdd(ii,1));
    latm(ii,1) = fix((latdd(ii,1) - latd(ii,1))*60);
    lats(ii,1) = round(((latdd(ii,1) - latd(ii,1))*60 - latm(ii,1))*60);
    
    lond(ii,1) = fix(londd(ii,1));
    lonm(ii,1) = fix((londd(ii,1) - lond(ii,1))*60);
    lons(ii,1) = round(((londd(ii,1) - lond(ii,1))*60 - lonm(ii,1))*60);
end

%Write out a .dat file to be using in the canada_specV2.exe
fprintf(1,'Step 3: Write out year files \n')
for jj = 1:numyearst
    kk = find(yrs(:) == numyears(jj));
    for mm = 1:size(kk,1)
        dateyear{1,mm,jj} = dateout{kk(mm),1};
    end
    yearsize(jj) = size(kk,1);

% for jj = 1:numyearst
    station= char(textdata{2,1});
    filename = [station(1:6),'_',num2str(numyears(jj)),'.dat'];
    fid = fopen(filename,'wt');
    id = 999999;
    aelev = 3.3;
    
    for ii = 1:yearsize(jj)
        fprintf(fid,'%6i %5s %13s',id,station(2:end),dateyear{1,ii,jj});
        fprintf(fid,'%7i %4i %4i %5i %5i %5i',latd(kk(ii),1),latm(kk(ii),1),lats(kk(ii),1), ...
          lond(kk(ii),1),lonm(kk(ii),1),lons(kk(ii),1));
        fprintf(fid,'%7.1f %6.1f %6.1f %6.1f %8.1f %7.1f %7.1f\n',aelev,wspd(kk(ii),1),gspd(kk(ii,1)), ...
            wdir(kk(ii),1),atms(kk(ii),1),dryt(kk(ii),1),sstp(kk(ii),1));
    end

    fclose(fid);
    
end
%Write out buoy file to be used in canada_specV2.exe
fprintf(1,'Step 4: Write buoy file \n')
fid2 = fopen('canada_bouy.dat','wt');
fprintf(fid2,'%4i %4i %6s %4.2f',min(yrs),max(yrs),station(1:6),cutoff);
fclose(fid2);

%Run canada_specV2.exe to make *.onlns and *.spec1d
fprintf(1,'Step 5: Run canada_specV2 \n')
specname = ['C:\Great_lakes\ISH_processing\src\canada_specV2.exe'];
system(specname)

%Create fort.5 for use by buoy2ISH_format.exe
%Run buoy2ISH_format.exe 
fprintf(1,'Step 6: Bouy processing \n')
buoyname = ['C:\Great_lakes\ISH_processing\src\buoy2ISH_format.exe < fort.5'];
for jj = 1:numyearst
    fid3 = fopen('fort.5','wt');
    fprintf(fid3,'%4i %5s \n',numyears(jj),station(2:end));
    fprintf(fid3,'%1i \n',lake);
    fclose(fid3);
    system(buoyname)
end