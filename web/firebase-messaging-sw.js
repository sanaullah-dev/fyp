importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyDyCtN4KYInCI8NXHKvYNVq4YPNk7e8o70",
    authDomain: "vmbs-2c700.firebaseapp.com",
    databaseURL: "https://vmbs-2c700-default-rtdb.firebaseio.com",
    projectId: "vmbs-2c700",
    storageBucket: "vmbs-2c700.appspot.com",
    messagingSenderId: "467918462056",
    appId: "1:467918462056:web:7478d83e2c7369189d2fdd",
});



const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage*****************", message);
});



// Handle background notifications
messaging.setBackgroundMessageHandler(function (payload) {
  console.log('Handling background message ######################', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: 'your-icon-url',
  };

  return self.registration.showNotification(
    notificationTitle,
    notificationOptions
  );
});