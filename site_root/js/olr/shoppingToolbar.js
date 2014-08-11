

//manages operation of shopping toolbar (mini cart, user profile menu)


var shoppingToolbarMgr = function() {
    
    
    var userProfileVisible = false,
        miniCartVisible = false;
        
    var userProfile,
        miniCart;
    
    //only grab the data once upon opening the menu
    var dataFetched = false;
    
    function getData() {
    
        if (!dataFetched) {
            
            $.get('/get-mini-cart/', function(html) {
                $('.cart-items').html(html);
                dataFetched = true;
            });
        }
    
        
    
    }
    
    return {
        init: function() {

            $(function() {
                 $('.mini-cart')
                   .hover(getData)
                   .click(getData);
                   
                   
                userProfile = $('.user-profile .profile-menu');
                miniCart = $('.mini-cart .cart-menu');
                   
                //if the screen is less than 640 pixels wide when loaded, assume
                //the user is on a mobile device, and require the user to toggle
                //the menus on and off
                
                //if the screen is greater than 640 pixels, then we assume
                //they're coming through a desktop, so allow them to hover over
                //the menus to reveal them.
                    
                if (screen.width < 640 ) {
                    
                   $('.mini-cart').click(function() {
                    
                        userProfile.hide();
                        
                        if (miniCartVisible) {
                            miniCart.hide();
                            miniCartVisible = false;
                        }
                        else {
                            miniCart.show();
                            miniCartVisible = true;
                        }
                        
                    });
                   
                   
                    $('.user-profile').click(function() {
                        
                        miniCart.hide();
                        
                        if (userProfileVisible) {
                            userProfile.hide();
                            userProfileVisible = false;
                        }
                        else {
                            userProfileVisible = true;
                            userProfile.show();
                        }
                    })
                   
                   
                   
                   
                }
                else {
                    
                     $('.mini-cart').hover(
                        function() {
                            userProfile.hide();
                            miniCart.show();
                            miniCartVisible = true;
                        },
                        function() {
                            userProfile.hide();
                            miniCart.hide();
                            miniCartVisible = false;
                        }
                    )
                     
                    $('.user-profile').hover(
                           function() {
                            
                            miniCart.hide();
                            userProfile.show();
                            userProfileVisible = true;
                           },
                           function() {
                            miniCart.hide();
                            userProfile.hide()
                            userProfileVisible = false;
                           }
                    );
                     
                }
            });
            
            
            
        }
    }
    
}().init();



