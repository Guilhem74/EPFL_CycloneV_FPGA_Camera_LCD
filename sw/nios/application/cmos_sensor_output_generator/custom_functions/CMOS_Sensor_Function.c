#include "../custom_functions/CMOS_Sensor_Function.h"

#define CMOS_SENSOR_OUTPUT_GENERATOR_0_PIX_DEPTH_REDEFINED  (12)     /* cmos_sensor_output_generator pix depth from system.h (ADAPT TO YOUR DESIGN) */
#define Number_Of_Pixels_RGB CMOS_SENSOR_OUTPUT_GENERATOR_0_WIDTH*CMOS_SENSOR_OUTPUT_GENERATOR_0_HEIGHT/4 // One pixel = 4 sensors values
#define Number_Of_Memory_Slot Number_Of_Pixels_RGB/2 //One memory slot =2 Pixels


cmos_sensor_output_generator_dev cmos_sensor_output_generator;
/* Camera Acquisition Module Part */
#define CAMERA_MODULE_REGISTER_ADDRESS                 (0 * 4) /* RW */
#define CAMERA_MODULE_REGISTER_LENGTH                (1 * 4) /* RW */
#define CAMERA_MODULE_REGISTER_START          (2 * 4) /* RW */
#define CAMERA_MODULE_REGISTER_STOP            (3 * 4) /* RW */
#define CAMERA_MODULE_REGISTER_SNAPSHOT             (4 * 4) /* RW */
#define CAMERA_MODULE_REGISTER_FLAG            (5 * 4) /* RW */
int Camera_Acquisition_Module_SETUP_Address_Memory(int Address)
{
	IOWR_32DIRECT(CAMERA_MODULE_0_BASE, CAMERA_MODULE_REGISTER_ADDRESS, Address);
	for (int i=0;i<10;i++);
	return IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_ADDRESS);
}
// Length : Number of pixel to store. reminder : 1 Memory slot =2 pixels and 1 memory slot = 4 bytes
int Camera_Acquisition_Module_SETUP_Length_Frame(int Pixel_Number)
{
	IOWR_32DIRECT(CAMERA_MODULE_0_BASE, CAMERA_MODULE_REGISTER_LENGTH, Pixel_Number/2*4);//*4 because 32bits;
	for (int i=0;i<10;i++);
	return IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_LENGTH);
}
int Camera_Acquisition_Module_Start()
{
	IOWR_32DIRECT(CAMERA_MODULE_0_BASE, CAMERA_MODULE_REGISTER_START, 1);//*4 because 32bits;
	for (int i=0;i<10;i++);
	return IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_START);
}
int Camera_Acquisition_Module_Stop()
{
	IOWR_32DIRECT(CAMERA_MODULE_0_BASE, CAMERA_MODULE_REGISTER_STOP, 1);//*4 because 32bits;
	for (int i=0;i<10;i++);
	return IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_STOP);
}
void Camera_Acquisition_Module_Display_Registers()
{
	printf("CAMERA_MODULE_REGISTER_ADDRESS=0x%x\r\n",IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_ADDRESS));
	printf("CAMERA_MODULE_REGISTER_LENGTH=%d\r\n",IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_LENGTH));
	printf("CAMERA_MODULE_REGISTER_START=%d\r\n",IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_START));
	printf("CAMERA_MODULE_REGISTER_STOP=%d\r\n",IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_STOP));
	printf("CAMERA_MODULE_REGISTER_SNAPSHOT=%d\r\n",IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_SNAPSHOT));
	printf("CAMERA_MODULE_REGISTER_FLAG=%d\r\n",IORD_32DIRECT(CAMERA_MODULE_0_BASE,CAMERA_MODULE_REGISTER_FLAG));
}
/* Pixels Generator Part */

 void Configure_CMOS_Generator(int width, int height)
 {
	  cmos_sensor_output_generator = cmos_sensor_output_generator_inst(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,
	 	    																					CMOS_SENSOR_OUTPUT_GENERATOR_0_PIX_DEPTH_REDEFINED,
																								width,
																								height);
	    cmos_sensor_output_generator_init(&cmos_sensor_output_generator);
	    cmos_sensor_output_generator_stop(&cmos_sensor_output_generator);
	    cmos_sensor_output_generator_configure(&cmos_sensor_output_generator,
	    																width,
																		height,
	                                           CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_FRAME_BLANK_MIN,
	                                           CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_LINE_BLANK_MIN,
	                                           CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_LINE_BLANK_MIN,
	                                           CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_FRAME_BLANK_MIN);
 }
 void Start_CMOS_Generator()
 {
	    cmos_sensor_output_generator_start(&cmos_sensor_output_generator);
 }
 void Stop_CMOS_Generator()
 {
	    cmos_sensor_output_generator_stop(&cmos_sensor_output_generator);
 }
 void Display_Configuration_Generator()
 {
	 	printf("CMOS_SENSOR_OUTPUT_GENERATOR_0_WIDTH=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_WIDTH_OFST));
	    printf("CMOS_SENSOR_OUTPUT_GENERATOR_0_HEIGHT=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_HEIGHT_OFST));
	    printf("CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_FRAME_BLANK_MIN=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_FRAME_BLANK_OFST));
	    printf("CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_LINE_BLANK_MIN=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_FRAME_LINE_BLANK_OFST));
	    printf("CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_LINE_BLANK_MIN=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_LINE_BLANK_OFST));
	    printf("CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_FRAME_BLANK_MIN=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_CONFIG_LINE_FRAME_BLANK_OFST));
	    printf("CMOS_SENSOR_OUTPUT_GENERATOR_COMMAND=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_COMMAND_OFST));
	    printf("CMOS_SENSOR_OUTPUT_GENERATOR_STATUS=%d\r\n",IORD_32DIRECT(CMOS_SENSOR_OUTPUT_GENERATOR_0_BASE,CMOS_SENSOR_OUTPUT_GENERATOR_STATUS_OFST));
 }
