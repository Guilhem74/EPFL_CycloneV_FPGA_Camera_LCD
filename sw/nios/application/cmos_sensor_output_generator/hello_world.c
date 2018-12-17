#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include "system.h"
#include "sys/alt_stdio.h"
#include "HAL/inc/io.h"
#include <string.h>
#include <math.h>

#include "cmos_sensor_output_generator.h"
#include "cmos_sensor_output_generator_regs.h"

#define CMOS_SENSOR_OUTPUT_GENERATOR_0_PIX_DEPTH_REDEFINED  (12)     /* cmos_sensor_output_generator pix depth from system.h (ADAPT TO YOUR DESIGN) */
#define CMOS_SENSOR_OUTPUT_GENERATOR_0_WIDTH  (32)    /* cmos_sensor_output_generator max width from system.h (ADAPT TO YOUR DESIGN) */
#define CMOS_SENSOR_OUTPUT_GENERATOR_0_HEIGHT (32)    /* cmos_sensor_output_generator max height from system.h (ADAPT TO YOUR DESIGN) */
#define Number_Of_Pixels_RGB CMOS_SENSOR_OUTPUT_GENERATOR_0_WIDTH*CMOS_SENSOR_OUTPUT_GENERATOR_0_HEIGHT/4 // One pixel = 4 sensors values
#define Number_Of_Memory_Slot Number_Of_Pixels_RGB/2 //One memory slot =2 Pixels

//#define CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_WIDTH_OFST                 (0 * 4) /* RW */
//#define CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_HEIGHT_OFST                (1 * 4) /* RW */
//#define CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_FRAME_BLANK_OFST           (2 * 4) /* RW */
//#define CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_LINE_BLANK_OFST            (3 * 4) /* RW */
//#define CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_LINE_BLANK_OFST             (4 * 4) /* RW */
//#define CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_FRAME_BLANK_OFST            (5 * 4) /* RW */
//#define CMOS_SENSOR_OUTPUT_GENERATOR_COMMAND_OFST                            (6 * 4) /* WO */
//#define CMOS_SENSOR_OUTPUT_GENERATOR_STATUS_OFST                             (7 * 4) /* RO */
int main(void) {
	 int i=0,j=0,k=0;
	printf("Hello from Nios II and Camera Generator!\n");
    for (i=0;i<400000;i++);

    cmos_sensor_output_generator_dev cmos_sensor_output_generator = cmos_sensor_output_generator_inst(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,
    																					CMOS_SENSOR_OUTPUT_GENERATOR_0_PIX_DEPTH_REDEFINED,
																									  CMOS_SENSOR_OUTPUT_GENERATOR_0_WIDTH,
																									  CMOS_SENSOR_OUTPUT_GENERATOR_0_HEIGHT);
    cmos_sensor_output_generator_init(&cmos_sensor_output_generator);
    cmos_sensor_output_generator_stop(&cmos_sensor_output_generator);
    cmos_sensor_output_generator_configure(&cmos_sensor_output_generator,
    										CMOS_SENSOR_OUTPUT_GENERATOR_0_WIDTH,
											CMOS_SENSOR_OUTPUT_GENERATOR_0_HEIGHT,
                                           CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_FRAME_BLANK_MIN,
                                           CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_LINE_BLANK_MIN,
                                           CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_LINE_BLANK_MIN,
                                           CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_FRAME_BLANK_MIN);
    printf("CMOS_SENSOR_OUTPUT_GENERATOR_0_WIDTH=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_WIDTH_OFST));
    printf("CMOS_SENSOR_OUTPUT_GENERATOR_0_HEIGHT=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_HEIGHT_OFST));
    printf("CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_FRAME_BLANK_MIN=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_FRAME_BLANK_OFST));
    printf("CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_LINE_BLANK_MIN=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_LINE_BLANK_OFST));
    printf("CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_LINE_BLANK_MIN=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_LINE_BLANK_OFST));
    printf("CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_FRAME_BLANK_MIN=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_FRAME_BLANK_OFST));
    printf("CMOS_SENSOR_OUTPUT_GENERATOR_COMMAND=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_COMMAND_OFST));
    printf("CMOS_SENSOR_OUTPUT_GENERATOR_STATUS=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_STATUS_OFST));

    int32_t Frame[16][8]={};
    printf("Address Frame=0x%x\r\n",Frame);
    #define CAMERA_MODULE_REGISTER_ADDRESS                 (0 * 4) /* RW */
    #define CAMERA_MODULE_REGISTER_LENGTH                (1 * 4) /* RW */
    #define CAMERA_MODULE_REGISTER_START          (2 * 4) /* RW */
    #define CAMERA_MODULE_REGISTER_STOP            (3 * 4) /* RW */
    #define CAMERA_MODULE_REGISTER_SNAPSHOT             (4 * 4) /* RW */
    #define CAMERA_MODULE_REGISTER_FLAG            (5 * 4) /* RW */
    IOWR_32DIRECT(CAMERA_MODULE_0_BASE, CAMERA_MODULE_REGISTER_ADDRESS, Frame);
    IOWR_32DIRECT(CAMERA_MODULE_0_BASE, CAMERA_MODULE_REGISTER_LENGTH, Number_Of_Memory_Slot*4);//*4 because 32bits
    printf("CAMERA_MODULE_REGISTER_ADDRESS=0x%x\r\n",IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_ADDRESS));
    printf("CAMERA_MODULE_REGISTER_LENGTH=%d\r\n",IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_LENGTH));
    IOWR_32DIRECT(CAMERA_MODULE_0_BASE, CAMERA_MODULE_REGISTER_STOP, 1);
    printf("CAMERA_MODULE_REGISTER_STOP=%d\r\n",IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_STOP));
    for (i=0;i<20000;i++);

    IOWR_32DIRECT(CAMERA_MODULE_0_BASE, CAMERA_MODULE_REGISTER_START, 1);
    printf("CAMERA_MODULE_REGISTER_START=%d\r\n",IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_START));

    cmos_sensor_output_generator_start(&cmos_sensor_output_generator);


    for (i=0;i<Number_Of_Pixels_RGB/8;i++)
    {
    			for (j=0;j<8;j++)
    			{
    				Frame[i][j]=1;
    			}
     }
    while (1)
    {
        printf("CMOS_SENSOR_OUTPUT_GENERATOR_STATUS=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_STATUS_OFST));
        for (i=0;i<4000000;i++);
		for (i=0;i<Number_Of_Pixels_RGB/8;i++)
		    {
			for (j=0;j<8;j++)
			{
				printf("%ld ",Frame[i][j]);
				//printf("%ld ",&Frame[i][j]);
			}
			printf("\r\n");
		    }
    }
    return EXIT_SUCCESS;
}
