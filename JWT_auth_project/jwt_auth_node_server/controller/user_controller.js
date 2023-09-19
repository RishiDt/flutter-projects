const UserServices= require("../services/user_services");

exports.register = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        await UserServices.registerUser(email, password);
        res.json({ status: true, success: 'User registered successfully' });
    } catch (err) {
        console.log("---> err -->", err);
    }
}

checkPreviousLogInSession = function (req){
const {token} =req.body;
if(token != null ){
return  UserServices.validateJwt(token);
}else return false;
}







exports.logIn = async (req, res, next) => {
    try {

        const isValidPreviousLogIn = checkPreviousLogInSession(req);

        if (isValidPreviousLogIn) {
            res.status(200).json({ status: true });
            return
        }
        else {
            const { email, password } = req.body;
            const user = await UserServices.checkUser(email);
            if (user == null) {
                res.status(200).json({ status: false, msg:"User does not exist register first."});
                return
            }

            const isMatch = user.comparePassword(password);

            if (!isMatch) {
                res.status(200).json({ status: false, msg: "Password does not match" });
            }

            const tokenData = { _id: user._id, email: user.email };
            const jwtToken = await UserServices.generateJwtToken(tokenData);

            res.status(200).json({ status: true, token: jwtToken });
        }


    } catch (error) {
        console.log(`exception is UserController.login():` + error);
    }

}

exports.getData = async(req,res,next)=>{
const {token} = req.body;
console.log(`jwt is :${token}`);
const isValid = await UserServices.validateJwt(token);
if(isValid){
    console.log("token is valid");
    res.json({ status:"here is your data" });

} 
else {
    res.json({ status:"your toekn was invalid log in again." });
}

}