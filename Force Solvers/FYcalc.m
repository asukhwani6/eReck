function coeff = FYcalc(SA, FZ)

FZ = FZ./4.448; %newtons to pounds 
set(groot,'defaultLineLineWidth',2.0)

coeff50 = [150.912834232081, -0.00934276342218337, -149.689077744157, -0.351597488020009];
coeff100 = [299.656288828352, -0.0107066421435731, -299.563524259225, -0.280056917854840];
coeff150 = [498.864002834171, -0.0183557493279336, -507.681946243869, -0.232725090179545];
coeff200 = [1085.69022541101, -0.0452714948166384, -1102.30691536716, -0.160844288974745];
coeff250 = [17395399.4036968, -0.0937233076793558, -17395412.3903182, -0.0937318138111042];
f50 = @(x)coeff50(1)*exp(coeff50(2)*x)+coeff50(3)*exp(coeff50(4)*x);
f100 = @(x)coeff100(1)*exp(coeff100(2)*x)+coeff100(3)*exp(coeff100(4)*x);
f150 = @(x)coeff150(1)*exp(coeff150(2)*x)+coeff150(3)*exp(coeff150(4)*x);
f200 = @(x)coeff200(1)*exp(coeff200(2)*x)+coeff200(3)*exp(coeff200(4)*x);
f250 = @(x)coeff250(1)*exp(coeff250(2)*x)+coeff250(3)*exp(coeff250(4)*x);

FY50 = feval(f50, SA);
FY100 = feval(f100, SA);
FY150 = feval(f150, SA);
FY200 = feval(f200, SA);
FY250 = feval(f250, SA);

FYvec = [FY50, FY100, FY150, FY200, FY250];
FZvec = [50, 100, 150, 200, 250];

[FYfit, gof] = fit(FZvec'.*4.448, FYvec'.*4.448,"poly2");
coeff = coeffvalues(FYfit);
%f = @(x) coeff(1)*x.^(coeff(2));
%f = @(x) coeff(1)*x.^2 + coeff(2).*x + coeff(3);
%FYreturn = feval(f, FZ);
%FYreturn_Newtons = FYreturn * 4.448;
% fprintf('For SA = %.2f degrees and FZ = %.2f N, FY = %.2f N', SA, FZ, FYreturn_Newtons)

% x = linspace(min(FZvec).*4.45, max(FZvec).*4.45);
% y = feval(f, x);
% plot(x, y)
% hold on
% plot(FZ, FYreturn, 'r*')
% xlabel('FZ (N)')
% ylabel('FY (N)')
% str = sprintf('FY vs. FZ at SA = %.2f deg', SA);
% title(str)

function [fitresult, gof] = createFit(FZvec, FYvec)
%CREATEFIT(FZVEC,FYVEC)
%  Create a fit.
%
%  Data for 'a*x^b' fit:
%      X Input : FZvec
%      Y Output: FYvec
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.

%% Fit: 'untitled fit 3'.
[xData, yData] = prepareCurveData( FZvec, FYvec );

% Set up fittype and options.
ft = fittype( 'power1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [4.7373139577513 0.73862926025503];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
end

end

