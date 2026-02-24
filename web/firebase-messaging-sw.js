importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyDa0R4NIDT7yFqzNmyedYpKQo3IXOeMjhc",
  authDomain: "tybetogodriver.firebaseapp.com",
  projectId: "tybetogodriver",
  storageBucket: "tybetogodriver.firebasestorage.app",
  messagingSenderId: "356779144732",
  appId: "1:356779144732:web:25604849c62be4d2bdd1d9",
  measurementId: "G-PXSLY985VL"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((message) => {
  console.log('[firebase-messaging-sw.js] Background message:', message);
});
