/*
 * zyNet.h
 *
 *  Created on: May 22, 2019
 *      Author: VIPIN
 */

#ifndef SRC_ZYNET_H_
#define SRC_ZYNET_H_

#include "xparameters.h"

#define zynetBaseAddress XPAR_ZYNET_0_BASEADDR
#define weightReg XPAR_ZYNET_0_BASEADDR+0
#define biasReg XPAR_ZYNET_0_BASEADDR+4
#define outputReg XPAR_ZYNET_0_BASEADDR+8
#define layerReg XPAR_ZYNET_0_BASEADDR+12
#define neuronReg XPAR_ZYNET_0_BASEADDR+16
#define axi_rd_data XPAR_ZYNET_0_BASEADDR+20
#define statReg XPAR_ZYNET_0_BASEADDR+24
#define controlReg XPAR_ZYNET_0_BASEADDR+28

#endif /* SRC_ZYNET_H_ */
