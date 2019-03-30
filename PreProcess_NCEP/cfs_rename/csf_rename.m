%csf重命名
function csf_rename(filefolder)
%对指定文件夹的grib2文件进行重命名
%file0='F:\NCEP\201401';
file0=filefolder;
z=pwd;
cd(fullfile(file0))
grib=dir(fullfile(file0,'*.grib2'));
n=length(grib);
for i=1:n
    file=fullfile(file0,grib(i).name);
    nc=ncgeodataset(file);
    unit=nc.attribute('time','units');%Hour since 2014-01-01T00:00:00Z
    date=unit(12:24);%2014-01-01T00
    close(nc)
    delete(nc)% 关闭nc，否则文件被占用无法重命名
    new=['cfs_',date,'.grib2'];
    old=grib(i).name;
    system(['rename ' old ' ' new]);
end
cd(fullfile(z));
    
    