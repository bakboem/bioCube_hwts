//
//  ViewController.h
//  mobilePassSampleObjc
//
//  Created by namsu choi on 2021/10/27.
//


#import "PassLIb-Swift.h"
#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
API_AVAILABLE(ios(13.0))
@interface PassController : NSObject<NfcDelegate, BleServiceDelegate,CBCentralManagerDelegate>
@property (nonatomic,strong) FlutterBasicMessageChannel *msgChannel;
@property (nonatomic,strong) BlePassService *blePassService;
@property (nonatomic,strong) NfcPassService *nfcService;
@property (nonatomic,strong) MobilePass *mobilePass;
@property (nonatomic,strong) CBCentralManager *centralManager;
@property (nonatomic,strong) NSString *trn;
@property (nonatomic,strong) NSString *tid;
@property (nonatomic,strong) NSString *mobilePassToken;
@property (nonatomic,strong) NSString *bleConnectedDeviceName;
@property (nonatomic,strong) NSObject *obesrver;
@property (nonatomic,strong) NSString *defaultToken;
@property int *bleRssi;
- (void)initial;
- (void)handleBackgroudTask;
- (void)saveToken:(NSString*)newToken;
- (void)updateToken :(NSString*)newToken;
- (NSString*)getToken;
- (void)deleteToken;
- (void)startNFC;
- (void)startBLE;
- (void)startBleScan;
- (void)stopBleScan;
- (void)ClearBtn;
- (void)dispose;
- (void)isNfcOk;
- (void)setChannel:(FlutterBasicMessageChannel *)channel;
- (void)sendData:(NSString *)data;
//- (void)didPassCompleteWithResult:(BOOL)result resultCode:(NSString * _Nonnull)resultCode;
//- (BOOL)didTidReceivedWithTId:(NSString *)tId;
//- (void)passReady;
@end


