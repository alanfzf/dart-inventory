const {
    makeBackup, callLogin,
    reqCategories, reqProducts,
    reqSuppliers,
    updateCategory,
    updateSupplier,
    updateProduct,
    createCategory,
    createSupplier,
    createProduct,
    reportProducts,
    reportCategories,
    callOlap,
    getSells,
} = require('../database/db-man');


const requestSells = async (req,res) =>{
    const resp = await getSells();
    res.json(resp);
}

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

const getOlap = async (req, res)=>{
    const resp = await callOlap();
    res.json(resp);
}

const getReportProducts = async (req, res)=>{
    const resp = await reportProducts();
    res.json(resp);
}

const getReportCategories = async (req, res)=>{
    const resp = await reportCategories();
    res.json(resp);
}

const getSuppliers  = async (req, res) =>{
    const resp = await reqSuppliers();
    res.json(resp);
}

const getProducts  = async (req, res) =>{
    const resp = await reqProducts();
    res.json(resp);
}

const getCategories  = async (req, res) =>{
    const resp = await reqCategories();
    res.json(resp);
}


//create
const insertCategory= async (req, res) => {
    const {id_category, category} = req.body;
    let resp;

    if(id_category === -1){
        resp = await createCategory(category);
    }else{
        resp = await updateCategory(id_category, category);
    }

    res.json(resp);
}

const insertSupplier = async (req, res) => {
    const {sup_id, sup_name, sup_nit, rep_name, 
        rep_surname, rep_phone, rep_mail
    } = req.body;

    let resp;

    if(sup_id === -1){
        resp = await createSupplier(sup_name, sup_nit, 
            rep_name, rep_surname, rep_phone, rep_mail
        );
    }else{
        resp = await updateSupplier(sup_id, sup_name, sup_nit, 
            rep_name, rep_surname, rep_phone, rep_mail
        );
    }

    res.json(resp);
}

const insertProduct = async (req, res) => {
    const {prod_id, prod, image, price, category
    } = req.body;

    let resp;

    if(prod_id === -1){
         resp = await createProduct(prod, image, price, category);
    }else{
        resp = await updateProduct(prod_id, prod, image, price, category)
    }

    res.json(resp);
}


module.exports = {
    backupHandler,
    loginHandler,
    getSuppliers,
    getCategories,
    getProducts,

    insertCategory,insertProduct,
    insertSupplier,

    getReportCategories, getReportProducts,
    getOlap, requestSells
}