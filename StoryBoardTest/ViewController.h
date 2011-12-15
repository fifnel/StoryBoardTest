//
//  ViewController.h
//  StoryBoardTest
//
//  Created by fifnel on 2011/12/14.
//  Copyright (c) 2011年 fifnel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *_lastEditTextField;
}

- (void)EverythingCapture;
- (void)NormalCapture;

- (void)onUIKeyboardWillShowNotification:(NSNotification *)notification;
- (void)onUIKeyboardDidShowNotification:(NSNotification *)notification;
- (void)onUIKeyboardWillHideNotification:(NSNotification *)notification;
- (void)onUIKeyboardDidHideNotification:(NSNotification *)notification;


@property (weak, nonatomic) IBOutlet UIScrollView *_scrollView;

@end

CGImageRef UIGetScreenImage(void);