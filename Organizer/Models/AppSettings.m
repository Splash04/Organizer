//
//  AppSettings.m
//  Organizer
//
//  Created by Splash on 4/14/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if(self = [super init]) {
        [self loadSettings];
    }
    return self;
}

- (void)loadSettings {
    [self resetSettings];
}

- (void)resetSettings {
    
}

@end
