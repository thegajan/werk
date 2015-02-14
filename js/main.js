$(document).ready(function () {
    $('#add-button').click(function (){
        var bub = $('.bubble');
        bub[bub.css('display') == 'block' ? 'hide' : 'show']();

    })
});
