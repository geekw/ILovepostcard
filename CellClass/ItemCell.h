//
//  ItemCell.h
//  ILovepostcard
//
//  Created by wang piepie on 12-6-3.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *btn;
@property (retain, nonatomic) IBOutlet UILabel *titleLbl;
@property (retain, nonatomic) IBOutlet UILabel *heartNumLbl;
@property (retain, nonatomic) NSString *whichListInt;

//+ (ItemCell *)getInstance;
- (void)configWithTitle:(NSString *)title 
               btnImage:(UIImage *)image 
               heartNum:(NSString *)heartNum            
               tagValue:(NSInteger)tagInt
               listInteger:(NSInteger)listInt;
@end
