function aa = adjust_canada_spec(bb)
%
%   function adjust_canada_spec
%     created 07/05/13 by TJ Hesser
%     cuts out sections of Canadian data that are assumed to be bad
%
%   INPUT:
%     bb        STRUCT    : structured array of info from read_canada_sp
%
%   OUTPUT:
%     aa        STRUCT    : corrected structured array for printing in
%                           canada_2_onlns
%
% -------------------------------------------------------------------------
aa.stnum = bb.stnum;
aa.lat = bb.lat;
aa.lon = bb.lon;
aa.dep = bb.dep;

ii = bb.hsb > 0.25 & bb.hsb < 20.0 & bb.hsb < 0.8.*(0.142.*9.81* ...
    bb.tpb.^2./(2.0*pi));
aa.date = bb.date(ii,:);
aa.timemat = bb.timemat(ii,:);
aa.ef = bb.ef(:,ii);
aa.bw = bb.bw(:,ii);
aa.freq = bb.freq(:,ii);
aa.tm = bb.tm(ii);
aa.hsb = bb.hsb(ii);
aa.tpb = bb.tpb(ii);
aa.wspd = bb.wspd(ii);
aa.gust = bb.gust(ii);
aa.wdir = bb.wdir(ii);
aa.airt = bb.airt(ii);
aa.seat = bb.seat(ii);
aa.atms = bb.atms(ii);

aa.efold = aa.ef;

for ii = 1:size(aa.ef,2);
dum = 0;
nfreq = size(aa.freq,1);
for jj = nfreq:-1:1
    dum = dum + aa.efold(jj,ii).*aa.bw(jj,ii);
    if dum == aa.hsb(ii).^2/16
        aa.ef(1:jj-1,ii) = 0;
        break
    elseif dum > aa.hsb(ii).^2/16
        aa.ef(1:jj,ii) = 0;
        break
    end
end

aa.hs(ii) = 4.0*sqrt(sum(aa.ef(:,ii).*aa.bw(:,ii)));
ip = find(aa.ef(:,ii) == max(aa.ef(:,ii)));

if length(ip) > 1
    if ip(1) == ip(2)-1
        ip = ip(1);
    else
        ip = ip(2);
    end
end
if bb.stnum >= 45000 & bb.stnum < 46000
    if ip < 17
        ip = 17;
    end
else
    if ip < 15
        ip = 15;
    end
end

aa.tp(ii) = 1.0/aa.freq(ip,ii);
end
    

