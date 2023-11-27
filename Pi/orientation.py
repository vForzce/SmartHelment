from mpu6050 import mpu6050
from gpsmodule import GPS_Data
import time

mpu = mpu6050(0x68)
def get_orientation():
        accel_data = mpu.get_accel_data()
        ax = float(accel_data['x'])
        ay = float(accel_data['y'])
        az = float(accel_data['z'])
        orientation = ""
        if az >= 8.8:
                orientation = "Tilted Right"
        elif az <= -8.8:
                orientation = "Tilted Left"
        if ay >= 8.8:
                orientation = "Facing Down"
        elif ay <= -8.8:
                orientation = "Facing Up"
        if ax >= 8.8:
                orientation = "Upside Down" 
        elif ax <= -8.8:
                orientation = "Upright"
        return orientation

def severe_vibrations():
        gyro_data = mpu.get_gyro_data()
        gyro_x = float(gyro_data['x'])
        gyro_y = float(gyro_data['y'])
        gyro_z = float(gyro_data['z'])

        if gyro_x >= 200 or gyro_y >= 200 or gyro_z >= 200:
                return True
        elif gyro_x <= -200 or gyro_y <= -200 or gyro_z <= -200:
                return True
        else:
                return False
        
def stag_location(prev_lat, prev_long):
    lat, long = GPS_Data()

    if lat != prev_lat or long != prev_long:
        prev_lat, prev_long = lat, long

    if prev_lat == lat and prev_long == long:
        if prev_lat == lat and prev_long == long:
            return True, prev_lat, prev_long

    return False, prev_lat, prev_long
