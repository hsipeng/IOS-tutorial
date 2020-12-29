//
//  main.m
//  Objectc-Hello-world-NoStoryBoard
//
//  Created by 彭熙 on 2020/12/29.
//  Copyright © 2020 彭熙@lirawx.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
