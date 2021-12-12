/*  client-side functions */

$(document).ready(function() {

    // set heights for scrolling
    let setCWHeight = function(){
        let h = $(window).height() - 100;
        $(".configureTab-scrolling").height(h);
        $(".downloadTab-scrolling").height(h);
    };
    setCWHeight();
    $(window).resize(setCWHeight);

    // show input-specific help
    $(".option-input").on('click', function(){
        $(".option-help").hide();
        let id = $(this).data('help');
        $("#" + id).show();
    });
});
