
#import "NSObject+BPImagePickerTools.h"

#import <MobileCoreServices/MobileCoreServices.h>

static ImagePicker_Block conversion_Block;

@implementation NSObject (BPImagePickerTools)

-(void)bp_ShowImagePickerAlertWithActions:(NSArray *)actions completeHanlder:(ImagePicker_Block)image_Block{
    __weak typeof(self) weakSelf = self;
    //相机
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [actions enumerateObjectsUsingBlock:^(NSString *action, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIAlertAction *cameraAction;
        UIAlertAction *videoAction;
        UIAlertAction *photoLibraryAction;
        UIAlertAction *cancelAction;
        
        if ([action isEqualToString:@"相机"]) {
            cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
                pickerController.delegate = self;
                pickerController.allowsEditing = YES;
                
                ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ?:         [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                
                [(UIViewController*)weakSelf presentViewController:pickerController animated:YES completion:nil];
                
            }];
            [alertController addAction:cameraAction];
        }else if ([action isEqualToString:@"录制"]){
            //录制
            videoAction = [UIAlertAction actionWithTitle:@"录制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
                pickerController.delegate = self;
                pickerController.allowsEditing = YES;
                pickerController.mediaTypes = @[((NSString*)kUTTypeMovie)];
                
                ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ?:         [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                [(UIViewController*)weakSelf presentViewController:pickerController animated:YES completion:nil];
                
            }];
            [alertController addAction:videoAction];
        }else if ([action isEqualToString:@"相册"]){
            //相册
            photoLibraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
                pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pickerController.allowsEditing = YES;
                pickerController.delegate = self;
                [(UIViewController*)weakSelf presentViewController:pickerController animated:YES completion:nil];
            }];
            [alertController addAction:photoLibraryAction];
        }else if ([action isEqualToString:@"取消"]){
            //取消
            cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
        }
    }];
    [(UIViewController*)weakSelf presentViewController:alertController animated:YES completion:nil];
    conversion_Block = image_Block;
    
    
    
    
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = info[UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString*)kUTTypeImage]) {//当选取的是image的时候
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        conversion_Block(image,picker,nil);
    }else if ([type isEqualToString:(NSString*)kUTTypeMovie]){//当选取的是视频的时候
        NSURL *url = info[UIImagePickerControllerMediaURL];
        
        /**可以选择调用保存Movie*/
//        [self saveMovieToiPhoneWithUrl:url];
        conversion_Block(nil , picker, url);
    }
}
//如果想保存Movie调用
-(void)saveMovieToiPhoneWithUrl:(NSURL*)url{
    NSString *urlPath = url.path;
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlPath)) {
        //保存视频到相簿
        UISaveVideoAtPathToSavedPhotosAlbum(urlPath, self,
                                            @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }

}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    NSLog(@"保存视频完成");
}
@end

