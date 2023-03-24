const Pool = require('pg').Pool
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port: process.env.DB_PORT,
})

const getPhones = (req,res)=>{
    pool.query('SELECT * FROM phones ORDER BY id ASC', (error, results) => {
        if (error) {
            console.log(error);
            throw error
        }
        res.status(200).json(results.rows)
    })
}

const addPhone = (req,res)=>{
    const name = req.body

    pool.query('INSERT INTO phones (name) VALUES ($1) RETURNING *', [name], (error, results) => {
        if (error) {
            console.log(error);
            throw error
        }
        res.status(201).send(`Phone added with ID: ${results.rows[0].id}`)
    })
}

module.exports = {addPhone,getPhones}
