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

@interface ChooseAddressView : UIViewController <PassValueDelegate,UITextViewDelegate,UIScrollViewDelegate,UIKeyInput>
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

    NSString *provinceSelectedStr;
    NSString *citySelectedStr;
    NSString *countySelectedStr;
    NSString *postcodeSelectedStr;

    ActionSheetStringPicker *provincePicker;
    ActionSheetStringPicker *cityPicker;
    ActionSheetStringPicker *countPicker;
}
@property (retain, nonatomic) IBOutlet UITextView *postcodeTxtView;
@property (retain, nonatomic) IBOutlet UITextView *adressTextView;
@property (retain, nonatomic) IBOutlet UITextView *nameTextView;
@property (retain, nonatomic) IBOutlet UITextView *detailTxView;

@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;
@property (retain, nonatomic) IBOutlet UIButton *confirmBtn;

@property (retain, nonatomic) IBOutlet UIButton *provinceBtn;
@property (retain, nonatomic) IBOutlet UIButton *cityBtn;
@property (retain, nonatomic) IBOutlet UIButton *countyBtn;


@property (retain, nonatomic) NSString *addressStr;

@property (retain, nonatomic) IBOutlet UITextView *streetAddress;

@property (retain, nonatomic) IBOutlet UIScrollView *addressScrollView;

@property (retain, nonatomic) IBOutlet UITextView *senderNameTextView;

@property (retain, nonatomic) IBOutlet UIButton *provinceBtn_Sender;

@property (retain, nonatomic) IBOutlet UIButton *cityBtn_Sender;

@property (retain, nonatomic) IBOutlet UIButton *countryBtn_Sender;

@property (retain, nonatomic) IBOutlet UITextView *postcodeTextView_Sender;

@property (retain, nonatomic) IBOutlet UITextView *detailTextView_Sender;

@property (retain, nonatomic) IBOutlet UITextView *streetAddress_Sender;


- (void)initData;

-(IBAction)goBack:(id)sender;

- (IBAction)clickedProvince:(id)sender;
- (IBAction)clickedCity:(id)sender;
- (IBAction)clickedCounty:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)finishAdressInfo;

- (IBAction)clickedProvince_Sender:(id)sender;
- (IBAction)clickedCity_Sender:(id)sender;
- (IBAction)clickedCounty_Sender:(id)sender;

@end
