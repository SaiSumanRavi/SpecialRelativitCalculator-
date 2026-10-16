function graphingCalculator
% GRAPHINGCALCULATOR
% Graphing, calculus, and special relativity calculator.
% Run: graphingCalculator

c = 299792458;
hPlanck = 6.62607015e-34;
eV = 1.602176634e-19;

fig = uifigure('Name','MATLAB Math & Physics Calculator', ...
    'Position',[80 70 1260 790]);
fig.Color = [0.97 0.98 1.00];

tabs = uitabgroup(fig,'Position',[10 10 1240 770]);
graphTab = uitab(tabs,'Title','Graphing & Calculus');
srTab = uitab(tabs,'Title','Special Relativity');

%% GRAPHING TAB
root = uigridlayout(graphTab,[1 2]);
root.ColumnWidth = {330,'1x'};
root.Padding = [12 12 12 12];
root.ColumnSpacing = 12;

panel = uipanel(root,'Title','Graphing Calculator', ...
    'FontWeight','bold');
panel.Layout.Row = 1;
panel.Layout.Column = 1;

controls = uigridlayout(panel,[18 2]);
controls.ColumnWidth = {'1x','1x'};
controls.RowHeight = {26,24,72,26,26,26,26,26,34,24,28,28,28,28,28,'1x',30,24};
controls.Padding = [10 10 10 10];
controls.RowSpacing = 5;

lab = uilabel(controls,'Text','Graph type','FontWeight','bold');
lab.Layout.Row = 1;
lab.Layout.Column = 1;

graphMode = uidropdown(controls,'Items', ...
    {'2D: y = f(x)','3D: z = f(x,y)'});
graphMode.Layout.Row = 1;
graphMode.Layout.Column = 2;

lab = uilabel(controls,'Text','Functions (one per line)', ...
    'FontWeight','bold');
lab.Layout.Row = 2;
lab.Layout.Column = [1 2];

expr = uitextarea(controls,'Value', ...
    {'sin(x)','0.5*cos(2*x)'},'FontName','Consolas');
expr.Layout.Row = 3;
expr.Layout.Column = [1 2];

lab = uilabel(controls,'Text','x min');
lab.Layout.Row = 4; lab.Layout.Column = 1;
xMin = uieditfield(controls,'numeric','Value',-10);
xMin.Layout.Row = 4; xMin.Layout.Column = 2;

lab = uilabel(controls,'Text','x max');
lab.Layout.Row = 5; lab.Layout.Column = 1;
xMax = uieditfield(controls,'numeric','Value',10);
xMax.Layout.Row = 5; xMax.Layout.Column = 2;

lab = uilabel(controls,'Text','y min');
lab.Layout.Row = 6; lab.Layout.Column = 1;
yMin = uieditfield(controls,'numeric','Value',-10);
yMin.Layout.Row = 6; yMin.Layout.Column = 2;

lab = uilabel(controls,'Text','y max');
lab.Layout.Row = 7; lab.Layout.Column = 1;
yMax = uieditfield(controls,'numeric','Value',10);
yMax.Layout.Row = 7; yMax.Layout.Column = 2;

lab = uilabel(controls,'Text','3D resolution');
lab.Layout.Row = 8; lab.Layout.Column = 1;
resolution = uieditfield(controls,'numeric','Value',100, ...
    'Limits',[20 300],'RoundFractionalValues','on');
resolution.Layout.Row = 8; resolution.Layout.Column = 2;

btn = uibutton(controls,'push','Text','Plot / Update', ...
    'FontWeight','bold','ButtonPushedFcn',@plotGraph);
btn.Layout.Row = 9; btn.Layout.Column = [1 2];

lab = uilabel(controls, ...
    'Text','Calculus tools (first function, 2D only)', ...
    'FontWeight','bold');
lab.Layout.Row = 10; lab.Layout.Column = [1 2];

