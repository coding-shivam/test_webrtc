// const mongoose = require("mongoose");

// exports.dbconnection = async function (){
//     try {
//       const connection = mongoose.connect('mongodb://localhost:27017/test')
//       console.log('connection successfully');
//     } catch (error) {
//         console.log(error);
//     }
// }
const MONGO_DB_CONFIG = {
  DB: "mongodb://localhost/meeting-app"
};

module.exports =
  MONGO_DB_CONFIG
