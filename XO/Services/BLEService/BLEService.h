//
//  BLEService.h
//  XO
//
//  Created by Kirill Gorbushko on 29.10.15.
//  Copyright (c) 2014 - present Thinkmobiles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSUInteger, BLEType) {
    BLETypeManager,
    BLETypePeripheral
};

typedef NS_ENUM(NSUInteger, BLEState) {
    BLEStateStarted,
    BLEStateNeedToProceed,
    BLEStateError
};

@class BLEService;

@protocol BLEServiceDelegate <NSObject>

@required
/** Avaliable for type BLETypeManager
    Avaliable for type BLETypePeripheral
 
 @param peripheral nil for BLETypeManager
 */
- (void)BLEServiceDidReceiveData:(nullable NSData *)data peripheral:(nullable CBPeripheral *)peripheral service:(nonnull BLEService *)BLEService;

@optional

/** Avaliable for type BLETypeManager
    Avaliable for type BLETypePeripheral */
- (void)BLEServiceDidUpdateState:(nonnull BLEService *)service description:(nonnull NSString *)description state:(BLEState)currentState;

/** Avaliable for type BLETypeManager
 @param peripheral - founded Peripheral device
 @param advertisementData - additional Info
 @param RSSI - Reseived Service Strength Indicator,
        RSSI = -10*n*log(d) + A,
        where d = distance, A = txPower, n = signal propagation constant and [RSSI] = dBm.
        In free space n = 2, but it will vary based on local geometry - for example, 
        a wall will reduce RSSI by ~3dBm and will affect n accordingly
        http://www.rn.inf.tu-dresden.de/dargie/papers/icwcuca.pdf
 
 @code
 advertisementData:
 {
    kCBAdvDataIsConnectable = 1;
    kCBAdvDataLocalName = "<HERE WILL BE NAME OF DEVICE>
    kCBAdvDataServiceUUIDs =     (
        "2BDCCD09-EFF9-47C9-B906-E0055A8E229A"
    );
 }
 */
- (void)BLEServiceDidDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI;

/** Avaliable for type BLETypeManager */
- (void)BLEServiceDidConnect:(nonnull CBPeripheral *)peripheral;

/** Avaliable for type BLETypeManager */
- (void)BLEServiceDidDisconnect:(nonnull CBPeripheral *)peripheral;

/** Avaliable for type BLETypeManager */
- (void)BLEServiceDidFailWithError:(nonnull NSError *)error peripheral:(nonnull CBPeripheral *)peripheral;

@end

@interface BLEService : NSObject <CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate>

@property (weak, nonatomic) id <BLEServiceDelegate> delegate;
@property (assign, nonatomic) BOOL canSendData;

#pragma mark - Common
- (nonnull instancetype)initWithType:(BLEType)type;

- (void)sendData:(nonnull NSData *)data;
- (BLEType)currentServiceType;

#pragma mark - ManagerOnly
/** start Automatically after creating
    if some problem occured will be called BLEServiceDidUpdateState: */
- (void)startScanning;
- (void)stopScanning;

- (void)connectToPerephiral:(nonnull CBPeripheral *)peripheral;

#pragma mark - PeripheralOnly
/** start Automatically after creating
    if some problem occured will be called BLEServiceDidUpdateState: */
- (void)startAdvertisement;
- (void)stopAdvertisement;

@end