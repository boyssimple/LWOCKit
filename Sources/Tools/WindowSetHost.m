//
//  WindowSetHost.m
//  KaKaWorking
//
//  Created by yanyu on 2019/9/18.
//  Copyright © 2019 yanyu. All rights reserved.
//

#import "WindowSetHost.h"
#import <LWOCKit/YYNetworkingConfig.h>

@interface WindowSetHost()
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UIView *vLine;
@property (nonatomic, strong) UILabel *lbText;
@property (nonatomic, strong) UITextField *tfText;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;
@end
@implementation WindowSetHost

- (id)initWithType:(YYBaseWindowType)type{
    self = [super initWithType:type];
    if (self) {
        self.mainView.height = 220;
        _lbTitle = [[UILabel alloc]init];
        _lbTitle.textColor = RGB3(0);
        _lbTitle.font = [UIFont boldSystemFontOfSize:16*RATIO_WIDHT750];
        _lbTitle.text = @"服务器地址切换";
        _lbTitle.textAlignment = NSTextAlignmentCenter;
        [self.mainView addSubview:_lbTitle];
        
        _vLine = [[UIView alloc]initWithFrame:CGRectZero];
        _vLine.backgroundColor = RGB3(230);
        [self.mainView addSubview:_vLine];
        
        _lbText = [[UILabel alloc]init];
        _lbText.textColor = RGB3(0);
        _lbText.font = [UIFont systemFontOfSize:14*RATIO_WIDHT750];
        _lbText.text = @"服务器地址：";
        [self.mainView addSubview:_lbText];
        
        _tfText = [[UITextField alloc]init];
        _tfText.font = [UIFont systemFontOfSize:14*RATIO_WIDHT750];
        _tfText.textColor = [UIColor blackColor];
        _tfText.text = [YYNetworkingConfig shareInstance].hostUrl;
        _tfText.placeholder = @"请输入服务器地址";
        _tfText.keyboardType = UIKeyboardTypeAlphabet;
        [self.mainView addSubview:_tfText];
        
        _btnCancel = [[UIButton alloc]init];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnCancel.titleLabel.font = [UIFont systemFontOfSize:14*RATIO_WIDHT750];
        _btnCancel.tag = 100;
        [_btnCancel addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnCancel.backgroundColor = RGB3(232);
        [self.mainView addSubview:_btnCancel];
        
        _btnConfirm = [[UIButton alloc]init];
        [_btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [_btnConfirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btnConfirm.titleLabel.font = [UIFont systemFontOfSize:14*RATIO_WIDHT750];
        _btnConfirm.tag = 101;
        _btnConfirm.backgroundColor = [UIColor redColor];
        [_btnConfirm addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:_btnConfirm];
        
        
        CGRect r = self.lbTitle.frame;
        r.size.width = 200*RATIO_WIDHT750;
        r.size.height = 40*RATIO_WIDHT750;
        r.origin.x = (self.mainView.width - r.size.width)/2.0;
        r.origin.y = 5 * RATIO_WIDHT750;
        self.lbTitle.frame = r;
        
        r = self.vLine.frame;
        r.size.width = self.mainView.width;
        r.size.height = 1;
        r.origin.x = 0;
        r.origin.y = self.lbTitle.bottom + 5*RATIO_WIDHT750;
        self.vLine.frame = r;
        
        r = self.lbText.frame;
        r.size.width = 100*RATIO_WIDHT750;
        r.size.height = 40*RATIO_WIDHT750;
        r.origin.x = 15*RATIO_WIDHT750;
        r.origin.y = 20*RATIO_WIDHT750 + self.lbTitle.bottom;
        self.lbText.frame = r;
        
        r = self.tfText.frame;
        r.size.width = (self.mainView.width - self.lbText.right - 25*RATIO_WIDHT750);
        r.size.height = 40*RATIO_WIDHT750;
        r.origin.x = self.lbText.right + 10*RATIO_WIDHT750;
        r.origin.y = self.lbText.y + (self.lbText.height - r.size.height)/2.0;
        self.tfText.frame = r;
        
        r = self.btnConfirm.frame;
        r.size.width = self.mainView.width / 2.0;
        r.size.height = 45*RATIO_WIDHT750;
        r.origin.x = self.mainView.width - r.size.width;
        r.origin.y = self.mainView.height - r.size.height;
        self.btnConfirm.frame = r;
        
        r = self.btnCancel.frame;
        r.size.width = self.mainView.width / 2.0;
        r.size.height = 45*RATIO_WIDHT750;
        r.origin.x = 0;
        r.origin.y = self.mainView.height - r.size.height;
        self.btnCancel.frame = r;
        
        
    }
    return self;
}

- (void)clickAction:(UIButton*)sender{
    if (sender.tag == 100) {
        [self dismiss];
    }else{
        [YYNetworkingConfig shareInstance].hostUrl = [self.tfText.text trim];
        [[NSUserDefaults standardUserDefaults] setObject:[YYNetworkingConfig shareInstance].hostUrl forKey:@"net_working_config_host"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismiss];
    }
}

@end
