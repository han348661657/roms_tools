% ���ļ����ڵĽű������¹��ܣ�
% 1.����grib2��ʽ��NCEPԭʼ�������ص�ַ������ncep_url_generate.m �ű���
% 2.�����ص��ļ����������������ļ������ܹ���ʾ�����ڣ�����csf_rename.m �ű�
%����Ҫ�õ�nctoolbox������
%���grib2���ܶ�ȡ�������£�
setup_nctoolbox
%��ַ��https://yunpan.cn/cvRR9UHaPZa6R  �������� cec6
%http://code.google.com/p/nctoolbox

%�÷�
% s = ncdataset('http://geoport.whoi.edu/thredds/dodsC/coawst/fmrc/coawst_2_best.ncd'); 
% ds.size('temp');
% firstIdx = [4672 16 1 1]; lastIdx = [4672 16 336 896]; 
% t = ds.data('temp', firstIdx, lastIdx); % default stride here is [1 1 1 1] size(t)