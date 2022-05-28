const {makeBackup, callLogin} = require('../database/db-man');


const backupHandler = async (req, res) =>{
    const resp = await makeBackup();
    res.json(resp);
}

const loginHandler = async (req, res) =>{
    const {username, password} = req.body;

    if(!username || !password){
        res.status(400).end();
        return;
    }

    const resp = await callLogin(username, password);
    res.json(resp);
}


module.exports = {
    backupHandler,
    loginHandler,
}