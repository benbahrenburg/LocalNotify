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
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}


#pragma Public APIs

-(void)scheduleLocalNotification:(id)args
{
    
	ENSURE_SINGLE_ARG(args,NSDictionary);
    
	UILocalNotification *localNotif = [[UILocalNotification alloc] init];
	
	id date = [args objectForKey:@"date"];
	
	if (date!=nil)
	{
		localNotif.fireDate = date;
		localNotif.timeZone = [NSTimeZone defaultTimeZone];
	}
	
	id repeat = [args objectForKey:@"repeat"];
	if (repeat!=nil)
	{
		if ([repeat isEqual:@"weekly"])
		{
			localNotif.repeatInterval = NSWeekCalendarUnit;
		}
		else if ([repeat isEqual:@"daily"])
		{
			localNotif.repeatInterval = NSDayCalendarUnit;
		}
		else if ([repeat isEqual:@"yearly"])
		{
			localNotif.repeatInterval = NSYearCalendarUnit;
		}
		else if ([repeat isEqual:@"monthly"])
		{
			localNotif.repeatInterval = NSMonthCalendarUnit;
		}
	}
	
	id alertBody = [args objectForKey:@"alertBody"];
	if (alertBody!=nil)
	{
		localNotif.alertBody = alertBody;
	}
	id alertAction = [args objectForKey:@"alertAction"];
	if (alertAction!=nil)
	{
		localNotif.alertAction = alertAction;
	}
	id alertLaunchImage = [args objectForKey:@"alertLaunchImage"];
	if (alertLaunchImage!=nil)
	{
		localNotif.alertLaunchImage = alertLaunchImage;
	}
	
	id badge = [args objectForKey:@"badge"];
	if (badge!=nil)
	{
		localNotif.applicationIconBadgeNumber = [TiUtils intValue:badge];
	}
	
	id sound = [args objectForKey:@"sound"];
	if (sound!=nil)
	{
		if ([sound isEqual:@"default"])
		{
			localNotif.soundName = UILocalNotificationDefaultSoundName;
		}
		else
		{
			localNotif.soundName = sound;
		}
	}
	
	id userInfo = [args objectForKey:@"userInfo"];
	if (userInfo!=nil)
	{
		localNotif.userInfo = userInfo;
	}
	
	TiThreadPerformOnMainThread(^{
		if (date!=nil) {
			[[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
		}
		else {
			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
		}
	}, NO);
	
	[localNotif release];
}

-(void)cancelAllLocalNotifications:(id)args
{
	ENSURE_UI_THREAD(cancelAllLocalNotifications,args);
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
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
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          [notification fireDate],@"fireDate",
                          interval,@"repeatInterval",
                          [notification alertBody],@"alertBody",
                          [notification alertAction],@"alertAction",
                           NUMBOOL([notification hasAction]),@"hasAction",
                          [notification alertLaunchImage ],@"alertLaunchImage ",
                          notification.userInfo, @"userInfo",
                          nil];
    return data;
}
-(void) returnLocationNotificationList:(id)args
{
    ENSURE_ARG_COUNT(args,1);
	KrollCallback *callback = [args objectAtIndex:0];
	ENSURE_TYPE(callback,KrollCallback);
    ENSURE_UI_THREAD(returnLocationNotificationList,args);
     
    //Get a list of all of the notifications I've got scheduled
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];

    //Check if we have any notifications scheduled
    if (notifications==nil)
	{
        //NSLog(@"No scheduled notifications");
        if (callback){                
            NSDictionary *eventNoScheduled = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:0],@"scheduledCount",
                                     NUMBOOL(YES),@"success",                                     
                                     nil];
            
            [self _fireEventToListener:@"completed" 
                            withObject:eventNoScheduled listener:callback thisObject:nil];
        } 
        
    }
    else
    {
        //NSLog(@"We have scheduled notification");
        NSUInteger notificationCount = [notifications count];        
        NSMutableArray *notificationData = [[[NSMutableArray alloc] init] autorelease];

        for (int iLoop = 0; iLoop < notificationCount; iLoop++) {
            [notificationData addObject:[self buildNotificationPayload:[notifications objectAtIndex:iLoop]]];
        } 
       
        if (callback){                
            NSDictionary *eventScheduled = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithInt:notificationCount],@"scheduledCount",
                                               notificationData,@"notifications",
                                              NUMBOOL(YES),@"success",                                     
                                              nil];
            
            [self _fireEventToListener:@"completed" 
                            withObject:eventScheduled listener:callback thisObject:nil];
        }         
    }
    
}

-(void)cancelLocalNotification:(id)args
{
    //Make sure we're on the right thread and everything
    ENSURE_ARG_COUNT(args,1);
    //My user Id to find
    NSInteger findThisId = [TiUtils intValue:[args objectAtIndex:0] def:-1000];
    ENSURE_UI_THREAD(cancelLocalNotification,args);
    //NSLog(@"We are looking for the Id of %d", findThisId);
    
    //Get a list of all of the notifications I've got scheduled
	NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    int cancelCounter = 0; //Create our counter
    
	//See if we have any notifications to query over
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
                 id userIdofCurrentNotification = [userInfoCurrent valueForKey:@"id"];
                 if(userIdofCurrentNotification!=nil)
                 {
                     //NSLog(@"Checking notification with id of  %d", [userIdofCurrentNotification intValue]);
                     //If we have an UI we need to see if it matches the one we provided
                     if ([userIdofCurrentNotification intValue]==findThisId)
                     {
                          //NSLog(@"Cancelling notification: %d", [userIdofCurrentNotification intValue]);
                         [[UIApplication sharedApplication] cancelLocalNotification:currentNotification];
                         cancelCounter++;
                     }
                 }
             }
        }
    }
    
    NSLog(@"%d Notifications have been canceled", cancelCounter);
}

@end
