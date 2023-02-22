//
//  ViewController.m
//  mobilePassSampleObjc
//
//  Created by namsu choi on 2021/10/27.
//

#import "passController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@import AudioToolbox;
@implementation PassController

- (void)initial {
    // Do any additional setup after loading the view.
    _mobilePass = [MobilePass mobilePassInstance];
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _blePassService =[[BlePassService alloc] initWithMobilePass:_mobilePass centralManager:_centralManager bleServiceDelegate:self];
    if (@available(iOS 13.0, *)){
        _nfcService = [[NfcPassService alloc] initWithMobilePass:_mobilePass delegate:self];
    }
    _centralManager.delegate = self;
    [self sendData:@"initial successful!~"];

}

-(void) handleBackgroudTask{}

- (void)saveToken:(NSString*)newToken {
     NSLog(@"token::    %@",newToken);
    NSDictionary *putTokenResult = [_mobilePass putTokenWithToken:newToken];
    NSString * temp = @"";
    temp = [temp stringByAppendingFormat:@"save token successful!~ newToken: %@",newToken];
   
//     NSLog(@"putTokenResult::%@",putTokenResult);
    if ([[putTokenResult objectForKey:@"resultCode"] isEqual:[ResultCode SUCCESS]]){
        _mobilePassToken = newToken;
        [self sendData:temp];
    }else{
        [self sendData:@"save token fail!~ token is exits"];
    }
}
-(NSString *) getToken{
    NSDictionary *getTokenResult = [_mobilePass getToken];
    NSString *token = [getTokenResult objectForKey:@"data"];
//    NSLog(@"토큰 get successful!~ %@",token);
    NSString * temp = @"";
    temp = [temp stringByAppendingFormat:@"get token successful!~ %@",token];
    [self sendData:temp];
    return token;
}
- (void)updateToken: (NSString*)newToken{
    NSDictionary *updateToken = [_mobilePass updateTokenWithToken:newToken];
    if([[updateToken objectForKey:@"resultCode"] isEqual:[ResultCode SUCCESS]]){
//        NSLog(@"토큰 update successful!");
        [self sendData:@"updateTokenSuccessful"];
    }
}

- (void)deleteToken {
    NSDictionary *deleteResult = [_mobilePass deleteToken];
        if([[deleteResult objectForKey:@"resultCode"] isEqual:[ResultCode SUCCESS]]){
            
            _mobilePassToken = nil;
            [self sendData:@"delete token successful"];
        }
}

- (void)startNFC{
    if (@available(iOS 13.0, *)) {
        [_mobilePass setPassModeWithPassMode:PASS_MODEMODE_NFC];
                _mobilePassToken = [self getToken];
        if (_mobilePassToken ==nil) {
//            NSLog(@"토큰 조회 필요");
            [self sendData:@"토큰 조회 필요"];
            return; 
        }
        bool isTokenConverted = [_nfcService setTokenWithToken:_mobilePassToken];
        if (isTokenConverted) {
//            NSLog(@"NFC 통신 시작");
            [self sendData:@"NFC 통신 시작"];
            [_nfcService beginSession];
        }else{
            [self sendData:@"convertTokenError"];
//            NSLog(@"convert Token Error");
            return ;
        }
    } else {
        // Fallback on earlier versions
        [self sendData:@"Ios version is lower than 13"];
//        NSLog(@"Ios version is lower than 13");
    }
}
- (void)didPassCompleteWithResult:(BOOL)result resultCode:(NSString * _Nonnull)resultCode {
    if (result == true) {
        // NSLog(@" NFC 통신 성공");
     
    }else{
        // NSLog(@" NFC 통신 실패");
        [self sendData:@"nfcFaild"];
    }
}

-(BOOL)didTidReceivedWithTId:(NSString *)tId {
//    NSLog(@" TID %@",tId);
    if ([tId hasPrefix:@"T"]) {
         NSString * temp = @"";
        temp = [temp stringByAppendingFormat:@"nfcSuccess:%@",tId];
        [self sendData:temp];
        return true;
    }else{
        [self sendData:@"fail to get Tid!"];
        return false;
    }
}

- (void)passReady {
    // NSLog(@" NFC passReady");
    [self sendData:@"nfc passReady"];
}
- (void)startBLE{
     [_mobilePass setPassModeWithPassMode:PASS_MODEMODE_BLE];
                _mobilePassToken = [self getToken];
     if (_mobilePassToken ==nil) {
            [self sendData:@"토큰 조회 필요"];
            return; 
     }else{
    [self sendData:@"bleStart"];
    [self startBleScan];
//    NSLog(@" BLE 통신 시작");
   
     }
    
}
//



-(NSString*) getDtime{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return  [dateFormatter stringFromDate:[NSDate date]];
}

