% 本文件夹内的脚本有以下功能：
% 1.生成grib2格式的NCEP原始数据下载地址，利用ncep_url_generate.m 脚本。
% 2.对下载的文件进行重命名，在文件名上能够显示出日期，利用csf_rename.m 脚本
%其中要用到nctoolbox工具箱
%如果grib2不能读取，运行下：
setup_nctoolbox
%网址：https://yunpan.cn/cvRR9UHaPZa6R  访问密码 cec6
%http://code.google.com/p/nctoolbox

%用法
% s = ncdataset('http://geoport.whoi.edu/thredds/dodsC/coawst/fmrc/coawst_2_best.ncd'); 
% ds.size('temp');
% firstIdx = [4672 16 1 1]; lastIdx = [4672 16 336 896]; 
% t = ds.data('temp', firstIdx, lastIdx); % default stride here is [1 1 1 1] size(t)