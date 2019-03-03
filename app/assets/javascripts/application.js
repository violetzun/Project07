// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap-alert
//= require bootstrap-dropdown
//= require jquery.tokeninput
//= require magnific-popup
//= require jquery.ui.all
//= require redactor-rails
//= require jquery.wookmark
//= require socket
//= require turbolinks



jQuery(document).ready(function ($) {

    //Set default open/close settings
    var divs=$('.accordion>div').hide(); //Hide/close all containers

    var h2s=$('.accordion>h2').click(function () {
        h2s.not(this).removeClass('active')
        $(this).toggleClass('active')
        divs.not($(this).next()).slideUp()
        $(this).next().slideToggle()
        return false; //Prevent the browser jump to the link anchor



    });

});




var ready = function(){

	//====================================================
	//----------- animation for review item---------------
	//====================================================

	$( ".reviewItem" ).each(function() {
		$( this ).animate({"opacity":Math.random() * 1});
    	$( this ).animate({"opacity":1})
    });


	//====================================================
	//------------- open Youtube Link---------------------
	//====================================================  window.location.href = site_url ;
	$('.youtubeLink').magnificPopup({

          type: 'iframe',
          mainClass: 'mfp-fade',
          removalDelay: 160,
          preloader: false,

          fixedContentPos:   false

        });

	//==================================================
	//------------- AJAX search (new entry)-------------
	//==================================================
	//in entry/new
	$('#entry_topic').tokenInput('/movies.json', { propertyToSearch: 'title' ,
	tokenValue: 'id',
	tokenLimit: 1,
	noResultsText: "Not Match",
	searchingText: '  '+'<i class="fa fa-refresh fa-spin"></i>'+'  Searching',
	prePopulate: $('#entry_topic').data("load"),
	hintText: "Enter movie title",
	resultsFormatter: function(item){ var releaseDate = new Date(item.release_date); return "<li>"+"<img src='http://d3gtl9l2a4fn1j.cloudfront.net/t/p/w500/"+item.poster_path+"' height='25px' width='25px' />"+ "<div style='display: inline-block; padding-left: 10px;'>" + item.title +" ("+releaseDate.getFullYear()+")"+"</div></li>"},
	tokenFormatter : function(item){ var releaseDate = new Date(item.release_date); return "<li>"+"<img src='http://d3gtl9l2a4fn1j.cloudfront.net/t/p/w500/"+item.poster_path+"' height='25px' width='25px' />"+ "<div style='display: inline-block; padding-left: 10px;'>" + item.title +" ("+releaseDate.getFullYear()+")"+"</div></li>"}
	});

	//==================================================
	//---------------- AJAX search (movie)--------------
	//==================================================
	//in entry/new
	$('#topic').tokenInput('/movies.json', { propertyToSearch: 'title' ,
	tokenValue: 'id',
	tokenLimit: 1,
	noResultsText: "Not Match",
	searchingText: '  '+'<i class="fa fa-refresh fa-spin"></i>'+'  Searching',
	hintText: "Search by movie title",
	onAdd: function (item) {
		var win = window.open('/movies/'+item.id,'_blank');
		$("#topic").tokenInput("clear");
		win.focus();
    },
	width: "10%",
	resultsFormatter: function(item){ var releaseDate = new Date(item.release_date); return "<li>"+"<img src='http://d3gtl9l2a4fn1j.cloudfront.net/t/p/w500/"+item.poster_path+"' height='20px' width='20px' />"+ "<div style='display: inline-block; padding-left: 10px;'>" + item.title +" ("+releaseDate.getFullYear()+")"+"</div></li>"},
	tokenFormatter : function(item){ var releaseDate = new Date(item.release_date); return "<li>"+"<img src='http://d3gtl9l2a4fn1j.cloudfront.net/t/p/w500/"+item.poster_path+"' height='20px' width='20px' />"+ "<div style='display: inline-block; padding-left: 10px;'>" + item.title +" ("+releaseDate.getFullYear()+")"+"</div></li>"}
	});


	//==================================================
	//---------------- Old stuff----------------------
	//==================================================
	$('.poster').mouseenter(function(){
    $(this).prepend($(".posterDesc"));
    $(".posterDesc").fadeIn(800);
}).mouseleave(function(){
    $(".posterDesc").hide();
});
	//==================================================
	//------------- for big Poster----------------------
	//==================================================
	//move the image in pixel
	var move = -15;
	
	//zoom percentage, 1.2 =120%
	var zoom = 1.2;

	//On mouse over those thumbnail
	$('.zitem').hover(function() {
		
		//Set the width and height according to the zoom percentage
		width = $('.zitem').width() * zoom;
		height = $('.zitem').height() * zoom;
		
		//Move and zoom the image
		$(this).find('img').stop(false,true).animate({'width':width, 'height':height, 'top':move, 'left':move}, {duration:200});
		
		//Display the caption
		$(this).find('div.caption').stop(false,true).fadeIn(200);
	},
	function() {
		//Reset the image
		$(this).find('img').stop(false,true).animate({'width':$('.zitem').width(), 'height':$('.zitem').height(), 'top':'0', 'left':'0'}, {duration:100});	

		//Hide the caption
		$(this).find('div.caption').stop(false,true).fadeOut(200);
	});
	//----------------------------------------------------
	
	//====================================================
	//------------- for small Poster----------------------
	//====================================================
	//move the image in pixel
	var move = -15;
	
	//zoom percentage, 1.2 =120%
	var zoom = 1.2;

	//On mouse over those thumbnail
	$('.zitemSmall').hover(function() {
		
		//Set the width and height according to the zoom percentage
		width = $('.zitemSmall').width() * zoom;
		height = $('.zitemSmall').height() * zoom;
		
		//Move and zoom the image
		$(this).find('img').stop(false,true).animate({'width':width, 'height':height, 'top':move, 'left':move}, {duration:200});
		
		//Display the caption
		$(this).find('div.caption').stop(false,true).fadeIn(200);
	},
	function() {
		//Reset the image
		$(this).find('img').stop(false,true).animate({'width':$('.zitemSmall').width(), 'height':$('.zitemSmall').height(), 'top':'0', 'left':'0'}, {duration:100});	

		//Hide the caption
		$(this).find('div.caption').stop(false,true).fadeOut(200);
	});


	//====================================================
	//--------------------- Wookmark ---------------------
	//====================================================
	$('.reviewItem').wookmark({
        align: 'left',
  		comparator: null,
  		container: $('.reviewBody'),
  		direction: undefined,
  		ignoreInactiveItems: true,
  		itemWidth: 0,
  		fillEmptySpace: false,
  		flexibleWidth: 0,
  		offset: 32,
  		onLayoutChanged: undefined,
  		outerOffset: 0,
  		resizeDelay: 50,
  		possibleFilters: []
	});

	//====================================================
	//--------------------Review Hover ------------------
	//====================================================

	$('.reviewItem').mouseenter(function(){
    	$(this).css( "background-color", "#fffbf0" );
    	$('.movieName',this).css( "background-color", "#232323" );
		}).mouseleave(function(){
    $(this).css( "background-color", "#fbfafa" );
    $('.movieName',this).css( "background-color", "#454545" );
	});

	//====================================================
	//--------------------Click comment ------------------
	//====================================================
	$(".commentButton").on( "click",function(){
  		$(".comment").css( "display", "block" );
	});
	

	//====================================================
	//--------------------Click comment ------------------
	//====================================================
	$( ".inner" ).mouseenter(function(){
  		$(this).css( "max-height","1000px");
  		$(this).children('.reviewContent2').find('div').animate({ "max-height": 1000+"px" }, 'slow');

	});
	$( ".inner" ).mouseleave(function(){
  		$(this).animate({ "max-height": 500+"px" }, 'fast');
  		$(this).children('.reviewContent2').find('div').animate({ "max-height": 160+"px" }, 'fast');
	});


};
$(document).ready(ready);
$(document).on('page:load',ready);






