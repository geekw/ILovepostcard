//
//  ActivityDetailView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-7.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "PostcardList_WithoutSearchbar.h"
#import "GoToPostcardList.h"
#import "PromptView.h"

@interface ActivityDetailView : UIViewController<ASIHTTPRequestDelegate,UITextViewDelegate>

@property (retain, nonatomic) NSString *activityTag;

//@property (retain, nonatomic) NSDictionary *listDict;

@property (retain, nonatomic) IBOutlet UIButton *goBackBtn;

@property (retain, nonatomic) IBOutlet UIImageView *activityImgView;

@property (retain, nonatomic) IBOutlet UILabel *activityLabel1;

@property (retain, nonatomic) IBOutlet UILabel *activityLabel2;

@property (retain, nonatomic) IBOutlet UITextView *descriptionField;

@property (retain, nonatomic) IBOutlet UIButton *templateListBtn;

@property (retain, nonatomic) PostcardList_WithoutSearchbar *postcardList_WithoutSearchbar;

@property (retain, nonatomic) PromptView *promptView;

@property (retain, nonatomic) NSString *effert;

- (IBAction)goBack;

- (IBAction)goToTemplateListView;

@end
