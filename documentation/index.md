<h1>benCoding.localNotify Module</h1>

This module provides helper functions for creating Local Notifications within your Titanium iOS project. The localNotify is meant to replace the existing Titanium Schedule and Cancel methods.

<h2>Before you start</h2>
* You need Titanium 1.8.2 or greater. 

<h2>Download the release</h2>

This module is freely available on [github](https://github.com/benbahrenburg/LocalNotify/). Check the [dist folder](https://github.com/benbahrenburg/LocalNotify/tree/master/dist) for a compiled release.

<h2>Building from source?</h2>

If you are building from source you will need to do the following:
* Modify the titanium.xcconfig file with the path to your Titanium installation

<h2>Setup</h2>

* Download the latest release from the [dist folder](https://github.com/benbahrenburg/LocalNotify/tree/master/dist)  or you can build it yourself.
* Install the bencoding.dictionary module. If you need help here is a "How To" [guide](https://wiki.appcelerator.org/display/guides/Configuring+Apps+to+Use+Modules). 
* You can now use the module via the commonJS require method, example shown below.

<pre><code>

var notify = require('bencoding.localnotify');

</code></pre>

Now we have the module installed and avoid in our project we can start to use the components, see the feature guide below for details.

<h2>benCoding.localNotify How To Example</h2>

For detailed documentation please reference this project's documentation folder.
A code "How To" example is provided in the app.js located in the project's example folder.

<h2>Methods</h2>
<hr />

<h3>scheduleLocalNotification</h3>
This method takes all of the same parameters as the [Titanium official API](http://docs.appcelerator.com/titanium/2.0/index.html#!/api/Titanium.App.iOS-method-scheduleLocalNotification), but does not return a notification object. 

Because the notification object is not returned, you can schedule your notifications without requiring a background service.  For example you can use the below code sample under a button click event. 

The below sample shows you how to schedule a local notification to run in 30 seconds from now.
<pre><code>

	notify.scheduleLocalNotification({
		alertBody:"This is a test of benCoding.localNotify",
		alertAction:"Just a test",
		userInfo:{"id":1,"hello":"world"},
		date:new Date(new Date().getTime() + 30000) 
	});

</code></pre>

<h3>returnLocationNotificationList</h3>
You can use this method to query your scheduled local notifications.  Simply call this method and provide a callback method similar to what is shown below.  The callback will be returned a collection with all of the available information about your scheduled local notifications.

The below sample shows how to create a callback that queries your scheduled local notifications. You can then loop through the results in your callback function.
<pre><code>

	//This is our callback for our scheduled local notification query
	function localNotificationCallback(e){
		Ti.API.info("Did it work? " + e.success);
		if(e.success){
			Ti.API.info("Let's how many local notifications we have scheduled'");
			Ti.API.info("Scheduled LocalNotification = " + e.scheduledCount);	
		}	

		var test = JSON.stringify(e);
		Ti.API.info("results stringified" + test);
	};

	//Call this method and return a callback with the results
	notify.returnLocationNotificationList(localNotificationCallback);

</code></pre>

<h3>cancelLocalNotification</h3>
This method allows you to cancel a specific scheduled local notification using the userInfo dictionary.  To do this we use the convention of providing an id within the userInfo dictionary upon notification creation.

In the above scheduleLocalNotification example you see we use userInfo:{"id":1,"hello":"world"} when creating the notification.  We can now use returnLocationNotificationList to cancel this scheduled notification by providing it the id of 1 as shown below.

The below sample shows how to cancel a local notification with the userInfo id property set to 1.  After canceling we query the saved notifications to confirm the cancel was successful.

<pre><code>

	//We are going to remove all of the LocalNotifications scheduled with a userInfo id value of 1
	notify.cancelLocalNotification(1);
	
	//Now query the scheduled notifications to make sure our local notification was canceled
	notify.returnLocationNotificationList(localNotificationCallback);

</code></pre>

<h3>cancelAllLocalNotifications</h3>
This method cancels all scheduled local notifications. 

Please note this method works the same as the native Titanium method discussed [here](http://docs.appcelerator.com/titanium/2.0/index.html#!/api/Titanium.App.iOS-method-scheduleLocalNotification).

The below sample shows how to cancel all scheduled local notifications.
<pre><code>

	//Cancel all scheduled local notifications
	notify.cancelAllLocalNotifications();

</code></pre>

<h2>Licensing & Support</h2>

This project is licensed under the OSI approved Apache Public License (version 2). For details please see the license associated with each project.

Developed by [Ben Bahrenburg](http://bahrenburgs.com) available on twitter [@benCoding](http://twitter.com/benCoding)

<h2>Learn More</h2>
<hr />
<h3>Twitter</h3>

Please consider following the [@benCoding Twitter](http://www.twitter.com/benCoding) for updates 
and more about Titanium.

<h3>Blog</h3>

For module updates, Titanium tutorials and more please check out my blog at [benCoding.Com](http://benCoding.com). 
