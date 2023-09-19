const UserModel = require("../model/user_model");
const jwt = require("jsonwebtoken");
const secretKey="secretKey";
const jwt_expire="1hr";

class UserServices{
    static async registerUser(email,password){
        try{
            console.log(`email and passoword: ${email},${password}`);
            const createUser = new UserModel({email,password});
            return await createUser.save();
        }catch(err){
            throw err;
        }
    }
    static async checkUser(email){
        try {
            return await UserModel.findOne({email});    
        } catch (error) {
            console.log("exception in UserServices.checkUser:"+error);
        }
        
    }
   static async generateJwtToken(tokenData){
    return  jwt.sign(tokenData,secretKey,{ expiresIn: jwt_expire });
   }

 static  async  validateJwt(token){
    console.log(`jwt is :${token}`);

    try {
       
        jwt.verify(token,secretKey,);
    } catch (error) {
        console.log("login again. token invalid");
        return false;
    }
    
    return true;
    
   }
}
module.exports=UserServices;