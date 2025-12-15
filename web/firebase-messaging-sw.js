// Import and configure the Firebase SDK
// These scripts are made available when the app is served or deployed on the Firebase Hosting
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
firebase.initializeApp({
  apiKey: 'AIzaSyBJKP4B9XBGelHEygVDI6isaJfRQ6G2Tpw',
  appId: '1:1042661219588:web:9dbb7255483c2f5eb28451',
  messagingSenderId: '1042661219588',
  projectId: 'futorna-reservation-app',
  authDomain: 'futorna-reservation-app.firebaseapp.com',
  storageBucket: 'futorna-reservation-app.firebasestorage.app',
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();

// Optional: Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  // Customize notification here
  const notificationTitle = payload.notification?.title || 'Background Message Title';
  const notificationOptions = {
    body: payload.notification?.body || 'Background Message body.',
    icon: '/icons/Icon-192.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

