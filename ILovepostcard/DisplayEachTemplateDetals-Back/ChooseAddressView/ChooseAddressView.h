//
//  ChooseAddressView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-31.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DataItem.h"
#import "SeachList.h"
#import "PassValueDelegate.h"
#import "ActionSheetStringPicker.h"
#define PROVINCE_LIST 0
#define CITY_LIST 1
#define COUNTY_LIST 2
#define POSTCODE_LIST 3

@interface ChooseAddressView : UIViewController <PassValueDelegate,UITextViewDelegate>
{
    NSInteger provincePickerIndex;
    NSInteger cityPickerIndex;
    NSInteger countyPickerIndex;
    NSInteger postcodePickerIndex;

    NSMutableArray *provinceArray;
    NSMutableArray *cityArray;
    NSMutableArray *countyArray;
    NSMutableArray *postcodeArray;
    
    NSMutableArray *dataArray;
    
//    SeachList *provinceList;
//    SeachList *cityList;
//    SeachList *countyList;
//    SeachList *postcodeList;
    
    UITextView *currentTxtView;
    int moveheight;

    
    ActionSheetStringPicker *provincePicker;
    ActionSheetStringPicker *cityPicker;
    ActionSheetStringPicker *countPicker;


}
@property (retain, nonatomic) IBOutlet UITextView *postcodeTxtView;
@property (retain, nonatomic) IBOutlet UITextView *adressTextView;
@property (retain, nonatomic) IBOutlet UITextView *nameTextView;

@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;
@property (retain, nonatomic) IBOutlet UIButton *confirmBtn;

@property (retain, nonatomic) IBOutlet UIButton *provinceBtn;
@property (retain, nonatomic) IBOutlet UIButton *cityBtn;
@property (retain, nonatomic) IBOutlet UIButton *countyBtn;


- (void)initData;

- (IBAction)clickedProvince:(id)sender;
- (IBAction)clickedCity:(id)sender;
- (IBAction)clickedCounty:(id)sender;
- (IBAction)backgroundTap:(id)sender;



@end
