;Mapping of the data memory
;SRAM starts at 0x60

;Accelerometer dataset from the MPU6050
.equ ACCEL_XOUT_H = 0x0060
.equ ACCEL_XOUT_L = 0x0061
.equ ACCEL_YOUT_H = 0x0062
.equ ACCEL_YOUT_L = 0x0063
.equ ACCEL_ZOUT_H = 0x0064
.equ ACCEL_ZOUT_L = 0x0065

;Temperature dataset from the MPU6050
.equ TEMP_OUT_H   = 0x0066
.equ TEMP_OUT_L   = 0x0067

;Gyro dataset from the MPU6050
.equ GYRO_XOUT_H  = 0x0068
.equ GYRO_XOUT_L  = 0x0069
.equ GYRO_YOUT_H  = 0x006A
.equ GYRO_YOUT_L  = 0x006B
.equ GYRO_ZOUT_H  = 0x006C
.equ GYRO_ZOUT_L  = 0x006D

;Time0 variables
.equ Timer_1ms_H  = 0x006E
.equ Timer_1ms_M  = 0x006F
.equ Timer_1ms_L  = 0x0070
