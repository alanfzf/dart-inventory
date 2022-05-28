require('dotenv').config()
//express-related
const express = require('express');
const cors = require('cors');

const {backupHandler, loginHandler} = require('./handlers/handlers');



const app = express();
app.listen(3004, () => console.log('Running on port 3004'))
app.use(cors())
app.use(express.json())
app.use(express.urlencoded({extended: true}))
app.post('/api/backup', backupHandler);
app.post('/api/login', loginHandler);