/*
 * General JavaScript
 */

$(document).ready(function($) {
    //make rows in a table clickable
    //only when data-href is a present property
    $('tr').click(function() {
        if ($('tr').is('[data-href]')) {
            window.document.location = $(this).data('href');
        }
    });

    //set cursor for table rows that are links
    if ($('tr').is('[data-href]')) {
        $('tr').css('cursor', 'pointer');
    }
});