function aa = mat_onlns_struct(aalen)

%       :  time      NUM   : MAT time 
%       :  lat       NUM   : Latitude
%       :  lon       NUM   : Longitude
%       :  dep       NUM   : Depth
%       :  alt       NUM   : anemometer height
%       :  wspd      NUM   : wind speed
%       :  gust      NUM   : wind speed gust
%       :  wdir      NUM   : wind direction
%       :  air       NUM   : air temperature
%       :  sea       NUM   : sea-surface temperature
%       :  bar       NUM   : barometric pressure
%       :  hmo       NUM   : Wave height
%       :  tp        NUM   : Peak period
%       :  tpp       NUM   : Parabolic fit peak period
%       :  tm        NUM   : Mean period
%       :  wavdvt    NUM   : Mean wave direction
%       :  wavdvfm   NUM   : Wave direction at mean frequency
%       :  wavpd     NUM   : Wave direction at peak period
%       :  wavdmx    NUM   : Wave direction spread
%       :  delhmo    NUM   : Delft wave height
%       :  delttp    NUM   : Delft peak period
%       :  deltm     NUM   : Delft mean period
%       :  deltm1    NUM   : Delft 1st moment mean period
%       :  deltm2    NUM   : Delft 2nd moment mean period
%       :  delfspr   NUM   : Delft mean direction
%       :  delftmdr  NUM   : Delft direction at mean period
%       :  delftpdr  NUM   : Delft direction at peak period
%       :  delftsprd NUM   : Delft directional spreading
%       :  sumefx    NUM   : can't remember
%       :  sumefy    NUM   : can't remember
%       :  summfx    NUM   : can't remember
%       :  summfy    NUM   : can't remember

aa.time = repmat(-999,[aalen,1]);
aa.lat = -999;
aa.lon = -999;
aa.dep = -999;
aa.alt = -999;
aa.wspd = repmat(-999,[aalen,1]);
aa.gust = repmat(-999,[aalen,1]);
aa.wdir = repmat(-999,[aalen,1]);
aa.air = repmat(-999,[aalen,1]);
aa.sea = repmat(-999,[aalen,1]);
aa.bar = repmat(-999,[aalen,1]);
aa.hmo = repmat(-999,[aalen,1]);
aa.tp = repmat(-999,[aalen,1]);
aa.tpp = repmat(-999,[aalen,1]);
aa.tm = repmat(-999,[aalen,1]);
aa.wavdvt = repmat(-999,[aalen,1]);
aa.wavdvfm = repmat(-999,[aalen,1]);
aa.wavpd = repmat(-999,[aalen,1]);
aa.wavdmx = repmat(-999,[aalen,1]);
aa.delhmo = repmat(-999,[aalen,1]);
aa.delttp = repmat(-999,[aalen,1]);
aa.deltm = repmat(-999,[aalen,1]);
aa.deltm1 = repmat(-999,[aalen,1]);
aa.deltm2 = repmat(-999,[aalen,1]);
aa.delfspr = repmat(-999,[aalen,1]);
aa.delftmdr = repmat(-999,[aalen,1]);
aa.delftpdr = repmat(-999,[aalen,1]);
aa.delftsprd = repmat(-999,[aalen,1]);
aa.sumefx = repmat(-999,[aalen,1]);
aa.sumefy = repmat(-999,[aalen,1]);
aa.summfx = repmat(-999,[aalen,1]);
aa.summfy = repmat(-999,[aalen,1]);

