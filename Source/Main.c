
 // This application configures UART 16550 to baud rate 9600.


#define __MICROBLAZE__
#include <xil_io.h>

#define BUFFER_SIZE 8
#include <stdint.h>
#include <stdio.h>
#include <xil_types.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xsysmon.h"
#include "stdlib.h"
#include "sleep.h"
#include "xintc.h"


char UARTBuffer[8]={0,0,0};
volatile u16 ADCval = 0;


XIntc InterruptController;
XSysMon XADCInstance;
void MyIsr(void *CallbackRef) {
 // Your ISR code here (e.g., toggle an LED or handle button press)
ADCval = XSysMon_GetAdcData(&XADCInstance, XSM_CH_AUX_MIN + 4)>>4;
Xil_Out32(XPAR_XADC_REG_0_BASEADDR,ADCval);
}


int main()
{
    
    init_platform();
     print("|-.-|Entering Main|-.-|\n\r");

  
      // The XADC instance
XSysMon_Config *ADCConfigPtr; // Pointer to the XADC configuration
XStatus Status;


ADCConfigPtr = XSysMon_LookupConfig( XPAR_XADC_WIZ_0_BASEADDR ); // The macro comes from xparameters.h
if( ADCConfigPtr == NULL ) {print("!Pointer Config Failed!\n\r");}

Status = XSysMon_CfgInitialize( &XADCInstance, ADCConfigPtr, ADCConfigPtr->BaseAddress );
if( Status != XST_SUCCESS ) {print("!ADC Config Failed!\n\r");}


XSysMon_IntrGlobalDisable( &XADCInstance );

XSysMon_SetSequencerMode( &XADCInstance, XSM_SEQ_MODE_SINGCHAN );
XSysMon_SetAlarmEnables( &XADCInstance, 0 );

u32 RegValue = XSysMon_ReadReg( XADCInstance.Config.BaseAddress, XSM_CFR0_OFFSET );
RegValue |= XSM_CFR0_CAL_AVG_MASK;
XSysMon_WriteReg( XADCInstance.Config.BaseAddress, XSM_CFR0_OFFSET, RegValue );

XSysMon_SetAvg( &XADCInstance, XSM_AVG_16_SAMPLES  );
XSysMon_SetCalibEnables(&XADCInstance, XSM_CFR1_CAL_ADC_OFFSET_MASK | XSM_CFR1_CAL_PS_OFFSET_MASK);

 XSysMon_SetSingleChParams(
  &XADCInstance,
  XSM_CH_AUX_MIN+4, // == channel index of VAUX[1]
  FALSE,            /* IncreaseAcqCycles==false -> default 4 ADCCLKs used for the settling;
                       true -> 10 ADCCLKs used */
  FALSE,            // IsEventMode==false -> continuous sampling
  FALSE );          // IsDifferentialMode==false -> unipolar mode


  
  

  
   /*
for(int i=0;i<10;i++){

 ADCval = XSysMon_GetAdcData(&XADCInstance, XSM_CH_AUX_MIN + 4);
  itoa(ADCval, UARTBuffer, 10);
   print(UARTBuffer);
   print("\n\r");
   msleep(50);
}
*/

Status = XIntc_Initialize(&InterruptController, XPAR_XINTC_0_BASEADDR);
 // Connect the interrupt handler to the ISR
 Status = XIntc_Connect(&InterruptController, 0,
 (XInterruptHandler)MyIsr, 0);
 // Start the interrupt controller
 Status = XIntc_Start(&InterruptController, XIN_REAL_MODE);
 // Enable interrupts in the MicroBlaze processor
 XIntc_Enable(&InterruptController, 0);
 Xil_ExceptionInit();
 Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
 (Xil_ExceptionHandler)XIntc_InterruptHandler,
&InterruptController);
 Xil_ExceptionEnable();


 print("Waiting for interrupt\n\r");
 while(1){

     itoa(Xil_In32(XPAR_XADC_REG_0_BASEADDR), UARTBuffer, 10);
   print(UARTBuffer);
   print("\n\r");
   msleep(100);
  // Xil_Out32(XPAR_XADC_REG_0_BASEADDR,ADCval);
 }


    print("|-^-|Exiting Main|-^-|\n\r");
    cleanup_platform();
    return 0;
}
