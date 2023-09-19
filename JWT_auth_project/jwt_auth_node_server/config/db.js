const mongoose = require('mongoose');

const dbUrl= "mongodb://127.0.0.1:27017/";
const dbName="movie_search_flutter_app";
const connection = mongoose.createConnection(dbUrl+dbName).on('open',()=>{
    console.log("Connected to mongoDB.");
}).on('error',()=>{
    console.log('Could not connect to mongoDB');
});

module.exports=connection;
