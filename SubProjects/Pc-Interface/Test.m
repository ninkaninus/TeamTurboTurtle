s = serial('COM9','BaudRate',115200);
lapCount=20;
lapData = zeros([1,lapCount]);
fopen(s);
fprintf(s,'e');
fprintf(s,'r');
pause on;
grid on;
for i=1:lapCount
    lapData(i)= str2double(fgetl(s));
end
fclose(s);
delete(s);
clear s;
clear i;
plot(lapData,'-gs','LineWidth',2, 'MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor',[1,0,0])