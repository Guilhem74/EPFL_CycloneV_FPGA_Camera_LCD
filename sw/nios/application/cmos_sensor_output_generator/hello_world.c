#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include "system.h"
#include "sys/alt_stdio.h"
#include "HAL/inc/io.h"
#include <string.h>
#include <math.h>

#include "CMOS_Sensor/cmos_sensor_output_generator.h"
#include "CMOS_Sensor/cmos_sensor_output_generator_regs.h"
#include "custom_functions/CMOS_Sensor_Function.h"
#include "custom_functions/Memory_Access.h"
#include "custom_functions/function_i2c.h"

void delay(int duration );
void Test_Function_Generator();
void Test_Camera_Memory();
#define DEBUG_MEMORY 1
#define DEBUG_I2C 1
#define ULTRA_Debug 0
#define Frame_Generator 0
#if Frame_Generator
	#define Camera 0
#else
	#define Camera 1
#endif
int main(void) {
	 int i=0,j=0,k=0;
	printf("Hello from Nios II and Camera Generator!\n");
	printf("Compiled %s %s\n", __DATE__, __TIME__);
	delay(1000);

#if DEBUG_MEMORY
	Quick_Test_Memory_Map();
	#if ULTRA_Debug
		Test_Memory_Map();
	#endif
#endif
#if DEBUG_I2C
	Test_i2c();
#endif
	#if Camera
		Camera_Configuration();
		Test_Camera_Memory();
	#endif
	#if Frame_Generator
		Test_Function_Generator();
	#endif

}


void Test_Camera_Memory()
{

		int32_t Address=HPS_0_BRIDGES_BASE;
	//Camera_Acquisition_Module_Stop();
		for (int i=0;i<64;i++)
		{
	        IOWR_32DIRECT(Address, i*4, i);

		}
		Camera_Acquisition_Module_Stop();
		delay(5000);
		Camera_Acquisition_Module_SETUP_Address_Memory(Address);
		Camera_Acquisition_Module_SETUP_Length_Frame(64);
		Camera_Acquisition_Module_Start();
		int j=0;
	    while (1)
	    {
	    	delay(10000000);
	    	for (int i=0;i<8;i++)
	    	{
	    		for( j=0;j<8;j++)
	    		{
	    			printf("%d ",IORD_32DIRECT(Address, i*32+j*4));
	    		}
	    		printf("\n");

	    	}
	    	printf("\r\n");
	    	printf("\r\n");
	    }

}

void Test_Function_Generator()
{

	int32_t Address=HPS_0_BRIDGES_BASE;
	//Camera_Acquisition_Module_Stop();
		for (int i=0;i<64;i++)
		{
	        IOWR_32DIRECT(Address, i*4, i);

		}
		Camera_Acquisition_Module_Stop();
		//Stop_CMOS_Generator();
		delay(5000);
		Configure_CMOS_Generator(16,16);
		Display_Configuration_Generator();
		Camera_Acquisition_Module_SETUP_Address_Memory(Address);
		Camera_Acquisition_Module_SETUP_Length_Frame(64);
		Camera_Acquisition_Module_Start();
		Start_CMOS_Generator();
		int j=0;
	    while (1)
	    {
	    	delay(10000000);
	    	for (int i=0;i<8;i++)
	    	{
	    		for( j=0;j<8;j++)
	    		{
	    			printf("%d ",IORD_32DIRECT(Address, i*32+j*4));
	    		}
	    		printf("\n");

	    	}
	    	printf("\r\n");
	    	printf("\r\n");
	    }

}
void delay(int duration )
{
	int i;
	for (i=0;i<duration;i++);
}
