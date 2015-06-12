//
//  PaintView.m
//  Magic Launcher 2
//
//  Created by Marek on 09.06.2015.
//  Copyright (c) 2015 Marek Helak. All rights reserved.
//
//

#import "PaintView.h"
#import "GestureEvents.h"
#import <QuartzCore/QuartzCore.h>

@interface PaintView(){
    
    //Ivars
    float _screenWidth;
    float _screenHeight;
    BOOL _isNewGesture;
    CGPoint _lastPoint;
    CGPoint _curPoint;
    CGPoint _location;
    CGRect _imageFrame;
    NSDate *_lastClick;
   
    UIImageView *_drawImage;
    NSUInteger _bytesPerPixel;
    NSUInteger _bytesPerRow;
    BOOL _lock;
    unsigned char *_rawData;
}

@end
@implementation PaintView

-(id)initWithFrame:(CGRect)frame forImage:(UIImageView*)image toSaveGesture:(BOOL)isNew{
    
    if (self == [super initWithFrame:frame])
    {
        _isNewGesture = isNew;
        _drawImage = image;
        _imageFrame = frame;
        _screenWidth = frame.size.width;
        _screenHeight = frame.size.height;
        _lock = 0;
    }
 
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    
    _location = [touch locationInView:touch.view];
    _lastClick = [NSDate date];
    
    _lastPoint = [touch locationInView:self];
    _lastPoint.y -= 0;
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    _curPoint = [[touches anyObject] locationInView:self];
    
    //Creates bitmap
    UIGraphicsBeginImageContext(CGSizeMake(_screenWidth, _screenHeight));
    [_drawImage.image drawInRect:CGRectMake(0, 0, _screenWidth, _screenHeight)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 75.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x, _lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), _curPoint.x, _curPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    [_drawImage setFrame:CGRectMake(0,0, _screenWidth, _screenHeight)];
    
    //This make screenshots of actual
    _drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _lastPoint = _curPoint;
    
    [self addSubview:_drawImage];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (_isNewGesture){
    UIAlertController* alert =
    [UIAlertController alertControllerWithTitle:@"New Gesture"
                                        message:@"Choose action for this draw:"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* message =
    [UIAlertAction actionWithTitle:@"Show Message"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               [self saveGestureforAction:1];
                                _drawImage.image = nil;
                               ;}];
    UIAlertAction* camera =
    [UIAlertAction actionWithTitle:@"Run Camera"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                [self saveGestureforAction:2];
                                _drawImage.image = nil;
                                ;}];
    UIAlertAction* google =
    [UIAlertAction actionWithTitle:@"Go Google"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                [self saveGestureforAction:3];
                                _drawImage.image = nil;
                                ;}];
    UIAlertAction* cancel =
    [UIAlertAction actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               NSLog(@"Cancel");
                               _drawImage.image = nil;
                           }];
    
    [alert addAction:message];
    [alert addAction:camera];
    [alert addAction:google];
        
    [alert addAction:cancel];

    //Get reference from top used ViewController
    [[self getSuperController] presentViewController:alert animated:YES completion:nil];
    } else {
    [self findGesture];
    _drawImage.image = nil;
    }
}

- (void)drawRect:(CGRect)rect {
    [_drawImage setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    [_drawImage setFrame:_imageFrame];
    [self addSubview:_drawImage];
}

-(UIViewController*)getSuperController{
   UIViewController *topController =
    [UIApplication sharedApplication].keyWindow.rootViewController;
   while (topController.presentedViewController) {
       topController = topController.presentedViewController;
        }
   return topController;
}

-(void)saveGestureforAction:(NSInteger)action{
    
    if(_isNewGesture){
        NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"index"];
            index++;
            [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"index"];
        
        NSString *key = [NSString stringWithFormat:@"Gesture%zdAction:%zd", index,action];
        NSLog(@"save: %@", key);
        
        [[NSUserDefaults standardUserDefaults]
        setObject: [self getBinaryFromImage]
        forKey:key];
        
    } else {
        NSLog(@"compare!");
        [self findGesture];
    }
}

-(void)findGesture{
    
    //Get gesture from bank
    NSArray *memory = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    NSMutableArray *gestureBank = [[NSMutableArray alloc] init];
    for(NSString* key in memory){
        if ([key containsString:@"Gesture"]) {
               NSLog(@"Key: %@",key);
            [gestureBank addObject:key];
        }
    }
    
    //Get actual gesture
    NSArray* array1 = [self getBinaryFromImage];
    for (NSString* storedGesture in gestureBank){
        
    //Compare
    int similar = 0;
    NSArray* array2 = [[NSUserDefaults standardUserDefaults] objectForKey:storedGesture];
        for (int i = 0; i < array1.count; i++) {
            NSNumber *bool1 = [array1 objectAtIndex:i];
            NSNumber *bool2 = [array2 objectAtIndex:i];
            if ([bool1 isEqual:bool2]) similar++;
        }
        NSLog(@"It's similar in %d", similar);
        
        if (similar > 555){
            
            //Take action from last
            NSInteger actionNR = [[storedGesture substringFromIndex:[storedGesture length] - 1] intValue];
            switch (actionNR){
                case 1: [GestureEvents showAlert:similar]; break;
                case 2: [GestureEvents runCamera]; break;
                case 3: [GestureEvents goGoogle]; break;
            }
        }
    }
}

-(NSArray*)getBinaryFromImage{
    NSMutableArray *mut = [[NSMutableArray alloc] init];
    for (int x = 0; x < _screenWidth; x+=18) {
        for (int y = 0; y < _screenHeight; y+=18){
            if ([self isBlack:_drawImage.image atX:x andY:y])
                [mut addObject:[NSNumber numberWithBool:YES]];
            else
                [mut addObject:[NSNumber numberWithBool:NO]];
        }
    }
    _lock = 0;
    return mut;
}

-(BOOL)isBlack:(UIImage*)image atX:(int)x andY:(int)y
{
    if (_lock == 0) {
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
    _rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    _bytesPerPixel = 4;
    _bytesPerRow = _bytesPerPixel * width;
        
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(_rawData,
                              width,
                              height,
                              bitsPerComponent,
                              _bytesPerRow,
                              colorSpace,
                              kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    }

    NSUInteger byteIndex = (_bytesPerRow * y) + x * _bytesPerPixel;
        float alpha = (_rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += _bytesPerPixel;
    
    _lock = 1;
    if(alpha == 1) return YES;
    else return NO;
}


@end
