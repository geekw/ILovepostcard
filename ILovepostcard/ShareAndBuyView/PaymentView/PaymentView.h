//
//  PaymentView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-27.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentView : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *goBackButton;

@property (retain, nonatomic) IBOutlet UIButton *snailMailButton;

@property (retain, nonatomic) IBOutlet UIButton *registeredLetterButton;

@property (retain, nonatomic) IBOutlet UIButton *expressDeliveryButton;

@property (retain, nonatomic) IBOutlet UIButton *payTheBillButton;

- (IBAction)goBack;

- (IBAction)snailMail;

- (IBAction)registeredLetter;

- (IBAction)expressDelivery;

- (IBAction)payTheBill;
@end
