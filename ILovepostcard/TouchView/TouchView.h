//
//  TouchView.h
//  ILovePostcards
//
//  Created by 进 吴 on 12-5-2.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define degreesToRadian(x) (M_PI * (x) / 180.0)//定义弧度

@protocol TouchVieweDelegate <NSObject>
@optional
- (void)TouchViewActionBegin:(NSNumber *)tag; //声明协议,检测图片获得焦点         
@end

@interface TouchView : UIView <UIGestureRecognizerDelegate, TouchVieweDelegate>
{
    CGFloat _lastScale;
	CGFloat _lastRotation;  
	CGFloat _firstX;
	CGFloat _firstY;
    CGRect imageFrame;
    int newTag;
    
    UIImageView *photoImageView;
    UIImage *photoImage;
    id<TouchVieweDelegate> delegate;
    
}

@property(nonatomic,assign) id<TouchVieweDelegate> delegate;

- (void)setImage:(UIImage*)image;
- (void)setViewTag:(int)tag;
- (void)setAngle:(float)angle;


@end
