
classdef SerialInterface 
    
    methods(Static)
        
        %{
        Takes the inputs: 
        COM = the com port of the module. 
        BaudRate = the baudrate for the serial connection. 
        lapsToLog = the amount of lapsto log.
        
        Returns: 
        A 1 x n array consisting of the laptimes in order.
        %}
        function [lapTimes] = ReturnLapTime(COM,BaudRate,lapsToLog) 
            s = serial(COM,'BaudRate',BaudRate);    %Create a serial object with the specified inputs
            lapTimes = zeros([1,lapsToLog]);        %Allocate memory for the amount of values expected to be returned
            fopen(s);                               %Open a serial connection on serial object s
            fprintf(s,'e');                         %Print and ASCII "e" on the serial connection. "e" is implemented as "external mode" on the micro.
            fprintf(s,'r');                         %Print and ASCII "r" on the serial connection. "r" is implemented as "restart count" on the micro.
            for i=1:lapsToLog                       
                lapTimes(i)= str2double(fgetl(s));  %Get the first available byte in the input buffer, format it as ASCII, convert it to a number and store it in the output variable.
            end
            fclose(s);                              %Close the serial connection
            delete(s);                              %Delete the serial object
            clear s;                                %Clear s from workspace
        end
    end
    
end
