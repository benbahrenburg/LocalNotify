var notify = require('bencoding.localnotify');
Ti.API.info("module is => " + notify);

// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white',
	orientationModes : [
		Ti.UI.PORTRAIT
	]
});
function buildRow(title,itemId){
	var row = Ti.UI.createTableViewRow({height:65,hasChild:true,selectedBackgroundColor:'#a32020',itemId:itemId });						
	var vwRow = Ti.UI.createView({left:10,right:10,layout:'vertical'});
	
	var lblRowTitle = Ti.UI.createLabel({
		text:title, color:'#000', left:5, right:5, top:5, height:50, font:{ fontSize:18, fontWeight:'bold'}
	});
	vwRow.add(lblRowTitle);
	
	row.add(vwRow);
	row.className = itemId;
	return row;	
};

function generateTableData(){
	var data = [];
	data.push(buildRow('Check if Any Scheduled Notifications', 0));
	
	data.push(buildRow("Schedule Notification", 1));
	
	data.push(buildRow("Get All Scheduled Notification (callback)", 2));
	data.push(buildRow('Get All Scheduled Notification', 3));
	data.push(buildRow('Get Scheduled Notification By Key (callback)', 4));
	data.push(buildRow('Get Scheduled Notification By Key', 5));
	
	data.push(buildRow('Cancel Scheduled Notification By id', 6));
	data.push(buildRow('Cancel Scheduled Notification By Key', 7));
	data.push(buildRow('Cancel All Scheduled Notification', 8));
	return data;
};

var tableView = Ti.UI.createTableView({
	top:0,bottom:0,left:0,right:0, data:generateTableData()	
});
win.add(tableView);

function localNotificationCallback(e){
	Ti.API.info("Let's how many local notifications we have scheduled'");
	Ti.API.info("Scheduled LocalNotification = " + e.scheduledCount);	
	alert("You have " +  e.scheduledCount + " Scheduled LocalNotification");

	var test = JSON.stringify(e);
	Ti.API.info("results stringified" + test);
};

tableView.addEventListener('click', function(mx){
	
	if(mx.rowData.itemId===0){
		//Check if we have any scheduled notifications
		var hasSchedule = notify.hasScheduledNotifications();
		var msg = (hasSchedule) ? 'There Are Scheduled Notifications':'No notifications have been scheduled';
		alert(msg);		
	}
	
	if(mx.rowData.itemId===1){
		notify.scheduleLocalNotification({
			alertBody:"This is a test of benCoding.localNotify",
			alertAction:"Just a test",
			userInfo:{"id":1,"hello":"world","category":"foo"},
			badge:11, //Then needs to be a number
			//sound:"pop.caf", //Copy file from KitchenSink example if you want to try this out
			date:new Date(new Date().getTime() + 60000) 
		});
		alert("LocalNotification Scheduled");	
	}	
	
	if(mx.rowData.itemId===2){
		notify.activeScheduledNotifications(localNotificationCallback);
	}
	
	if(mx.rowData.itemId===3){
		//Call this method to return a collection with information on your scheduled notifications
		var results = notify.returnScheduledNotifications();
		Ti.API.info("Let's how many local notifications we have scheduled'");
		Ti.API.info("Scheduled LocalNotification = " + results.scheduledCount);	
		alert("You have " +  results.scheduledCount + " Scheduled LocalNotification");
		var test = JSON.stringify(results);
		Ti.API.info("results stringified" + test);
	}
	
	if(mx.rowData.itemId===4){
		notify.searchLocalNotificationsByKey("foo","category",localNotificationCallback);
	}	
	
	if(mx.rowData.itemId===5){
		var results5 = notify.findLocalNotificationsByKey("foo","category");
		Ti.API.info("Let's how many local notifications we have scheduled'");
		Ti.API.info("Scheduled LocalNotification = " + results5.scheduledCount);	
		alert("You have " +  results5.scheduledCount + " Scheduled LocalNotification");
		var test5 = JSON.stringify(results5);
		Ti.API.info("results stringified" + test5);
	}	
	
	if(mx.rowData.itemId===6){
		//We are going to remove all of the LocalNotifications scheduled with a userInfo id value of 1
		var canceledCount6 = notify.cancelLocalNotification(1);
		alert("You have canceled " + canceledCount6 + " notifications");
		//Now query the scheduled notifications to make sure our local notification was canceled
		notify.activeScheduledNotifications(localNotificationCallback);		
	}
	
	if(mx.rowData.itemId===7){
		//We are going to remove all of the LocalNotifications scheduled with a userInfo id value of 1
		var canceledCount7 = notify.cancelLocalNotificationByKey("foo","category");
		alert("You have canceled " + canceledCount7 + " notifications");
		//Now query the scheduled notifications to make sure our local notification was canceled
		notify.activeScheduledNotifications(localNotificationCallback);		
	}	
	
	if(mx.rowData.itemId===8){
		//Cancel all scheduled local notifications
		notify.cancelAllLocalNotifications();
		//Now query the scheduled notifications to make sure our local notification was canceled
		notify.activeScheduledNotifications(localNotificationCallback);		
	}	
	
});	

win.open();