var notify = require('bencoding.localnotify');
Ti.API.info("module is => " + notify);

// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white',
	orientationModes : [
		Ti.UI.PORTRAIT
	]
});

var testButton1 = Ti.UI.createButton({
	title:'Schedule Notification',
	height:40,
	width:300,
	top:20
});

win.add(testButton1);

testButton1.addEventListener('click', function(){
	notify.scheduleLocalNotification({
		alertBody:"This is a test of benCoding.localNotify",
		alertAction:"Just a test",
		userInfo:{"id":1,"hello":"world"},
		date:new Date(new Date().getTime() + 60000) 
	});
	alert("LocalNotification Scheduled");
});

var testButton2 = Ti.UI.createButton({
	title:'Get Scheduled Notification (callback)',
	height:40,
	width:300,
	top:100
});

win.add(testButton2);

//This is our callback for our scheduled local notification query
function localNotificationCallback(e){
	Ti.API.info("Let's how many local notifications we have scheduled'");
	Ti.API.info("Scheduled LocalNotification = " + e.scheduledCount);	
	alert("You have " +  e.scheduledCount + " Scheduled LocalNotification");

	var test = JSON.stringify(e);
	Ti.API.info("results stringified" + test);
};
testButton2.addEventListener('click', function(){
	//Call this method and return a callback with the results
	notify.activeScheduledNotifications(localNotificationCallback);
});

var testButton3 = Ti.UI.createButton({
	title:'Get Scheduled Notification',
	height:40,
	width:300,
	top:180
});

win.add(testButton3);

testButton3.addEventListener('click', function(){
	//Call this method to return a collection with information on your scheduled notifications
	var results = notify.returnScheduledNotifications();
	Ti.API.info("Let's how many local notifications we have scheduled'");
	Ti.API.info("Scheduled LocalNotification = " + results.scheduledCount);	
	alert("You have " +  results.scheduledCount + " Scheduled LocalNotification");
	var test = JSON.stringify(results);
	Ti.API.info("results stringified" + test);	
});

var testButton4 = Ti.UI.createButton({
	title:'Removed Scheduled Notification',
	height:40,
	width:300,
	top:260
});
win.add(testButton4);

testButton4.addEventListener('click', function(){
	//We are going to remove all of the LocalNotifications scheduled with a userInfo id value of 1
	var canceledCount = notify.cancelLocalNotification(1);
	alert("You have canceled " + canceledCount + " notifications");
	//Now query the scheduled notifications to make sure our local notification was canceled
	notify.activeScheduledNotifications(localNotificationCallback);
});

var testButton5 = Ti.UI.createButton({
	title:'Cancel All Scheduled Notification',
	height:40,
	width:300,
	top:340
});
win.add(testButton5);

testButton5.addEventListener('click', function(){
	//Cancel all scheduled local notifications
	notify.cancelAllLocalNotifications();
	//Now query the scheduled notifications to make sure our local notification was canceled
	notify.activeScheduledNotifications(localNotificationCallback);	
});

var testButton6 = Ti.UI.createButton({
	title:'Do we have Schedule Notifications?',
	height:40,
	width:300,
	top:400
});
win.add(testButton5);

testButton6.addEventListener('click', function(){
	//Check if we have any scheduled notifications
	var hasSchedule = notify.hasScheduledNotifications();
	var msg = (hasSchedule) ? 'There Are Scheduled Notifications':'No notifications have been scheduled';
	alert(msg);
});
win.open();