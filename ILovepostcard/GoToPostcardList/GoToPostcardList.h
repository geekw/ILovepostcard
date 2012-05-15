//
//  GoToPostcardList.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-14.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "PromptView.h"//提示成功失败
#import "ASIFormDataRequest.h"
#import "DisplayEachTemplateDetals.h"
#import "ILPostcardList.h"

@interface GoToPostcardList : UIViewController<ASIHTTPRequestDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
    DisplayEachTemplateDetals *displayEachTemplateDetals;
    
    IBOutlet UIButton *backButton;
    IBOutlet UIScrollView *templateScrollView;
    IBOutlet UIButton *addMoreTemplateButton;//增加一页模板
    int addTemplatePageNumber;//增加的模板的页数
    int page_total;//模板页数
    CGFloat rotationAngle;//模板旋转的角度
}

-(IBAction)goBack;

-(void)displayEachTemplate:(NSString *)idName 
             backgroundPic:(UIImage *)image 
                      name:(NSString *)nameString 
                       tag:(NSString *)tagstring;//显示每一个button

-(IBAction)addMoreTemplate;//增加更多明信片模板

-(int)getRandomWithRange:(int)rangeValue;//生成随机数

@end
