// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------
import "bootstrap";


const hideOrDisplayMenu = () => {
  const x = document.getElementById("myDIV");
  if (x.style.display === "none") {
    x.style.display = "block";
  } else {
    x.style.display = "none";
  }
}


const buttonSettings = document.getElementById('user-settings');
if (buttonSettings) {
  buttonSettings.addEventListener('click', (event) => {
    event.preventDefault();
    hideOrDisplayMenu();
  })
}

// const buttonUpdateProfile = document.getElementById('update-profile');
// buttonUpdateProfile.addEventListener('click', (event) => {
//   event.preventDefault();
//   hideMenu();
//   displayMenu();
// })


const countdown = document.getElementById('countdown');
if (countdown) {
  let initTime = parseInt(countdown.innerText, 10);

  setInterval(() => {
    initTime = initTime - 1;
    var heure = parseInt((initTime / 3600), 10);
    var reste = (initTime % 3600);
    var minutes = parseInt((reste / 60),10);
    var seconde = reste % 60;
    countdown.innerText = heure + ":"
  + minutes + ":" + seconde
    console.log(initTime);
  }, 1000);
};








