<?php
session_start();
$token = md5(rand(1000,9999)); //you can use any encryption
$_SESSION['token'] = $token; //store it as session variable
?>
<!DOCTYPE html>
<head>
    <link href='http://fonts.googleapis.com/css?family=Exo+2:200,300,400,500' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,400,300,600' rel='stylesheet'
          type='text/css'>
    <meta charset="utf-8"/>
    <!--    <link rel="shortcut icon" href="img_fontss/favicon.jpg" type="image/x-icon">-->
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
                <h1>Add a Task</h1>
                <input type="text" id="task-name" class="input section" name="task-name" placeholder="Task Name">
                <textarea class="textarea seciton" id="taskDescription" rows="5" name="taskDescription"
                          placeholder="Task Description"></textarea>

                <h1>Task Timings</h1>

                <h2>Start Time:</h2> <input type="text" id="start-date" class="time datepicker box" name="startDay"
                                            placeholder="Start Day"><br>
                <input type="text" id="startHour" name="startHour" placeholder="Hour"
                       class="time start times  box">:<input type="text" id="startMinute" name="min"
                                                             placeholder="Minute"
                                                             class="time start times box"> <select name="start-time"
                                                                                                   id="startTOD"
                                                                                                   class="box">
                    <option></option>
                    <option>AM</option>
                    <option>PM</option>
                </select>

                <h2>End Time:</h2> <input type="text" id="end-date" class="time datepicker box" name="endDay"
                                          placeholder="End Day"><br>
                <input type="text" id="endHour" name="endHour" placeholder="Hour"
                       class="time end times box">:<input type="text" id="endMinute" name="min" placeholder="Minute"
                                                          class="time end times box"> <select name="end-time"
                                                                                              id="endTOD" class="box">
                    <option></option>
                    <option>AM</option>
                    <option>PM</option>
                </select>
                <br>

                <div><input id="submit-add" name="submit-add" class="button" type="submit" value="Create Task"></div>
                <br>

                <div><input id="submit-add-cancel" name="submit-add-cancel" class="button" type="submit" value="Cancel">
                </div>
                <script type="text/javascript">
                        $('#submit-add').click(function () {
//                            var taskName = $('#task-name').trim();
//                            var description = $('#taskDescription').trim();
//                            var startDate = $('#start-date').trim();
//                            var startHour = $('#startHour').trim();
//                            var startMinute = $('#startMinute').trim();
//                            var startTOD = $('#startTOD').trim();
//                            var endDate = $('#end-date').trim();
//                            var endHour = $('#endHour').trim();
//                            var endMinute = $('#endMinute').trim();
//                            var endTOD = $('#endTOD').trim();
                            var hi = "hi";
                            var form_data = {
                                data: hi, //your data being sent with ajax
                                token:'<?php echo $token; ?>', //used token here.
                                is_ajax: 1
                            };

                            $.ajax({
                                type: "POST",
                                url: 'https://www.readmybluebutton.com/werk/addTask.php',
                                data: form_data,
                                success: function(response)
                                {
                                    alert(response);
                                }
                            });
                        });
                </script>
            </div>
            <div class="ico-shit other">
                <div data-icon="ei-bell"></div>
            </div>
            <div class="ico-shit stuff">
                <div data-icon="ei-user"></div>
            </div>
    </nav>
</header>