lab = uilabel(controls,'Text','x value');
lab.Layout.Row = 11; lab.Layout.Column = 1;
xPoint = uieditfield(controls,'numeric','Value',1);
xPoint.Layout.Row = 11; xPoint.Layout.Column = 2;

btn = uibutton(controls,'push','Text','Derivative at x', ...
    'ButtonPushedFcn',@derivativeAtPoint);
btn.Layout.Row = 12; btn.Layout.Column = 1;

btn = uibutton(controls,'push','Text','Find root near x', ...
    'ButtonPushedFcn',@findRoot);
btn.Layout.Row = 12; btn.Layout.Column = 2;

btn = uibutton(controls,'push','Text','Definite integral', ...
    'ButtonPushedFcn',@integrateFunction);
btn.Layout.Row = 13; btn.Layout.Column = [1 2];

lab = uilabel(controls,'Text','Integral lower bound a');
lab.Layout.Row = 14; lab.Layout.Column = 1;
aField = uieditfield(controls,'numeric','Value',0);
aField.Layout.Row = 14; aField.Layout.Column = 2;

lab = uilabel(controls,'Text','Integral upper bound b');
lab.Layout.Row = 15; lab.Layout.Column = 1;
bField = uieditfield(controls,'numeric','Value',pi);
bField.Layout.Row = 15; bField.Layout.Column = 2;

graphResult = uitextarea(controls,'Editable','off', ...
    'Value',{'Ready.'});
graphResult.Layout.Row = 16;
graphResult.Layout.Column = [1 2];

btn = uibutton(controls,'push','Text','Clear graph', ...
    'ButtonPushedFcn',@(~,~) cla(ax));
btn.Layout.Row = 17; btn.Layout.Column = 1;

btn = uibutton(controls,'push','Text','Reset view', ...
    'ButtonPushedFcn',@resetView);
btn.Layout.Row = 17; btn.Layout.Column = 2;

lab = uilabel(controls, ...
    'Text','Use .*, ./, .^ for vectorized expressions.');
lab.Layout.Row = 18; lab.Layout.Column = [1 2];

ax = uiaxes(root);
ax.Layout.Row = 1; ax.Layout.Column = 2;
ax.Box = 'on';
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.FontSize = 12;
title(ax,'Graphing Calculator');
xlabel(ax,'x');
ylabel(ax,'y');

%% SPECIAL RELATIVITY TAB
srRoot = uigridlayout(srTab,[1 2]);
srRoot.ColumnWidth = {430,'1x'};
srRoot.Padding = [16 16 16 16];
srRoot.ColumnSpacing = 16;

srPanel = uipanel(srRoot, ...
    'Title','Special Relativity Problem Solver', ...
    'FontWeight','bold');
srPanel.Layout.Row = 1;
srPanel.Layout.Column = 1;

sg = uigridlayout(srPanel,[15 2]);
sg.ColumnWidth = {190,'1x'};
sg.RowHeight = {34,62,26,30,26,30,26,30,26,30,36,30,30,'1x',30};
sg.Padding = [12 12 12 12];
sg.RowSpacing = 7;

lab = uilabel(sg,'Text','Choose a problem','FontWeight','bold');
lab.Layout.Row = 1;
lab.Layout.Column = [1 2];

problem = uidropdown(sg,'Items',{ ...
    'Lorentz factor', ...
    'Time dilation', ...
    'Length contraction', ...
    'Relativistic momentum', ...
    'Total energy and kinetic energy', ...
    'Mass-energy equivalence', ...
    'Velocity addition (collinear)', ...
    'Lorentz coordinate transformation', ...
    'Energy-momentum relation', ...
    'Speed from kinetic energy', ...
    'Relativistic Doppler shift', ...
    'Photon energy from wavelength'}, ...
    'Value','Lorentz factor', ...
    'ValueChangedFcn',@updateHelp);
problem.Layout.Row = 2;
problem.Layout.Column = [1 2];

helpText = uitextarea(sg,'Editable','off','Value', ...
    {'Enter beta = v/c for velocity-based problems.', ...
     'Use SI units unless stated otherwise.'});
