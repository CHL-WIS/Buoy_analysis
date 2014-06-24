function bb = convert_2_onlns(aa)
%
%  convert a structured array to onlns array format
%    created 05/15/2013 TJ Hesser
%
%  INPUT:
%    aa.        STRUCT    : structured array with wave parameters
%      
for zz = 1:size(aa.c11,2)
    hmo = 4.0*sqrt(sum(aa.c11(:,zz).*aa.df));
    [fpp,fm,fp,mp] = periods(aa.c11(:,zz),aa.freq,aa.df);
    tpp = 1./(fpp + 1.0e-10);
    tm = 1./(fm + 1.0e-10);
    tp = 1./(fp + 1.0e-10);
    [delhmo,delttp,deltm,deltm1,deltm2, ...
    delfspr] = delftsums(aa.c11(:,zz),aa.freq,aa.df);
%end

if mp > 0
    if any(strcmp('a1',fieldnames(aa)))
        
        ef2d = twodgen_mem(aa.freq,aa.c11(:,zz),aa.a1(:,zz), ...
            aa.b1(:,zz),aa.a2(:,zz),aa.b2(:,zz),aa.dep);
        [wavdvt,wavdvfm,wavpd,wavdmx,wavfmx, ...
            sumefx,sumefy,summfx,summfy] = ....
            directns(ef2d,aa.freq,aa.df,360,1,mp,aa.dep);
        [delftmdr,delftpdr,delftsprd] = ...
            delftsdrs(ef2d,aa.freq,aa.df,360,1);
    elseif any(strcmp('r1',fieldnames(aa)))
        [ef2d] = twodgen(aa.c11(:,zz),aa.freq,aa.df,aa.r1(:,zz), ...
            aa.r2(:,zz),aa.alpha1(:,zz),aa.alpha2(:,zz),aa.dep);
        [wavdvt,wavdvfm,wavpd,wavdmx,wavfmx ...
            ,sumefx,sumefy,summfx,summfy] = ...
            directns(ef2d,aa.freq,aa.df,360,1,mp,dep);
        [delftmdr,delftpdr,delftsprd] = ...
            delftsdrs(ef2d,aa.freq,aa.df,360,1);
    else
        wavdvt = -999.00;wavdvfm = -999.00;wavpd = -999.00;
        wavdmx = -999.00;wavfmx = -999.00;sumefx = -999.00;
        sumefy = -999.00;summfx = -999.00;summfy = -999.00;
        delftmdr = -999.00;delftpdr = -999.00;delftsprd = -999.00;
    end
else
    wavdvt = -999.00;wavdvfm = -999.00;wavpd = -999.00;
    wavdmx = -999.00;wavfmx = -999.00;sumefx = -999.00;
    sumefy = -999.00;summfx = -999.00;summfy = -999.00;
    delftmdr = -999.00;delftpdr = -999.00;delftsprd = -999.00;
end

bb(zz,:) = [hmo,tp,tpp,tm,wavdvt,wavdvfm,wavpd,wavdmx,delhmo,delttp,deltm, ...
    deltm1,deltm2,delfspr,delftmdr,delftpdr,delftsprd,sumefx,sumefy, ...
    summfx,summfy];
end