const req = require('express/lib/request');
const sql = require('mssql');
const creds = {
    user: process.env.USER,
    password: process.env.PASSWORD,
    server: process.env.SERVER,
    database: process.env.DATABASE,
    options: {
        encrypt: true,
        trustServerCertificate: true
    }
}

async function getConnection(){
    try{
        const con = await sql.connect(creds);
        return con;
    }catch(err){
        console.log(err);
    }
}


async function makeBackup(){
    const conn = await getConnection();
    //create request.
    const req = new sql.Request(conn);
    req.output('log', sql.VarChar());
    //call request.
    const resp = await req.execute('generar_backup');
    await conn.close();
    
    return resp;
}

async function callLogin(user, pass){
    const conn = await getConnection();
    const req = new sql.Request(conn);
    req.input('user', sql.VarChar(), user);
    req.input('pass', sql.VarChar(), pass);
    const resp = await req.query('select * from dbo.login_staff(@user, @pass)');
    await conn.close();

    return resp.recordset;
}


module.exports = {makeBackup, callLogin};