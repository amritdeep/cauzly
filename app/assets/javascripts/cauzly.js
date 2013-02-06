$(document).ready(function(){
	
	if($('.use_saved_card').attr("checked"))
	{
	    $("#billing_card_form").hide(); 
	}else{
	    $("#billing_card_form").show();
	}
	
	$('.use_saved_card').on('click', function () {
	
    if($('.use_saved_card').is(':checked'))
    {
         $("#billing_card_form").hide();
       }else{         
         $("#billing_card_form").show();
        }
    })
    
	$('#modal-gallery').on('load', function () {
    var modalData = $(this).data('modal');
    // modalData.$links is the list of (filtered) element nodes as jQuery object
    // modalData.img is the img (or canvas) element for the loaded image
    // modalData.options.index is the index of the current link
    
   
});


$(function(){
    $(".morePagination a").live("click",function(){
        $('.morePagination').html("<img src='/assets/icons/loading.gif' />");
        $.get(this.href, null, null, "script");
        return false;
    });
});


		  $(".ajax").bind('ajax:before', function() {
		  	
		                $('#processing').modal('show')
		               $(".postsubmit").attr('disabled','disabled');
		                  }); 
		
		  $(".ajax").bind('ajax:success', function() {
		                 //
		                $('#processing').modal('hide')
		                 $(".postsubmit").attr('disabled','disabled');
		                  }); 

$(".status_content img").css({"width":"250","height":"200"});
$(".postsubmit").attr('disabled','disabled');
    

                 
                   $('.inputbox').keyup(function()
                    {
                    	var inputtext = $(this).val().length;
                    	 	 var remaining = 200 - inputtext;
                    	
                        if($(this).val() == ''){
                         $(".postsubmit").attr('disabled','disabled');
                        }
                        else
                        {  if(inputtext > 190 && inputtext <= 200)
                          {   $(".postsubmit").removeAttr('disabled');
                          	  $(".inputerror").html('<span class=" alert alert-error"><strong>'+remaining+'</strong> </span>');
                         
                          }
                          else if(inputtext > 200)
                          {
                            $(".postsubmit").attr('disabled','disabled');
                            $(".inputerror").html('<span class=" alert alert-error">Please use no more than 200 characters</span>');
                           }
                          
                           else
                           {
                          
    						
                            $(".postsubmit").removeAttr('disabled');
                            $(".inputerror").html('<span class=" alert alert-info"><strong>'+remaining+'</strong> </span>');
                         
                           }
                        }
                 });


$('#cause_keyword').bind('railsAutocomplete.select', function(event, data){
  /* Do something here */
  window.location.href="?cause_keyword="+ encodeURIComponent(data.item.label);
});

	
	$(".btnselec").click(function() {
		var selected_type = $(this).data("value");
		$("#user_user_type").val(selected_type);
	});

checkinputno();
resize_player();


});

function remove_fields (link) {
  $(link).siblings("input[type=hidden]:first").attr('value', '1');
	$(link).parents(".field:first").hide();
    checkinputno();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).before(content.replace(regexp, new_id));
  checkinputno();
}

function checkinputno()
{
	var $selector = $("#addvideos"); /* Assuming the selector is `this` */
	var count = $selector.find(".video_url").length;
	//alert(count);
	if(count >= 6)
	{
		$(".addmore").hide();
	}else{
		$(".addmore").show();
		
	}
}


function resize_player(){
	//alert("resized");
$(".user_video  iframe").attr({"width":'320',"height":"170"});
$(".user_video  object").attr({"width":'320',"height":"170"});
$(".user_video  div").css({"width":'320',"height":"168" ,"padding":"0","margin":"0"});
$(".user_video div embed").attr({"width":'320',"height":"168"});

$(".user_videob  iframe").attr({"width":'320',"height":"225"});
$(".user_videob  object").attr({"width":'320',"height":"225"});
$(".user_videob  div").css({"width":'320',"height":"223" ,"padding":"0","margin":"0"});
$(".user_videob div embed").attr({"width":'320',"height":"223"});

}


function showhideVideo(elem)
{
	var a='#video_player_'+elem;
	var link=$("#uvideo_"+elem);
	
	if(link.html()=="Video [+]")
		{
		link.html("Video [-]");
		}else{
			link.html("Video [+]");
		}
	$(a).toggle();
}



function moreless(elem)
{	
	$(elem).toggle();
}


jQuery(document).ready(function() {
    jQuery('#mycarousel').jcarousel();
});
jQuery(function($){
 
   $(".phone").mask("(999)-999-9999");
 
});
