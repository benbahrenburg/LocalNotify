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
	title:'Get Scheduled Notification',
	height:40,
	width:300,
	top:100
});

win.add(testButton2);

//This is our callback for our scheduled local notification query
function localNotificationCallback(e){
	Ti.API.info("Did it work? " + e.success);
	if(e.success){
		Ti.API.info("Let's how many local notifications we have scheduled'");
		Ti.API.info("Scheduled LocalNotification = " + e.scheduledCount);	
		alert("You have " +  e.scheduledCount + "Scheduled LocalNotification");
	}	

	var test = JSON.stringify(e);
	Ti.API.info("results stringified" + test);
};
testButton2.addEventListener('click', function(){
	//Call this method and return a callback with the results
	notify.returnLocationNotificationList(localNotificationCallback);
});


var testButton3 = Ti.UI.createButton({
	title:'Removed Scheduled Notification',
	height:40,
	width:300,
	top:180
});
win.add(testButton3);

testButton3.addEventListener('click', function(){
	//We are going to remove all of the LocalNotifications scheduled with a userInfo id value of 1
	notify.cancelLocalNotification(1);
	//Now query the scheduled notifications to make sure our local notification was canceled
	notify.returnLocationNotificationList(localNotificationCallback);
});

var testButton4 = Ti.UI.createButton({
	title:'Cancel All Scheduled Notification',
	height:40,
	width:300,
	top:260
});
win.add(testButton4);

testButton4.addEventListener('click', function(){
	//Cancel all scheduled local notifications
	notify.cancelAllLocalNotifications();
});


win.open();