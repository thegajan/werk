<?php
include_once "header.php";
?>
<body>
<link rel="stylesheet" href="css/main.css">
<link rel="stylesheet" href="css/currTask.css">
<!--<section>-->
<!--    <div id="outline">-->
<!--        <div class="circle">-->
<!--        </div>-->
<!--    </div>-->
<!--</section>-->
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

                <div data-icon="ei-chevron-down" class="icons header-icons"></div>
                <div data-icon="ei-search" class="icons header-icons"></div>
            </div>
            <div id="curr-task-content-stuff" class="task-content">
                <table>
                    <tbody>
                    <tr>
                        <td>
                            <div class="task-content-div"><input type="checkbox" class="task-left">

                                <h1 class="task-left">Name</h1></div>
                            <div class="task-content-div icon-menu">
                                <div data-icon="ei-star"></div>
                                <div data-icon="ei-chevron-down"></div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="task-content-div"><input type="checkbox" class="task-left">

                                <h1 class="task-left">Name</h1></div>
                            <div class="task-content-div icon-menu">
                                <div data-icon="ei-star"></div>
                                <div data-icon="ei-chevron-down"></div>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <!--<table id="side-menu">-->
    <!--    <tbody>-->
    <!--    <tr class="space"><td></td></tr>-->
    <!--        <tr id="home" class="hoem tr"><td><div><img src="img_fonts/home.png" class="side-bar-icon" id="home-icon"><h2>Home</h2></div></td></tr>-->
    <!--        <tr id="stats" class="tr"><td><div><img src="img_fonts/calculator.png" class="side-bar-icon" id="calc-icon"><h2>Stats</h2></div></td></tr>-->
    <!--        <tr id="graphs" class="tr"><td><div><div data-icon="ei-chart" class="side-bar-icon" id="graph-icon"></div><h2>Graphs</h2></div></td></tr>-->
    <!--        <tr id="settings" class="tr"><td><div><div data-icon="ei-gear" class="side-bar-icon" id="gear-icon"></div><h2>Settings</h2></div></td></tr>-->
    <!--    <tr class="space"><td></td></tr>-->
    <!--    </tbody>-->
    <!--</table>-->
</main>
</body>