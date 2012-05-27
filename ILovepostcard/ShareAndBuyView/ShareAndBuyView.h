//
//  ShareAndBuyView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-25.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentView.h"

@interface ShareAndBuyView : UIViewController

@property (retain, nonatomic) PaymentView *paymentView;

@property (retain, nonatomic) IBOutlet UIButton *goBackButton;

@property (retain, nonatomic) IBOutlet UIButton *flipButton;

@property (retain, nonatomic) IBOutlet UIButton *flipButton_Back;

@property (retain, nonatomic) IBOutlet UIButton *shareButton;

@property (retain, nonatomic) IBOutlet UIButton *buyButton;

@property (retain, nonatomic) IBOutlet UIView *flipView;

- (IBAction)goBack;

- (IBAction)flip;

- (IBAction)shareToSIna;

- (IBAction)buyThisCard;


@end
