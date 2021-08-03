//
//  ViewController.m
//  NONIN3230 Mini iOS Application
//
//  Created by Nonin on 11/1/13.
//  Copyright (c) 2013 Nonin. All rights reserved.
//  Revision 1.0
//

#import "PulseOximeterClass.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define kServiceUUID  @"46A970E0-0D5F-11E2-8B5E-0002A5D5C51B"
#define kPeripheralUUID @"DCB8D975-1314-5572-2EDF-CD7CD80EB52D"
#define kCharacteristicsUUID @"0AAD7EA0-0D60-11E2-8E3C-0002A5D5C51B"
#define SerialNumber_Char                    @"2A25"
#define kDEVICE_INFO_SERVICE_UUID            @"180A"

@implementation PulseOximeterClass

- (void)startMonitoring {
	//Initialize the class and set the delegate
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void) centralManagerDidUpdateState:(CBCentralManager *) central
{
    switch(central.state)
    {
            //BLE is powered on and ready
        case CBCentralManagerStatePoweredOn:
            //Start the scanning for any devices
            [self scan];
            break;
            //BLE is powered off
            //Note: Here, you can re-initialize the central Manager so that the iOS device will alert the user to turn on the Bluetooth
        case CBCentralManagerStatePoweredOff:
            NSLog(@"PoweredOff!");
            self.discoveredPeripheral = nil;
            break;
        default:
            break;
    }
}


/*
 =======================================================================================
 Function: scan
 Description: scans for peripherals that are advertising services (any BLE device)
 Parameters: None
 Returns: None
 =======================================================================================
 */
-(void) scan
{
    //Standard services have a 16-bit UUID, in our case its 0x180A for device information. If we leave it nil, it will automatically look for device information.
    //We cannot use our proprietary services since its 128-bit UUID(16 bytes)
    //CBCentralManagerScanOptionAllowDuplicatesKey is set to YES because it disables filtering and a discovery event is generated each time the central receives an advertising packet form the peripheral.
    [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
}


/*
 =======================================================================================
 Function: didDicoverPeripheral
 Description: Invoked when the iOS device discovers a peripheral while scanning
 Parameters: central, peripheral, adertisementData, RSSI
 Returns: None
 =======================================================================================
 */
-(void)centralManager:(CBCentralManager *) central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if(self.discoveredPeripheral != peripheral)
    {
        self.discoveredPeripheral = peripheral;
      
        //Try connecting to the device whose name contains the "Nonin" substring
        if([peripheral.name containsString:(@"Nonin")])
        {
            //Stop scanning
            self.name = peripheral.name;
            self.serialNumber = [[peripheral.name componentsSeparatedByString:@"_"] lastObject];
            [self.centralManager stopScan];
            NSLog(@"Scanning Stopped!");
            [self.centralManager connectPeripheral:peripheral options:nil];
        }
    }
}


/*
 =======================================================================================
 Function: didConnectperipheral
 Description: Invoked when a connection is sucessfully created with a peripheral
 Parameters: central, peripheral
 Returns: None
 =======================================================================================
 */
-(void) centralManager:(CBCentralManager *) central didConnectPeripheral:(CBPeripheral *)peripheral
{
        // Asks the peripheral to discover all services
        peripheral.delegate = self;
        [peripheral discoverServices:nil];
        
        //NSLog(@"Connection sucessfull to peripheral: %@ with UUID: %@", peripheral, peripheral.UUID);
}


/*
 =======================================================================================
 Function: didFailToConnectPeripheral
 Description: Invoked when the iOS device fails to create a connection with a peripheral
 Parameters: central, peripheral, error
 Returns: None
 =======================================================================================
 */
-(void) centralManager:(CBCentralManager *) central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *) error
{
    NSLog(@"Connection Failed");
    //Do something when a connection to a peripheral fails
    self.discoveredPeripheral = nil;
    [self scan];
}


/*
 =======================================================================================
 Function: didDiscoverServices
 Description: Invoked when you discover the peripheral's available services
 Parameters: peripheral, error
 Returns: None
 =======================================================================================
 */
- (void)peripheral:(CBPeripheral *) peripheral didDiscoverServices:(NSError *)error
{
    if(error)
    {
        NSLog(@"Error dicovering service: %@", [error localizedDescription]);
        [self cleanUp];
        return;
    }
    
    for (CBService *service in peripheral.services)
    {
        // Discovers the characteristics for a given service
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]])
        {
            [peripheral discoverCharacteristics:nil forService:service];
        }
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kDEVICE_INFO_SERVICE_UUID]]) {
            [peripheral discoverCharacteristics:[NSArray arrayWithObject:[CBUUID UUIDWithString:SerialNumber_Char]] forService:service];
        }
    }
}


