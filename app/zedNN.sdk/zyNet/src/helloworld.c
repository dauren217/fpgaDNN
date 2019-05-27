/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include "zyNet.h"
#include "weightValues.h"
#include "biasValues.h"
#include "dataValues.h"
#include <xil_io.h>
#include "xaxidma.h"

XAxiDma dma_inst;



#define numLayers 5
int numNeurons[] = {784,30,30,10,10};


int main()
{
	u32 i,j,k,l;
	l=0;
	int status;
	XAxiDma_Config* cfg_ptr;
	// Look up hardware configuration for device
	cfg_ptr = XAxiDma_LookupConfig(XPAR_AXIDMA_0_DEVICE_ID);
	if (!cfg_ptr)
	{
		xil_printf("ERROR! No hardware configuration found for AXI DMA with device id %d.\r\n", XPAR_AXIDMA_0_DEVICE_ID);
	}
	status = XAxiDma_CfgInitialize(&dma_inst, cfg_ptr);
	if (status != XST_SUCCESS)
	{
		xil_printf("ERROR! Initialization of AXI DMA failed with %d\r\n", status);
	}
	XAxiDma_IntrDisable(&dma_inst, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(&dma_inst, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);
	// Reset DMA
	XAxiDma_Reset(&dma_inst);
	while (!XAxiDma_ResetIsDone(&dma_inst)) {}
	xil_printf("Successfully initialized DMA controller\n\r", status);

	Xil_Out32(controlReg,0x1); //softreset the NN
	Xil_Out32(controlReg,0x0);

	for(i=0;i<=numLayers;i++){
		Xil_Out32(layerReg,i+1); //Write layer number to layer register
		for(j=0;j<numNeurons[i+1];j++){
			Xil_Out32(neuronReg,j); //Write neuron number to neuron register
				for(k=0;k<numNeurons[i];k++){
					Xil_Out32(weightReg,weightValues[l]); //Write weight to weight register
					l++;
				}
		}
	}

	l=0;
	for(i=0;i<=numLayers;i++){
		Xil_Out32(layerReg,i+1); //Write layer number to layer register
		for(j=0;j<numNeurons[i+1];j++){
			Xil_Out32(neuronReg,j); //Write neuron number to neuron register
			Xil_Out32(biasReg,biasValues[l]); //Write weight to weight register
			l++;
		}
	}

	xil_printf("Configuration completed\n\r", status);

	status = XAxiDma_SimpleTransfer
	(
		&dma_inst,
		(int)&dataValues,
		784*4,
		XAXIDMA_DMA_TO_DEVICE
	);

	status = Xil_In32(statReg);
	while(!status)
		status = Xil_In32(statReg);

	status = Xil_In32(outputReg);
	xil_printf("Detected Number %d\n\r",status);

	for(i=0;i<10;i++){
		status = Xil_In32(axi_rd_data);
		xil_printf("Neuron %d value %0x\n\r",i,status);
	}
}
