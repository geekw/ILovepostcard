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

@interface GoToPostcardList : UIViewController<ASIHTTPRequestDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UISearchBarDelegate,UIScrollViewDelegate>
{
    DisplayEachTemplateDetals *displayEachTemplateDetals;
    
    IBOutlet UIButton *backButton;
    IBOutlet UIScrollView *templateScrollView;
    IBOutlet UIScrollView *templateScrollView_Keyword;
    IBOutlet UIButton *addMoreTemplateButton;//增加一页模板
    IBOutlet UIButton *addMoreTemplateButton_Keyword;//带关键字增加模板

    //BOOL addMoreTemplateFlag;//为YES,所有页数加载完毕
    
    BOOL addMoreTemplateFlag_Keyword;//为YES,所有页数加载完毕
    NSString *templateNameString;//模板名称
    int addTemplatePageNumber;//增加的模板的页数
    int addTemplatePageNumber_Keyword;
    int page_total;//模板页数
    CGFloat rotationAngle;//模板旋转的角度
}

@property (nonatomic, retain) NSString *keyword;//搜索关键字
@property (retain, nonatomic) IBOutlet UIView *bottomKeywordView;
@property (retain, nonatomic) IBOutlet UISearchBar *mySearchBar;//关键字搜索栏
@property (retain, nonatomic) IBOutlet UIScrollView *bottomKeywordScrollView;


-(IBAction)goBack;

-(void)displayEachTemplate:(NSString *)idName 
             backgroundPic:(UIImage *)image 
                      name:(NSString *)nameString 
                       tag:(NSString *)tagstring;//显示每一个button

-(NSString *)urlEncodedString:(NSString *)string;//中文字符转换成url可用字符串

-(IBAction)addMoreTemplate;//增加更多明信片模板

-(IBAction)addMoreTemplate_Keyword;//增加更多明信片模板(带关键字)

-(int)getRandomWithRange:(int)rangeValue;//生成随机数

@end
