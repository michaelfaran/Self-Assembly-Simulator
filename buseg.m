function [segment,segment_all] = buseg(Pmat,num_segments,minres,help_vec)

% Created by Eamonn Keogh,
% Modified by Laszlo Dobos, 2012

% Inputs:
% Pmat          - contains all the sensitivites in every sample time
% num_segments  - number of desired segments
% minres        - minimum resolution (number of initial segments, in the beginning
% of segmentation process)
% help_vec      - indicates the parameters sensitivites which should be
% included to calculation of Fisher matrices

% Outputs:       
% segment       - structure for describing the result of segmentation
% segment_all   - structure for describing the initial segments

Pmat=Pmat(:,find(help_vec==1));

right_x=[minres:minres:size(Pmat,1)];   % calculate the right boarders of segments
left_x=right_x-minres+1;                % calculate the left boarders of segments
number_of_segments = length(left_x);    % Calculate the number of segments in the initial "fine segmented representation".


% Initialize the segments in the "fine segmented representation". 
for i = 1 : number_of_segments 
   segment(i).lx = left_x(i);
   segment(i).rx = right_x(i);
   segment(i).mc = inf;
end;
% tc=[];
% wc=[];


% calculation of merge costs of initial segments
for i = 1 : number_of_segments -1
   seg_left.lx=segment(i).lx;
   seg_left.rx=segment(i).rx;
   seg_right.lx=segment(i+1).lx;
   seg_right.rx=segment(i+1).rx;
   segment(i).mc= Fisher_resid_bu(Pmat,seg_left,seg_right);
end
segment(i+1).mc = inf; 

% save the structure of inital segments
segment_all=segment;




% merging segments until the number of desired segment is reached
while length(segment) > num_segments  

   [temp, i ] = min([segment(:).mc]); % minimum of merge costs

   if i > 1 && i < length(segment) -1 % none of the merged segments is lateral segment

       segment(i).rx = segment(i+1).rx;
       seg_left.lx=segment(i).lx;
       seg_left.rx=segment(i).rx;
   
       seg_right.lx=segment(i+2).lx;
       seg_right.rx=segment(i+2).rx;
       
       segment(i).mc= Fisher_resid_bu(Pmat,seg_left,seg_right);
       segment(i+1) = [];
       
       seg_left.lx=segment(i-1).lx;
       seg_left.rx=segment(i-1).rx;
   
       seg_right.lx=segment(i).lx;
       seg_right.rx=segment(i).rx;
       
       segment(i-1).mc= Fisher_resid_bu(Pmat,seg_left,seg_right);

   elseif i == 1 % one of the merged segments is a left-side segment (of all the segments)
       segment(i).rx = segment(i+1).rx;
       
       seg_left.lx=segment(i).lx;
       seg_left.rx=segment(i).rx;
   
       seg_right.lx=segment(i+2).lx;
       seg_right.rx=segment(i+2).rx;
       
       segment(i).mc= Fisher_resid_bu(Pmat,seg_left,seg_right);
       segment(i+1) = [];
   else % the right-side segment should be merged

        segment(i).mc=inf;
        segment(i).rx = segment(i).rx;

   end

end


