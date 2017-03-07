$(document).on('turbolinks:load', function(){
  $('#join-organization-request').on('click', function () {
    var group_id = $(this).find('button').attr('data-group-id');
    var group_type = $(this).find('button').attr('data-group-type');
    var url = window.location.pathname + '/group_members/';
    $.ajax({
      url: url,
      method: 'POST',
      data: {group_members: {group_id: group_id, group_type: group_type}},
      success: function (data) {
        $('#join-organization-request').empty();
        $('#leave-organization-request').html(data);
      }
    });
  });

  $('#leave-organization-request').on('click', function () {
    var group_id = $(this).find('button').attr('data-group-id');
    var group_type = $(this).find('button').attr('data-group-type');
    var url = window.location.pathname + '/group_members/' + group_id;

    $.ajax({
      url: url,
      method: 'DELETE',
      data: {group_members: {group_id: group_id, group_type: group_type}},
      success: function (data) {
        $('#leave-organization-request').empty();
        $('#join-organization-request').html(data);
      }
    });
  });

});
