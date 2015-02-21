<?php
include_once "header.php";
?>
<body>
<script type="text/javascript" src="js/countDown.js"></script>
<script type="text/javascript" src="js/jstz-1.0.4.min.js"></script>
<script type="text/javascript" src="js/main.js"></script>
<link rel="stylesheet" href="css/main.css">
<link rel="stylesheet" href="css/currTask.css">
<main>
    <section id="side-menu">
        <div>
            <div class="space">
                <div></div>
            </div>
            <div id="home" class="hoem div">
                <div>
                    <div><img src="img_fonts/home.png" class="side-bar-icon" id="home-icon">

                        <h2>Home</h2></div>
                </div>
            </div>
            <div id="stats" class="div">
                <div>
                    <div><img src="img_fonts/calculator.png" class="side-bar-icon" id="calc-icon">

                        <h2>Stats</h2></div>
                </div>
            </div>
            <div id="graphs" class="div">
                <div>
                    <div>
                        <div data-icon="ei-chart" class="side-bar-icon" id="graph-icon"></div>
                        <h2>Graphs</h2></div>
                </div>
            </div>
            <div id="settings" class="div">
                <div>
                    <div>
                        <div data-icon="ei-gear" class="side-bar-icon" id="gear-icon"></div>
                        <h2>Settings</h2></div>
                </div>
            </div>
            <div class="space">
                <div></div>
            </div>
        </div>
    </section>
    <section id="main-contents">
        <div id="curr-task-content">
            <div id="curr-task-header">
                <h1 class="header">Current Tasks</h1>

                <img src="img_fonts/android-more-vertical.svg" class="icons header-icons">

                <div data-icon="ei-search" class="icons header-icons"></div>
            </div>
            <div id="curr-task-content-stuff" class="task-content">
                <script>
                    function countdownDate(elementID, date) {
                        var clock = document.getElementById(elementID)
                            , targetDate = new Date(date); // Jan 1, 2050;

                        clock.innerHTML = countdown(targetDate).toString();
                        setInterval(function () {
                            clock.innerHTML = countdown(targetDate).toString();
                        }, 3000);
                    }
                    var timezone = jstz.determine();
                    var timeZone = timezone.name();
                </script>
                <table id="task-table">
                    <tbody>
                    <script type="text/javascript">
                        var date = $.datepicker.formatDate('yy/mm/dd hh:mm:ss', new Date());
                        (function worker() {
                            $.ajax({
                                type: "POST",
                                url: 'https://www.readmybluebutton.com/werk/currentTask.php',
//                            data: form_data,
                                data: {currDate: date, creator: 1, timeZone: timeZone, token: '<?php echo $token ?>'},
                                success: function (response) {
                                    if (response == "error") {
                                        $('#task-table').css('display', 'none');
                                        $('#nothing').css('display', 'block');
                                    }
                                    $('#task-table tbody').html(response);
                                },
                                error: function (xhr, status, error) {
                                    $('#task-table').css('display', 'none');
                                    $('#fail').fadeIn('fast');
                                },
                                complete: function () {
                                    // Schedule the next request when the current one's complete
                                    setTimeout(worker, 2000);
                                }
                            });
                        })();
                        //$('#hook').hook();
                    </script>
                    </tbody>
                </table>
                <div id="nothing">
                    <div data-icon="ei-exclamation"></div>
                    <h4>No Tasks Found</h4></div>
            </div>
                <div id="fail">
                    <div data-icon="ei-close-o"></div>
                    <h4>Cannot Connect to Server!</h4></div>
            </div>
        </div>
    </section>
</main>
</body>