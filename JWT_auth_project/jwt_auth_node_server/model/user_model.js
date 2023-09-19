const dbCon = require("../config/db");
const mongoose = require("mongoose");
const bcrypt = require("bcrypt");

//schema design code
const {Schema} = mongoose;
const userSchema = Schema({
    email:{
        type:String,
        lowercase:true,
        require:true,
        unique:true,
    },
    password:{
        type:String,
        require:true,

    }
});

userSchema.methods.comparePassword= async function(userPassword){
    try {
        const isMatch = await bcrypt.compare(userPassword,this.password);
        return isMatch;
    } catch (error) {
        console.log(`caught exception in userSchema.comparePassword: ${error}`);
    }
}

//encryption code
userSchema.pre("save",async function(){
   const salt= await  bcrypt.genSalt(10);
   const hash= await bcrypt.hash(this.password, salt);
   this.password=hash;
    
});

UserModel = dbCon.model("user",userSchema);
module.exports=UserModel;