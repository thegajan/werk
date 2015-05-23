$(document).ready(function () {
    $('#add-button').click(function () {
        var bub = $('.bubble');
        bub[bub.css('display') == 'block' ? 'hide' : 'show']();

    });
    $('.datepicker').datepicker({
        dateFormat: 'mm/dd/yy',
        inline: true,
        firstDay: 0,
        showOtherMonths: true,
        dayNamesMin: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    });
    $('#submit-add-cancel').click(function () {
        $('.bubble').fadeOut('fast');
        setTimeout(function () {
            $('#task-name').val(null);
            $('#taskDescription').val(null);
            $('#start-date').val(null);
            $('#startHour').val(null);
            $('#startMinute').val(null);
            $('#startTOD').val(null);
            $('#end-date').val(null);
            $('#endHour').val(null);
            $('#endMinute').val(null);
            $('#endTOD').val(null);
        }, 1000);
    });
});
