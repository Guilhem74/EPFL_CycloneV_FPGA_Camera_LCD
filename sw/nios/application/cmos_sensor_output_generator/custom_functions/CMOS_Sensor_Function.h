#ifndef CMOS_Sensor_Function_H
#define CMOS_Sensor_Function_H
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include "system.h"
#include "sys/alt_stdio.h"
#include "HAL/inc/io.h"
#include <string.h>
#include <math.h>

#include "../CMOS_Sensor/cmos_sensor_output_generator.h"
#include "../CMOS_Sensor/cmos_sensor_output_generator_regs.h"
int Camera_Acquisition_Module_SETUP_Address_Memory(int Address);
int Camera_Acquisition_Module_SETUP_Length_Frame(int Pixel_Number);
int Camera_Acquisition_Module_Start();
int Camera_Acquisition_Module_Stop();
void Camera_Acquisition_Module_Display_Registers();
void Configure_CMOS_Generator(int width, int height);
void Start_CMOS_Generator();
void Stop_CMOS_Generator();
void Display_Configuration_Generator();

#endif

