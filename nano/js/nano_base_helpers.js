// NanoBaseHelpers is where the base template helpers (common to all templates) are stored
NanoBaseHelpers = function () 
{
	var _urlParameters = {}; // This is populated with the base url parameters (used by all links), which is probaby just the "src" parameter
	
	var init = function () 
	{
		var body = $('body'); // We store data in the body tag, it's as good a place as any
	
		_urlParameters = body.data('urlParameters');
		
		initHelpers();
	};
	
	var initHelpers = function ()
	{
		$.views.helpers({
			// Generate a Byond link
			link: function( text, icon, parameters, status, elementClass, elementId) {
	
				var iconHtml = '';
				if (typeof icon != 'undefined' && icon)
				{
					iconHtml = '<div class="uiLinkPendingIcon"></div><div class="uiIcon16 ' + icon + '"></div>';
				}
				
				if (typeof elementClass == 'undefined' || !elementClass)
				{
					elementClass = '';
				}
				
				var elementIdHtml = '';
				if (typeof elementId != 'undefined' && elementId)
				{
					elementIdHtml = 'id="' + elementId + '"';
				}
				
				if (typeof status != 'undefined' && status)
				{
					return '<div class="link ' + elementClass + ' ' + status + '" ' + elementIdHtml + '>' + iconHtml + text + '</div>';
				}
				
				return '<div class="link linkActive ' + elementClass + '" data-href="' + generateHref(parameters) + '" ' + elementIdHtml + '>' + iconHtml + text + '</div>';
			},
			// Round a number to the nearest integer
			round: function(number) {								
				return Math.round(number);
			},
			// Round a number down to integer
			floor: function(number) {								
				return Math.floor(number);
			},
			// Round a number up to integer
			ceil: function(number) {								
				return Math.ceil(number);
			},
			// Format a string (~string("Hello {0}, how are {1}?", 'Martin', 'you') becomes "Hello Martin, how are you?")
			string: function() {		
				if (arguments.length == 0)
				{					
					return '';
				}
				else if (arguments.length == 1)
				{					
					return arguments[0];
				}
				else if (arguments.length > 1)
				{
					stringArgs = [];
					for (var i = 1; i < arguments.length; i++)
					{
						stringArgs.push(arguments[i]);   
					}
					return arguments[0].format(stringArgs);
				}
				return '';
			},
			// Display a bar. Used to show health, capacity, etc.
			displayBar: function(value, rangeMin, rangeMax, styleClass, showText) {		
			
				if (rangeMin < rangeMax)
                {
                    if (value < rangeMin)
                    {
                        value = rangeMin;
                    }
                    else if (value > rangeMax)
                    {
                        value = rangeMax;
                    }
                }
                else
                {
                    if (value > rangeMin)
                    {
                        value = rangeMin;
                    }
                    else if (value < rangeMax)
                    {
                        value = rangeMax;
                    }
                }				
				
				if (typeof styleClass == 'undefined' || !styleClass)
				{
					styleClass = '';
				}
				
				if (typeof showText == 'undefined' || !showText)
				{
					showText = '';
				}
				
				var percentage = Math.round((value - rangeMin) / (rangeMax - rangeMin) * 100);
				
				return '<div class="displayBar ' + styleClass + '"><div class="displayBarFill ' + styleClass + '" style="width: ' + percentage + '%;"></div><div class="displayBarText ' + styleClass + '">' + showText + '</div></div>';
			}
		});
		
		$.views.tags({
			/*
			 * Sample JsViews tag control: {{tabs}} control
			 * http://www.jsviews.com/download/sample-tag-controls/tabs/tabs.js
			 * Used in samples: http://www.jsviews.com/#samples/tag-controls/tabs
			 * Copyright 2013, Boris Moore
			 * Released under the MIT License.
			 */
			 tabs: {
				init: function(tagCtx) {
					this.selectedIndex = tagCtx.props.selectedIndex || 0;
					this.tabCount = this.tagCtxs.length;
				},
				render: function() {
					var tagCtx = this.tagCtx;
					return this.selectedIndex === tagCtx.index ? tagCtx.render() : "";
				},
				onAfterLink: function() {
					var self = this;
					self.contents(true, ".tabstrip").first()
						.on("click", ".header_false", function() {
							self.setTab($.view(this).index);
						});
				},
				template: '<table class="tabsview"><tbody>' +
					'<tr class="tabstrip">' +
					'{{for ~tag.tagCtxs}}' +
						'<th data-link="class{:\'header_\' + (#index === ~tag.selectedIndex)}">' +
							'{{>props.tabCaption}}' +
						'</th>' +
					'{{/for}}' +
				'</tr>' +
				'<tr class="tabscontent">' +
					'<td colspan="{{:~tag.tagCtxs.length}}">' +
						'<div style="width:{{attr:~tag.tagCtxs[0].props.width}};' +
												'height:{{attr:~tag.tagCtxs[0].props.height}}">' +
							'{^{for ^tmpl=~tag.tagCtxs[~tag.selectedIndex].content /}}' +
						'</div>' +
						'</td>' +
					'</tr>' +
				'</tbody></table>',

				//METHODS
				setTab: function(index) {
					$.observable(this).setProperty("selectedIndex", index);
					if (this.onSelectionChange) {
						this.onSelectionChange(index, this);
					}
				},
				dataBoundOnly: true
			}
		});
	}
	
	// generate a Byond href, combines _urlParameters with parameters
	var generateHref = function (parameters)
	{
		var queryString = '?';
		
		for (var key in _urlParameters)
		{
			if (_urlParameters.hasOwnProperty(key))
			{
				if (queryString !== '?')
				{
					queryString += ';';
				}
				queryString += key + '=' + _urlParameters[key];
			}
		}
		
		for (var key in parameters)
		{
			if (parameters.hasOwnProperty(key))
			{
				if (queryString !== '?')
				{
					queryString += ';';
				}
				queryString += key + '=' + parameters[key];
			}
		}
		return queryString;
	}

	return {
        init: function () 
		{
            init();
        }
	};
} ();

$(document).ready(function() 
{
	NanoBaseHelpers.init();
});






