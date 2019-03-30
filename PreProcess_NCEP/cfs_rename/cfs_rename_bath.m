% cfs_rename_bath
Ymin=2014;
Ymax=2014;
Mmin=8;
Mmax=8;
root_dir='E:\NCEP\';
for Y=Ymin:Ymax
    disp('==========================')
    disp(['Processing year: ',num2str(Y)])
    disp('==========================')
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
        disp(['  Processing month: ',num2str(M)])
        filefolder=[root_dir,num2str(Y),num2str(M,'%02d')];
        csf_rename(filefolder)
      end %month
end %Year