/* Manager for point despost/withdraw modals */

var pointsMgr = function() {
    
    var urls = {
        withdraw: "",
        deposit: "",
        balance: "",
        transactions: ""
    }
    
        
    return {
        
     showDeposit: function() {
        
        
         displayEditModal(
            urls.deposit,
            "#DepositPointsModal",
            "#CurrentBalance",
            urls.balance,
            "#PointTransactionHistory",
            urls.transactions
        );
            
        
     },
     
     showWithdraw: function()  {
                
         displayEditModal(
            urls.withdraw,
            "#WithdrawPointsModal",
            "#CurrentBalance",
            urls.balance,
            "#PointTransactionHistory",
            urls.transactions
        );
        
     },
     
     init: function(opts)
     {
        //initialize using the points manager
        //with urls passed in
        
         //url to withdrawal form
         urls.withdraw = opts.withdrawUrl;
         
         //url to deposit form
         urls.deposit = opts.depositUrl;
         
         //url to current point balance html
         urls.balance = opts.balancePanelUrl;
         
         //url to transaction list table
         urls.transactions = opts.transactionListUrl;
         
      
     }
     
    }
}();