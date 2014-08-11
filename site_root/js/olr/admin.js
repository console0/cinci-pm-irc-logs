/* Admin utility functions */
   
    function watchSubmit(postUrl, frmName, container, callback) {
    
        //watches a regular non AJAX form post and turns it into an AJAX post    
        
        //postUrl: the url to post and get
        //formName: the name of the form
        //container: the container for the form
        //callback: an optional function to execute after submitting
        
        var frm = $(frmName);
        
        frm.submit(function(event) {

            
        
            event.preventDefault();
        
            $.ajax({
                type: frm.attr('method'),
                url: postUrl,
                data: frm.serialize(),
                success: function(response, status, xhr)
                {
                    
                    //check if the response is JSON or not
                    //assuming JSON is for a successful update, and HTML is a validation error
                    
                    
                    var ct = xhr.getResponseHeader("content-type") || "";
                    
                                        
                    if (ct.indexOf('html') > -1) {
                        
                        //if the repsonse is html then emit
                        //back to the container
                        
                        $(container).html(response);
                        watchSubmit(postUrl, frmName, container, callback);
                        
                    }
                    else if (ct.indexOf('json') > -1) {
                      
                        //otherwise use the callback, passing the JSON
                      
                        if (callback) {
                            callback(response);
                        }
                        
                      
                    }
                    else {
                        //not either content type, we gots a problem
                        throw new Error("Response type was neither JSON or HTML.")
                                                
                    }
                    
                }
            });
            
            return false;
        });
    }
    
    
    
    function displayEditModal(url, modalId, balancePanelId, balancePanelUrl, transactionHistoryPanelId, transactionHistoryUrl) {
        
        /*
         * helper function handles showing a point/token/distributable modal
         * and refreshes associated balance summary and transaction portions of the page
         *
         * url: url that returns the html to fill the modal 
         * modalId: the id (with #) of the modal to open and refresh to
         * 
         * balancePanelId: the id of the div that contains the balance summary html
         * balancePanelUrl: the url that returns the balance summary html
         *
         * transactionHistoryPanelId: the id of the div that contains the transaction history table
         * transactionHistoryUrl: the url that returns the transaction history table html
         */
        
        
        
        $.get(url, function(html){
            
            $(modalId + ' .form-container').html(html);
            $(modalId).foundation('reveal', 'open');
            
            watchSubmit(
              
              url,
              modalId + ' form',
              modalId + ' .form-container',
              
              function(data) {
                
                //reload balance panel
                $(balancePanelId).load(balancePanelUrl);
                
                $(modalId).foundation('reveal', 'close');
                
                //refresh transaction hisotry
                $(transactionHistoryPanelId).updater(transactionHistoryUrl);
                
                displayMessage(data);
              }
            );
            
        });
        
    }
    
    
    
    function displayMessage(response) {
        
        //adds a notification message to the top of the page
        
        /*
         *  Expected JSON
         *
         *  {success: 1, message "whatever"}
         *
         *
         * success value options:
         * 
         *  1: display the message styles as a "success"
         *
         *  0: display the message as an 'alert'
         *
         */
        
        //show the container if it's not already visible
        
        $('#AjaxAlertsContainer').show();

        //style the alert
        var style = (response.success == 1) ? "" : "alert";
        
        var alert =
        $(
            "<div style='display:none' data-alert class='alert-box " + style + "'>" +
                response.message +
                "<a  class='close'>&#215</a>" +
            "</div>"
        );
        
        //append to the existing alerts in the container
                
        $('#AjaxAlerts').append(alert);
        
        //show it
        alert.slideDown().fadeIn();
        
        //wire up the close link to actually close, because foundation
        //won't handle it when an alert is dynamically added to the page
        
        $('.close', alert).click(function() {
            alert.slideUp().fadeOut();                
        });
    }
    