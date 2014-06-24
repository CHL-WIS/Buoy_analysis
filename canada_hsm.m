files = dir('*_*.ALL');
files2 = dir('*_*.onlns');

for zz = 1:size(files,1)
    filename = getfield(files(zz,1),'name');
    filename2 = getfield(files2(zz,1),'name');
    data = load(filename);
    data2 = load(filename2);
    hs(:,1) = data(:,21);
    hs2(:,1) = data2(:,21);
    
    kk = find(hs > 0.0 & hs < 5.0);
    kk2 = find(hs2 > 0.0 & hs < 5.0);
    hsm(1,zz) = mean(hs(kk,1));
    hsmax(1,zz) = max(hs(kk,1));
    
    hsm2(1,zz) = mean(hs2(kk2,1));
    hsmax2(1,zz) = max(hs2(kk2,1));
    
    clear data hs kk data2 hs2 kk2
end