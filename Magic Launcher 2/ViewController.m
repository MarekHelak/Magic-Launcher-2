//
//  ViewController.m
//  Magic Launcher 2
//
//  Created by Marek on 08.06.2015.
//  Copyright (c) 2015 Marek Helak. All rights reserved.
//

#import "ViewController.h"
#import "PaintView.h"

@implementation ViewController

- (void)viewDidLoad {
    
    //Get image frame from root view
    UIImageView* drawImage = [[UIImageView alloc] initWithImage:nil];
    PaintView *paint = [[PaintView alloc]
                        initWithFrame:CGRectMake(0,0,self.view.frame.size.width,(self.view.frame.size.height-100))
                        forImage:drawImage
                        toSaveGesture:NO];
    
    [self.view addSubview:paint];
    [super viewDidLoad];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
