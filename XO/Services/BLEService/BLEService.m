//
//  BLEService.m
//  XO
//
//  Created by Kirill Gorbushko on 29.10.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import "BLEService.h"

static NSString *const CBUUIDServiceCodeString = @"2BDCCD09-EFF9-47C9-B906-E0055A8E229A";
static NSString *const CBUUIDWriteableCharacteristicCodeString = @"81827E6D-7B64-48F0-B571-D08CE1E70E2C";
static NSString *const CBUUIDNotifierCharacteristicCodeString = @"E1B9FBBE-8EBA-444F-A31A-451065F60CE5";

@interface BLEService()

//manager
@property (strong, nonatomic) CBCentralManager *centalRoleManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;

//perihperal
@property (strong, nonatomic) CBPeripheralManager *peripheralRoleManager;
@property (strong, nonatomic) CBMutableCharacteristic *notifierCharacteristic;
@property (strong, nonatomic) CBMutableCharacteristic *writeableCharacteristic;
@property (assign, nonatomic) NSInteger sendDataIndex;

@property (assign, nonatomic) BLEType BLEType;

@end

@implementation BLEService

#pragma mark - Public

- (instancetype)initWithType:(BLEType)type
{
    self = [super init];
    if (self) {
        if (type) {
            [self preparePeriperalManager];
        } else {
            [self prepareCentralManager];
        }
        self.BLEType = type;
    }
    return self;
}

- (void)startScanning
{
    if (!self.BLEType) {
        [self.centalRoleManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:CBUUIDServiceCodeString]] options:nil];
    }
}

- (void)stopScanning
{
    if (!self.BLEType) {
        [self.centalRoleManager stopScan];
    }
}

- (void)connectToPerephiral:(CBPeripheral *)peripheral
{
    if (!self.BLEType) {
        if (self.discoveredPeripheral != peripheral) {
            self.discoveredPeripheral = peripheral;
            peripheral.delegate = self;
            [self.centalRoleManager connectPeripheral:peripheral options:nil];
        }
    }
}

- (void)startAdvertisement
{
    if (self.BLEType) {
        [self.peripheralRoleManager startAdvertising:@{
                                                       CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:CBUUIDServiceCodeString]],
                                                       CBAdvertisementDataLocalNameKey : [[UIDevice currentDevice] name]
                                                       }];
    }
}

- (void)stopAdvertisement
{
    if (self.BLEType) {
        [self.peripheralRoleManager stopAdvertising];
    }
}

