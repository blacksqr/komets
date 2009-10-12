/**
 * Multi-level Drop Down Menu (multi-ddm)
 * March 26, 2009
 * Corey Hart @ http://www.codenothing.com
 *
 * @timer: [Default 500] Time in milliseconds to hold menu's open on mouseouts
 * @parentMO: CSS class to add/remove from parent menu on mouseover/mouseouts
 * @childMO: CSS class to add/remove to ALL child menus
 * @levels: Array of CSS classes in order of appearance on drop downs
 * @parentTag: List type of the parent menu ('ul' or 'ol')
 * @childTag: List type of each menu level ('ul' or 'ol')
 * @tags: List type of each level in order ('ul' or 'ol' for each)
 * @numberOfLevels: [Default 5] Number of levels the menu has. Will default to 
 * 	length of levels array when childMO is null.
 */ 
;(function($){
	$.fn.dropDownMenu = function(options){
		var menus = new Array();
		var css;
		var tag;
		var internal;
		var timeout;
		var settings = $.extend({
			timer: 500,
			parentMO: null,
			childMO: null,
			levels: [],
			parentTag: 'ul',
			childTag: 'ul',
			tags: [],
			numberOfLevels: 5
		},options||{});

		// Set number of levels
		if (settings.tags.length > 0){
			settings.numberOfLevels = settings.tags.length;
		}else if (settings.levels.length){
			settings.numberOfLevels = settings.levels.length;
		}

		// Set css levels with childMO
		if (settings.childMO){
			for (var i=0; i<settings.numberOfLevels; i++) settings.levels[i] = settings.childMO;
		}

		// Set tag levels with tag
		if (settings.tags.length < 1){
			for (var i=0; i<settings.numberOfLevels; i++) settings.tags[i] = settings.childTag;
		}

		// Run through each level
		menus[0] = $(this).children('li');
		for (var i=1; i<settings.numberOfLevels+2; i++){
			// Tags/CSS
			css = (i==1) ? settings.parentMO : settings.levels[i-2];
			tag = (i==1) ? settings.parentTag : settings.tags[i-2];

			// level selector
			menus[i] = menus[i-1].children(settings.tag).children('li');

			// Action
			menus[i-1].attr({rel: css+';'+tag}).mouseover(function(){
				if (timeout) clearTimeout(timeout);
				internal = $(this).attr("rel").split(";");
				$(this).siblings('li').children('a').removeClass(internal[0]).siblings(internal[1]).hide();
				$(this).children('a').addClass(internal[0]).siblings(internal[1]).show();
			}).mouseout(function(){
				internal = $(this).attr("rel").split(";");
				if (internal[0] == settings.parentMO){
					timeout = setTimeout(function(){closemenu();}, settings.timer);
				}
			});
		}

		// Allows user option to close menus by clicking outside the menu on the body
		$(document).click(function(){closemenu();});

		// Closes all open menus
		var closemenu = function(){
			for (var i=menus.length; i>-1; i--){
				if (menus[i] && menus[i].attr("rel")){
					internal = menus[i].attr("rel").split(";");
					menus[i].children(internal[1]).hide().siblings('a').removeClass(internal[0]);
				}
			}
			$('a', menus[0]).removeClass(settings.parentMO);
			if (timeout) clearTimeout(timeout);
		}
	};
})(jQuery);
