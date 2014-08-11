/* module for shopping pages interaction */

shopMgr = function() {
    
    var mobileCategoriesBuilt = false;
    var mobileSearchBuilt = false;
    var previousScrollPos = 0;
    
    return {
        
        
        showMobileCategories: function() {
            
            //display a fullscreen list of categories over top of existing
            //content
            
          
            
            if (!mobileCategoriesBuilt) {
                
                //move the modal to the bottom of the page body to ensure
                //it's not in another relative context, since we want
                //it to take up the full screen
                
                $('#MobileCategories').appendTo(document.body);
                
                //copy the (likely hidden) categories listing into the modal
                //but only copy them once, no need to do the work again
                //if a user opens the display more than once per page...
                
                var categoryList = $('#CategoryList').clone();
                $('#MobileCategoriesListing').html(categoryList);
                mobileCategoriesBuilt = true;
                
            }
            
            
            $('#MobileCategories')
                .css({top: '-200%'})
                .show()
                .animate({top: 0}, 800);
            
            
            //get the current scroll position
            previousScrollPos = $(document).scrollTop();
            
            
            $("html, body").animate({ scrollTop: 0 }, 500);
        },
        
        closeMobileCategories: function() {
            
          $('#MobileCategories').animate({top: '-200%'}, 800, function() {
            $('#MobileCategories').hide();
          });
          $("html, body").animate({ scrollTop: previousScrollPos }, 500);
        },
        
        showMobileSearch: function() {
            
            if (!mobileSearchBuilt) {
                
                $('#MobileSearch').appendTo(document.body);
                mobileSearchBuilt = true;
                
            }
            
            previousScrollPos = $(document).scrollTop();
            
            $("html, body").animate({ scrollTop: 0 }, 500);
            
             $('#MobileSearch')
                .css({top: '-200%'})
                .show()
                .animate({top: 0}, 800, function() {
                    $('#MobileSearch input[name="search"').focus();
                });
            
            
        },
        
        closeMobileSearch: function() {
            
          $('#MobileSearch').animate({top: '-200%'}, 800, function() {
            $('#MobileSearch').hide();
          });
          $("html, body").animate({ scrollTop: previousScrollPos }, 500);
            
        }
        
        
        
        
    }
}();