//BLE
- (void)didConnectPeripheral {
    // NSLog(@"BLE 연결 성공");
    NSString * temp = @"";
    temp = [temp stringByAppendingFormat:@"bleSuccess:%@", _bleConnectedDeviceName];
    [self sendData:temp];
    // NSLog(@"deviceName : %@",_bleConnectedDeviceName);
}

- (void)didDisconnectPeripheralWithResultCode:(NSString * _Nonnull)resultCode {
    if ([resultCode isEqual:[ResultCode SUCCESS]]) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self sendData:@"sound play complete"];
    }else{
        [self sendData:@"sound play faild"];
    }
    [self sendData:@"BLE 연결 해제"];
    _centralManager.delegate = self;
}

- (void)peripheralNotSupported {
    [self sendData:@"peripheral not supported"];
    // NSLog(@"peripheral not supported");
}

- (void)peripheralReady {
    //    _mobilePassToken = [self getToken];
    [self sendData:@"peripheral Ready"];
    [_blePassService authenticateWithToken:_mobilePassToken trn:_trn];
}



- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStatePoweredOn:
            [self sendData:@"Is Powered On"];
            // NSLog(@"Is Powered On.");
            break;
        case CBManagerStatePoweredOff:
            [self sendData:@"Is Powered Off"];
            // NSLog(@"Is Powered Off");
            break;
        case CBManagerStateUnsupported:
            [self sendData:@"Is Unsupported"];
            // NSLog(@"Is Unsupported.");
            break;
        case CBManagerStateUnauthorized:
            [self sendData:@"Is Unauthorized"];
            // NSLog(@"Is Unauthorized.");
            break;
        case CBManagerStateUnknown:
            [self sendData:@"Is Unknown"];
            // NSLog(@"Unknown");
            break;
        case CBManagerStateResetting:
            [self sendData:@"Is Resetting"];
            // NSLog(@"Resetting");
            break;
        default:
            [self sendData:@"Is Error"];
            // NSLog(@"Error");
            break;
    }
    
}
-(void) isNfcOk {
    switch (self.centralManager.state) {
        case CBManagerStatePoweredOn:
            [self sendData:@"Is Powered On"];
            // NSLog(@"Is Powered On.");
            break;
        case CBManagerStatePoweredOff:
            [self sendData:@"Is Powered Off"];
            // NSLog(@"Is Powered Off");
            break;
        case CBManagerStateUnsupported:
            [self sendData:@"Is Unsupported"];
            // NSLog(@"Is Unsupported.");
            break;
        case CBManagerStateUnauthorized:
            [self sendData:@"Is Unauthorized"];
            // NSLog(@"Is Unauthorized.");
            break;
        case CBManagerStateUnknown:
            [self sendData:@"Is Unknown"];
            // NSLog(@"Unknown");
            break;
        case CBManagerStateResetting:
            [self sendData:@"Is Resetting"];
            // NSLog(@"Resetting");
            break;
        default:
            [self sendData:@"Is Error"];
            // NSLog(@"Error");
            break;
    }
}
-(void) startBleScan{
   
          [_centralManager scanForPeripheralsWithServices:@[BleServiceUUID.BLEService_UUID] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC) ,dispatch_get_main_queue(), ^{
        if (self->_centralManager.isScanning) {
            [self stopBleScan];
            [self sendData:@"BLE 통신 종료(Scan Timeout)"];
            // NSLog(@"BLE 통신 종료(Scan Timeout)");
        }
    });
     
  
    
}
-(void) stopBleScan{
    [_centralManager stopScan];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    CBPeripheral *connectedPeripheral = peripheral;
    bool isNameMatched;
    
    NSString *deviceName = advertisementData[@"kCBAdvDataLocalName"];
   
    
    if ([deviceName hasPrefix:@"T"] ) {
        isNameMatched = true;
    }else{
        isNameMatched = false;
    }
    int rssi = [RSSI intValue];
    if( &rssi > _bleRssi && isNameMatched){
        [self stopBleScan];
        NSString *mandData = [HexUtil dataToHexWithData:advertisementData[@"kCBAdvDataManufacturerData"] ];
        _trn = [_mobilePass getTrnFromData:[mandData substringFromIndex:4]] ;
//        NSLog(@"trn : %@",_trn);
        _bleConnectedDeviceName = deviceName;
      
        _blePassService =[[BlePassService alloc] initWithMobilePass:_mobilePass centralManager:_centralManager bleServiceDelegate:self];
        [_blePassService setPeripheralWithPeripheralForConnect:connectedPeripheral];
       
    }
}

- (void)setChannel:(FlutterBasicMessageChannel *)channel{
    _msgChannel = channel;
}
- (void)sendData:(NSString *)data{
    if(_msgChannel==nil) {
         [_msgChannel sendMessage:[NSString stringWithFormat:@"channel error"]];
        return;
    };

    [_msgChannel sendMessage:[NSString stringWithFormat:@"%@",data]];
}


-(void) dispose {
    _mobilePass = nil;
    _centralManager = nil;
    _blePassService = nil;

}



@end

