**[EPFL] Interfacing a camera and a LCD to an Intel FPGA**

Project done for the Embedded system course at EPFL.

In collaboration with Pierre Fourcade.

Goal : Capture and display the image seen by a camera on a LCD without using a processor.
Two DMA units have been developped in order to capture and store the image from the camera and then to read and display it on a LCD

Board : Cyclone V DE1-SoC Board

The LCD part has been developped by Pierre

The CAMERA part has been developped by myself. 

Software : Quartus

Project file can be found at ./hw/quartus/

VHDL can be found at ./hw/hdl/

Feel free to use everything present on that repository unless something else is mentionned.
