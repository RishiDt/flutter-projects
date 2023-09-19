const router = require("express").Router();
const userController = require("../controller/user_controller");

router.post("/registration",userController.register);
router.post("/login",userController.logIn);
router.post("/getdata",userController.getData);
module.exports=router;
