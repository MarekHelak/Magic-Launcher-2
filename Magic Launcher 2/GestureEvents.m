//
//  GestureEvents.m
//  Magic Launcher 2
//
//  Created by Marek on 12.06.2015.
//  Copyright (c) 2015 Marek Helak. All rights reserved.
//

#import "GestureEvents.h"

@implementation GestureEvents

+(void)showAlert:(int)similar{
    
    UIViewController *topController =
    [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    UIAlertController* alert =
    [UIAlertController
     alertControllerWithTitle:@"Yes! This is gesture!"
    message:[NSString stringWithFormat:@"Your gesture got %zd points!", similar]
    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton =
    [UIAlertAction actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                           }];
    
    [alert addAction:okButton];
    [topController presentViewController:alert animated:YES completion:nil];
    NSLog(@"Alert shown!");
}
+(void)runCamera{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    picker.showsCameraControls = NO;
    picker.navigationBarHidden = YES;
    picker.toolbarHidden = NO;

    UIViewController *topController =
    [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    [topController presentViewController:picker animated:NO completion:nil];
    
    NSLog(@"run Camera!");
}
+(void)goGoogle{
    UIApplication *mySafari = [UIApplication sharedApplication];
    NSURL *myURL = [[NSURL alloc]initWithString:@"http://www.Google.com"];
    [mySafari openURL:myURL];
     NSLog(@"go Google!");
}

@end
