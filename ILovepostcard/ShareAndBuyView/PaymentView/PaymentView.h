//
//  PaymentView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-27.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "PostOfficeView.h"

@interface PaymentView : UIViewController<ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
	NSMutableArray *myProduct; //要卖的产品
}

@property (retain, nonatomic) PostOfficeView *postOfficeView;

@property (retain, nonatomic) IBOutlet UIButton *goBackButton;

@property (retain, nonatomic) IBOutlet UIButton *snailMailButton;

@property (retain, nonatomic) IBOutlet UIButton *registeredLetterButton;

@property (retain, nonatomic) IBOutlet UIButton *expressDeliveryButton;

@property (retain, nonatomic) IBOutlet UIImageView *preViewImgView;

@property (retain, nonatomic) IBOutlet UILabel *priceLabel;

@property (retain, nonatomic) IBOutlet UIButton *openPayViewBtn;

@property (retain, nonatomic) UIView   *tempPayView;

@property (retain, nonatomic) NSMutableArray *priceArray;

@property (retain, nonatomic) IBOutlet UILabel *snailMailLabel;

@property (retain, nonatomic) IBOutlet UILabel *registeredMailLabel;

@property (retain, nonatomic) IBOutlet UILabel *expressLabel;




- (IBAction)goBack;

- (IBAction)snailMail;

- (IBAction)registeredLetter;

- (IBAction)expressDelivery;

- (IBAction)openPayView;




@end
