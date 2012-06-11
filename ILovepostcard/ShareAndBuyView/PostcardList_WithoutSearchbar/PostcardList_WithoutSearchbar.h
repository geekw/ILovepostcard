//
//  PostcardList_WithoutSearchbar.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-6.
//  Copyright (c) 2012年 开趣. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "PromptView.h"//提示成功失败
#import "ASIFormDataRequest.h"
#import "DisplayEachTemplateDetals.h"
#import "ILPostcardList.h"
#import "EGOImageButton.h"

@interface PostcardList_WithoutSearchbar : UIViewController<ASIHTTPRequestDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UISearchBarDelegate,UIScrollViewDelegate,EGOImageButtonDelegate>
{
    int page_total;//模板页数
    int addTemplatePageNumber;//增加的模板的页数
}

@property (nonatomic, retain) DisplayEachTemplateDetals *displayEachTemplateDetals;

@property (retain, nonatomic) IBOutlet UIButton *goBackBtn;

@property (retain, nonatomic) IBOutlet UIScrollView *listScrollView;

@property (retain, nonatomic) IBOutlet UISearchBar *mySearchBar_Activity;

@property (retain, nonatomic) NSString *keyword_Activity;

- (IBAction)goBack;

-(NSString *)urlEncodedString:(NSString *)string;//中文字符转换成url可用字符串


@end
