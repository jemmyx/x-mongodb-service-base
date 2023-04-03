const pwd = process.env.MONGO_INITDB_ROOT_PASSWORD;
const user = process.env.MONGO_INITDB_ROOT_USERNAME;

db.createUser({
    user,
    pwd,
    roles: [{
        role: "root",
        db: "admin"
    }]
})



