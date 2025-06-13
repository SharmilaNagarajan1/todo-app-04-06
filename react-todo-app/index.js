const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const path = require('path');
const routes = require('./routes/api/todo');

require('dotenv').config();

const port = process.env.PORT || 5050;

const app = express();

//connect to database

mongoose.connect(process.env.DB, {
    useNewUrlParser: true, 
    useUnifiedTopology: true,
})
        .then(() => console.log('Database connected'))
        .catch(err => console.log(err));

app.use(bodyParser.json());
app.use('/api',routes);

app.use((req,res,next) => {
    res.header("Access-Control-Allow-Origin","*");
    res.header("Access-Control-Allow-Headers","Origin, X-Requested-With, Content-Type, Accept");
    next();
});


app.listen(port, () => {
    console.log(`Port running on ${port}`)
});

app.get("/", (req, res) => {
  res.send(`
    <h2>🚀 Todo API is running</h2>
    <p>Available endpoints:</p>
    <ul>
      <li>GET /api/todos</li>
      <li>POST /api/todos</li>
      <li>DELETE /api/todos/:id</li>
    </ul>
  `);
});

