nx = 500;

xlim = [-11 11];
ylim = [-1.1 1.1];


zz = -10 + 20*rand(nx,1);
xx = 1./(1+exp(-zz));
yy = log(xx)-log(1-xx) + 0.5*randn(nx,1);

hh = figure;
hold on
plot(yy,xx,'b.')

plot(0,0.48,'g*')

b = regress(xx,[ones(nx,1) yy]);
h(1) = plot(xlim,b(1)+b(2)*xlim,'b--');
ins3 = abs(yy)<2;
b3 = regress(xx(ins3),[ones(sum(ins3),1) yy(ins3)]);
h(2) = plot(xlim,b3(1)+b3(2)*xlim,'r-');

plot([-2 -2], ylim,'r:')
plot([2 2], ylim,'r:')
plot(yy(ins3),xx(ins3),'r.')

legend(h,'All','d<2','location','NorthWest')


axis([xlim -0.1 1.1])

xlabel('$S$','interpreter','latex');
ylabel('$\theta$','interpreter','latex');
set(gca,'Fontsize',7)


fileext = '.eps';
fileformat = '-depsc';
filebeg = ['C:\Users\sirenj5\work\Pr\dimReduc\figures\'];
fileend = {'localFig'};
reso = '-r300';
positions = [2 2 9 8];

saveFigures(hh,filebeg,fileend,fileext,positions,fileformat,reso);

