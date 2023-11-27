import pyrebase
from gpsmodule import GPS_Data
from mpu_6050 import Get_ACC
from INA219 import INA219
from orientation import get_orientation, severe_vibrations, stag_location
from time import sleep

config = {
    "apiKey": "AIzaSyA5BcvaQYFaVBCyJEFTbqOWCUDKdUyh7Bw",
    "authDomain": "iot-smart-helmet-5a382.firebaseapp.com",
    "databaseURL": "https://iot-smart-helmet-5a382-default-rtdb.firebaseio.com",
    "projectId": "iot-smart-helmet-5a382",
    "storageBucket": "iot-smart-helmet-5a382.appspot.com",
    "messagingSenderId": "168206761654",
    "appId": "1:168206761654:web:4a2766f8b379d8e79e7017"
};

firebase = pyrebase.initialize_app(config)
Sensor_Data = firebase.database()

while True:
    vibration = severe_vibrations()
    orientation = get_orientation()
    location = True
    crash = False
    ina219 = INA219(addr=0x42)
    bus_voltage = ina219.getBusVoltage_V()
    p = (bus_voltage - 6)/2.4*100
   
    if(p > 100):
        p = 100
    if(p < 0):
        p = 0
    current = ina219.getCurrent_mA()  

    if (current > 0): 
        current = True
    else:
        current = False
    
    if((orientation == "Facing Up" or orientation == "Facing Down" or orientation == "Titled Left" or orientation == "Titled Right" or 
       orientation == "Upside Down" or orientation == "Upright") and vibration == True and location == True):
        crash = True
        print("Crash Detected")
        sleep(3)
        if((orientation == "Facing Up" or orientation == "Facing Down" or orientation == "Titled Left" or orientation == "Titled Right" or 
            orientation == "Upside Down" or orientation == "Upright") and vibration == False and location == True):
            crash = True
            sleep(3)
            if(orientation == "Upright" and vibration == False and location == True or False):
                crash = False

    a, b = GPS_Data()
    temp, ax, ay, az, gx, gy, gz = Get_ACC()

    Sensor_Data.child("Devices/IRQgSMRaKZltXjuUhgc3/GPS Data")
    data_1 = {"Latitude": a, "Longitude": b}
    Sensor_Data.set(data_1)

    Sensor_Data.child("Devices/IRQgSMRaKZltXjuUhgc3/Accelermeter Data")
    data_2 = {"Temperature": temp, "Acc X": ax, "Acc Y": ay, "Acc Z": az}
    Sensor_Data.set(data_2)
    
    Sensor_Data.child("Devices/IRQgSMRaKZltXjuUhgc3/Gyroscope Data")
    data_3 = {"Gyro X": gx, "Gyro Y": gy, "Gyro Z": gz}
    Sensor_Data.set(data_3)

    Sensor_Data.child("Devices/IRQgSMRaKZltXjuUhgc3/Battery Information")
    data_4 = {"Percentage": p, "Charging?": current}
    Sensor_Data.set(data_4)

    Sensor_Data.child("Devices/IRQgSMRaKZltXjuUhgc3/Crash Detection")
    data_5 = {"Severe Vibrations?": vibration, "Helment Orientation": orientation, "Crash Detected?": crash, "Stagnet Location": location}
    Sensor_Data.set(data_5)
