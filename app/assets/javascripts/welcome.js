$(document).ready(function(){
// keep track of position and update the server and local map when it changes
  navigator.geolocation.watchPosition(getBirds);

  function getBirds(position) {
    $.get("http://ebird.org/ws1.1/data/obs/geo/recent?lng="+position.coords.longitude+"&lat="+position.coords.latitude+"&fmt=json&dist=5&back=14&includeProvisional=true", function(data) {
      console.log(data);
      $('div#birds').html("");
      console.log("cleared");
      $.each(data, function(index, bird){
          $.get("image?comName="+encodeURIComponent(bird.comName),function(data2){
            $('div#birds').append("<p><img src='"+data2.url+"'/></br>"+bird.comName+"</p>");
          });
      });
    });
  }
});