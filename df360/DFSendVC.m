//
//  DFSendVC.m
//  df360
//
//  Created by wangxl on 14-9-21.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFSendVC.h"
#import "DFToolClass.h"
#import "DFRequestUrl.h"
#import "DFToolView.h"
#import "AFNetworking.h"
#import "photoCell.h"
#import "AFNetworking.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface DFSendVC ()<DFHudProgressDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,photoCellDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    DFHudProgress *_hud;
    
    UICollectionView *_collectionView; //照片collectionview
    
    UITableView *_detailTableView;
    
    
    NSIndexPath *_indexPath;  //点击的collectionviewcell的indexpath
    
    
    NSMutableArray *_photoArr;  //照片数组
    
    NSMutableArray *_layoutArr;
    
    UIImage *_selectImg;
    
}
@end

@implementation DFSendVC

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
    
    self.WTitle = @"发布";
    
    _hud = [[DFHudProgress alloc] init];
    
    _photoArr = [[NSMutableArray alloc] init];
    
    _layoutArr = [[NSMutableArray alloc] init];
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    
    [self getLayout];
    
    self.view.backgroundColor = [DFToolClass getColor:@"e5e5e5"];

    [self buildUI];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getLayout
{
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getLayoutWithId:[self.childDic objectForKey:@"cat_id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        _layoutArr = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
        
        [self buildLayout];
        
        [_hud dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [_hud dismiss];
    }];

}

- (void)buildUI
{
    /********************** 照片CollectionView *************************/
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 90) collectionViewLayout:flowLayout];
    [_collectionView registerClass:[photoCell class] forCellWithReuseIdentifier:@"Cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [DFToolClass getColor:@"e5e5e5"];
    [self.view addSubview:_collectionView];
}

- (void)buildLayout
{
    UITextField *title = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, KCurrentWidth, 25)];
    
    title.placeholder = @"标题";
    
    title.font = [UIFont systemFontOfSize:15];
    
    title.borderStyle = UITextBorderStyleNone;
    
    title.delegate = self;
    
    [self.view addSubview:title];
    
    UITextField *content = [[UITextField alloc] initWithFrame:CGRectMake(0, 130, KCurrentWidth, 55)];
    
    content.placeholder = @"内容";
    
    content.borderStyle = UITextBorderStyleNone;
    
    content.font = [UIFont systemFontOfSize:15];

    content.delegate = self;
    
    [self.view addSubview:content];
    
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 190, KCurrentWidth, KCurrentHeight - 220) style:UITableViewStylePlain];
    
    _detailTableView.dataSource = self;
    
    _detailTableView.delegate = self;
    
    [self.view addSubview:_detailTableView];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    sendBtn.backgroundColor = [UIColor orangeColor];
    
    sendBtn.frame = CGRectMake(0, KCurrentHeight - 30, KCurrentWidth, 30);
    
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sendBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sendBtn];
}

- (void)sendMessage
{
}

- (void)uploadImgWithImage:(UIImage *)image withFilename:(NSString *)filename
{
    
    NSString *name = [[filename componentsSeparatedByString:@"."] objectAtIndex:0];
    
    NSString *urlString = @"http://www.df360.cc/df360/api/imgvideo_upload";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);

    
//    NSDate *date = [NSDate date];
//    NSDateFormatter *dm = [[NSDateFormatter alloc] init];
//    [dm setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSString *imageName = [dm stringFromDate:date];
//    NSMutableData *requestData = [NSMutableData data];
//    NSString *boundary = @"BOUNDARY";
//
//    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n",imageName]dataUsingEncoding:NSUTF8StringEncoding]];
//    [requestData appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [requestData appendData:imgData];
//    [requestData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *parameters = @{@"loadfile":name};
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
        [formData appendPartWithFormData:imgData name:name];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[responseObject objectForKey:@"error"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - collectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (_photoArr.count < 4) {
        return _photoArr.count + 1;

    }
    else
    {
        return _photoArr.count;
    }
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    photoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.delegate = self;
    
    if (indexPath.row == _photoArr.count) {
        [cell initAddPhotoCell];
    }
    else
    {
        [cell initPhotoCell:YES whithPhotos:_photoArr withIndexPath:indexPath.row withTag:1];
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {10,0,0,0};
    return top;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {0,0};
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80,80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _photoArr.count ) {
        _indexPath = indexPath;
        [self choosePhoto];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _layoutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"sendCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    [self initCell:cell WithIndex:indexPath.row];
    
    return cell;
    
}

- (void)initCell:(UITableViewCell *)cell WithIndex:(NSInteger)index
{
    NSDictionary *layoutDic = [_layoutArr objectAtIndex:index];
    
    cell.textLabel.text = [layoutDic objectForKey:@"c_name"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if ([[layoutDic objectForKey:@"c_type"] isEqualToString:@"input"]) {
        UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(100, 7, KCurrentWidth - 130, 30)];
        textFiled.placeholder = [layoutDic objectForKey:@"c_name"];
        
        textFiled.borderStyle = UITextBorderStyleRoundedRect;
        
        textFiled.font = [UIFont systemFontOfSize:15];
        
        textFiled.delegate = self;
        
        [cell addSubview:textFiled];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
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
    
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    _selectImg = [info objectForKey:UIImagePickerControllerEditedImage];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        NSString *fileName = [representation filename];
        NSLog(@"fileName : %@",fileName);
        [self uploadImgWithImage:_selectImg withFilename:fileName];
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
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
    //    [self saveImage:image withName:@"currentImage.png"];
    //
    //    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    //
    //    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    //    isFullScreen = NO;
    [_photoArr addObject:_selectImg];
    [_collectionView reloadData];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
