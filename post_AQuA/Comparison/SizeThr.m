close all
% Add res structure before running
if ~exist('res','var')
    error('No fie loaded');
end

Area = res.fts.basic.area;
[Freq , height] = hist(Area);

f = fit(Freq' , height' , 'exp1');
g = @(x) f(x);
syms k(x)
k(x) = str2sym(Sm(f));
dfun = matlabFunction(diff(k)+0.0001);
line = fzero(dfun , 1);

hold on
fplot(g , [0 max(Area)]);
histogram(Area);
xline(line);
hold off


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