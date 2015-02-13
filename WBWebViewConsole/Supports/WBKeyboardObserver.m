//
//  WBKeyboardObserver.m
//  Weibo
//
//  Created by Wutian on 14/6/27.
//  Copyright (c) 2014年 Sina. All rights reserved.
//

#import "WBKeyboardObserver.h"

NSString * const WBKeyboardObserverFrameDidUpdateNotification = @"WBKeyboardObserverFrameDidUpdateNotification";

@implementation WBKeyboardObserver

+ (void)load
{
    [super load];
    
    [WBKeyboardObserver sharedObserver];
}

+ (instancetype)sharedObserver
{
    static WBKeyboardObserver * observer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        observer = [[[self class] alloc] init];
    });
    return observer;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (id)init
{
    if (self = [super init])
    {
        self.frameBegin = CGRectNull;
        self.frameEnd = CGRectNull;
        self.animationDuration = 0.0;
        self.animationCurve = UIViewAnimationCurveEaseInOut;
        
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        
        [center addObserver:self selector:@selector(keyboardDidChangeNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [center addObserver:self selector:@selector(keyboardDidChangeNotification:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardDidChangeNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardDidChangeNotification:(NSNotification *)notification
{
    NSDictionary * userInfo = notification.userInfo;
    
    if (!userInfo) return;
    
    self.frameEnd = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.frameBegin = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    self.animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WBKeyboardObserverFrameDidUpdateNotification object:self];
}

@end