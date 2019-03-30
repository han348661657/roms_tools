%csf������
function csf_rename(filefolder)
%��ָ���ļ��е�grib2�ļ�����������
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
    delete(nc)% �ر�nc�������ļ���ռ���޷�������
    new=['cfs_',date,'.grib2'];
    old=grib(i).name;
    system(['rename ' old ' ' new]);
end
cd(fullfile(z));
    
    