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
#import "DFSendSelectVC.h"

#define TitleLabelTag    40001
#define ContentLabelTag  40002

@interface DFSendVC ()<DFHudProgressDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,photoCellDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,sendSelectDelegate>
{
    DFHudProgress *_hud;
    
    UICollectionView *_collectionView; //照片collectionview
    
    UITableView *_detailTableView;
    
    
    NSIndexPath *_indexPath;  //点击的collectionviewcell的indexpath
    
    
    NSMutableArray *_photoArr;  //照片数组
    
    NSMutableArray *_layoutArr;
    
    UIImage *_selectImg;
    
    NSMutableDictionary *_postDic;
    
    NSDictionary *_imagePara;
    
    NSMutableArray *_tableViewData;
    
    NSInteger _checkboxIndex; //多选时记录index
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
    
    _postDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    [_postDic setObject:@"" forKey:@"post_text"];
    
    _imagePara = [[NSDictionary alloc] initWithObjects:@[@"post_img_1",@"post_img_2",@"post_img_1",@"post_img_1"] forKeys:@[@"0",@"1",@"2",@"3"]];
    
    _tableViewData = [[NSMutableArray alloc] init];
    
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    [_postDic setObject:@"0" forKey:@"post_up"];
    
    [_postDic setObject:[DFToolClass getIPAddress] forKey:@"post_ip"];
    
    [_postDic setObject:[df objectForKey:@"fatherId"] forKey:@"cat_id"];
    
    [_postDic setObject:[df objectForKey:@"fatherTitle"] forKey:@"cat_title"];
    
    [_postDic setObject:[self.childDic objectForKey:@"cat_id"] forKey:@"subcat_id"];
    
    [_postDic setObject:[self.childDic objectForKey:@"cat_title"] forKey:@"subcat_title"];
    
    [_postDic setObject:[df objectForKey:@"uid"] forKey:@"member_uid"];
    
    [_postDic setObject:[df objectForKey:@"username"] forKey:@"member_title"];

    
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
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 104) collectionViewLayout:flowLayout];
    [_collectionView registerClass:[photoCell class] forCellWithReuseIdentifier:@"Cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [DFToolClass getColor:@"e5e5e5"];
    [self.view addSubview:_collectionView];
}

- (void)buildLayout
{
    UITextField *title = [[UITextField alloc] initWithFrame:CGRectMake(0, 94, KCurrentWidth, 25)];
    
    title.placeholder = @"  标题";
    
    title.font = [UIFont systemFontOfSize:15];
    
    title.borderStyle = UITextBorderStyleNone;
    
    title.delegate = self;
    
    title.backgroundColor = [UIColor whiteColor];
    
    title.tag = TitleLabelTag;
    
    [self.view addSubview:title];
    
    UITextField *content = [[UITextField alloc] initWithFrame:CGRectMake(0, 120, KCurrentWidth, 55)];
    
    content.placeholder = @"  内容";
    
    content.borderStyle = UITextBorderStyleNone;
    
    content.font = [UIFont systemFontOfSize:15];

    content.delegate = self;
    
    content.backgroundColor = [UIColor whiteColor];
    
    content.tag = ContentLabelTag;
    
    [self.view addSubview:content];
    
    for (int i = 0; i < _layoutArr.count; i ++) {
        [_tableViewData addObject:@""];
    }
    
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 190, KCurrentWidth, KCurrentHeight - 230) style:UITableViewStylePlain];
    
    _detailTableView.dataSource = self;
    
    _detailTableView.delegate = self;
    
    [self.view addSubview:_detailTableView];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    sendBtn.backgroundColor = [UIColor orangeColor];
    
    sendBtn.frame = CGRectMake(0, KCurrentHeight - 40, KCurrentWidth, 40);
    
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sendBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sendBtn];
}