helpText.Layout.Row = 3;
helpText.Layout.Column = [1 2];

fields = gobjects(1,4);

for k = 1:4
    lab = uilabel(sg,'Text',['Input ' num2str(k)]);
    lab.Layout.Row = 2*k+2;
    lab.Layout.Column = 1;

    fields(k) = uieditfield(sg,'numeric','Value',0);
    fields(k).Layout.Row = 2*k+2;
    fields(k).Layout.Column = 2;
end

calcBtn = uibutton(sg,'push','Text','Calculate', ...
    'FontWeight','bold','ButtonPushedFcn',@calculateSR);
calcBtn.Layout.Row = 11;
calcBtn.Layout.Column = [1 2];

resetSR = uibutton(sg,'push','Text','Load example values', ...
    'ButtonPushedFcn',@loadExample);
resetSR.Layout.Row = 12;
resetSR.Layout.Column = [1 2];

lab = uilabel(sg,'Text','Constants: c = 299,792,458 m/s', ...
    'FontColor',[0.25 0.3 0.4]);
lab.Layout.Row = 13;
lab.Layout.Column = [1 2];

srResult = uitextarea(sg,'Editable','off', ...
    'Value',{'Choose a problem, enter values, and click Calculate.'});
srResult.Layout.Row = 14;
srResult.Layout.Column = [1 2];

lab = uilabel(sg,'Text','Signed beta: positive = +x direction.', ...
    'WordWrap','on');
lab.Layout.Row = 15;
lab.Layout.Column = [1 2];

infoPanel = uipanel(srRoot,'Title','Formula guide & conventions', ...
    'FontWeight','bold');
infoPanel.Layout.Row = 1;
infoPanel.Layout.Column = 2;

infoGrid = uigridlayout(infoPanel,[2 1]);
infoGrid.RowHeight = {'1x','1x'};
infoGrid.Padding = [14 14 14 14];

formulaInfo = uitextarea(infoGrid,'Editable','off', ...
    'FontName','Consolas','Value',{ ...
    'CORE RELATIONS', ...
    'gamma = 1/sqrt(1-beta^2), beta = v/c', ...
    'Time dilation: delta_t = gamma * delta_tau', ...
    'Length contraction: L = L0/gamma', ...
    'Momentum: p = gamma*m*v', ...
    'Total energy: E = gamma*m*c^2', ...
    'Kinetic energy: K = (gamma-1)*m*c^2', ...
    'Rest energy: E0 = m*c^2', ...
    'Velocity addition: w/c = (u/c + v/c)/(1 + uv/c^2)', ...
    'Lorentz transform: x''=gamma*(x-v*t)', ...
    'Lorentz transform: t''=gamma*(t-v*x/c^2)', ...
    'Energy-momentum: E^2 = (pc)^2 + (mc^2)^2', ...
    'Doppler: f_obs=f_source*sqrt((1+beta)/(1-beta))', ...
    'Photon: E = h*c/lambda', ...
    '', ...
    'INPUT GUIDE', ...
    'Beta must satisfy abs(beta) < 1.', ...
    'Mass: kg; time: s; length: m; momentum: kg*m/s;', ...
    'Energy: J; frequency: Hz; wavelength: m.', ...
    'Velocity addition inputs are beta_u and beta_v.', ...
    'Lorentz transform inputs: x (m), t (s), frame beta.'});
formulaInfo.Layout.Row = 1;
formulaInfo.Layout.Column = 1;

srNotes = uitextarea(infoGrid,'Editable','off','Value',{ ...
    'Study tip: identify the proper quantity first.', ...
    'Proper time is measured in the clock''s rest frame.', ...
    'Proper length is measured in the object''s rest frame.', ...
    'This tool gives numerical answers and uses SI units.', ...
    'Doppler convention: beta > 0 means source approaching observer.', ...
    'For energy-momentum, input p in kg*m/s.'});
