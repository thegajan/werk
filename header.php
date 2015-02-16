<?php
session_start();
$token = md5(rand(1000, 9999)); //you can use any encryption
$_SESSION['token'] = $token; //store it as session variable
?>
<!DOCTYPE html>
<head>
    <link href='http://fonts.googleapis.com/css?family=Exo+2:200,300,400,500' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,400,300,600' rel='stylesheet'
          type='text/css'>
    <meta charset="utf-8"/>
    <!--        <link rel="shortcut icon" href="img_fontss/favicon.jpg" type="image/x-icon">-->
    <title>A Time Productivity App</title>
    <!--    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>-->
    <script type="text/javascript" src="js/jquery.js"></script>
    <script type="text/javascript" src="js/jquery-ui-1.11.3.custom/jquery-ui.js"></script>
    <script type="text/javascript" src="js/header.js"></script>
    <script type="text/javascript" src="js/evil-icons.min.js"></script>
    <link rel="stylesheet" href="css/evil-icons.min.css">
    <link rel="stylesheet" href="css/header.css">
    <meta name="description"
          content="A Time Productivity App.">
    <meta name="keywords"
          content="WERK, time management, productivity, Gajan  Nagaraj, Alex Erf, werk">
    <meta name="author" content="Gajan Nagaraj and Alex Erf">
