$(document).on('turbolinks:load', function() {
  function fetch_data(id, url, method) {
    $.ajax({
      url: url,
      method: method,
      data: {tab_id: id},
      success: function (data) {
        $('#'+id).html(data);
      }
    });
  }

  $('.tab-ajax a').on('click', function () {
    var id = $(this).attr('data-destination-id');
    var url = window.location.pathname;
    var method = 'GET';
    if (id != 'documents'){
      fetch_data(id, url, method);
    }
  });


  $('body').on('click', '.icon-accept', function () {
    event.preventDefault();
    var id = $(this).attr('id');
    var url = window.location.pathname + '/group_members/' + id;
    $.ajax({
      method: 'PUT',
      url: url,
      success: function () {
        var request_item = '#accept-request-'+id;
        if($(request_item) !== null){
          $(request_item).remove();
        }
      }
    });
  });

  $('body').on('click', '.icon-decline', function () {
    event.preventDefault();
    var id = $(this).attr('id');
    var url = window.location.pathname + '/group_members/' + id + '/admin_add_members/' + id;
    $.ajax({
      method: 'DELETE',
      url: url,
      success: function () {
        var request_item = '#accept-request-'+id;
        if($(request_item) !== null){
          $(request_item).remove();
        }
      }
    });
  });

  $('.select-user-to-add').select2({
    placeholder: I18n.t("organizations.show.select_user"),
    allowClear: true,
    width: 200
  });
  
  $('#add-organization-member-btn').on('click', function () {
    var url = window.location.pathname + '/admin_add_members/';
    var user_id = $('#organization-select-user').val();
    var group_id = $(this).attr('data-group-id');
    var group_type = $(this).attr('data-group-type');

    $.ajax({
      url: url,
      method: 'POST',
      data: {group_members: {user_id: user_id,
        group_id: group_id, group_type: group_type, confirm: true}},
      success: function (status) {
        alert(status);
        $('#organization-select-user').find('[value='+user_id+']').remove();
      }
    })
  })
});

