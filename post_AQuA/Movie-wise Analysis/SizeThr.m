function line = SizeThr(res,opt) 
%opt = 1 -> Graph Data
%opt = 2 -> Do not Graph

if ~exist('res','var')
    error('No fie loaded');
end

Area = res.fts.basic.area;
[height , Freq] = histcounts(Area);
Freq = Freq(1:(end-1));

[f , r] = fit(Freq' , height' , 'exp1');
g = @(x) f(x);
% x = sym('x');
k = str2sym(Sm(f));
dfun = matlabFunction(diff(k)+1);
line = fzero(dfun , 1);
if opt == 1
    figure
    hold on
    histogram(Area);
    plot(Freq , f(Freq), 'r','LineWidth',2.5);
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