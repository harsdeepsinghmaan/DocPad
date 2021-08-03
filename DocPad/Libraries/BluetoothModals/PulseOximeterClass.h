//
//  ViewController.h
//  NONIN3230 Application
//
//  Created by Nonin Connectivity on 7/25/13.
//  Copyright (c) 2013 Nonin Connectivity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol PulseOximeterDelegate <NSObject>

-(void)pulseOximeterReadingUpdated;

@end

@interface PulseOximeterClass : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property(nonatomic, strong) CBCentralManager *centralManager;
@property(nonatomic,strong) CBPeripheral *discoveredPeripheral;

@property(nonatomic,strong) NSString *spO2;
@property(nonatomic,strong) NSString *pulse;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *serialNumber;

@property(nonatomic,weak) id<PulseOximeterDelegate>delegate;

-(void)startMonitoring;

@end
