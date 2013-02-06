// NOTICE!! DO NOT USE ANY OF THIS JAVASCRIPT
// IT'S ALL JUST JUNK FOR OUR DOCS!
// ++++++++++++++++++++++++++++++++++++++++++
!function ($) {
$(function(){
$('a[rel=popover]').popover()

$('a.ajax').click(function()
	{
		$('#processing').modal('show')
	}
)
})



}(window.jQuery)