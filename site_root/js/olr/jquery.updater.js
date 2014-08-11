(function ($) {
    
    //url is the initial URL to load
    //any reloads will append the url to the base url
    //this means any link inside the container MUST BE RELATIVE
    
    //TO OVERRIDE LINK HIJACKING AND DISABLE THE AJAX LOADING FOR A SPECIFIC LINK
    //add the class 'no-updater' to the anchor tag
    
    $.updater = function (el, url, options) {

        var skipLoad = false;
    
        $.updater.defaultOptions = {
            overrideClass: "no-updater"
        };
    

        // To avoid scope issues, use 'base' instead of 'this'
        // to reference this class from internal events and functions.
        var base = this;

        // Access to jQuery and DOM versions of element
        base.$el = $(el);
        base.el = el;

        // Add a reverse reference to the DOM object
        base.$el.data("updater", base);
        
        base.url = url;
    
        base.hash = "";
        
        
        
        
        
        
        function getPathFromUrl(url) {
            return url.split("?")[0];
        }
        
        function getQueryStringFromHash(url) {
            return url.split("#")[1];
        }
        
        
        
        
        
        
        function changeHash(ajaxUrl) {
            
            //only modify hash to include query string if ajax URL has one...
           if (ajaxUrl.indexOf('?') != -1) {
               
               //if in a tab, the update the hash to include the tab id and the query string
               if (base.isInTab) {
                   window.location.hash = base.tabHash + ajaxUrl;
               }
               else {
                   //if not, modify the existing hash and append the query string
                   window.location.hash = getPathFromUrl(window.location.hash) + ajaxUrl;        
               }

           }
            
        }
        
        function load(ajaxUrl) {
            
            $.get(base.url + ajaxUrl, function(html) {
                
                base.$el.html(html);
                base.currentHashQueryString = ajaxUrl;
                watchLinks();
           });
        }
        
        function watchLinks() {
             
            //hijack any link click inside the container div
            //and redirect to load inside the defined container
            
             $('a', base.$el).click(function(e) {
                
                var linkUrl = $(this).attr('href');
                
                //check if the href has the override class and ignore hijacking
                //the link, allowing it to do whatever it was intending to do
                //in the first place
                var ignore = $(this).hasClass(base.options.overrideClass);
                
                //only reload if the link clicked has a href
                if (!ignore && linkUrl) {
                    e.preventDefault();    
                    changeHash(linkUrl);
                }
                
            });
        }

        base.init = function (url) {
        
            base.options = $.extend({}, $.updater.defaultOptions, options);
            
            
            //check if contained within a foundation tab
            //so we can manage hash tracking
        
            base.isInTab = base.$el.closest('.tabs-content').length > 0;
            
            
            if (base.isInTab) {
                base.tabHash = base.$el.closest('.content')[0].id;
                base.tabsContainer = base.$el.parents().find('.tabs')
                base.currentHashQueryString = "";
                            
                
                $("dd a[href='#" + base.tabHash + "']", base.tabsContainer).click(function() {
                   
                    if (base.currentHashQueryString) {
                        var qs = base.currentHashQueryString;
                    }
                    else {
                        var qs = "";
                    }
                    window.location.hash = base.tabHash + qs;
                   
                });
                
            }
        
            $(window).on('hashchange', function() {
            
               if (location.hash != "") {
                    if (getPathFromUrl(location.hash) == '#' + base.tabHash) {
                        
                        var qs = location.hash.indexOf('?') != -1  ? "?" + location.hash.split('?')[1] : "";
                        
                        //don't reload tab if the same query string - no reason to reload the same exact data twice
                        if (base.currentHashQueryString != qs ) {
                            load(qs);
                        }
                        
                    }
               }
            });
            
            
            //load the initial html into the container div
            
            
            if (location.hash && getPathFromUrl(location.hash) == '#' + base.tabHash) {
                        
                var qs = location.hash.indexOf('?') != -1  ? "?" + location.hash.split('?')[1] : "";
                        
                load(url + qs);
                
                        
            } else {
                
                load(url);    
            }
           
            
        };

        // Run initializer
        base.init(url);
    };
    


    $.fn.updater = function (url, options) {
        
        return this.each(function () {
            (new $.updater(this, url, options));
        });
    };

})(jQuery);