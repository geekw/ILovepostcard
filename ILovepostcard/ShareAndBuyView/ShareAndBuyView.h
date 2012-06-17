//
//  ShareAndBuyView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-25.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentView.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "PromptView.h"
#import "TKLoadingAnimationView.h"


@interface ShareAndBuyView : UIViewController<ASIHTTPRequestDelegate>
{
    UIView *spinerView;
//    TKLoadingAnimationView *spiner;
}

@property (retain, nonatomic) PaymentView *paymentView;

@property (retain, nonatomic) IBOutlet UIButton *goBackButton;

@property (retain, nonatomic) IBOutlet UIButton *flipButton;

@property (retain, nonatomic) IBOutlet UIButton *flipButton_Back;

@property (retain, nonatomic) IBOutlet UIButton *shareButton;

@property (retain, nonatomic) IBOutlet UIButton *buyButton;

@property (retain, nonatomic) IBOutlet UIView *flipView;

@property (retain, nonatomic) IBOutlet UIButton *flipButton2;

@property (retain, nonatomic) NSMutableArray *priceArray;

@property (retain, nonatomic) IBOutlet UIButton *resignBtn;

@property (retain, nonatomic) IBOutlet UIView *sinaWeiBoShareView;

@property (retain, nonatomic) IBOutlet UIButton *shareBtn;


- (IBAction)goBack;

- (IBAction)flip;

- (IBAction)flip2;

- (IBAction)shareToSina;

- (IBAction)buyThisCard;

- (IBAction)resignKeyboard;

- (IBAction)goToShareView;








@end
