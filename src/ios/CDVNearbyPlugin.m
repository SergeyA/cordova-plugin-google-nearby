//
//  NearbyPlugin.m
//
//
//  Created by Bruno Rigo Werminghoff on 19/07/18.
//

#import "CDVNearbyPlugin.h"
#import "GNSMessages.h"

@interface CDVNearbyPlugin ()
    
    @property(strong) NSString* subscribeCallbackId;
    @property(strong) NSString* unsubscribeCallbackId;
    @property(strong) GNSMessageManager* messageManager;
    @property(strong) id<GNSSubscription> subscription;
    @property(strong) id<GNSPublication> publication;
    @end

@implementation CDVNearbyPlugin
    
- (void)pluginInitialize {
    [GNSMessageManager setDebugLoggingEnabled:YES];
    NSString* apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"NearbyApiKey"];
    self.messageManager = [[GNSMessageManager alloc] initWithAPIKey:apiKey];
}
    
- (void)publish:(CDVInvokedUrlCommand*)command {
    NSString* parameter = [command.arguments objectAtIndex:0];
    // NSString* parameter = command.arguments;
    
    NSData* publishedData = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    GNSMessage* message = [GNSMessage messageWithContent: publishedData];
    self.publication = [self.messageManager publicationWithMessage:message];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)unpublish:(CDVInvokedUrlCommand*)command {
    self.publication = nil;

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
    
- (void)subscribe:(CDVInvokedUrlCommand*)command {
    self.subscribeCallbackId = command.callbackId;
    
    self.subscription = [self.messageManager subscriptionWithMessageFoundHandler:^(GNSMessage *message) {
        NSString* messageString = [[NSString alloc] initWithData:message.content encoding:NSUTF8StringEncoding];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:messageString]; // success callback
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.subscribeCallbackId];
        
    } messageLostHandler:^(GNSMessage *message) {
         // Remove the name from the list (?)
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]; // error callback
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.subscribeCallbackId];
    }];

    // CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK]; // success callback
    // [pluginResult setKeepCallbackAsBool: true];
    // [self.commandDelegate sendPluginResult:pluginResult callbackId:self.subscribeCallbackId];
}
    
- (void)unsubscribe:(CDVInvokedUrlCommand*)command {
    self.subscription = nil;

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK]; // success callback
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
    
    @end
