var profileMgr = function () {
    
    return {
        
        init: function(postUrl, snapshotRefreshUrl) {
            
            watchSubmit(
                postUrl,
                '#Profile form',
                '#Profile',
                
                function() {
                    //reload the user profile snapshot
                    $('#ProfileSnapshot').load(snapshotRefreshUrl);   
                }
            );
           
        },
        
        initPassword: function(postUrl) {
            
             watchSubmit(
                postUrl,
                '#PasswordReset form',
                '#PasswordReset'
            );
            
        }
        
    }
}();