/*
 =======================================================================================
 Function: didDiscoverCharacteristicsForService
 Description: Invoked when you discover the characteristics of a specified service
 Parameters: peripheral, service, error
 Returns: None
 =======================================================================================
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if(error)
    {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [self cleanUp];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicsUUID]] || [characteristic.UUID isEqual:[CBUUID UUIDWithString:SerialNumber_Char]]) {
            //Required device found, turn on the notifications
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}


/*
 =======================================================================================
 Function: didUpdateValueForCharacteristics
 Description: Invoked when you retrieve a specifed characteristics's value
 Parameters: peripheral, characteristic, error
 Returns: None
 =======================================================================================
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error)
    {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    NSLog(@"%@", characteristic.UUID);
    //Parse the received data
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SerialNumber_Char]]) {
        self.serialNumber = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    }else {
        [self parseData:characteristic.value];
    }
}


/*
 =======================================================================================
 Function: parseData
 Description: The receieved data are parsed here into measurements
 Parameters: data
 Returns: None
 =======================================================================================
 */

- (void)parseData:(NSData *)data
{
    const uint8_t *bytes = [data bytes];
    
    /*------------------------------------------------Packet---------------------------------------------*/
    
    //Indicates the current device status
    uint8_t status    = bytes[1];
        /*----------------Status field----------------*/
        //Indicates that the display is synchronized to the SpO2 and pulse rate values contained in this packet
//        uint8_t syncIndication = (status & 0x1);
//        //Average amplitude indicates low or marginal signal quality
//        uint8_t weakSignal   = (status & 0x2) >> 1;
//        //Used to indicate tht the data successfully passed the SmartPoint Algorithm
//        uint8_t smartPoint  = (status & 0x4) >> 2;
//        //An absence of consecutive good pulse signal
//        uint8_t searching   = (status & 0x8) >> 3;
//        //CorrectCheck technology indicates that the finger is placed correctly in the oximeter
//        uint8_t correctCheck  = (status & 0x10) >> 4;
//        //Low or critical battery is indicated on the device
//        uint8_t lowBattery  = (status & 0x20) >> 5;
    
    //Voltage level of the battries in use in .1 volt increments [decivolts]
//    uint8_t battVolt  = bytes[2];
//    //Value that indicates the relative strength of the pulsatile signal. Units 0.01% (hundreds of a precent)
//    uint16_t pai      = (bytes[3] << 8) | bytes[4];
//    //Value that indicates that number of seconds since the device went into run mod (between 0-65535)
//    uint16_t secCounter = (bytes[5] << 8) | bytes[6];
    //SpO2 percentage 0-100 (127 indicates missing)
    uint8_t spO2      = bytes[7];
    //Pulse Rate in beats per minute, 0-325. (511 indicates missiing)
    uint16_t pulse    = (bytes[8] << 8) | bytes[9];

    //Display the received values
    
    //Display the 1 for TRUE and 0 for FALSE
    
    // A value of 127 indicates no data for SpO2
    if((int)(spO2) != 127)
    {
        self.spO2 =[NSString stringWithFormat:@"%d",spO2];
        //NSLog(@"SPO2 %@",self.spO2);
    }
    else
    {
    }
    //A value of 511 indicates no data for pulse
    if((int)(pulse) != 511)
    {
        self.pulse =[NSString stringWithFormat:@"%d",pulse];
        //NSLog(@"Pulse %@",self.pulse);
    }
    else
    {
        //self.pulseBox.text = @"--";
    }
    //Display second counter
    //self.secCounterBox.text =[NSString stringWithFormat:@"%d",secCounter];
    if (self.spO2 != nil && self.pulse != nil ) {
        [self.delegate pulseOximeterReadingUpdated];
    }
}


/*
 =======================================================================================
 Function: didDisconnectPeripheral
 Description: Invoked when an existing connection with a peripheral is disconnected
 Parameters: peripheral, error
 Returns: None
 =======================================================================================
 */
-(void) centralManager:(CBCentralManager *) central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected. Error: %@",error);
    //set all the values to nil
    self.discoveredPeripheral = nil;
    
    //scan
    [self scan];
}


/*
 =======================================================================================
 Function: cleanUp
 Description: Call this when things either go wrong or you're done with the connection
 Parameters: None
 Returns: None
 =======================================================================================
 */
-(void) cleanUp
{
    if(self.discoveredPeripheral.state != CBPeripheralStateConnected)
        return;
    
    if(self.discoveredPeripheral.services != nil)
    {
        for(CBService *service in self.discoveredPeripheral.services)
        {
            if(service.characteristics != nil)
            {
                for(CBCharacteristic *characteristics in service.characteristics)
                {
                    if([characteristics.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]])
                    {
                        if(characteristics.isNotifying)
                        {
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic: characteristics];
                        }
                    }
                }
            }
        }
    }
    
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}

@end
