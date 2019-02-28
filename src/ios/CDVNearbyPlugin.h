//
//  CDVNearbyPlugin.h
//  nearby2
//
//  Created by Fábio Akira Yoshida on 19/07/18.
//  Copyright © 2018 Fábio Akira Yoshida. All rights reserved.
//

#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>

@interface CDVNearbyPlugin : CDVPlugin

- (void)subscribe:(CDVInvokedUrlCommand*)command;
- (void)unsubscribe:(CDVInvokedUrlCommand*)command;
- (void)publish:(CDVInvokedUrlCommand*)command;
    
@end
