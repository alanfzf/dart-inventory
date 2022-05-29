require('dotenv').config()
//express-related
const express = require('express');
const cors = require('cors');

const {
    backupHandler, loginHandler,
    getCategories, getProducts,
    getSuppliers,
    insertProduct,
    insertCategory,
    insertSupplier,
} = require('./handlers/handlers');


const app = express();
app.listen(3004, () => console.log('Running on port 3004'))
app.use(cors())
app.use(express.json())
app.use(express.urlencoded({extended: true}))
//post
app.post('/api/backup', backupHandler);
app.post('/api/login', loginHandler);
//req
app.get('/api/get_categories', getCategories);
app.get('/api/get_products', getProducts);
app.get('/api/get_suppliers', getSuppliers);
//post
app.post('/api/upsert_product', insertProduct);
app.post('/api/upsert_category', insertCategory);
app.post('/api/upsert_supplier', insertSupplier);

