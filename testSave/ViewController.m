//
//  ViewController.m
//  testSave
//
//  Created by oyq on 2017/12/19.
//  Copyright © 2017年 XHJ. All rights reserved.
//

#import "ViewController.h"
#import "FESandbox.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()


@property(nonatomic, strong) NSURL *videUrl;
@property(nonatomic, strong) NSString *videoPath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(120, 220, 120, 40);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor greenColor];
    [saveBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveVideo:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:saveBtn];
    
    
    _videoPath=[[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    
    _videUrl =  [NSURL URLWithString:_videoPath];
    

}

- (NSURL *)compressedURL
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-DD--HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    return [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",dateTime]]];
}

- (void)saveVideo:(id)sender
{
    NSString *tmpPath = [[FESandbox tmpPath]stringByAppendingString:@"/video"];
    [FESandbox createDirectoryAtPath:tmpPath];
    NSLog(@"tmpPath = %@",tmpPath);

    NSString* dstPath=[tmpPath stringByAppendingPathComponent:@"test.mp4"];
    if ([FESandbox fileExistsAtPath:dstPath]){
        NSLog(@"已经存在");
    }else {
        NSError *error = nil;
        NSFileManager * fileManager = [NSFileManager defaultManager];
        BOOL flag =  [fileManager copyItemAtPath:_videoPath toPath:dstPath error:&error];
        
        if (flag) {
            NSLog(@"copy成功");
        }
    }
   
    if (dstPath) {
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(dstPath)) {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum(dstPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

//保存视频完成之后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
        NSLog(@"保存视频成功");
        NSLog(@"videoPath = %@",videoPath);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
