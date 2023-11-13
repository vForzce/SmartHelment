from mpu6050 import mpu6050
mpu = mpu6050(0x68)

def Get_ACC():
    temp = str(mpu.get_temp())
    accel_data = mpu.get_accel_data()
    acc_x = str(accel_data['x'])
    acc_y = str(accel_data['y'])
    acc_z = str(accel_data['z'])
    gyro_data = mpu.get_gyro_data()
    gyro_x = str(gyro_data['x'])
    gyro_y = str(gyro_data['y'])
    gyro_z = str(gyro_data['z'])
    return temp, acc_x, acc_y, acc_z, gyro_x, gyro_y, gyro_z