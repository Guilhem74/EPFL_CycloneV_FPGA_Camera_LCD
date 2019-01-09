#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include "system.h"
#include "sys/alt_stdio.h"
#include "HAL/inc/io.h"
#include <string.h>
#include <math.h>
#include <stdio.h>

#include "CMOS_Sensor/cmos_sensor_output_generator.h"
#include "CMOS_Sensor/cmos_sensor_output_generator_regs.h"
#include "custom_functions/CMOS_Sensor_Function.h"
#include "custom_functions/Memory_Access.h"
#include "custom_functions/function_i2c.h"

void delay(int duration );
void Test_Function_Generator();
void Test_Camera_Memory();
void Extract_Colors(int16_t Data,int* Storage);
void Convert_Pixels(int32_t Data,int* Storage);
void Capture_Image_Computer(int Frame);
#define DEBUG_MEMORY 0
#define DEBUG_I2C 0
#define ULTRA_Debug 0
#define CAPTURE_IMAGE 1
#define Frame_Generator 0
#if Frame_Generator
#define Camera 0
#else
#define Camera 1
#endif
int32_t Address=HPS_0_BRIDGES_BASE;
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


	//Camera_Acquisition_Module_Stop();
	for (int32_t i=0;i<76800;i++)
	{
		IOWR_32DIRECT(Address, i*4, 1);

	}
	Camera_Acquisition_Module_Stop();
	delay(5000);
	Camera_Acquisition_Module_SETUP_Address_Memory(HPS_0_BRIDGES_BASE);//Address of the HPC, 256 MB Available from it
	Camera_Acquisition_Module_SETUP_Length_Frame(76800);//320*240
	Camera_Acquisition_Module_Start();//Set a one in the start register

	#if CAPTURE_IMAGE
	Capture_Image_Computer(2);
	Capture_Image_Computer(1);
	Capture_Image_Computer(0);
	#endif
	int j=0;
	while (1)
	{
		j++;
		if(j>5)
			j=0;
		int32_t Data_Memory_Case=IORD_32DIRECT(Address, 0+j*4);
		int Pixels[6];

		Convert_Pixels(Data_Memory_Case,Pixels);
		printf( "Frame 0 Pix %d : %3d %3d %3d %3d %3d %3d \r\n",j,Pixels[0],Pixels[1],Pixels[2],Pixels[3],Pixels[4],Pixels[5]);
		Data_Memory_Case=IORD_32DIRECT(Address, 240*160*4+j*4);
		Convert_Pixels(Data_Memory_Case,Pixels);
		printf( "Frame 1 Pix %d : %3d %3d %3d %3d %3d %3d \r\n",j,Pixels[0],Pixels[1],Pixels[2],Pixels[3],Pixels[4],Pixels[5]);
		Data_Memory_Case=IORD_32DIRECT(Address, 240*160*4*2+j*4);
		Convert_Pixels(Data_Memory_Case,Pixels);
		printf( "Frame 2 Pix %d : %3d %3d %3d %3d %3d %3d \r\n",j,Pixels[0],Pixels[1],Pixels[2],Pixels[3],Pixels[4],Pixels[5]);
		printf("End\r\n");
		printf("\r\n");
		for (int i=0;i<4000000;i++);

	}

}
void Capture_Image_Computer(int Frame)
{
	char filename[80];
	sprintf(filename, "/mnt/host/image%d.ppm",Frame);
		FILE *foutput = fopen(filename, "w");
		if (foutput) {
			/* Use fprintf function to write to file through file pointer */
			fprintf(foutput, "P3\n320 240\n255\n");
			printf("Good: open \"%s\" for writing\n", filename);
			//
			delay(5000000);
			int Pixels[6];

			for (int i=0;i<240;i++)
			{
				for(int j=0;j<160;j++)
				{
					int32_t Data_Memory_Case=IORD_32DIRECT(Address, i*160*4+j*4+160*240*4*Frame);
					Convert_Pixels(Data_Memory_Case,Pixels);
					//printf( "%3d %3d %3d %3d %3d %3d ",Pixels[0,Pixels[1],Pixels[2],Pixels[3],Pixels[4],Pixels[5]);

					fprintf(foutput, "%3d %3d %3d %3d %3d %3d ",Pixels[0],Pixels[1],Pixels[2],Pixels[3],Pixels[4],Pixels[5]);

				}
				//printf( "\n");
				printf( "%3d %3d %3d %3d %3d %3d ",Pixels[0],Pixels[1],Pixels[2],Pixels[3],Pixels[4],Pixels[5]);

				fprintf(foutput, "\r\n");

			}
			fclose(foutput);
		}
		else
		{
			printf("Error: could not open \"%s\" for writing\n", filename);

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
void Convert_Pixels(int32_t Data,int* Storage)
{
	Extract_Colors(Data&0xFFFF,Storage);
	Extract_Colors((Data&0xFFFF0000)>>16,Storage+3);

}
void Extract_Colors(int16_t Data,int* Storage)
{
	int Red=0, Blue=0, Green=0;
	Red=(Data & 0xF800)>>11;
	Blue=(Data & 0x001F);
	Green=(Data & 0x07E0)>>5;
	int Color=Red*255/32;
	if(Color>255)
		Storage[0]=255;
	else
		Storage[0]=Color;
	Color=Green*255/64;
	if(Color>255)
		Storage[1]=255;
	else
		Storage[1]=Color;
	Color=Blue*255/32;
	if(Color>255)
		Storage[2]=255;
	else
		Storage[2]=Color;
	return ;
}
