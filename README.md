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

<h3>activeScheduledNotifications</h3>
You can use this method to query your scheduled local notifications.  Simply call this method and provide a callback method similar to what is shown below.  The callback will be returned a collection with all of the available information about your scheduled local notifications.

The below sample shows how to create a callback that queries your scheduled local notifications. You can then loop through the results in your callback function.
<pre><code>

	//This is our callback for our scheduled local notification query
	function localNotificationCallback(e){
		Ti.API.info("Let's how many local notifications we have scheduled'");
		Ti.API.info("Scheduled LocalNotification = " + e.scheduledCount);	
		alert("You have " +  e.scheduledCount + " Scheduled LocalNotification");

		var test = JSON.stringify(e);
		Ti.API.info("results stringified" + test);
	};

	//Call this method and return a callback with the results
	notify.activeScheduledNotifications(localNotificationCallback);

</code></pre>

<h3>returnScheduledNotifications</h3>
This method allows you to query your scheduled notification similar to activeScheduledNotifications but without the callback.

Simply call the returnScheduledNotifications method and you will be returned a collection with all of the available information about your scheduled local notifications.

The below sample shows how to get a resultset by using this method.
<pre><code>

	//Call this method to return a collection with information on your scheduled notifications
	var results = notify.returnScheduledNotifications();
	Ti.API.info("Let's how many local notifications we have scheduled'");
	Ti.API.info("Scheduled LocalNotification = " + results.scheduledCount);	
	alert("You have " +  results.scheduledCount + " Scheduled LocalNotification");
	var test = JSON.stringify(results);
	Ti.API.info("results stringified" + test);	

</code></pre>

<h3>findLocalNotificationsByKey</h3>
This method allows you to query your scheduled notification similar to activeScheduledNotifications but with using a value and key combination.  This method will return all notifications that has a matching UserInfo with the provided value and key combination.  In the below example, we return all notifications that have a userInfo.category property with a value of foo.

The below sample shows how to get a resultset by using this method.
<pre><code>

	//Call this method to return a collection with information on your scheduled notifications
	var results = notify.findLocalNotificationsByKey("foo","category");
	Ti.API.info("Let's how many local notifications we have scheduled'");
	Ti.API.info("Scheduled LocalNotification = " + results.scheduledCount);	
	alert("You have " +  results.scheduledCount + " Scheduled LocalNotification");
	var test = JSON.stringify(results);
	Ti.API.info("results stringified" + test);

</code></pre>

<h3>searchLocalNotificationsByKey</h3>
This method works in the same way as findLocalNotificationsByKey, but provides a callback method.

In the below example, a callback is returned with all notifications that have a userInfo.category property with a value of foo.

The below sample shows how to get a resultset by using this method.
<pre><code>

	//This is our callback for our scheduled local notification query
	function localNotificationCallback(e){
		Ti.API.info("Let's how many local notifications we have scheduled'");
		Ti.API.info("Scheduled LocalNotification = " + e.scheduledCount);	
		alert("You have " +  e.scheduledCount + " Scheduled LocalNotification");

		var test = JSON.stringify(e);
		Ti.API.info("results stringified" + test);
	};

	//Call this method and return a callback with the results
	notify.searchLocalNotificationsByKey("foo","category",localNotificationCallback);

</code></pre>


<h3>cancelLocalNotificationByKey</h3>
This method allows you to cancel a specific scheduled local notification using any key defined in the userInfo dictionary.  

In the above scheduleLocalNotification example you see we use userInfo:{"id":1,"hello":"world","category":"foo"} when creating the notification.  

You can use any of the defined keys to cancel an event. In the below example, you see that a key of "category" is provided along with the value of "foo". This will remove all notifications that meet this criteria.

The method cancelLocalNotificationByKey returns an integer with the number of scheduled notifications canceled. Since you can schedule one or more notifications with the same property information this will let you know how many where removed without having to re-run the activeScheduledNotifications method. 

The below sample shows how to cancel a local notification with the userInfo "category" property set to "foo".  After canceling we query the saved notifications to confirm the cancel was successful.

<pre><code>

	//We are going to remove all of the LocalNotifications scheduled with a userInfo id value of 1
	var canceledCount =  notify.cancelLocalNotificationByKey("foo","category");
	alert("You have canceled " + canceledCount + " notifications");
	//Now query the scheduled notifications to make sure our local notification was canceled
	notify.activeScheduledNotifications(localNotificationCallback);

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
