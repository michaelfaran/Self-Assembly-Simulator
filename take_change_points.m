function cp= take_change_points(ncpP,ncp_median,small_time_scale)
count=0;
cp=zeros(ncp_median,1);
while count<ncp_median+1
[m,i]=max(ncpP);
bottom_line=max(1,i-small_time_scale);
upper_line=min(length(ncpP),i+small_time_scale);
ncpP(bottom_line:1:upper_line)=zeros(upper_line-bottom_line+1,1);
    count=count+1;
    cp(count)=i;
if (sum(ncpP)==0)    
break
end
end