srNotes.Layout.Row = 2;
srNotes.Layout.Column = 1;

updateHelp();
plotGraph();

%% GRAPHING FUNCTIONS
    function expressions = getExpressions()
        raw = expr.Value;
        if ischar(raw)
            raw = cellstr(raw);
        end

        expressions = {};
        for jj = 1:numel(raw)
            ss = strtrim(raw{jj});
            if ~isempty(ss)
                expressions{end+1} = ss; %#ok<AGROW>
            end
        end

        if isempty(expressions)
            error('Enter at least one function expression.');
        end
    end

    function f = makeFunction(expression,is3D)
        if is3D
            f = str2func(['@(x,y) ' expression]);
        else
            f = str2func(['@(x) ' expression]);
        end
    end

    function plotGraph(~,~)
        try
            expressions = getExpressions();

            if xMin.Value >= xMax.Value || yMin.Value >= yMax.Value
                error('Each minimum must be smaller than its maximum.');
            end

            cla(ax);
            hold(ax,'on');

            if strcmp(graphMode.Value,'2D: y = f(x)')
                xx = linspace(xMin.Value,xMax.Value,2000);
                colors = lines(numel(expressions));

                for jj = 1:numel(expressions)
                    f = makeFunction(expressions{jj},false);
                    yy = f(xx);

                    if isscalar(yy)
                        yy = yy + zeros(size(xx));
                    end

                    if ~isnumeric(yy) || ~isreal(yy)
                        error('Function %d must return real numeric values.',jj);
                    end

                    yy(~isfinite(yy)) = NaN;

                    plot(ax,xx,yy,'LineWidth',1.8, ...
                        'Color',colors(jj,:), ...
                        'DisplayName',expressions{jj});
                end

                xlim(ax,[xMin.Value xMax.Value]);
                ylim(ax,[yMin.Value yMax.Value]);
                xlabel(ax,'x');
                ylabel(ax,'y');
                title(ax,'2D Function Plot');
                legend(ax,'show','Interpreter','none','Location','best');
                view(ax,2);
            else
                n = round(resolution.Value);
                xv = linspace(xMin.Value,xMax.Value,n);
                yv = linspace(yMin.Value,yMax.Value,n);
                [X,Y] = meshgrid(xv,yv);

                f = makeFunction(expressions{1},true);
                Z = f(X,Y);

                if isscalar(Z)
                    Z = Z + zeros(size(X));
                end

                if ~isnumeric(Z) || ~isreal(Z)
                    error('3D function must return real numeric values.');
                end

                Z(~isfinite(Z)) = NaN;
                surf(ax,X,Y,Z,'EdgeColor','none');
                xlabel(ax,'x');
                ylabel(ax,'y');
                zlabel(ax,'z');
                title(ax,['z = ' expressions{1}],'Interpreter','none');
                colorbar(ax);
                colormap(ax,'turbo');
                view(ax,3);
                xlim(ax,[xMin.Value xMax.Value]);
                ylim(ax,[yMin.Value yMax.Value]);
            end

            hold(ax,'off');
            graphResult.Value = {'Plot updated successfully.'};

        catch ME
            hold(ax,'off');
            graphResult.Value = {['Error: ' ME.message]};
            uialert(fig,ME.message,'Unable to plot function');
        end
    end

    function [f,expression] = firstFunction()
        expressions = getExpressions();
        expression = expressions{1};
        f = makeFunction(expression,false);
    end

    function derivativeAtPoint(~,~)
        try
            if ~strcmp(graphMode.Value,'2D: y = f(x)')
                error('Switch to 2D mode.');
            end

            [f,ex] = firstFunction();
            x0 = xPoint.Value;
            step = 1e-5*max(1,abs(x0));
            val = (f(x0+step)-f(x0-step))/(2*step);

            graphResult.Value = {sprintf('f(x) = %s',ex), ...
                sprintf('f''(%.8g) approximately %.12g',x0,val)};

        catch ME
            uialert(fig,ME.message,'Derivative error');
        end
    end

    function integrateFunction(~,~)
        try
            if ~strcmp(graphMode.Value,'2D: y = f(x)')
                error('Switch to 2D mode.');
            end

            [f,ex] = firstFunction();
            val = integral(@(xx) f(xx),aField.Value,bField.Value);

            graphResult.Value = {sprintf('f(x) = %s',ex), ...
                sprintf('Integral from %.8g to %.8g = %.12g', ...
                aField.Value,bField.Value,val)};

        catch ME
            uialert(fig,ME.message,'Integration error');
        end
    end

    function findRoot(~,~)
        try
            if ~strcmp(graphMode.Value,'2D: y = f(x)')
                error('Switch to 2D mode.');
            end

            [f,ex] = firstFunction();
            x0 = xPoint.Value;
            r = fzero(@(xx) f(xx),x0);

            graphResult.Value = {sprintf('f(x) = %s',ex), ...
                sprintf('Root near %.8g: x = %.12g',x0,r)};

        catch ME
            uialert(fig, ...
                ['Could not find a root near the chosen value. ' ME.message], ...
                'Root error');
        end
    end

    function resetView(~,~)
        xlim(ax,[xMin.Value xMax.Value]);
        ylim(ax,[yMin.Value yMax.Value]);

        if strcmp(graphMode.Value,'2D: y = f(x)')
            view(ax,2);
        else
            view(ax,3);
        end
    end

