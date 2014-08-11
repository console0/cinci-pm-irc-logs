/* for wiring up additional functionality to forms */


/* wire up any autocomplete select lists to their respect AJAX urls */


$(function() {
    $("form select[data-form='autocomplete']").each(function(index, value) {
        
        $(this).select2({
            
            placeholder: $(this).attr('placeholder') ? 'please choose...': $(this).attr('placeholder'),
            allowClear: true,
            minimumInputLength: 3,
            
            ajax:{
                url: $(this).data('uri'),
                dataType: 'json',
                quietMillis: 100,
                type: "GET",
                data: function(term) {
                    return {
                      search: term  
                    }
                },
                
                results: function (data) {
                    return {
                        results: $.map(data, function (item) {
                            return {
                                text: item.value,
                                id: item.id
                            }
                        })
                    };
                }
            }               
        });
    });
    
});