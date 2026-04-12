importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyACQ3YTugn8nEHpMLkYP6LDHPXWOpCv_B0",
  authDomain: "drivertaybgo.firebaseapp.com",
  projectId: "drivertaybgo",
  storageBucket: "drivertaybgo.firebasestorage.app",
  messagingSenderId: "527527512549",
  appId: "1:527527512549:web:0730fc8535383822d1c70c",
  measurementId: "G-GW9V84HBQ5"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((message) => {
  console.log('[firebase-messaging-sw.js] Background message:', message);
});
