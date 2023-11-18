from mpu6050 import mpu6050
import time
from time import sleep

mpu = mpu6050(0x68)

def Get_ACC():
    temp = float(mpu.get_temp())
    accel_data = mpu.get_accel_data()
    acc_x = float(accel_data['x']) 
    acc_y = float(accel_data['y'])
    acc_z = float(accel_data['z']) 
    gyro_data = mpu.get_gyro_data()
    gyro_x = float(gyro_data['x'])
    gyro_y = float(gyro_data['y'])
    gyro_z = float(gyro_data['z'])
    return temp, acc_x, acc_y, acc_z, gyro_x, gyro_y, gyro_z