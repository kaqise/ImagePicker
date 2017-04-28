//
//  NSObject+BPImagePickerTools.h
//  Demo3
//
//  Created by 张保平 on 16/7/12.
//  Copyright © 2016年 baoping.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
/*
 *
 参数：1、相册中选取的照片
 参数：2、当前的pickerViewController
 参数：3、如果是录像的话，录像的url
 
 如果是摄像，请导入<MediaPlayer/MediaPlayer.h>库文件
 并使用MPMoviePlayerController进行播放
 */
typedef void(^ImagePicker_Block)(UIImage
                                 *selectImage,
                                 UIImagePickerController
                                 *currentPickerController,
                                 NSURL
                                 *url);

@interface NSObject (BPImagePickerTools)<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//@[@"相机",@"录制",@"相册",@"取消"]
//一键调用
-(void)bp_ShowImagePickerAlertWithActions:(NSArray*)actions completeHanlder:(ImagePicker_Block)image_Block;
@end
