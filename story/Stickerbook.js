$(document).ready(function(){

	var i = 0;

	$("page1").show();
	for (i = 2; i <= 21; i++){
		$("#page" + i.toString()).hide();
	}
	i = 1;
   
   $("#prev-button").hide();
	  
	$("#next-button").click(function(){
		if (i == 21) {
			alert("This is already the last page");
		}
		else{
			var id = "#page" + i.toString();
	    	$(id).hide();
	    	//alert(id);
	    	i++;
	    	id = "#page" + i.toString();
	    	$(id).show();
         if (i == 21) {
            $("#next-button").hide();
         } else {
            $("#next-button").show();
         }
         if (i > 1) {
            $("#prev-button").show();
         }
		}
	});
	 
	$("#prev-button").click(function(){
		if (i == 1) {
			alert("This is already the first page");
		}
		else{
			var id = "#page" + i.toString();
	    	$(id).hide();
	    	//alert(id);
	    	i--;
	    	id = "#page" + i.toString();
	    	$(id).show();
         if (i == 1) {
            $("#prev-button").hide();
         } else {
            $("#prev-button").show();
         }
         if (i < 21) {
            $("#next-button").show();
         }
		}
	});

});
