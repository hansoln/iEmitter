//
//  HONViewController.m
//  iEmitter
//
//  Created by Hans Olav Nome on 03.02.14.
//  Copyright (c) 2014 Hans Olav Nome. All rights reserved.
//

#import "HONViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CLBeaconRegion.h>

@interface HONViewController () <CBPeripheralManagerDelegate>

@end

@implementation HONViewController
{
    CBPeripheralManager *_peripheralManager;
    BOOL _isAdvertising;
}

-(void)viewDidLoad {
    _peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
}

- (void)startAdvertising
{
    NSUUID *estimoteUUID = [[NSUUID alloc] initWithUUIDString:@"076E0F6E-14BC-48C5-BA5F-22B1B5469213"];
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:estimoteUUID
                                                                     major:123
                                                                     minor:456
                                                                identifier:@"SimEstimote"];
    NSDictionary *beaconPeripheralData = [region peripheralDataWithMeasuredPower:nil];
    
    [_peripheralManager startAdvertising:beaconPeripheralData];
}

- (void)updateEmitterForDesiredState
{
    if (_peripheralManager.state == CBPeripheralManagerStatePoweredOn)
    {
        // only issue commands when powered on
        
        if (_isAdvertising)
        {
            if (!_peripheralManager.isAdvertising)
            {
                [self startAdvertising];
            }
        }
        else
        {
            if (_peripheralManager.isAdvertising)
            {
                [_peripheralManager stopAdvertising];
            }
        }
    }
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    [self updateEmitterForDesiredState];
}

#pragma mark - Actions

- (IBAction)emittSwitchToggled:(UISwitch *)sender {
    
    _isAdvertising = sender.isOn;
    
    [self updateEmitterForDesiredState];
}

@end
