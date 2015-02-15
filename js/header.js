$(document).ready(function () {
    $('#add-button').click(function () {
        var bub = $('.bubble');
        bub[bub.css('display') == 'block' ? 'hide' : 'show']();

    });
    $('.datepicker').datepicker({
        inline: true,
        firstDay: 1,
        showOtherMonths: true,
        dayNamesMin: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    });
    $('#submit-add').click(function () {
        var taskName = $('#task-name').trim();
        var description = $('#taskDescription').trim();
        var startDate = $('#start-date').trim();
        var startHour = $('#startHour').trim();
        var startMinute = $('#startMinute').trim();
        var startTOD = $('#startTOD').trim();
        var endDate = $('#end-date').trim();
        var endHour = $('#endHour').trim();
        var endMinute = $('#endMinute').trim();
        var endTOD = $('#endTOD').trim();

    });
});
