clear all;
file = './�ϲ㷽��ͳ��.xls';
num = xlsread(file,1,'H1:H43');
num = num/180*3.141592653;

figure
polarhistogram(num, 72,'FaceColor', 'red')