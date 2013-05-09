$(document).ready(function(){
// keep track of position and update the server and local map when it changes
  navigator.geolocation.watchPosition(getBirds);

  function getBirds(position) {
    console.log("starting...");
    $.get("http://ebird.org/ws1.1/data/obs/geo/recent?lng="+position.coords.longitude+"&lat="+position.coords.latitude+"&fmt=json&dist=10&back=14&includeProvisional=true", function(data) {
      $.each(data, function(index, bird){
          $.get("image?comName="+encodeURIComponent(bird.comName),function(data2){
            $('div#birds').append("<p><img src='"+data2.url+"'/>"+bird.comName+"</p>");
          });
      });
    });
  }
});