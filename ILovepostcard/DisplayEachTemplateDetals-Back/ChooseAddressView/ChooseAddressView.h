//
//  ChooseAddressView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-31.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseAddressView : UIViewController

@property (retain, nonatomic) IBOutlet UITextView *adressTextView;

@property (retain, nonatomic) IBOutlet UIButton *goBackButton;


- (IBAction)goBack;


@end
