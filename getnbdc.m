% change dirname to the directory you want the data in.  
dirname = 'C:\Great_lakes\Lake_Huron\NDBC\Buoy\';
cd 'X:\NDBC\'
% change station number
file = 45008;
% change year range 
year = [1980:1:2009];
month = ['janfebmaraprmayjunjulaugsepoctnovdec'];
for kk = 1:size(year,2)
    yy = num2str(year(kk))
    cd(yy)
    moveto = [dirname,num2str(file),'\',yy];
    for jj = 1:12
        mon = month(3*jj-2:3*jj)
        cd(mon)
        if jj < 10
            cpfile = ['n',num2str(file),'_',yy,'_','0',num2str(jj)];
        else
            cpfile = ['n',num2str(file),'_',yy,'_',num2str(jj)];
        end
        file1 = [cpfile,'.onlns'];
        file2 = [cpfile,'.spe1D'];
        
        nn1 = exist(file1,'file');
        nn2 = exist(file2,'file');
        % file does't exist
        if nn1 == 2
          
        copyfile(file1,moveto);
        end
        if nn2 == 2
        copyfile(file2,moveto);
        end
        cd ../
    end
    cd ../
end
    