%% SPECIAL RELATIVITY FUNCTIONS
    function updateHelp(~,~)
        p = problem.Value;

        problemNames = { ...
            'Lorentz factor','Time dilation','Length contraction', ...
            'Relativistic momentum','Total energy and kinetic energy', ...
            'Mass-energy equivalence','Velocity addition (collinear)', ...
            'Lorentz coordinate transformation','Energy-momentum relation', ...
            'Speed from kinetic energy','Relativistic Doppler shift', ...
            'Photon energy from wavelength'};

        descriptions = { ...
            'Input 1: beta = v/c. Returns gamma and velocity.', ...
            'Input 1: proper time tau (s). Input 2: beta.', ...
            'Input 1: proper length L0 (m). Input 2: beta.', ...
            'Input 1: rest mass m (kg). Input 2: beta.', ...
            'Input 1: rest mass m (kg). Input 2: beta.', ...
            'Input 1: rest mass m (kg). Returns rest energy.', ...
            'Input 1: beta_u. Input 2: beta_v.', ...
            'Input 1: x (m). Input 2: t (s). Input 3: frame beta.', ...
            'Input 1: rest mass m (kg). Input 2: momentum p (kg m/s).', ...
            'Input 1: rest mass m (kg). Input 2: kinetic energy K (J).', ...
            'Input 1: source frequency (Hz). Input 2: beta.', ...
            'Input 1: wavelength (m). Returns photon energy.'};

        idx = find(strcmp(p,problemNames),1);
        helpText.Value = {descriptions{idx}, ...
            'Unused inputs can be left at zero.'};

        fieldNames = { ...
            {'beta','unused','unused','unused'}, ...
            {'Proper time tau (s)','beta','unused','unused'}, ...
            {'Proper length L0 (m)','beta','unused','unused'}, ...
            {'Rest mass m (kg)','beta','unused','unused'}, ...
            {'Rest mass m (kg)','beta','unused','unused'}, ...
            {'Rest mass m (kg)','unused','unused','unused'}, ...
            {'beta_u','beta_v','unused','unused'}, ...
            {'Position x (m)','Time t (s)','Frame beta','unused'}, ...
            {'Rest mass m (kg)','Momentum p (kg m/s)','unused','unused'}, ...
            {'Rest mass m (kg)','Kinetic energy K (J)','unused','unused'}, ...
            {'Source frequency (Hz)','Source beta','unused','unused'}, ...
            {'Wavelength (m)','unused','unused','unused'}};

        item = sg.Children;
        for kk = 1:4
            for q = 1:numel(item)
                if isa(item(q),'matlab.ui.control.Label') && ...
                        isprop(item(q),'Layout') && ...
                        item(q).Layout.Row == 2*kk+2 && ...
                        item(q).Layout.Column == 1
                    item(q).Text = fieldNames{idx}{kk};
                end
            end
        end
    end

    function calculateSR(~,~)
        try
            a = fields(1).Value;
            b = fields(2).Value;
            d = fields(3).Value;
            out = {};

            switch problem.Value
                case 'Lorentz factor'
                    validateBeta(a);
                    g = 1/sqrt(1-a^2);

                    out = {sprintf('beta = %.12g',a), ...
                        sprintf('v = %.12g m/s',a*c), ...
                        sprintf('gamma = %.12g',g), ...
                        sprintf('1/gamma = %.12g',1/g)};

                case 'Time dilation'
                    tau = a;
                    validateBeta(b);
                    requireNonnegative(tau,'Proper time');
                    g = 1/sqrt(1-b^2);
                    dt = g*tau;

                    out = {sprintf('gamma = %.12g',g), ...
                        sprintf('Proper time tau = %.12g s',tau), ...
                        sprintf('Dilated time = %.12g s',dt), ...
                        sprintf('Elapsed-time increase = %.12g s',dt-tau)};

                case 'Length contraction'
                    L0 = a;
                    validateBeta(b);
                    requireNonnegative(L0,'Proper length');
                    g = 1/sqrt(1-b^2);
                    L = L0/g;

                    out = {sprintf('gamma = %.12g',g), ...
                        sprintf('Proper length L0 = %.12g m',L0), ...
                        sprintf('Contracted length L = %.12g m',L), ...
                        sprintf('Contraction = %.12g m',L0-L)};

                case 'Relativistic momentum'
                    m = a;
                    validateBeta(b);
                    requireNonnegative(m,'Mass');
                    v = b*c;
                    g = 1/sqrt(1-b^2);
                    mom = g*m*v;

                    out = {sprintf('v = %.12g m/s',v), ...
                        sprintf('gamma = %.12g',g), ...
                        sprintf('p = %.12g kg m/s',mom), ...
                        sprintf('Classical momentum mv = %.12g kg m/s',m*v)};

                case 'Total energy and kinetic energy'
                    m = a;
                    validateBeta(b);
                    requireNonnegative(m,'Mass');
                    g = 1/sqrt(1-b^2);
                    E = g*m*c^2;
                    E0 = m*c^2;
                    K = (g-1)*m*c^2;

                    out = {sprintf('gamma = %.12g',g), ...
                        sprintf('Total energy E = %.12g J',E), ...
                        sprintf('Rest energy E0 = %.12g J',E0), ...
                        sprintf('Kinetic energy K = %.12g J',K), ...
                        sprintf('Kinetic energy = %.12g eV',K/eV)};

                case 'Mass-energy equivalence'
                    m = a;
                    requireNonnegative(m,'Mass');
                    E = m*c^2;

                    out = {sprintf('Rest mass m = %.12g kg',m), ...
                        sprintf('Rest energy E0 = %.12g J',E), ...
                        sprintf('Rest energy E0 = %.12g eV',E/eV)};

                case 'Velocity addition (collinear)'
                    validateBeta(a);
                    validateBeta(b);

                    beta = (a+b)/(1+a*b);
                    validateBeta(beta);

                    out = {sprintf('Combined beta = %.12g',beta), ...
                        sprintf('Combined velocity = %.12g m/s',beta*c), ...
                        sprintf('Combined speed = %.12g c',abs(beta))};

                case 'Lorentz coordinate transformation'
                    x = a;
                    t = b;
                    validateBeta(d);

                    v = d*c;
                    g = 1/sqrt(1-d^2);
                    xp = g*(x-v*t);
                    tp = g*(t-v*x/c^2);

                    out = {sprintf('Frame speed v = %.12g m/s',v), ...
                        sprintf('x prime = %.12g m',xp), ...
                        sprintf('t prime = %.12g s',tp), ...
                        sprintf('gamma = %.12g',g)};

                case 'Energy-momentum relation'
                    m = a;
                    mom = b;
                    requireNonnegative(m,'Mass');

                    E = sqrt((mom*c)^2+(m*c^2)^2);
                    K = E-m*c^2;

                    out = {sprintf('Total energy E = %.12g J',E), ...
                        sprintf('Rest energy E0 = %.12g J',m*c^2), ...
                        sprintf('Kinetic energy K = %.12g J',K), ...
                        sprintf('Total energy = %.12g eV',E/eV)};

                case 'Speed from kinetic energy'
                    m = a;
                    K = b;
                    requirePositive(m,'Rest mass');
                    requireNonnegative(K,'Kinetic energy');

                    g = 1+K/(m*c^2);
                    beta = sqrt(max(0,1-1/g^2));

                    out = {sprintf('gamma = %.12g',g), ...
                        sprintf('beta = %.12g',beta), ...
                        sprintf('Speed v = %.12g m/s',beta*c), ...
                        sprintf('Percent of c = %.8g%%',100*beta)};

                case 'Relativistic Doppler shift'
                    f0 = a;
                    validateBeta(b);
                    requirePositive(f0,'Source frequency');

                    fobs = f0*sqrt((1+b)/(1-b));
                    lambda = c/fobs;

                    out = {sprintf('Source frequency = %.12g Hz',f0), ...
                        sprintf('Observed frequency = %.12g Hz',fobs), ...
                        sprintf('Observed wavelength = %.12g m',lambda), ...
                        'Convention: beta > 0 means source approaching observer.'};

                case 'Photon energy from wavelength'
                    lambda = a;
                    requirePositive(lambda,'Wavelength');

                    E = hPlanck*c/lambda;

                    out = {sprintf('Photon energy = %.12g J',E), ...
                        sprintf('Photon energy = %.12g eV',E/eV), ...
                        sprintf('Frequency = %.12g Hz',c/lambda)};
            end

            srResult.Value = out;

        catch ME
            srResult.Value = {['Error: ' ME.message]};
            uialert(fig,ME.message,'Special relativity calculation error');
        end
    end

    function validateBeta(beta)
        if ~isfinite(beta) || abs(beta) >= 1
            error('beta = v/c must satisfy abs(beta) < 1.');
        end
    end

    function requireNonnegative(v,name)
        if ~isfinite(v) || v < 0
            error('%s must be finite and nonnegative.',name);
        end
    end

    function requirePositive(v,name)
        if ~isfinite(v) || v <= 0
            error('%s must be finite and greater than zero.',name);
        end
    end

    function loadExample(~,~)
        switch problem.Value
            case 'Lorentz factor'
                vals = [0.8 0 0 0];
            case 'Time dilation'
                vals = [10 0.8 0 0];
            case 'Length contraction'
                vals = [10 0.8 0 0];
            case 'Relativistic momentum'
                vals = [1 0.8 0 0];
            case 'Total energy and kinetic energy'
                vals = [1 0.8 0 0];
            case 'Mass-energy equivalence'
                vals = [1 0 0 0];
            case 'Velocity addition (collinear)'
                vals = [0.6 0.6 0 0];
            case 'Lorentz coordinate transformation'
                vals = [100 1 0.8 0];
            case 'Energy-momentum relation'
                vals = [1 1e-19 0 0];
            case 'Speed from kinetic energy'
                vals = [9.1093837e-31 1e-16 0 0];
            case 'Relativistic Doppler shift'
                vals = [5e14 0.5 0 0];
            case 'Photon energy from wavelength'
                vals = [500e-9 0 0 0];
            otherwise
                vals = [0 0 0 0];
        end

        for kk = 1:4
            fields(kk).Value = vals(kk);
        end
    end
end