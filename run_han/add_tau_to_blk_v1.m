% 此程序用来将WWIII输出的ta和toc写入到roms_rutegers
% 的blk.nc文件中，替换掉里面的风速
% 需要在roms模式中搭配WINDSTRESS && BULK_FLUXS cpp开关
clearvars -global
close all
romstools_param
%*************************************************
% ta or toc 原始数据，该文件夹下为年份文件夹如：
% /2006
% 再下一层文件夹 /ust、taw、two三个子文件夹     
ww3_dir='H:\ww3\raw data\'; 
blk_old_dir='ROMS_FILES\';% roms_blk.nc文件所在路径
blk_new_dir='ROMS_FILES\ww3_toc\';% 新的roms_blk.nc文件路径
grd_name='ROMS_FILES\roms_grd.nc';
varname='toc';% 'tar' or 'toc'
blk_prefix='roms_blk_CFSR_';

if exist(blk_new_dir,'dir')==0
	mkdir(blk_new_dir);% 或者用 mkdir data,在当前目录下，生成一个data文件夹
end
%****************************************************

 for Y=Ymin:Ymax
    if Y==Ymin 
      mo_min=Mmin;
    else
      mo_min=1;
    end
    if Y==Ymax
      mo_max=Mmax;
    else
      mo_max=12;
    end
    for M=mo_min:mo_max
      disp(' ')
      disp(['Processing  year ',num2str(Y),...
	    ' - month ',num2str(M)])
      disp(' ')
      %
      Mm=M-1;Ym=Y;
      if Mm==0
	Mm=12;
	Ym=Y-1;
      end
      Mp=M+1;Yp=Y;
      if Mp==13
	Mp=1;
	Yp=Y+1;
      end
        %读取stress数据并插值到roms网格
        % 前两天
        [sms_time1,sustr1,svstr1]=get_ww3_sms(ww3_dir,grd_name,Ym,Mm,varname,...
            lonmin,lonmax,latmin,latmax,interp_method,Roa,Yorig,-2);
        %当月
        [sms_time2,sustr2,svstr2]=get_ww3_sms(ww3_dir,grd_name,Y,M,varname,...
            lonmin,lonmax,latmin,latmax,interp_method,Roa,Yorig,0);
        %后两天
        [sms_time3,sustr3,svstr3]=get_ww3_sms(ww3_dir,grd_name,Yp,Mp,varname,...
            lonmin,lonmax,latmin,latmax,interp_method,Roa,Yorig,2);
        % 待写入数据
        sms_time=[sms_time1;sms_time2;sms_time3];
        sustr=cat(3,sustr1,sustr2,sustr3);
        svstr=cat(3,svstr1,svstr2,svstr3);
        
        blk_old_name=[blk_old_dir,blk_prefix,'Y',num2str(Y),'M',num2str(M),'.nc'];
        blk_new_name=[blk_new_dir,blk_prefix,'Y',num2str(Y),'M',num2str(M),'.nc'];
        disp([' copy ', blk_old_name])
        disp([' into ',blk_new_name])
        copyfile(blk_old_name,blk_new_name)
        % 将windstress写入blk.nc文件中
        disp('writing stress into blk.nc')
        write_sms2blk(sms_time,sustr,svstr,blk_new_name,grd_name)
    end
end


