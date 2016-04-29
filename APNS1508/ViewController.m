//
//  ViewController.m
//  APNS1508
//
//  Created by HeHui on 16/4/29.
//  Copyright © 2016年 Hawie. All rights reserved.
//

#import "ViewController.h"
#import <AVOSCloud.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchXX;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取是否开启 接受推送
    // 将推送的标识还有信息 做成了一个对象(deviecToken...)
   AVInstallation * installation = [AVInstallation currentInstallation];
    bool isRcv = [[installation objectForKey:@"isRcv"] boolValue];
    if (isRcv) {
        self.switchXX.on = YES;
    }else {
        self.switchXX.on = NO;
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)openOrCloseRcvNoti:(id)sender {
    
    AVInstallation * installation = [AVInstallation currentInstallation];

    if (self.switchXX.on) {
        // 保存我的接受推送的状态
        [installation setObject:@(1) forKey:@"isRcv"];
        
    }else {
        // 保存我的不接受推送的状态
        [installation setObject:@(0) forKey:@"isRcv"];

    }
    // 同步到后台
    [installation saveInBackground];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
