//
//  NewestCardViewCellView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-18.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "NewestCardViewCellView.h"
#import "ImageProcess.h"

@interface NewestCardViewCellView ()

@end


@implementation NewestCardViewCellView
@synthesize btn1;
@synthesize label1;
@synthesize btn2;
@synthesize label2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (NewestCardViewCellView *)getInstance
{
    return [[[NSBundle mainBundle] loadNibNamed:@"NewestCardViewCellView" owner:nil options:nil] objectAtIndex:0];
}

-(void)configCellWithImgUrl:(NSString *)urlStr 
                    address:(NSString *)address
                   tagValue:(NSString *)tag
{
    static BOOL finishOne = NO;

    if (!finishOne)
    {
        UIImage *tmpImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
        
        [self.btn1 setImage:tmpImg forState:UIControlStateNormal];
        
        self.btn1.tag = [tag intValue];
        self.label1.text = [NSString stringWithFormat:@"%@",address];
        finishOne = YES;
    }
    else
    {
        UIImage *tmpImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
        [self.btn2 setImage:tmpImg forState:UIControlStateNormal];

        self.btn2.tag = [tag intValue];
        self.label2.text = [NSString stringWithFormat:@"%@",address];
        finishOne = NO;  
        
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [btn1 release];
    [label1 release];
    [btn2 release];
    [label2 release];
    [super dealloc];
}
@end
