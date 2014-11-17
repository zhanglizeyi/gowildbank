$.ajaxSetup({
    headers: {
	'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
});

$(document).ready(function() {
    $('.delete-account-btn').click(function() {
	var deleteUrl = $(this).data('url');
	var username = $(this).data('username');
	$.ajax({ 
            url: deleteUrl, 
            type: 'DELETE',
	    
            success: function(result) {
                window.location.href = '/users/' + username;
	    }
        })
    });
});
