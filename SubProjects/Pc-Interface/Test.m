s = serial('COM9','BaudRate',115200);
fopen(s);
fprintf(s,'e');
while 1
    fgetl(s)
end
fclose(s);
delete(s)
clear s