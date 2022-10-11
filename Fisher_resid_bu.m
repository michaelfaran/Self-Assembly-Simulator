%% Calculation of similarity of Fisher matrices
function cost  = Fisher_resid_bu(Pmat,seg_left,seg_right);

alpha=(seg_left.rx-seg_left.lx)/(seg_right.rx-seg_left.lx);     % ratio of the left-side segment to the merged (left and right side together) segments

partial_temp_left=Pmat(seg_left.lx:seg_left.rx,:);              % set of sensitivities in the left-side segment
partial_temp_right=Pmat(seg_right.lx:seg_right.rx,:);           % set of sensitivities in the right-side segment
partial_temp_full=Pmat(seg_left.lx:seg_right.rx,:);             % set of sensitivities in the merged segment

Fisher_left=cov(partial_temp_left);                             % Fisher matrix of the left-side segment
Fisher_right=cov(partial_temp_right);                           % Fisher matrix of the right-side segment
Fisher_full=cov(partial_temp_full);                             % Fisher matrix of the merged segment

cost_i=cost_function_Krzan(Fisher_left,Fisher_full);            % Krzanowski similarity of left-side segment and merged segment
cost_after_i=cost_function_Krzan(Fisher_right,Fisher_full);     % Krzanowski similarity of right-side segment and merged segment
cost=alpha*abs(cost_i)+(1-alpha)*abs(cost_after_i);             % calculation of final merge-cost based on Krzanowkski measures





