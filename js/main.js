$(document).ready(function () {
    $('#current-header').click(function () {
        $('#task-table').slideToggle('slow');
    });
    $('#future-header').click(function () {
        $('#task-table1').slideToggle('slow');
    });
    $('#past-header').click(function () {
        $('#task-table2').slideToggle('slow');
    });
    $('#current-task-click').click(function () {
        $('#finish-task-click').removeClass('current').addClass('others');
        $('#future-task-click').removeClass('current').addClass('others');
        $('#current-task-click').removeClass('others').addClass('current');
        $('#task-table1').css('display', 'none');
        $('#task-table2').css('display', 'none');
        $('#task-table').fadeIn('fast');
    });
    $('#finish-task-click').click(function () {
        $('#current-task-click').removeClass('current').addClass('others');
        $('#future-task-click').removeClass('current').addClass('others');
        $('#finish-task-click').removeClass('others').addClass('current');
        $('#task-table').css('display', 'none');
        $('#task-table1').css('display', 'none');
        $('#task-table2').fadeIn('fast');
    });
    $('#future-task-click').click(function () {
        $('#finish-task-click').removeClass('current').addClass('others');
        $('#current-task-click').removeClass('current').addClass('others');
        $('#future-task-click').removeClass('others').addClass('current');
        $('#task-table2').css('display', 'none');
        $('#task-table').css('display', 'none');
        $('#task-table1').fadeIn('fast');
    });
});