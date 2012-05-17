//
//  DisplayEachTemplateDetals.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-12.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayEachTemplateDetals-Back.h"

#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

#import "PromptView.h"

#import "TemplateDetails-Singleton.h"

@interface DisplayEachTemplateDetals : UIViewController<ASIHTTPRequestDelegate>
{
    DisplayEachTemplateDetals_Back *displayEachTemplateDetals_Back;
    
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *goDisplayEachTemplateDetals_BackButton;
    IBOutlet UIView *toolBar_FrontView;//侧面工具栏--添加素材
    IBOutlet UIView *postcard_FrontView;//明信片正面
}

@property(nonatomic, retain) NSString *idName;

-(IBAction)goback;

-(IBAction)goDisplayEachTemplateDetals;//去编辑明信片反面
@end
