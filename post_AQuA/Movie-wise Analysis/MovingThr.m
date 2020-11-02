function line = MovingThr(res,opt) 
%opt = 1 -> Graph Data
%opt = 2 -> Do not Graph

if ~exist('res','var')
    error('No fie loaded');
end

%% Check for Event Motion Score
TwdScore = res.fts.region.landmarkDir.chgToward;
[~ , twdEdge] = histcounts(TwdScore,100);
TwdScore((TwdScore<twdEdge(2))) = [];
[twdHeight , twdEdge] = histcounts(TwdScore,100);
twdEdge = twdEdge(1:(end-1));

[f , r] = fit(twdEdge' , twdHeight' , 'gauss2');
cval = coeffvalues(f);
line = cval(5);
% g = @(x) f(x);
% % x = sym('x');
% k = str2sym(Sm(f));
% dfun = matlabFunction(diff(k)+1);
% line = fzero(dfun , 1);
if opt == 1
    figure
    hold on
    histogram(TwdScore,100,'FaceColor','c');
    plot(twdEdge , f(twdEdge),'r','Linewidth',3);
    xline(line);
    hold off
    fprintf('The Rsq Value is:  %f \n',r.rsquare);
end


function eq = Sm(cf)
eq = formula(cf); %Formula of fitted equation
parameters = coeffnames(cf); %All the parameter names
values = coeffvalues(cf); %All the parameter values
for idx = 1:numel(parameters)
      param = parameters{idx};
      l = length(param);
      loc = regexp(eq, param); %Location of the parameter within the string
      while ~isempty(loc)     
          %Substitute parameter value
          eq = [eq(1:loc-1) num2str(values(idx)) eq(loc+l:end)];
          loc = regexp(eq, param);
      end
end
end

end