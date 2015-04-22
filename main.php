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
                <h1 class="header">Tasks</h1>

                <img src="img_fonts/android-more-vertical.svg" class="icons header-icons">

                <div data-icon="ei-search" class="icons header-icons"></div>
            </div>
            <div id="task-summary"></div>
            <div id="curr-task-content-stuff" class="task-content">
                <script>
                    function moreInfo(id){
                        $.ajax({
                            type: "POST",
                            url: 'https://www.readmybluebutton.com/werk/moreInfo.php',
//                            data: form_data,
                            data: {id: id, token: '<?php echo $token ?>'},
                            success: function (response) {
                                if (response == "error") {
                                    $('#task-table2').css('display', 'none');
                                    $('#nothing').css('display', 'block');
                                }
                                $('#curr-task-content-stuff').css('display', 'none');
                                $('#task-summary').html(response);
                            },
                            error: function (xhr, status, error) {
                                $('#task-table2').css('display', 'none');
                                $('#fail').fadeIn('fast');
                            }
                        });
                    }
                    function slidDown(clickId, slideId){
                        $(clickId).click(function () {
                            $(slideId).slideToggle('slow');
                        });
                    }
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
                <div id="current-header" class="some-header"><h1>Current Tasks</h1></div>
                    <table id="task-table">
                        <tbody>
                        <script type="text/javascript">
                            var d = new Date();
                            var curr_date = d.getDate();
                            var curr_month = d.getMonth() + 1; //Months are zero based
                            var curr_year = d.getFullYear();
                            var curr_hour = d.getHours();
                            var curr_min = d.getMinutes();
                            var curr_sec = d.getSeconds();
                            var date = curr_year + "-" + curr_month + "-" + curr_date + " " + curr_hour + ":" + curr_min + ":" + curr_sec;
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
                <div id="future-header" class="some-header"><h1>Future Tasks</h1></div>
                <table id="task-table1">
                    <tbody>
                    <script type="text/javascript">
                        (function worker1() {
                            $.ajax({
                                type: "POST",
                                url: 'https://www.readmybluebutton.com/werk/futureTask.php',
//                            data: form_data,
                                data: {currDate: date, creator: 1, timeZone: timeZone, token: '<?php echo $token ?>'},
                                success: function (response) {
                                    if (response == "error") {
                                        $('#task-table1').css('display', 'none');
                                        $('#nothing').css('display', 'block');
                                    }
                                    $('#task-table1 tbody').html(response);
                                },
                                error: function (xhr, status, error) {
                                    $('#task-table1').css('display', 'none');
                                    $('#fail').fadeIn('fast');
                                },
                                complete: function () {
                                    // Schedule the next request when the current one's complete
                                    setTimeout(worker1, 3000);
                                }
                            });
                        })();
                        //$('#hook').hook();
                    </script>
                    </tbody>
                </table>
                <div id="past-header" class="some-header"><h1>Finished</h1></div>
                <table id="task-table2">
                    <tbody>
                    <script type="text/javascript">

                        (function worker2() {
                            $.ajax({
                                type: "POST",
                                url: 'https://www.readmybluebutton.com/werk/pastTask.php',
//                            data: form_data,
                                data: {currDate: date, creator: 1, timeZone: timeZone, token: '<?php echo $token ?>'},
                                success: function (response) {
                                    if (response == "error") {
                                        $('#task-table2').css('display', 'none');
                                        $('#nothing').css('display', 'block');
                                    }
                                    $('#task-table2 tbody').html(response);
                                },
                                error: function (xhr, status, error) {
                                    $('#task-table2').css('display', 'none');
                                    $('#fail').fadeIn('fast');
                                },
                                complete: function () {
                                    // Schedule the next request when the current one's complete
                                    setTimeout(worker2, 10000);
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
