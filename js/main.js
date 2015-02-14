$(document).ready(function () {
    $('.add').click(function (){
        var bub = $('.bubble');
        bub[bub.css('display') == 'block' ? 'hide' : 'show']();

    })
});
