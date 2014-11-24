//
//  DFSelectFatherCateVC.m
//  df360
//
//  Created by wangxl on 14-9-22.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFSelectFatherCateVC.h"
#import "DFToolClass.h"
#import "DFSelectChildCateVC.h"

@interface DFSelectFatherCateVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DFSelectFatherCateVC

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
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    
    self.WTitle = @"大分类";
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    
    self.view.backgroundColor = [DFToolClass getColor:@"e5e5e5"];

    [self buildUI];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight - 64) style:UITableViewStylePlain];
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
//    [self.view addSubview:tableView];
    
    float btnWidth = (self.view.bounds.size.width - 100)/4;

    
    NSArray *imageArr = [[NSArray alloc] initWithObjects:@"ic_house", @"ic_mark", @"ic_jobs", @"ic_resume", @"ic-friends", @"ic_study", @"ic_pet", @"ic_clean", @"ic-photo", @"ic_travel", @"ic_hotel", @"ic_play", @"ic_shoping", @"ic_tag", nil];
    
    NSInteger PageItemCount = imageArr.count;
    //需要显示两行
    if (PageItemCount >= 5) {
        for (int i = 0; i<4; i++) {
            //当前行有几个item
            NSInteger cellItemCount = (PageItemCount-i*4)>=4?4:(PageItemCount-i*4);
            for (int y = 0; y < cellItemCount; y ++) {
                NSInteger tag = y + i*4;
                
                NSString *title = [[self.allCates objectAtIndex:tag] objectForKey:@"cat_title"];
                
                UIButton *fatherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                fatherBtn.backgroundColor = [UIColor clearColor];
                [fatherBtn setFrame:CGRectMake(20 + (btnWidth + 20)*y ,20 + (40 + btnWidth)*i, btnWidth, btnWidth)];
                [fatherBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                fatherBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                fatherBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [fatherBtn addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
                fatherBtn.tag = tag;
                [fatherBtn setImage:[UIImage imageNamed:[imageArr objectAtIndex:tag]] forState:UIControlStateNormal];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + (btnWidth + 20)*y ,20 + (40 + btnWidth)*i + 60, btnWidth, 20)];
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.text = title;
                titleLabel.font = [UIFont systemFontOfSize:13];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                
                [self.view addSubview:fatherBtn];
                
                [self.view addSubview:titleLabel];
            }
        }
        
    }

}

- (void)categorySelected:(UIButton *)btn
{
    NSInteger tag = [btn tag];
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    [df setObject:[[self.allCates objectAtIndex:tag] objectForKey:@"cat_id"] forKey:@"fatherId"];
    [df setObject:[[self.allCates objectAtIndex:tag] objectForKey:@"cat_title"] forKey:@"fatherTitle"];
    
    [self performSegueWithIdentifier:@"selectChildCate" sender:[[self.allCates objectAtIndex:tag] objectForKey:@"child"]];
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allCates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"fatherCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [[self.allCates objectAtIndex:indexPath.row] objectForKey:@"cat_title"];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    [df setObject:[[self.allCates objectAtIndex:indexPath.row] objectForKey:@"cat_id"] forKey:@"fatherId"];
    [df setObject:[[self.allCates objectAtIndex:indexPath.row] objectForKey:@"cat_title"] forKey:@"fatherTitle"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"selectChildCate" sender:[[self.allCates objectAtIndex:indexPath.row] objectForKey:@"child"]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DFSelectChildCateVC *selectChildVC = (DFSelectChildCateVC *)segue.destinationViewController;
    selectChildVC.childCates = sender;
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
