Bedrock Scripts

Last Updated: 7/21/2014


History
============================================================================
7/21/2014       Sean Johnson        First Version
7/22/2014       Sean Johnson        Upgraded Foundation from 5.0.3 to 5.3.1




INTRODUCTION

This document outlines the standard scripts included in bedrock necessary
for a fully functioning site, including detail on each of the files.

Each of the required scripts is already positioned in the correct loading order
on the outer shell templates for public, participant, and adminstrators. This
order is critical to proper loading in IE 8, and should not be modified.


***

As new scripts are introduced and existing ones are modified, please
update this document with details of what was changed.

***


REQUIRED BASE SCRIPTS


    These are the glue that hold everything together and must be included
    on each outer shell template:


    jQuery 1.10.2.min
        
        Has legacy IE 8 support
        
    jQuery UI 1.10.4
    
        Included all of jQuery UI minus the silly transition animations.
        The custom version includes:
        
            UI Core         - (everything) Core, Widget, Mouse, Position
            
            Interactions    - (everything) Draggable, Droppable, Resizable, Selectable, Sortable
            
            Widgets         - (everything) Accordian, Autocomplete, Button, Datepicker,
                                           Dialog, Menu, Progressbar, Slider, Spinner, Tabs,
                                           Tooltip
                                           
            Effects         - (custom) Effects Core, Fade Effect, Slide Effect, Transfer Effect
            
                    
    
    foundation-5.3.1.hacked.min.js
    
        Foundation 5.3.1 with our own fix for a modal bug, works "ok" with IE 8, no apparent problems
        
        This should be included in each outer shell.
        
        There is also an unminified foundation-5.3.1.hacked.js
        for reference.
    
        
    modernizer.js
    
        For detecting browser features






REQUIRED IE SCRIPTS

    These scripts are only included for IE 8 and below to
    get Foundation 5 to render correctly, they can be
    found in the /ie directory. Each adds some HTML5 support
    necessary for the modernity of Foundation.
    
    html5shiv-3.7.0.min.js
    nwmatcher-1.3.1.min.js
    rem-1.1.0.min.js
    respond-1.4.2.min.js
    selectivizr-1.0.2.min.js
  
  
  
REQUIRED OLR SCRIPTS

    The olr directory included scripts written specifically for functionality
    on participant and admin pages. These must be included in the outer shell
    for each.
    
        GENERAL
    
    
        jquery.updater.js
        
            A plugin for wiring up a div to refresh content back to itself - this
            is used to allow users to page through table results without having to reload
            the entire page. See the file itself for documentation on usage.
    
    
        PARTICIPANT SCRIPTS
    
        cart.js
        
            Required for proper functioning of mini cart in upper right hand corner
            of participant pages.
            
        
        ADMIN SCRIPTS
            
            
        admin.profile.js
        
            Required for admin user profile page to function correctly.
        
        
        admin.points.js
        
            Required for admin point deposit and withdrawal modals to display and function
            correctly.
        
        
            




CKEDITOR

    There are a number of CKEDITOR scripts mixed in
    the JS directory:
    
    ckeditor.js
    
        To be included on the pages as necessary where a HTML editor is desired
        
    config.js
    
        Used for universal configuration of CKEDITOR script
        
    /lang/
    
        language files for CKEDITOR internationalization
        
        
    /adapters/jquery.js
    
        For adding ckeditor extensions for jQuery
        
    /plugins/*
    
        Dynamically loaded plugins used for CKEDITOR functionality - you don't
        need to include this on any pages directly
        
    content.css
    
        Used for styling content within the CKEDITOR window. Adjust this as necessary
        so the styles reflect those of the rest of the site ... or not.
        
        
        
        
    
FOUNDATION REFERENCE SCRIPTS

    The only script required for foundation to work is the foundation-5.0.3.hacked.min.js
    referenced at the top of this document. For completeness, there are additional files
    that can be used for reference, but should not be included on any page.
    
    
    /foundation/
    
        The foundation folder includes each of the foundation widget/utility scripts
        individually, unminified, with comments on public functions. Use these for
        reference only. Documentation on how to use each widget can be found
        at http://foundation.zurb.com/docs/
        
    /vendor/
    
        A number of scripts included with the foundation download, use for reference only
        
        



    

            
        

        