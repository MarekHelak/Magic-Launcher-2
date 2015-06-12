//
//  DrawViewController.m
//  Magic Launcher 2
//
//  Created by Marek on 08.06.2015.
//  Copyright (c) 2015 Marek Helak. All rights reserved.
//

#import "DrawViewController.h"
#import "PaintView.h"

@implementation DrawViewController

- (void)viewDidLoad {
    
    //Get image frame from root view
    UIImageView* drawImage = [[UIImageView alloc] initWithImage:nil];
    PaintView *paint = [[PaintView alloc]
                        initWithFrame:CGRectMake(0,0,self.view.frame.size.width,(self.view.frame.size.height-100))
                        forImage:drawImage
                        toSaveGesture:YES];
    [self.view addSubview:paint];
    [super viewDidLoad];
    
}

- (IBAction)clearMemory:(id)sender {
        NSDictionary* dict = [[NSUserDefaults standardUserDefaults]dictionaryRepresentation];
        for (id key in dict) {
           [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }


@end
