<template>
    <div id="body">
        <!--main content-->
        <div id="main-container">
            <div id="main-div">
                <!--image container-->
                <div id="top-div">
                </div>
                <!--register container-->
                <div id="bottom-div">
                    <!--logo-->
                    <img id="logo" src="../assets/logo.png">
                    <form @submit.prevent="handleSubmit">
                        <div id="inputs">
                            
                            <div class="input-group">
                                <label for="firstname">First Name:</label>
                                <input type="text" name="firstname" id="firstname" v-model="firstname">
                            </div>

                            <div class="input-group">
                                <label for="lastname">Last Name:</label>
                                <input type="text" name="lastname" id="lastname" v-model="lastname">
                            </div>

                            <div class="input-group">
                                <label for="email">Email:</label>
                                <input type="email" name="email" id="email" v-model="email">
                            </div>

                            <div class="input-group">
                                <label for="password">Password:</label>
                                <input type="password" name="password" id="password" v-model="password">
                            </div>

                        </div>    
                        <div style="width: 80%; margin: auto;">
                            <input type="submit" value="Register" name="Submit">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import { addUser } from '@/services/userService';
    export default {
        name: 'RegisterForm',
        data() {
            return {
                email: '',
                firstname: '',
                lastname: '',
                password: '', 
            }
        },
        methods: {
        async handleSubmit() {
            try {
                await addUser(this.email, this.firstname, this.lastname, this.password);
            } catch (error) {
                console.error('Error adding user:', error);
            }
        }
    }
    }
</script>

<style scoped>

.m-a {
    margin: auto;
}

p, input, h1, h2, h2, label {
    font-family: 'Open Sans', sans-serif;
}

form{
    width: 100%;
    height: 100%;
}

#top-div {
    height: 30%;
    width: 100%;
    background-color: white;
    background-image: url('../assets/gotham.jpg');
    background-size: cover;
    background-repeat: no-repeat;
    background-position: center;
    border-radius: 20px 20px 0 0;
}

#bottom-div {
    background-color: rgb(232, 233, 235);
    height: 70%;
    padding: 30px; /* Unified padding */
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: space-evenly; /* Distribute space evenly */
    border-radius: 0 0 20px 20px;
}

#inputs{
    width: 80%;
    margin: auto;
}


#main-div {
    height: 800px;
    width: 100%;
    display: flex;
    flex-direction: column;
    box-shadow: 5px 5px 15px 5px rgba(0,0,0,0.36);
    border-radius: 20px;
}

#body {
    height: 100vh;
    width: 100%;
    background: linear-gradient(to top right, rgb(34, 64, 181) 0%, rgb(143, 151, 181) 80%) !important;
}

#logo {
    width: 100px;
    height: auto;
    position: absolute;
    top: 30%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: 2;
}

.input-group {
    position: relative;
    width: 100%;
    margin: 20px 0;
}

.input-group label {
    position: absolute;
    top: 10px;
    left: 15px;
    font-size: 16px;
    color: #888;
    pointer-events: none;
    transition: top 0.3s ease, font-size 0.3s ease, color 0.3s ease; 
}

input[type="text"]:focus + label,
input[type="text"]:not(:placeholder-shown) + label,
input[type="email"]:focus + label,
input[type="email"]:not(:placeholder-shown) + label,
input[type="password"]:focus + label,
input[type="password"]:not(:placeholder-shown) + label {
    top: -10px;
    left: 5px;
    font-size: 12px;
    color: rgb(34, 64, 181);
}

/* Common input styles */
input[type="text"], 
input[type="email"], 
input[type="password"], 
input[type="submit"] {
    width: 100%;
    padding: 12px 15px;
    border: none;
    border-radius: 8px;
    background-color: #f7f9fc;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    transition: box-shadow 0.3s ease, transform 0.3s ease;
    margin: 10px 0;
    font-size: 16px;
    font-family: 'Open Sans', sans-serif;
    color: #333;
    outline: none;
}

/* Specific styles for submit button */
input[type="submit"] {
    width: 100%;
    background-color: rgb(34, 64, 181);
    color: white;
    cursor: pointer;
    border-radius: 15px;
    height: 50px;
    font-weight: bold;
}

input[type="submit"]:hover {
    background-color: white;
    color: rgb(34, 64, 181);
    border: 2px solid rgb(34, 64, 181);
}

#main-container {
    min-width: 40%;
    max-width: 800px;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin: auto;
    position: relative;
}

/* Placeholder styling */
input[type="text"]::placeholder, 
input[type="password"]::placeholder, 
input[type="email"]::placeholder {
    color: #888;
    opacity: 1;
}

input[type="text"]:focus, 
input[type="password"]:focus, 
input[type="email"]:focus {
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    transform: translateY(-2px);
}
</style>
