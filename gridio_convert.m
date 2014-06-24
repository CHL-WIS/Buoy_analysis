clear all

files = '..\LakeSTCL_18SV3.dep';
fid = fopen(files,'r');
data = fscanf(fid,'%f',6);
dx = data(1);
dy = data(2);
lats = data(3);
latn = data(4);
lonw = data(5);
lone = data(6);
ny = floor((latn - lats)/dx + 1);
nx = floor((lone - lonw)/dy + 1);
dep = fscanf(fid,'%5i%1c',[2*nx ny]);
depth = dep(1:2:end-1,:)';
fclose(fid);

fid2 = fopen('fort.20','r');
for jj = 1:nx
    dat = fscanf(fid2,'%1i',ny);
    dep10(jj,:) = dat';
end
fclose(fid2);
dep10 = dep10';

for jj = 1:nx
    for ii = 1:ny
        if dep10(ii,jj) == 0;
            depth_t(ii,jj) = depth(ii,jj);
        elseif dep10(ii,jj) == 1;
            depth_t(ii,jj) = 0;
        elseif dep10(ii,jj) >= 2;
            depth_t(ii,jj) = dep10(ii,jj);
        end
    end
end
depth_t = depth_t';

[latg long] = meshgrid(lats:dy:latn,lonw:dx:lone);

depc = vertcat(depth_t(:,1),depth_t(:,2));
latc = vertcat(latg(:,1),latg(:,2));
lonc = vertcat(long(:,1),long(:,2));
for ii = 3:size(depth_t,2);
    depc = vertcat(depc,depth_t(:,ii));
    latc = vertcat(latc,latg(:,ii));
    lonc = vertcat(lonc,long(:,ii));
end

lsxyz(:,1) = lonc;
lsxyz(:,2) = latc;
lsxyz(:,3) = depc;

load_coast
figure('inverthardcopy','off','color','white')
hold on
% for ii = 1:size(lsxyz,1)
%     if (lsxyz(ii,3) > 0.0)
%         plot(lsxyz(ii,1),lsxyz(ii,2),'b.')
%     else
%         plot(lsxyz(ii,1),lsxyz(ii,2),'r.')
%     end
% end
for jj = 1:2:101
    for ii = 1:2:131
        if (lsxyz(ii+(131*(jj-1)),3) > 0.0)
            plot(lsxyz(ii+(131*(jj-1)),1),lsxyz(ii+(131*(jj-1)),2),'b.')
        else
            plot(lsxyz(ii+(131*(jj-1)),1),lsxyz(ii+(131*(jj-1)),2),'r.')
        end
    end
end

for ii = 1:123
   plot(lon{ii},lat{ii},'k');
end
xlabel('Longitude','fontweight','bold');
ylabel('Latitude','fontweight','bold');
cx1 = [-83.00:0.13:-82.35-0.13];
cx2 = [-83.00+0.13:0.13:83.35];
cy1 = [42.25:0.1:42.75-0.1];
cy2 = [42.25+0.1:0.1:42.75];
nn = 0;
for jj = 1:5
    for ii = 1:5
        nn = nn + 1;
        axis([cx1(ii) cx2(ii) cy1(jj) cy2(jj)]);
        fname = ['LS-zone-',num2str(nn)];
        title(fname);
        print(gcf,'-dpng',fname);
    end
end

axis([-83 -82.725 42.25 42.45]);
title('LS Southwest')
print(gcf,'-dpng','LS_sw');

axis([-83 -82.725 42.45 42.75]);
title('LS Northwest')
print(gcf,'-dpng','LS_nw');

axis([-82.725 -82.35 42.45 42.75]);
title('LS Northeast')
print(gcf,'-dpng','LS_ne');

axis([-82.725 -82.35 42.25 42.45]);
title('LS Southeast')
print(gcf,'-dpng','LS_se');

% lond(:,1) = fix(lsxyz(:,1));
% lonm(:,1) = fix((-lsxyz(:,1)+lond(:,1))*60);
% lonsec(:,1) = fix(((-lsxyz(:,1)+lond(:,1))*60-lonm(:,1))*60);
% latd(:,1) = fix(lsxyz(:,2));
% latm(:,1) = fix((lsxyz(:,2)-latd(:,1))*60);
% latsec(:,1) = fix(((lsxyz(:,2)-latd(:,1))*60-latm(:,1))*60);
% 
% fid3 = fopen('stclair_bathy_cor.xyz','wt')
% for ii = 1:size(lsxyz,1)
%     fprintf(fid3,'%4i %4i %4i %4i %4i %4i %6.1f \n',lond(ii,1),lonm(ii,1),lonsec(ii,1), ...
%         latd(ii,1),latm(ii,1),latsec(ii,1),-lsxyz(ii,3));
% end
% fclose(fid3);
% 
% fid4 = fopen('sclair_corr_deg.xyz','wt')
% for ii = 1:size(lsxyz,1)
%     fprintf(fid4,'%10.6f %10.6f %6.1f \n',lsxyz(ii,1),lsxyz(ii,2),lsxyz(ii,3));
% end
% fclose(fid4)