</head>
<header>
    <div id="whole-logo">

        <div id="logo">
            <ul>
                <li onclick="document.location='main.php'">
                    <div data-icon="ei-pencil"></div>
                </li>
                <!--				<li style="cursor:pointer;" id="menuIcon"><img alt="menuBTN" src="images/MenuButton.png"></li>-->
                <li onclick="document.location='main.php'" style="cursor: pointer;">Werk</li>
            </ul>
        </div>
    </div>
    <nav>
        <div class="ico-shit other add">
            <div id="add-button" title="Add Task">
                <div data-icon="ei-plus"></div>
            </div>
            <div class="drop-down bubble" id="add-drop-down">
                <div id="add-task-content">
                    <h1>Add a Task</h1>
                    <input type="text" id="task-name" class="input section" name="task-name"
                           placeholder="Task Name">
                    <textarea class="textarea seciton" id="taskDescription" rows="5" name="taskDescription"
                              placeholder="Task Description"></textarea>

                    <h1>Task Timings</h1>

                    <h2>Start Time:</h2> <input type="text" id="start-date" class="time datepicker box"
                                                name="startDay"
                                                placeholder="Start Day"><br>
                    <input type="text" id="startHour" name="startHour" placeholder="Hour"
                           class="time start times  box">:<input type="text" id="startMinute" name="min"
                                                                 placeholder="Minute"
                                                                 class="time start times box"> <select
                        name="start-time"
                        id="startTOD"
                        class="box">
                        <option></option>
                        <option>AM</option>
                        <option>PM</option>
                    </select>

                    <h2>End Time:</h2> <input type="text" id="end-date" class="time datepicker box" name="endDay"
                                              placeholder="End Day"><br>
                    <input type="text" id="endHour" name="endHour" placeholder="Hour"
                           class="time end times box">:<input type="text" id="endMinute" name="min"
                                                              placeholder="Minute"
                                                              class="time end times box"> <select name="end-time"
                                                                                                  id="endTOD"
                                                                                                  class="box">
                        <option></option>
                        <option>AM</option>
                        <option>PM</option>
                    </select>
                    <br>

                    <div><input id="submit-add" name="submit-add" class="button" type="submit" value="Create Task">
                    </div>
                    <br>

                    <div><input id="submit-add-cancel" name="submit-add-cancel" class="button" type="submit"
                                value="Cancel">
                    </div>
                    <script type="text/javascript">
                        $('#submit-add').click(function () {
                            var taskName = document.getElementById('task-name').value.trim();
                            var description = document.getElementById('taskDescription').value.trim();
                            var startDate = $('#start-date').datepicker("getDate");
                            var d = new Date(startDate);
                            var str = $.datepicker.formatDate('mm/dd/yy', d);
                            var startHour = document.getElementById('startHour').value.trim();
                            var startMinute = document.getElementById('startMinute').value.trim();
                            var startTOD = document.getElementById('startTOD').value.trim();
                            var endDate = $('#end-date').datepicker("getDate");
                            var b = new Date(endDate);
                            var str1 = $.datepicker.formatDate('mm/dd/yy', b);
                            var endHour = document.getElementById('endHour').value.trim();
                            var endMinute = document.getElementById('endMinute').value.trim();
                            var endTOD = document.getElementById('endTOD').value.trim();
                            var a = startDate + " " + startHour + ":" + startMinute + ":00 " + startTOD;
                            var c = endDate + " " + endHour + ":" + endMinute + ":00 " + endTOD;
                            if (taskName.length == 0 || description.length == 0 || str.length == 0 || startHour.length == 0 || startMinute.length == 0 || startTOD.length == 0 || str1.length == 0 || endHour.length == 0 || endMinute.length == 0 || endTOD.length == 0) {
                                $('#submit-add').css({'background-color': '#C0392B', 'border': '1px solid #C0392B'}).val('Incomplete Form!');
                                setTimeout(function () {
                                    $('#submit-add').css({'background-color': '#2ECC71', 'border': '1px solid #2ECC71'}).val('Create Task');
                                }, 1500);
                            } else if (a > c || startHour > 12 || startHour < 1 || startMinute > 59 || startMinute < 0 || endHour > 59 || endHour < 1 || endMinute > 59 || endMinute < 0) {
                                $('#submit-add').css({'background-color': '#C0392B', 'border': '1px solid #C0392B'}).val('Invalid Dates!');
                                setTimeout(function () {
                                    $('#submit-add').css({'background-color': '#2ECC71', 'border': '1px solid #2ECC71'}).val('Create Task');
                                }, 1500);
                            } else {
                                $.ajax({
                                    type: "POST",
                                    url: 'https://www.readmybluebutton.com/werk/addTask.php',
//                            data: form_data,
                                    data: {taskName: taskName, description: description, sur: str, startHour: startHour, startMinute: startMinute, startTOD: startTOD, sur1: str1, endHour: endHour, endMinute: endMinute, endTOD: endTOD, token: '<?php echo $token ?>'},
                                    success: function (response) {
                                        if (response == "success") {
                                            $('#add-task-content').css('display', 'none');
                                            $('#successful').fadeIn('fast');
                                            setTimeout(function () {
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
                                                    $('#successful').css('display', 'none');
                                                    $('#add-task-content').css('display', 'block');
                                                }, 1000);
                                            }, 3000);
                                        } else if (response == "form not complete") {
                                            $('#submit-add').css({'background-color': '#C0392B', 'border': '1px solid #C0392B'}).val('Invalid Form!');
                                            setTimeout(function () {
                                                $('#submit-add').css({'background-color': '#2ECC71', 'border': '1px solid #2ECC71'}).val('Create Task');
                                            }, 1500);
                                        } else {
                                            $('#add-task-content').css('display', 'none');
                                            $('#fail').fadeIn('fast');
                                            setTimeout(function () {
                                                $('#fail').css('display', 'none');
                                                $('#add-task-content').fadeIn('fast');
                                            }, 3000);
                                        }
                                    },
                                    error: function (xhr, status, error) {
                                        $('#add-task-content').css('display', 'none');
                                        $('#fail').fadeIn('fast');
                                        setTimeout(function () {
                                            $('#fail').css('display', 'none');
                                            $('#add-task-content').fadeIn('fast');
                                        }, 3000);
                                    }
                                });
                            }


                        });
                    </script>
                </div>
                <div id="successful">
                    <div data-icon="ei-check"></div>
                    <h4>Task Created!</h4></div>
                <div id="fail">
                    <div data-icon="ei-close-o"></div>
                    <h4>Cannot Connect to Server!</h4></div>
            </div>
            <div class="ico-shit other">
                <div data-icon="ei-bell"></div>
            </div>
            <div class="ico-shit stuff">
                <div data-icon="ei-user"></div>
            </div>
    </nav>
</header>
