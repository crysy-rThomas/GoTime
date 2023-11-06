<template>
    <div id="main-page">  
        <sideBar></sideBar>
        <div id="main-content-container">
            <div id="main-content-pi">
                <h1 class="title">{{nom}} {{ prenom }}</h1>
                <hr class="hr-pi">
                <div id="pi">
                    <h4>Email :  {{ mail }}</h4>
                    <h4>Role : {{ role }}</h4>
                </div>
                <hr class="hr-pi">
                <div style="margin-top: 45px;">
                    <table style="margin: auto;" class="paleBlueRows">
                        <thead>
                            <tr>
                                <th>Monday</th>
                                <th>Tuesday</th>
                                <th>Wednesday</th>
                                <th>Thursday</th>
                                <th>Friday</th>
                                <th>Saturday</th>
                                <th>Sunday</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr><td>cell1_1</td><td>cell2_1</td><td>cell3_1</td><td>cell4_1</td><td>cell5_1</td><td>cell6_1</td><td>cell7_1</td></tr>
                            <tr><td>cell1_1</td><td>cell2_1</td><td>cell3_1</td><td>cell4_1</td><td>cell5_1</td><td>cell6_1</td><td>cell7_1</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import sideBar from "./sideBar.vue"

    export default {
        components: {
            sideBar,
        },
        data() {
            return {
                mail : 'stanislas.selelj@gmail.com',
                nom : 'SEKELJ',
                prenom : 'Stanislas',
                role : 'utilisateur',
            }
        }
    };

</script>

<style>

    #main-content-container{
        margin-left: 100px;
        padding-top: 20px;
        padding: 20px;
    }

    #main-content-pi{
        width: 80%;
        max-width: 1600;
        border-radius: 20px;
        height: 100vh;
        background-color: white;
        margin: auto;
        box-shadow: 8px 8px 33px 0px #9D9D9D;
        padding: 30px;
    }

    .title{
        text-align: center;
        margin-bottom: 40px;
    }

    table.paleBlueRows {
    font-family: "Times New Roman", Times, serif;
    width: 80%;
    height: 200px;
    text-align: center;
    border-collapse: collapse;
    border-radius: 20px 20px 0px 0px;
    overflow: hidden;

    }
    table.paleBlueRows td, table.paleBlueRows th {
    border: 0px solid #FFFFFF;
    padding: 3px 2px;
    }
    table.paleBlueRows tbody td {
    font-size: 13px;
    }
    table.paleBlueRows tr:nth-child(even) {
    background: #d7e6f5;
    }
    table.paleBlueRows{
    background: #cccccc;
    }
    table.paleBlueRows thead {
    background: #3464B5;
    border-bottom: 2px solid #FFFFFF;
    }
    table.paleBlueRows thead th {
    font-size: 17px;
    font-weight: bold;
    color: #FFFFFF;
    text-align: center;
    border-left: 0px solid #FFFFFF;
    }
    table.paleBlueRows thead th:first-child {
    border-left: none;
    }

    table.paleBlueRows tfoot td {
    font-size: 14px;
    }

    .hr-pi{
        width: 60%;
        margin: auto;
    }
    #pi{
        padding-top: 20px;
        padding-bottom: 20px;
        text-align: center;
    }
</style>