#pragma mark - 发布信息
- (void)sendMessage
{
    
    if ([[_postDic objectForKey:@"post_text"] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"帖子内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else
    {
        [_hud show];
        
        NSString *url = @"http://www.df360.cc/df360/api/info_postinfo";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [manager POST:url parameters:_postDic success:^(AFHTTPRequestOperation *operation,id responseObject){
            NSLog(@"json:%@",responseObject);
            [_hud dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发布成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            
            [_hud dismiss];
            NSLog(@"operation:%@",operation);
            
            NSLog(@"error:%@",error);
        }];

    }
    
}

- (void)uploadImgWithImage:(UIImage *)image withFilename:(NSString *)filename withPaths:(NSString *)paths
{
    [_hud show];
    
    NSString *urlString = @"http://www.df360.cc/df360/api/imgvideo_upload";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSURL *filePath = [NSURL fileURLWithPath:paths];

    
    NSLog(@"%@",paths);
    
    
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"loadfile" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"response ======= %@",responseObject);
        
        NSString *key = [_imagePara objectForKey:[NSString stringWithFormat:@"%d",_indexPath.row]];
        
        NSString *value = [[responseObject objectForKey:@"data"] objectForKey:@"filepath"];
        
        NSString *imageName = [[value componentsSeparatedByString:@"http://www.df360.cc/df360/uploads/"] objectAtIndex:1];
        
        [_postDic setValue:imageName forKey:key];
        
        
        [_hud dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error =======  %@",error);
        [_hud dismiss];
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
//    static NSString *identify = @"sendCell";
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [self initCell:cell WithIndex:indexPath.row];
    
    return cell;
    
}

- (void)initCell:(UITableViewCell *)cell WithIndex:(NSInteger)index
{
    NSDictionary *layoutDic = [_layoutArr objectAtIndex:index];
    
    cell.textLabel.text = [layoutDic objectForKey:@"c_name"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if ([[layoutDic objectForKey:@"c_type"] isEqualToString:@"input"]) {
        UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(100, 7, KCurrentWidth - 140, 30)];
        
        textFiled.borderStyle = UITextBorderStyleRoundedRect;
        
        textFiled.font = [UIFont systemFontOfSize:15];
        
        textFiled.delegate = self;
        
        textFiled.tag = index;
        
        textFiled.textAlignment = NSTextAlignmentRight;
        
        textFiled.text = [_tableViewData objectAtIndex:index];
        
        [cell addSubview:textFiled];
        
        UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(KCurrentWidth - 40, 7, 40, 30)];
        
        unitLabel.backgroundColor = [UIColor clearColor];
        
        unitLabel.text = [[layoutDic objectForKey:@"c_unit"] isEqualToString:@"m<sup>2</sup>"]?@"m²":[layoutDic objectForKey:@"c_unit"];
        
        unitLabel.font = [UIFont systemFontOfSize:13];
        
        unitLabel.textAlignment = NSTextAlignmentCenter;
        
        [cell addSubview:unitLabel];
    }
    else
    {
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 7, KCurrentWidth - 140, 30)];
        
        valueLabel.backgroundColor = [UIColor clearColor];
        
        valueLabel.text = [_tableViewData objectAtIndex:index];
        
        valueLabel.font = [UIFont systemFontOfSize:14];
        
        valueLabel.textAlignment = NSTextAlignmentRight;
        
        [cell addSubview:valueLabel];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *layoutDic = [_layoutArr objectAtIndex:indexPath.row];
    
    if ([[layoutDic objectForKey:@"c_type"] isEqualToString:@"select"]) {
        [self selectWithDic:layoutDic withIndex:indexPath.row];
    }
    if ([[layoutDic objectForKey:@"c_type"] isEqualToString:@"checkbox"]) {
        
        _checkboxIndex = indexPath.row;
        
        DFSendSelectVC *sendSelect = [[DFSendSelectVC alloc] init];
        sendSelect.selectDic = layoutDic;
        sendSelect.sendDelegate = self;
        [self.navigationController pushViewController:sendSelect animated:YES];
    }
}

- (void)selectWithDic:(NSDictionary *)dic withIndex:(NSInteger)index
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[dic objectForKey:@"c_name"] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.tag = index;
    for (NSDictionary *cdic in [dic objectForKey:@"child_categories"]) {
        [actionSheet addButtonWithTitle:[cdic objectForKey:@"c_name"]];
    }
    [actionSheet showInView:self.view];
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
    else
    {
        NSDictionary *layoutDic = [_layoutArr objectAtIndex:actionSheet.tag];
        
        NSArray *cArr = [layoutDic objectForKey:@"child_categories"];
        
        NSString *key = [layoutDic objectForKey:@"c_id"];
        
        if (buttonIndex != 0) {
            NSString *value = [[cArr objectAtIndex:buttonIndex-1] objectForKey:@"c_id"];
            
            [_postDic setValue:value forKey:key];
            
            [_tableViewData replaceObjectAtIndex:actionSheet.tag withObject:[[cArr objectAtIndex:buttonIndex - 1] objectForKey:@"c_name"]];
            
            [_detailTableView reloadData];
            
            return;
        }
        
        
        
        
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
    
    
    
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    _selectImg = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    [self uploadImgWithImage:_selectImg withFilename:@"currentImage" withPaths:fullPath];
    
    [_photoArr addObject:_selectImg];
    [_collectionView reloadData];
    
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

#pragma mark - textFiledDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag != TitleLabelTag  && textField.tag != ContentLabelTag) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.view.frame;
            rect.origin.y -= 223;
            [self.view setFrame:rect];
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == TitleLabelTag) {
        [_postDic setObject:textField.text forKey:@"post_title"];
        return;
    }
    if (textField.tag == ContentLabelTag) {
        [_postDic setObject:textField.text forKey:@"post_text"];
        return;
    }
    else
    {
        [_tableViewData replaceObjectAtIndex:textField.tag withObject:textField.text];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.view.frame;
            rect.origin.y += 223;
            [self.view setFrame:rect];
        }];

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag < 100) {
        [_tableViewData replaceObjectAtIndex:textField.tag withObject:textField.text];
    }
    return YES;
}

- (void)addDicWithKey:(NSString *)key andValue:(NSString *)value andTitle:(NSString *)title
{
    [_tableViewData replaceObjectAtIndex:_checkboxIndex withObject:title];
    
    [_detailTableView reloadData];
    
    [_postDic setObject:value forKey:key];
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
