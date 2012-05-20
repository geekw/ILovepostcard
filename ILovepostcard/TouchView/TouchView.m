//
//  TouchView.m
//  ILovePostcards
//
//  Created by 进 吴 on 12-5-2.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.autoresizesSubviews = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        delegate = nil;
        imageFrame = frame;
        
        // 使图片视图支持交互和多点触摸
        [photoImageView setUserInteractionEnabled:YES];
        
        [photoImageView setMultipleTouchEnabled:YES];
                
        UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)] autorelease];
        [pinchRecognizer setDelegate:self];
        [self addGestureRecognizer:pinchRecognizer];
        
        UIRotationGestureRecognizer *rotationRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)] autorelease];
        [rotationRecognizer setDelegate:self];
        [self addGestureRecognizer:rotationRecognizer];
        
        UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] autorelease];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelegate:self];
        [self addGestureRecognizer:panRecognizer];
    }
    return self;
}




#pragma mark - Private Methods
- (void)scale:(id)sender
{
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) 
    {
        _lastScale = 1.0;
        
        NSLog(@"%d",newTag);
        [delegate performSelector:@selector(TouchViewActionBegin:) withObject:[NSNumber numberWithInteger:newTag]];
    }
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = photoImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [photoImageView setTransform:newTransform];    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    
}

- (void)rotate:(id)sender 
{
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        
        _lastRotation = 0.0;
        
        NSLog(@"%d",newTag);
        [delegate performSelector:@selector(TouchViewActionBegin:) withObject:[NSNumber numberWithInteger:newTag]];
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = photoImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [photoImageView setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}


- (void)move:(id)sender 
{
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self];
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan)
    {
        _firstX = [photoImageView center].x;
        _firstY = [photoImageView center].y;
        
        NSLog(@"%d",newTag);
        [delegate performSelector:@selector(TouchViewActionBegin:) withObject:[NSNumber numberWithInteger:newTag]];
    }
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    [photoImageView setCenter:translatedPoint];
}


- (void)setImage:(UIImage*)image
{
    photoImageView = [[UIImageView alloc] init];
    photoImage = [[UIImage alloc] initWithCGImage:image.CGImage];
    [photoImageView setImage:photoImage];
    [photoImageView setFrame:CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)];
    [self addSubview:photoImageView]; 
    
}

- (void)setAngle:(float)angle
{
    self.transform = CGAffineTransformMakeRotation(degreesToRadian(angle));
}

- (void)setViewTag:(int)tag;
{
    newTag = tag;
    //[self setTag:tag];
}

- (void)dealloc
{
    photoImage     = nil;[photoImage release];
    photoImageView = nil;[photoImageView release];
    
    [super dealloc];
}

@end
