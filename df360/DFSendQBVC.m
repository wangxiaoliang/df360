//
//  DFSendQBVC.m
//  df360
//
//  Created by wangxl on 14-9-18.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFSendQBVC.h"
#import <QuartzCore/QuartzCore.h>

#define titlePlaceTag 10001
#define contentPlaceTag 10002
#define titleTextViewTag 20001
#define contentTextViewTag 20002

@interface DFSendQBVC ()<UITextViewDelegate>
{
    NSString *_title;
    
    NSString *_content;
}
@end

@implementation DFSendQBVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    _title = [[NSString alloc] init];
    
    _content = [[NSString alloc] init];
    
    self.WTitle = @"发布";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;

    [self buildUI];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildUI
{
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, KCurrentWidth - 40, 40)];
    
    titleView.backgroundColor = [UIColor whiteColor];
    
    titleView.layer.masksToBounds = YES;
    titleView.layer.cornerRadius = 6.0;
    titleView.layer.borderWidth = 1.0;
    titleView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self.view addSubview:titleView];
    
    UILabel *titlePlace = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KCurrentWidth - 40, 40)];
    
    titlePlace.text = @"标题（不超过80个字符）";
    
    titlePlace.textAlignment = NSTextAlignmentCenter;
    
    titlePlace.font = [UIFont systemFontOfSize:14];
    
    titlePlace.alpha = 0.5f;
    
    titlePlace.tag = titlePlaceTag;
    
    [self.view addSubview:titlePlace];
    
    
    UITextView *titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, KCurrentWidth - 40, 40)];
    
    titleTextView.backgroundColor = [UIColor clearColor];
    
    titleTextView.tag = titleTextViewTag;
    
    titleTextView.delegate = self;
    
    [self.view addSubview:titleTextView];
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 80, KCurrentWidth - 40, 100)];
    
    contentView.backgroundColor = [UIColor whiteColor];

    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 6.0;
    contentView.layer.borderWidth = 1.0;
    contentView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self.view addSubview:contentView];
    
    UILabel *contentPlace = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, KCurrentWidth - 40, 20)];
    
    contentPlace.text = @"内容（不超过300字）";
    
    contentPlace.tag = contentPlaceTag;
    
    contentPlace.alpha = 0.5f;
    
    contentPlace.textAlignment = NSTextAlignmentCenter;
    
    contentPlace.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:contentPlace];
    
    
    UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, KCurrentWidth - 40, 100)];
    
    contentTextView.backgroundColor = [UIColor clearColor];
    
    contentTextView.delegate = self;
    
    contentTextView.tag = contentTextViewTag;
    
    [self.view addSubview:contentTextView];
    
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, KCurrentWidth - 40, 40)];
    
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    
    sendBtn.backgroundColor = [UIColor redColor];
    
    [sendBtn addTarget:self action:@selector(sendQB) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sendBtn];
    

    

}


#pragma mark - 发布
- (void)sendQB
{
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == contentTextViewTag) {
        UILabel *label = (UILabel*)[self.view viewWithTag:contentPlaceTag];
        
        label.hidden = YES;
    }
    else
    {
        UILabel *label = (UILabel*)[self.view viewWithTag:titlePlaceTag];
        
        label.hidden = YES;

    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == contentTextViewTag) {
        
        UILabel *label = (UILabel*)[self.view viewWithTag:contentPlaceTag];

        if ([textView.text isEqual:@""]) {
            label.hidden = NO;

        }
    }
    else
    {
        UILabel *label = (UILabel*)[self.view viewWithTag:titlePlaceTag];
        
        if ([textView.text isEqual:@""]) {
            label.hidden = NO;
        }
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
