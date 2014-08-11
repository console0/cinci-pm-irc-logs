/* Manager for DISTRIBUTABLE point despost/withdraw modals */

var distributableMgr = function() {
    
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
            "#DepositDistributablePointsModal",
            "#DistributableBalance",
            urls.balance,
            "#DistributableTransactionHistory",
            urls.transactions
        );
            
        
     },
     
     showWithdraw: function()  {
        
        
         displayEditModal(
            urls.withdraw,
            "#WithdrawDistributablePointsModal",
            "#DistributableBalance",
            urls.balance,
            "#DistributableTransactionHistory",
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
         
         //url to current token balance html
         urls.balance = opts.balancePanelUrl;
         
         //url to transaction list table
         urls.transactions = opts.transactionListUrl;
         
      
     }
     
    }
}();