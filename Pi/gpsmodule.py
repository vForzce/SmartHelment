import serial
from time import sleep


def GPS_Info(NMEA_buff):
    lat_in_degrees = 0
    long_in_degrees = 0
    nmea_time = NMEA_buff[0]
    nmea_latitude = NMEA_buff[1]
    nmea_longitude = NMEA_buff[3]

    #print("NMEA Time: ", nmea_time, '\n')
    #print("NMEA Latitude:", nmea_latitude, "NMEA Longitude:", nmea_longitude, '\n')


    lat = float(nmea_latitude)
    longi = float(nmea_longitude)

    lat_in_degrees = convert_to_degrees(lat)
    long_in_degrees = convert_to_degrees(longi)

    if nmea_latitude.startswith('0'): 
        lat_in_degrees = "-" + lat_in_degrees

    if nmea_longitude.startswith('0'):
        long_in_degrees = "-" + long_in_degrees

    return lat_in_degrees, long_in_degrees

def convert_to_degrees(raw_value):
    decimal_value = raw_value/100.00
    degrees = int(decimal_value)
    mm_mmmm = (decimal_value - int(decimal_value))/0.6


    position = degrees + mm_mmmm
    position = "%.4f" %(position)
    return position

def GPS_Data():
    gngga_info = "$GNGGA,"
    ser = serial.Serial("/dev/ttyUSB0")
    while True:
        received_data = str(ser.readline())
        GNGGA_data_available = received_data.find(gngga_info)
        if GNGGA_data_available > 0:
            GNGGA_buffer = received_data.split("$GNGGA,", 1)[1]
            NMEA_buff = GNGGA_buffer.split(',')
            lat_in_degrees, long_in_degrees = GPS_Info(NMEA_buff)
            lat = "{}".format(lat_in_degrees)
            long = "{}".format(long_in_degrees)
            return lat, long
            #print("lat in degrees:", lat_in_degrees, "long in degree:", long_in_degrees, '\n')