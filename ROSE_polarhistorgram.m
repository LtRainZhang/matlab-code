clear all;
file = './断层方向统计.xls';
num = xlsread(file,1,'H1:H43');
num = num/180*3.141592653;

figure
polarhistogram(num, 72,'FaceColor', 'red')