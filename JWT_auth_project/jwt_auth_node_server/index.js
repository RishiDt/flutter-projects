const app = require("./app");
const userModel = require("./model/user_model");
const dbCon = require("./config/db");

const port = 3000;
app.get('/',(req,res)=>{
    res.send("hello world");
})

app.listen(port,()=>{
console.log(`server listening on port http://localhost:${port}`);
});

