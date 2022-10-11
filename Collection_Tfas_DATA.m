Main_dir_hazirim='C:\Users\admin\Documents\Run_Matlab_Fast_Folder\Gather_Tfas_DATA_Many_Drives\Tfas_drives_Run_23_10_21';
save_Main_dir_hazirim='C:\Users\admin\Documents\Run_Matlab_Fast_Folder\Tfas_triag';
[~,message,~] = fileattrib([Main_dir_hazirim,'\*']);
         fprintf('\n There are %i total files & folders.\n',numel(message));
         allExts = cellfun(@(s) s(end-2:end),{message.Name},'uni',0);% Get file ext
         TXTidx = ismember(allExts,'mat');% Search extensions for "CSV" at the end 
         TXT_filepaths = {message(TXTidx).Name};  % Use idx of TXTs to list paths.
         fprintf('There are %i files with *.mat file ext.\n',numel(TXT_filepaths));
        stringer='A5_reduced_PCA';

%check if txt_filepeths is empty, if so, fix to add mu after point

        listt= ~cellfun('isempty',strfind(TXT_filepaths,stringer));
        address=find (listt==1);
       
        All_data=[];
       for ii=1:1:length(address)
        pivot1=load(TXT_filepaths{address(ii)}); 
        All_data=[All_data ;pivot1.A5_reduced_PCA];
       All_data5=All_data;


       cd(Main_dir_hazirim)
       save('All_data5.mat','All_data5');
       end
         stringer='A3_reduced';


%check if txt_filepeths is empty, if so, fix to add mu after point

        listt= ~cellfun('isempty',strfind(TXT_filepaths,stringer));
        address=find (listt==1);
       
        All_data=[];
       for ii=1:1:length(address)
        pivot1=load(TXT_filepaths{address(ii)}); 
        All_data=[All_data ;pivot1.A3_reduced_PCA];
       end
       All_data3=All_data;


       cd(save_Main_dir_hazirim)
       save('All_data3.mat','All_data3');