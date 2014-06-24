function aa = read_canada_csv(fdir,fname)

fid = fopen([fdir,fname]);

data = textscan(fid,'%s%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f', ...
    'headerlines',2,'delimiter',',');

aa.station = data{1}{1};
for jj = 1:length(data{2})
    date = data{2}{jj};
    mon(jj,:) = date(1:2);
    day(jj,:) = date(4:5);
    year(jj,:) = date(7:10);
    hour(jj,:) = date(12:13);
    minu(jj,:) = date(15:16);
end
aa.date = [year,mon,day,hour,minu];
aa.date(:,13:14) = '00';
aa.date = str2num(aa.date);

aa.timemat = datenum(str2num(year),str2num(mon),str2num(day),...
    str2num(hour),str2num(minu),0);

aa.qflag = data{3};
aa.lat = data{4};
aa.lon = data{5};
aa.dep = data{6};


fclose(fid);