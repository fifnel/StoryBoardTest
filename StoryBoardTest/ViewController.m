//
//  ViewController.m
//  StoryBoardTest
//
//  Created by fifnel on 2011/12/14.
//  Copyright (c) 2011年 fifnel. All rights reserved.
//

#import "ViewController.h"
#import <quartzcore/quartzcore.h>

@implementation ViewController
@synthesize _scrollView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _lastEditTextField = nil;
}

- (void)viewDidUnload
{
    [self set_scrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onUIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onUIKeyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onUIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onUIKeyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - StoryBoard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"everything"]) {
        [self EverythingCapture];
    }
    if ([[segue identifier] isEqualToString:@"normal"]) {
        [self NormalCapture];
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField canResignFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)tf {
    NSLog(@"%s", __func__);
    _lastEditTextField = tf;
}

#pragma mark - Capture Methods

- (void)NormalCapture {
    //画面をキャプチャー  
    NSLog(@"画面キャプチャー開始");  
    CGRect rect = [[UIScreen mainScreen] bounds];  
    UIGraphicsBeginImageContext(rect.size); //コンテクスト開始  
    UIApplication *app = [UIApplication sharedApplication];  
    
    //#import <quartzcore/quartzcore.h>をしておかないとrenderInContextで警告が出る  
    [app.keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];  
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext(); //画像を取得してからコンテクスト終了  
    
    //画像を「写真」に保存  
    //JPEGで保存され、クオリーティーはコントロールできないようだ。  
    //ImageMagickのidentifyによるとQuality=93らしい。  
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil); //完了通知が必要ない場合  
    //UIImageWriteToSavedPhotosAlbum(img, self, @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:), nil);    
}  

- (void)EverythingCapture {
    //画面キャプチャー開始  
    NSLog(@"画面キャプチャー開始");  
    
    //スクリーンに写っているものすべてを画像化  
    //ドキュメントにはないAPIコール（ひょっとするとREJECTの可能性もあるが、許されているという話も）  
    CGImageRef imgRef = UIGetScreenImage();  
    
    //CGImageRefをUIImageに変換  
    UIImage *img = [UIImage imageWithCGImage:imgRef];  
    
    //キャプチャーしたCGImageRefはUIImageに変換して必要なくなったので解放  
    CGImageRelease(imgRef);  
    
    //画像を「写真」に保存  
    //JPEGで保存され、クオリーティーはコントロールできないようだ。  
    //ImageMagickのidentifyによるとQuality=93らしい。  
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil); //完了通知が必要ない場合  
    //UIImageWriteToSavedPhotosAlbum(img, self, @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:), nil);  
}

#pragma mark - Keyboard Show/Hide Notification

- (void)onUIKeyboardWillShowNotification:(NSNotification *)notification
{
//    NSLog(@"%s", __func__);
//    NSLog(@"  * userInfo = %@", notification.userInfo);
    
    // キーボードの高さを取得
    CGRect bounds;
    if (&UIKeyboardFrameEndUserInfoKey != nil) {
        // iOS 3.0~3.1
        bounds = [[notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
    } else {
        bounds = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    }

    // キーボードの高さと編集対象のテキストフィールドから後ろのScrollViewをスクロールさせる
    if (_lastEditTextField == nil) {
        return;
    }
    NSInteger marginFromKeyboard = 10,keyboardHeight = bounds.size.height;
	CGRect tmpRect = _lastEditTextField.frame;
	if((tmpRect.origin.y + tmpRect.size.height + marginFromKeyboard + keyboardHeight) > _scrollView.frame.size.height){
		NSInteger yOffset;
		yOffset = keyboardHeight + marginFromKeyboard + tmpRect.origin.y + tmpRect.size.height - _scrollView.frame.size.height;
		[_scrollView setContentOffset:CGPointMake(0,yOffset) animated:YES];
	}
    
    _lastEditTextField = nil;
}

- (void)onUIKeyboardDidShowNotification:(NSNotification *)notification
{
//    NSLog(@"%s", __func__);
//    NSLog(@"  * userInfo = %@", notification.userInfo);
}

- (void)onUIKeyboardWillHideNotification:(NSNotification *)notification
{
//    NSLog(@"%s", __func__);
//    NSLog(@"  * userInfo = %@", notification.userInfo);
    
    [_scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void)onUIKeyboardDidHideNotification:(NSNotification *)notification
{
//    NSLog(@"%s", __func__);
//    NSLog(@"  * userInfo = %@", notification.userInfo);
}

@end
