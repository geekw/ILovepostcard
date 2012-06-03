//
//  PaymentView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-27.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//
@interface Product : NSObject
{
@private
	float     _price;
	NSString *_subject;
	NSString *_body;
	NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *orderId;

@end


@interface PaymentView : UIViewController<ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
	NSMutableArray *myProduct; //要卖的产品

}

@property (retain, nonatomic) IBOutlet UIButton *goBackButton;

@property (retain, nonatomic) IBOutlet UIButton *snailMailButton;

@property (retain, nonatomic) IBOutlet UIButton *registeredLetterButton;

@property (retain, nonatomic) IBOutlet UIButton *expressDeliveryButton;

@property (retain, nonatomic) IBOutlet UIButton *wapPayButton;

@property (retain, nonatomic) IBOutlet UIButton *clientPayButton;

- (IBAction)goBack;

- (IBAction)snailMail;

- (IBAction)registeredLetter;

- (IBAction)expressDelivery;

- (IBAction)wapPay;

- (IBAction)clientPay;


@end
