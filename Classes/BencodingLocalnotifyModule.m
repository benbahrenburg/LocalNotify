/**
 * benCoding.localNotify Project
 * Copyright (c) 2009-2012 by Ben Bahrenburg. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BencodingLocalnotifyModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"

@implementation BencodingLocalnotifyModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"648e81b4-9d78-4857-8fc9-688af1d23358";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"bencoding.localnotify";
}

#pragma mark Lifecycle

-(void)startup
{
	[super startup];
    _debug = NO;
}

-(void)shutdown:(id)sender
{
	[super shutdown:sender];
}


#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	[super didReceiveMemoryWarning:notification];
}


#pragma Public APIs

-(NSNumber*)hasScheduledNotifications:(id)args
{
    BOOL hasScheduled = NO;
    //Get a list of all of the notifications I've got scheduled
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    if ([notifications count] > 0)
    {
        hasScheduled = YES;
    }
    //This can call this to let them know if this feature is supported
    return NUMBOOL(hasScheduled);
}

-(void)enableDebug:(id)unused
{
    _debug = YES;
}

-(void)disableDebug:(id)unused
{
    _debug = NO;
}

- (NSDictionary *)buildNotificationPayload:(UILocalNotification *)notification
{
    //We need to map the repeatInterval interval to something Titanium can read
    NSString *interval =@"none";
    if([notification repeatInterval]== kCFCalendarUnitYear)
    {
            interval = @"yearly";
        
    }
    if([notification repeatInterval]== kCFCalendarUnitMonth)
    {
        interval = @"monthly";
        
    } 
    if([notification repeatInterval]== kCFCalendarUnitWeek)
    {
        interval = @"weekly";
        
    }  
    if([notification repeatInterval]== kCFCalendarUnitDay)
    {
        interval = @"daily";
        
    }        
    //Make our life easier for debugging
//    NSLog(@"interval: %@", interval);    
//    NSLog(@"fireDate: %@", [notification fireDate]);
//    NSLog(@"repeatInterval: %@", [notification repeatInterval]);
//    NSLog(@"alertBody: %@", [notification alertBody]);
//    NSLog(@"alertAction: %@", [notification alertAction]);
//    NSLog(@"hasAction: %@",  NUMBOOL([notification hasAction]));
//    NSLog(@"alertLaunchImage: %@", [notification alertLaunchImage]);
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          [notification fireDate],@"fireDate",
                          interval,@"repeatInterval",
                           NUMBOOL([notification hasAction]),@"hasAction",
                          nil];
    
    if([notification alertBody]!=nil)
    {
        [data setObject:[notification alertBody] forKey:@"alertBody"];
    }
    if([notification alertAction]!=nil)
    {
        [data setObject:[notification alertAction] forKey:@"alertAction"];
    }   
    if([notification alertLaunchImage]!=nil)
    {
        [data setObject:[notification alertLaunchImage] forKey:@"alertLaunchImage"];
    }     
    if([notification soundName]!=nil)
    {
        [data setObject:[notification soundName] forKey:@"sound"];
    }         
    if([notification applicationIconBadgeNumber]!=0)
    {
        [data setObject:[NSNumber numberWithInt:[notification applicationIconBadgeNumber]] forKey:@"badge"];
    }
    if([notification userInfo]!=nil)
    {
        [data setObject:[notification userInfo] forKey:@"userInfo"];
    }    
    
    //NSLog(@"data: %@", data);
    return data;
}


-(NSDictionary*) listScheduledNotifications
{
    //Get a list of all of the notifications I've got scheduled
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    //Check if we have any notifications scheduled
    if (notifications==nil)
	{
        
        NSDictionary *noScheduled = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInt:0],@"scheduledCount",                                   
                                          nil];
        return noScheduled;
        
    }
    else
    {

        NSUInteger notificationCount = [notifications count];        
        NSMutableArray *notificationData = [[NSMutableArray alloc] init];
        
        for (int iLoop = 0; iLoop < notificationCount; iLoop++) {
            [notificationData addObject:[self buildNotificationPayload:[notifications objectAtIndex:iLoop]]];
        } 
        
        NSDictionary *scheduled = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:notificationCount],@"scheduledCount",
                                        notificationData,@"notifications",                                
                                        nil];
        return scheduled;
    }    
}

-(NSDictionary*) queryLocalNotificationsForKey:(id)findKey keyName:(NSString*)keyName
{
    //Get a list of all of the notifications I've got scheduled
	NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSInteger addCounter = 0; //Create our counter
    NSMutableArray *notificationData = [[NSMutableArray alloc] init];
    
    if (notifications!=nil)
	{
        // NSLog(@"We have scheduled notification");
        NSUInteger notificationCount = [notifications count];
        // NSLog(@"%d notification(s) scheduled", notificationCount);
        for (int iLoop = 0; iLoop < notificationCount; iLoop++) {
            UILocalNotification* currentNotification = [notifications objectAtIndex:iLoop];
            if(currentNotification.userInfo!=nil)
            {
                NSDictionary *userInfoCurrent = currentNotification.userInfo;
                id userKeyFromCurrentNotification = [userInfoCurrent valueForKey:keyName];
                if(userKeyFromCurrentNotification!=nil)
                {
                    //NSLog(@"Checking notification with id of  %d", [userIdofCurrentNotification intValue]);
                    //If we have an UI we need to see if it matches the one we provided
                    if ([userKeyFromCurrentNotification isEqual:findKey])
                    {
                        [notificationData addObject:[self buildNotificationPayload:currentNotification]];
                        addCounter++;
                    }
                }
            }
        }
    }
    
    NSDictionary *found = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInt:addCounter],@"scheduledCount",
                           notificationData,@"notifications",                                
                           nil];
    return found;    
}


-(NSDictionary*) findLocalNotificationsByKey:(id)args
{
    ENSURE_ARG_COUNT(args,2);
    //Get the ID value we are searching for
    id findThisId = [args objectAtIndex:0];
    //Find what key we are looking for
    NSString *findThisKey = [TiUtils stringValue:[args objectAtIndex:1]];
    //Find the results by key
    NSDictionary *results = [self queryLocalNotificationsForKey:findThisId keyName:findThisKey];
    return results;
}

-(void) searchLocalNotificationsByKey:(id)args
{
    ENSURE_ARG_COUNT(args,3);
    //Get the ID value we are searching for
    id findThisId = [args objectAtIndex:0];
    //Find what key we are looking for
    NSString *findThisKey = [TiUtils stringValue:[args objectAtIndex:1]];
    //Grab the callback function so that we can use it later
    KrollCallback *callback = [args objectAtIndex:2];
    //Double check that it is a callback
	ENSURE_TYPE(callback,KrollCallback);
    
    if (callback){                
        
        NSDictionary *eventNotify = [self queryLocalNotificationsForKey:findThisId keyName:findThisKey];
        
        [self _fireEventToListener:@"completed" 
                        withObject:eventNotify listener:callback thisObject:nil];
    } 
}


-(NSDictionary*) returnScheduledNotifications:(id)args
{
    NSDictionary *results = [self listScheduledNotifications];    
    return results;
}

-(void) activeScheduledNotifications:(id)args
{
    ENSURE_ARG_COUNT(args,1);
	KrollCallback *callback = [args objectAtIndex:0];
	ENSURE_TYPE(callback,KrollCallback);
     
    if (callback){                
        
        NSDictionary *eventNotify = [self listScheduledNotifications];
        
        [self _fireEventToListener:@"completed" 
                        withObject:eventNotify listener:callback thisObject:nil];
    } 
}

-(NSInteger) cancelLocalNotifForKey:(id)findKey keyName:(NSString*)keyName
{
	NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSInteger cancelCounter = 0; //Create our counter
    
    if (notifications!=nil)
	{
        // NSLog(@"We have scheduled notification");
        NSUInteger notificationCount = [notifications count];
        // NSLog(@"%d notification(s) scheduled", notificationCount);
        for (int iLoop = 0; iLoop < notificationCount; iLoop++) {
            UILocalNotification* currentNotification = [notifications objectAtIndex:iLoop];
            if([currentNotification userInfo]!=nil)
            {
                NSDictionary *userInfoCurrent = [currentNotification userInfo];
                id userKeyFromCurrentNotification = [userInfoCurrent valueForKey:keyName];
                if(userKeyFromCurrentNotification!=nil)
                {
                    //NSLog(@"Checking notification with id of  %d", [userIdofCurrentNotification intValue]);
                    //If we have an UI we need to see if it matches the one we provided
                    if ([userKeyFromCurrentNotification isEqual:findKey])
                    {
                        [[UIApplication sharedApplication] cancelLocalNotification:currentNotification];
                        cancelCounter++;
                    }
                }
            }
        }
    }
    if(_debug){
        NSLog(@"[DEBUG] %d Notifications have been canceled", cancelCounter);
    }
    return cancelCounter;
}
-(NSNumber*) cancelLocalNotificationByKey:(id)args
{
    //Make sure we're on the right thread and everything
    ENSURE_ARG_COUNT(args,2);
    //My user Id to find
    id findThisId = [args objectAtIndex:0];
    //Find what key we are looking for
    NSString *findThisKey = [TiUtils stringValue:[args objectAtIndex:1]];    
    NSInteger cancelCount = [self cancelLocalNotifForKey:findThisId keyName:findThisKey];

    if(_debug){
        NSLog(@"[DEBUG] %d Notifications have been canceled", cancelCount);
    }

    return NUMINT(cancelCount);
}

-(void)scheduleLocalNotification:(id)args
{
    NSLog(@"[INFO] Method depreciated please use the Ti.App.iOS.scheduleLocalNotification");
}

-(void)cancelAllLocalNotifications:(id)args
{
    NSLog(@"[INFO] Method depreciated please use the Ti.App.iOS.cancelAllLocalNotifications");
}

-(NSNumber*) cancelLocalNotification:(id)args
{
    NSLog(@"[INFO] Method depreciated please use the Ti.App.iOS.cancelAllLocalNotification");
    return NUMINT(0);
}

@end
