//
//  SecondViewController.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-9.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoToPostcardList.h"


@interface SecondViewController : UIViewController<UINavigationControllerDelegate>
{
    IBOutlet UIButton *postcardButton;//进入明信片模板界面的按钮
    GoToPostcardList *goToPostcardList;
}

-(IBAction)goToPostcardScene;//进入明信片模板界面

@end