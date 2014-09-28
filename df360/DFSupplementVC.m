//
//  DFSupplementVC.m
//  df360
//
//  Created by wangxl on 14-9-28.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFSupplementVC.h"
#import "DFToolClass.h"
#import "QRadioButton.h"

#define payTextFieldTag     3001
#define needTextFieldTag    3002

@interface DFSupplementVC ()<UITableViewDataSource,UITableViewDelegate,QRadioButtonDelegate,UITextFieldDelegate>
{
    NSArray *_titleArr;
    UIView *_payView;
}
@end

@implementation DFSupplementVC

- (void)viewDidLoad {
    
    self.WTitle = @"积分充值";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    
    _titleArr = [[NSArray alloc] initWithObjects:@"人民币现金 1元=1人民币",@"单次最低充值 1 人民币",@"单次最高充值 10000 人民币",@"最近30天最高充值10000人民币", nil];

    [self bulidUI];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bulidUI
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, KCurrentWidth - 40 , 33.5)];
    
    titleLabel.text = @"充值规则";
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 43.5, KCurrentWidth - 40, .5)];
    
    lineView.backgroundColor = [DFToolClass getColor:@"b2b2b2"];

    [self.view addSubview:lineView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 44, KCurrentWidth - 40, 176) style:UITableViewStylePlain];
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.allowsSelection = NO;
    
    tableView.scrollEnabled = NO;
    
    [self.view addSubview:tableView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 240, KCurrentWidth - 40 , 33.5)];
    
    titleLabel.text = @"支付方式及充值";
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:titleLabel];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 273.5, KCurrentWidth - 40, .5)];
    
    lineView.backgroundColor = [DFToolClass getColor:@"b2b2b2"];
    
    [self.view addSubview:lineView];

    _payView = [[UIView alloc] initWithFrame:CGRectMake(20, 274, KCurrentWidth - 40, 176)];
    
    _payView.backgroundColor = [UIColor whiteColor];
    
    QRadioButton *_rqBtn = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    
    _rqBtn.frame = CGRectMake(20, 10, 200, 40);
    
    [_rqBtn setTitle:@"支付宝" forState:UIControlStateNormal];
    
    [_rqBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _rqBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [_rqBtn setChecked:YES];
    
    [_payView addSubview:_rqBtn];
    
    [self.view addSubview:_payView];
    
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 40, 40)];
    
    payLabel.text = @"充值";
    
    payLabel.textAlignment = NSTextAlignmentLeft;
    
    payLabel.font = [UIFont systemFontOfSize:13];
    
    [_payView addSubview:payLabel];
    
    UITextField *payTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 55, 100, 30)];
    
    payTextField.placeholder = @"0人民币";
    
    payTextField.delegate = self;
    
    payTextField.tag = payTextFieldTag;
    
    payTextField.returnKeyType = UIReturnKeyDone;
    
    payTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    payTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    payTextField.font = [UIFont systemFontOfSize:13];
    
    [_payView addSubview:payTextField];
    
    UITextField *needTextField = [[UITextField alloc] initWithFrame:CGRectMake(170, 50, 100, 40)];
    
    needTextField.text = @"所需人民币0元";
    
    needTextField.textAlignment = NSTextAlignmentCenter;
    
    needTextField.tag = needTextFieldTag;
    
    needTextField.enabled = NO;
    
    needTextField.font = [UIFont systemFontOfSize:13];
    
    [_payView addSubview:needTextField];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [payBtn setTitle:@"充值" forState:UIControlStateNormal];
    
    payBtn.backgroundColor = [UIColor redColor];
    
    payBtn.frame = CGRectMake(20, 120, _payView.frame.size.width - 40, 40);
    
    [payBtn addTarget:self action:@selector(paySelected) forControlEvents:UIControlEventTouchUpInside];
    
    [_payView addSubview:payBtn];
    
    
}

- (void)paySelected
{
    
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"supplementCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [_titleArr objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

#pragma mark - textfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, -100, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITextField *_needTextField = (UITextField *)[_payView viewWithTag:needTextFieldTag];
    
    _needTextField.text = [NSString stringWithFormat:@"所需人民币%@元",textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    self.view.frame = CGRectMake(0, 64, KCurrentWidth, KCurrentHeight);
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
