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

//delete
async function delCategory(id_cat){
    const conn = await getConnection();
    const req = new sql.Request(conn);
    req.input('id', sql.Int(), id_cat);
    const resp = await req.query('delete from tb_category where id_category = @id');
    await conn.close();
    return resp;
}

async function delCategory(id_prod){
    const conn = await getConnection();
    const req = new sql.Request(conn);
    req.input('id', sql.Int(), id_prod);
    const resp = await req.query('delete from tb_product where id_product = @id');
    await conn.close();
    return resp;
}

async function delSupplier(id_supplier){
    const conn = await getConnection();
    const req = new sql.Request(conn);
    req.input('supplier_id', sql.Int(), id_supplier);
    req.output('log', sql.VarChar());
    const resp = await req.execute('delete_supplier');
    await conn.close();
    return resp.output;
}


//FUNCIONES
async function callLogin(user, pass){
    const conn = await getConnection();
    const req = new sql.Request(conn);
    req.input('user', sql.VarChar(), user);
    req.input('pass', sql.VarChar(), pass);
    const resp = await req.query('select * from dbo.login_staff(@user, @pass)');
    await conn.close();

    return resp.recordset;
}

async function callOlap(){
    const conn = await getConnection();
    const req = new sql.Request(conn);
    const resp = await req.query('select * from dbo.olap_movimientos()');
    await conn.close();
    return resp.recordset;
}
//VISTAS
async function getSells(){
    const conn = await getConnection();
    const req = new sql.Request(conn);
    const resp = await req.query('select * from dbo.ventas_por_dia');
    await conn.close();
    return resp.recordset;
}

//vistas
async function reqCategories(){

    const conn = await getConnection();
    const req = new sql.Request(conn);

    const resp = await req.query('select * from tb_category');
    await conn.close();
    return resp.recordset;
}

async function reqSuppliers(){

    const conn = await getConnection();
    const req = new sql.Request(conn);

    const resp = await req.query('select * from dbo.lista_de_proveedores');
    await conn.close();
    return resp.recordset;
}

async function reqProducts(){

    const conn = await getConnection();
    const req = new sql.Request(conn);

    const resp = await req.query('select * from dbo.lista_de_productos');
    await conn.close();

    return resp.recordset;
}

async function reportProducts(){
    const conn = await getConnection();
    const req = new sql.Request(conn);
    const resp = await req.query('select * from dbo.existencias_productos');
    await conn.close();
    return resp.recordset;
}

async function  reportCategories(){
    const conn = await getConnection();
    const req = new sql.Request(conn);
    const resp = await req.query('select * from dbo.productos_en_categoria');
    await conn.close();
    return resp.recordset;
}
//PROCEDIMIENTOS.
async function makeBackup(){
    const conn = await getConnection();
    //create request.
    const req = new sql.Request(conn);
    req.output('log', sql.VarChar());
    //call request.
    const resp = await req.execute('generar_backup');
    await conn.close();
    return resp.output;
}

async function updateCategory(cat_id, cat_name){
    const conn = await getConnection();
    const req = new sql.Request(conn);

    req.input('catid', sql.Int(), cat_id);
    req.input('categoria', sql.VarChar(), cat_name);
    req.output('log', sql.VarChar());
    
    const resp = await req.execute('actualizar_categoria');
    const out = resp.output;
    await conn.close();

    return gen_response(out.log, null);
}

async function createCategory(cat_name){
    const conn = await getConnection();
    const req = new sql.Request(conn);

    req.input('categoria', sql.VarChar(), cat_name);
    req.output('log', sql.VarChar());
    req.output('catid', sql.Int())
    
    const resp = await req.execute('crear_categoria');
    const out = resp.output;
    await conn.close();

    return gen_response(out.log, out.catid);
}

async function updateProduct(prod_id, prod, img, price, categ){

    const conn = await getConnection();
    const req = new sql.Request(conn);
    req.input('prod_id', sql.Int(), prod_id);
    req.input('nombre_prod', sql.VarChar(), prod);
    req.input('imagen_prod', sql.VarChar(), img);
    req.input('precio_venta', sql.Numeric(19,4), price);
    req.input('categ_id', sql.Int(), categ);
    req.output('log', sql.VarChar());
    
    const resp = await req.execute('actualizar_producto');
    await conn.close();
    const output = resp.output;

    return gen_response(output.log, null);
}

async function createProduct(prod, img, price, categ){

    const conn = await getConnection();
    const req = new sql.Request(conn);
    req.input('nombre_prod', sql.VarChar(), prod);
    req.input('imagen_prod', sql.VarChar(), img);
    req.input('precio_venta', sql.Numeric(19,4), price);
    req.input('categ_id', sql.Int(), categ);
    req.output('log', sql.VarChar());
    req.output('id_prod',sql.Int());
    
    const resp = await req.execute('crear_producto');
    const out = resp.output;
    await conn.close();
    return gen_response(out.log, out.id_prod);
}

async function updateSupplier(prov_id, prov, nit, rep, rep2, phone, email){

    const conn = await getConnection();
    const req = new sql.Request(conn);

    req.input('prov_id', sql.Int(), prov_id);
    req.input('prov_nombre', sql.VarChar(), prov);
    req.input('prov_nit', sql.VarChar(), nit);
    req.input('rep_nombre', sql.VarChar(), rep);
    req.input('rep_apellido', sql.VarChar(), rep2);
    req.input('rep_telefono', sql.VarChar(), phone);
    req.input('rep_correo', sql.VarChar(), email);
    req.output('log', sql.VarChar());

    const resp = await req.execute('actualizar_proveedor');
    const out = resp.output;
    await conn.close();
    return gen_response(out.log, null);
}

async function createSupplier(prov, nit, rep, rep2, phone, email){

    const conn = await getConnection();
    const req = new sql.Request(conn);

    req.input('prov_nombre', sql.VarChar(), prov);
    req.input('prov_nit', sql.VarChar(), nit);
    req.input('rep_nombre', sql.VarChar(), rep);
    req.input('rep_apellido', sql.VarChar(), rep2);
    req.input('rep_telefono', sql.VarChar(), phone);
    req.input('rep_correo', sql.VarChar(), email);
    req.output('prov_id', sql.Int());
    req.output('log', sql.VarChar());
    const resp = await req.execute('crear_proveedor');
    const out = resp.output;
    await conn.close();
    return gen_response(out.log, out.prov_id);
}


function gen_response(log, id){
    return {
        "response": log,
        "gen_id": id
    }
}



module.exports = {
    makeBackup, callLogin, callOlap,
    reqCategories, reqSuppliers,
    reqProducts, 
    
    updateCategory, createCategory,
    updateProduct, createProduct,
    updateSupplier, createSupplier,


    reportProducts, reportCategories,
    getSells,

    delCategory, delSupplier
};