- (void)sendData:(NSData *)data
{
    if (self.BLEType) {
        self.canSendData = NO;
        self.sendDataIndex = 0;
        BOOL didSend = YES;
        
        while (didSend) {
            NSInteger amountToSend = data.length - self.sendDataIndex;
            if (amountToSend > 200) {
                amountToSend = 200;
            }
            NSData *chunk = [NSData dataWithBytes:data.bytes + self.sendDataIndex length:amountToSend];
            didSend = [self.peripheralRoleManager updateValue:chunk forCharacteristic:self.notifierCharacteristic onSubscribedCentrals:nil];
            
            if (didSend) {
                self.sendDataIndex += amountToSend;
            } else {
                return;
            }
        }
    } else {
        for(CBService *service in self.discoveredPeripheral.services) {
            if([service.UUID isEqual:[CBUUID UUIDWithString:CBUUIDServiceCodeString]]) {
                for(CBCharacteristic *charac in service.characteristics) {
                    if([charac.UUID isEqual:[CBUUID UUIDWithString:CBUUIDWriteableCharacteristicCodeString]]) {
                        [self.discoveredPeripheral writeValue:data forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
                    }
                }
            }
        }
    }
}

- (BLEType)currentServiceType
{
    return self.BLEType;
}

#pragma mark - ManagerLogic

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *description;
    BLEState state = BLEStateError;
    
    if (central.state == CBCentralManagerStatePoweredOff) {
        description = @"CentralManager Bluetooth BLE hardware is powered off";
        state = BLEStateNeedToProceed;
    } else if (central.state == CBCentralManagerStatePoweredOn) {
        description = @"CentralManager Bluetooth BLE hardware is powered on and ready";
        state = BLEStateStarted;
        [self startScanning];
    } else if (central.state == CBCentralManagerStateUnauthorized) {
        description = @"CentralManager Bluetooth BLE state is unauthorized";
        state = BLEStateNeedToProceed;
    } else if (central.state == CBCentralManagerStateUnknown) {
        description = @"CentralManager Bluetooth BLE state is unknown";
    } else if (central.state == CBCentralManagerStateUnsupported) {
        description = @"CentralManager Bluetooth BLE hardware is unsupported on this platform";
    } else if (central.state == CBPeripheralManagerStateResetting) {
        description = @"CentralManager Bluetooth BLE hardware is reseting now";
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(BLEServiceDidUpdateState:description:state:)]) {
        [self.delegate BLEServiceDidUpdateState:self description:description state:state];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(BLEServiceDidDiscoverPeripheral:advertisementData:RSSI:)]) {
        [self.delegate BLEServiceDidDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self stopScanning];
    peripheral.delegate = self;
    [peripheral discoverServices:@[[CBUUID UUIDWithString:CBUUIDServiceCodeString]]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(BLEServiceDidConnect:)]) {
        [self.delegate BLEServiceDidConnect:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self cleanUp];
    if (self.delegate && [self.delegate respondsToSelector:@selector(BLEServiceDidFailWithError:peripheral:)]) {
        [self.delegate BLEServiceDidFailWithError:error peripheral:peripheral];
    }
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    for (CBService *service in peripheral.services) {
        DLog(@"Discovered service %@", service);
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:CBUUIDNotifierCharacteristicCodeString],
                                              [CBUUID UUIDWithString:CBUUIDWriteableCharacteristicCodeString]
                                              ] forService:service];
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDNotifierCharacteristicCodeString]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDWriteableCharacteristicCodeString]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(BLEServiceDidDiscoveredServiceForPeripheral:error:)]) {
        [self.delegate BLEServiceDidDiscoveredServiceForPeripheral:peripheral error:error];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDNotifierCharacteristicCodeString]]) {
        NSString *dataString = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        DLog(@"Received from peripheral - %@", dataString);
        if (self.delegate && [self.delegate respondsToSelector:@selector(BLEServiceDidReceiveData:peripheral:service:)]) {
            [self.delegate BLEServiceDidReceiveData:characteristic.value peripheral:peripheral service:self];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDNotifierCharacteristicCodeString]] ||
        ![characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDWriteableCharacteristicCodeString]]) {
        return;
    }
    
    if (characteristic.isNotifying) {
        DLog(@"Notification began on %@", characteristic);
    } else {
        [self.centalRoleManager cancelPeripheralConnection:peripheral];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests
{
    for (CBATTRequest *request in requests) {
        if ([request.characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDWriteableCharacteristicCodeString]]) {
            NSString *dataString = [[NSString alloc] initWithData:request.value encoding:NSUTF8StringEncoding];
            DLog(@"Received from manager - %@", dataString);
            if (self.delegate && [self.delegate respondsToSelector:@selector(BLEServiceDidReceiveData:peripheral:service:)]) {
                [self.delegate BLEServiceDidReceiveData:request.value peripheral:nil service:self];
            }
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(BLEServiceDidDisconnect:)]) {
        [self.delegate BLEServiceDidDisconnect:peripheral];
    }

    self.discoveredPeripheral = nil;
    [self startScanning];
}

#pragma mark - PeripheralLogic

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSString *description;
    BLEState state = BLEStateError;
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        description = @"Peripheral Bluetooth BLE hardware is powered off";
        state = BLEStateNeedToProceed;
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        description = @"Peripheral Bluetooth BLE hardware is powered on and ready";
        state = BLEStateStarted;
        [self startAdvertisementProcess];
    } else if (peripheral.state == CBPeripheralManagerStateUnauthorized) {
        description = @"Peripheral Bluetooth BLE state is unauthorized";
        state = BLEStateNeedToProceed;
    } else if (peripheral.state == CBPeripheralManagerStateUnknown) {
        description = @"Peripheral Bluetooth BLE state is unknown";
    } else if (peripheral.state == CBPeripheralManagerStateUnsupported) {
        description = @"Peripheral Bluetooth BLE hardware is unsupported on this platform";
    } else if (peripheral.state == CBPeripheralManagerStateResetting) {
        description = @"Peripheral Bluetooth BLE hardware is reseting now";
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(BLEServiceDidUpdateState:description:state:)]) {
        [self.delegate BLEServiceDidUpdateState:self description:description state:state];
    }
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    self.canSendData = YES;
}

#pragma mark - Private

- (void)startAdvertisementProcess
{
    [self startAdvertisement];
    
    self.notifierCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:CBUUIDNotifierCharacteristicCodeString] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    self.writeableCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:CBUUIDWriteableCharacteristicCodeString] properties:CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsWriteable];
    CBMutableService *gameTransferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:CBUUIDServiceCodeString] primary:YES];
    gameTransferService.characteristics = @[self.notifierCharacteristic, self.writeableCharacteristic];
    [self.peripheralRoleManager addService:gameTransferService];
}

- (void)cleanUp
{
    if (self.discoveredPeripheral.services) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDNotifierCharacteristicCodeString]]) {
                        if (characteristic.isNotifying) {
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            continue;
                        }
                    }
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDWriteableCharacteristicCodeString]]) {
                        if (characteristic.isNotifying) {
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            continue;
                        }
                    }

                }
            }
        }
    }
    
    [self.centalRoleManager cancelPeripheralConnection:self.discoveredPeripheral];
}

#pragma mark - Scanner

- (void)prepareCentralManager
{
    self.centalRoleManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

#pragma mark - Service

- (void)preparePeriperalManager
{
    self.peripheralRoleManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

@end