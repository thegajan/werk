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


});