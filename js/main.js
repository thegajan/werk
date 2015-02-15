$(document).ready(function () {
    $('#add-button').click(function (){
        var bub = $('.bubble');
        bub[bub.css('display') == 'block' ? 'hide' : 'show']();

    });
    $('.datepicker').datepicker({
        inline: true,
        firstDay: 1,
        showOtherMonths: true,
        dayNamesMin: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    });
});
