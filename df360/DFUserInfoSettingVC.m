//
//  DFUserInfoSettingVC.m
//  df360
//
//  Created by wangxl on 14-9-28.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFUserInfoSettingVC.h"
#import "DFCustomTableViewCell.h"
#import "DFToolView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"



@interface DFUserInfoSettingVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DFHudProgressDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    NSArray *_titleArr;
    NSString *_nameStr;
    NSString *_telStr;
    NSString *_QQStr;
    NSString *_emailStr;
    NSString *_addressStr;
    NSString *_uid;
    
    UIButton *_imageBtn;
    
    UIImage *_selectImg;

    UIImageView *_photoImg;
    
    DFHudProgress *_hud;
}
@end

@implementation DFUserInfoSettingVC

- (void)viewDidLoad {
    self.WTitle = @"资料设置";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;

    _selectImg = [[UIImage alloc] init];

    
    [self initParaData];
    
    _titleArr = [[NSArray alloc] initWithObjects:@"姓名         *",@"联系电话  *",@"联系QQ",@"联系邮箱",@"联系地址", nil];
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    _nameStr = [df objectForKey:@"username"];
    _emailStr = [df objectForKey:@"email"];
    _uid = [df objectForKey:@"uid"];
    
    _hud = [[DFHudProgress alloc] init];
    
    _hud.delegate = self;
    
    [self buildUI];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)initParaData
{
    _nameStr = @"";
    _telStr = @"";
    _QQStr = @"";
    _emailStr = @"";
    _addressStr = @"";
    _uid = @"";
}
- (void)buildUI
{
    _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_imageBtn setFrame:CGRectMake(KCurrentWidth/2 - 40, 20, 80, 80)];
    
    _imageBtn.backgroundColor = [UIColor clearColor];
    
    _photoImg = [[UIImageView alloc] initWithFrame:CGRectMake(KCurrentWidth/2 - 40, 20, 80, 80)];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(KCurrentWidth/2 - 40, 110, 80, 15)];
    
    label.text = @"点击上传头像";
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:label];
    
    NSUserDefaults *df =[NSUserDefaults standardUserDefaults];
    
    NSString *imgUrl = [df objectForKey:@"photo"];
    
    if (imgUrl.length > 1) {
        
        [_photoImg setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"publish_add_image_normal"]];
    }
    
    else
    {
        [_photoImg setImage:[UIImage imageNamed:@"publish_add_image_normal"]];
    }
    
    [_imageBtn addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_photoImg];
    
    [self.view addSubview:_imageBtn];

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, KCurrentWidth, 220) style:UITableViewStylePlain];
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    tableView.allowsSelection = NO;
    
    tableView.scrollEnabled = NO;
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(60, 380, KCurrentWidth - 120, 30);
    
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    btn.backgroundColor = [UIColor redColor];
    
    [btn addTarget:self action:@selector(modifyUserInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}

- (void)modifyUserInfo
{
    if ([_nameStr isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"姓名不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
    }
    if ([_telStr isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"联系电话不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];

    }
    else
    {
        [_hud show];
        
        NSString *url = @"http://www.df360.cc/df360/api/info_member";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        
        NSDictionary *para = @{@"member_uid":_uid,@"member_title":_nameStr,@"member_phone":_telStr,@"member_qq":_QQStr,@"member_address":_addressStr};
        
        
        
        NSLog(@"%@",para);
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation,id responseObject){
            NSLog(@"json:%@",responseObject);
            
            [_hud dismiss];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alert show];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            
            [_hud dismiss];
            
            NSLog(@"operation:%@",operation);
            
            NSLog(@"error:%@",error);
        }];
    }

}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ModifyInfoCell";
    
    DFCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[DFCustomTableViewCell alloc] init];
        [cell initModifyUserInfoCellWithTitleArray:_titleArr Index:indexPath.row];
    }
    
    UITextField *textField = (UITextField *)[cell viewWithTag:indexPath.row + 1000];
    textField.delegate = self;
    if (indexPath.row == 0) {
        textField.text = _nameStr;
    }
    if (indexPath.row == 3) {
        textField.text = _emailStr;
    }
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%d",textField.tag);
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 1000)
    {
        _nameStr = textField.text;
    }
    if (textField.tag == 1001) {
        _telStr = textField.text;
    }
    if (textField.tag == 1002) {
        _QQStr = textField.text;
    }
    
    if (textField.tag == 1003) {
        _emailStr = textField.text;
    }
    
    if (textField.tag == 1004) {
        _addressStr = textField.text;
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - 选择照片
- (void)choosePhoto
{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    
    //    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    //
    //    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //
    //    NSString* documentsDirectory = [paths objectAtIndex:0];
    //
    //    _selectImg = [info objectForKey:UIImagePickerControllerMediaURL];
    //
    //    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    //    {
    //        ALAssetRepresentation *representation = [myasset defaultRepresentation];
    //        NSString *fileName = [representation filename];
    //        NSLog(@"fileName : %@",fileName);
    //        [self uploadImgWithImage:_selectImg withFilename:fileName withPaths:documentsDirectory];
    //    };
    //    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    //    [assetslibrary assetForURL:imageURL
    //                   resultBlock:resultblock
    //                  failureBlock:nil];
    
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [_photoImg setImage:image];
    
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    _selectImg = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    
    
    [self uploadImgWithImage:_selectImg withFilename:@"currentImage" withPaths:fullPath];
    
}

- (void)uploadImgWithImage:(UIImage *)image withFilename:(NSString *)filename withPaths:(NSString *)paths
{
    [_hud show];
    
    NSString *urlString = @"http://www.df360.cc/df360/api/imgvideo_upload";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSURL *filePath = [NSURL fileURLWithPath:paths];
    
    
    NSLog(@"%@",paths);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"loadfile" error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"response ======= %@",responseObject);
        
        NSString *value = [[responseObject objectForKey:@"data"] objectForKey:@"filepath"];
        
        [defaults setObject:value forKey:@"photo"];
        
        [self setPhotoWithImageUrl:value];
        
        [_hud dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error =======  %@",error);
        [_hud dismiss];
    }];
    
}


- (void)setPhotoWithImageUrl:(NSString *)imageUrl
{
    NSString *url = @"http://www.df360.cc/df360/api/mine_avatars";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *parametar = @{@"u_id":[defaults objectForKey:@"uid"],@"avatars_img":imageUrl};

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:parametar success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"TopJSON: %@", responseObject);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
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
