//
//  LGFUploadImage.m
//  LGFOCTool
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "LGFUploadImage.h"

@interface LGFUploadImage () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (copy, nonatomic) lgf_ReturnImage lgf_ReturnImage;
@property (strong, nonatomic) UIViewController *lgf_ViewController;
@end

@implementation LGFUploadImage

lgf_AllocOnlyOnceForM(LGFUploadImage, LGFUploadImage);

- (void)lgf_GetSystemPhotoWithVC:(id)SelfVC title:(NSString *)title returnImage:(lgf_ReturnImage)returnImage {
    
    self.lgf_ViewController = SelfVC;
    self.lgf_ReturnImage = returnImage;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"相册", nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.lgf_ViewController.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    @lgf_Weak(self);
    // 相机
    if ( buttonIndex == 0 ) {
        [LGFAllPermissions lgf_GetCameraPermission:^(BOOL isHave) {
            if (isHave) {
                @lgf_Strong(self);
                [self GoToCamera:self.lgf_ViewController];
            }
        }];
    }
    // 手机相册
    if ( buttonIndex == 1 ) {
        [LGFAllPermissions lgf_GetPhotoAutoPermission:^(BOOL isHave) {
            if (isHave) {
                @lgf_Strong(self);
                [self GoToPhotos:self.lgf_ViewController];
            } else {
                [LGFAllPermissions lgf_GoSystemSettingPermission:@"App-prefs:root=Photos"];
            }
        }];
    }
}

/**
 去相册取图片
 */
- (void)GoToPhotos:(id)SelfViewController {
    
    UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
    
    imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePC.delegate = self;
    
    imagePC.allowsEditing = YES;
    
    [SelfViewController presentViewController:imagePC animated:YES completion:nil];
    
    
}

/**
 去相机拍摄图片
 */
- (void)GoToCamera:(id)SelfViewController {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
        
        imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagePC.delegate = self;
        
        imagePC.allowsEditing = YES;
        
        [SelfViewController presentViewController:imagePC animated:YES completion:nil];
        
    }else {
        
        //        [MBProgressHUD showSuccess:@"该设备没有照相机" afterDelay:1.0 toView:LGFLastView];
        
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    /**
     *  获取到图片
     */
    lgf_HaveBlock(self.lgf_ReturnImage, image);
}

@end
