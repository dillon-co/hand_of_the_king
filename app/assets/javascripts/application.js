// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require_tree .


// Turbolinks.BrowserAdapter.prototype.showProgressBarAfterDelay = function() {
//   return this.progressBarTimeout = setTimeout(this.showProgressBar, 0);
// };

// function generateProgressBar(){
//     setInterval(function(){
//       // console.log($('#pb').value)
//       // document.getElementById('pb').style.backgroundImage = 'none'
//       // document.getElementById('pb').style.backgroundColor = '#47CE9A'
//       //   'background-image': 'none',
//       //   'background-color': '#47CE9A'
//       // })
//       var oldValue = document.getElementById('pb').value
//       // console.log(oldValue)
//       // console.log()
//       document.getElementById('pb').value = oldValue + 1
//     }, 20)
//   }  

console.log(window.location.search.substring(1).split('=')[0] == 'n_jid');
var params = window.location.search.substring(1).split('=')
if(params[0] == 'n_jid')
  setInterval(function() {
      console.log("meow")
      $.get('is_still_loading', {n_jid: parseInt(params[1])}, function(data) {
         if (data.success) {
           // Done loading, redirect or whatever
           console.log(data)
         }
    })
  }, 1000)
