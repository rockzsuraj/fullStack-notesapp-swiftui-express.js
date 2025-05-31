const express = require("express");
const mongoose = require("mongoose")

var app = express()

app.use(express.json());

var Data = require("./nodeSchema")

mongoose.connect("mongodb://localhost/newDB")
mongoose.connection.once("open", () => {
    console.log("Connected to DB!")
}).on("error", (error) => {
    console.log("Failed to connect " + error)
})

app.get("/", (req, res) => {
    res.send("Hello world!")
})


//Create a note
//POST request
app.post("/create", (req, res) => {

    console.log('create request started');
    
    
    console.log('req', req);
    
    var note = new Data({
        note: req.body.note,
        title: req.body.title,
        date: req.body.date
    })
    console.log('new note', note);
    
    note.save().then(() => {
        if (note.isNew === false) {
            res.send("Saved data!")
        } else {
            console.log("Failed to save data!")
        }
    }).catch((err) => {
        console.log("Failed to save data!", err);
        res.status(500).send("Failed to save data!");
    });
})

// delete a note
//POST request

app.post("/delete", async (req, res) => {
    try {
        console.log('id ', req.query.id);
        
        const result = await Data.findOneAndDelete({
            _id: req.query.id
        });

        if (!result) {
            return res.status(404).json({ error: "Note not found" });
        }

        res.json({ message: "Note deleted successfully", deletedNote: result });
    } catch (err) {
        console.error("Delete error:", err);
        res.status(500).json({
            error: "Failed to delete note",
            details: err.message
        });
    }
});


// update a note
//POST request

app.post("/update", async (req, res) => {
    try {
        console.log('body', req.body);
        
        if (!req.body.id) {
            return res.status(400).json({ error: "ID is required!" });
        }

        console.log('updated note', {
            title: req.body.title,
            note: req.body.note,
            date: req.body.date,
        });
        
        const updatedNotes = await Data.findOneAndUpdate({
            _id: req.body.id
        }, {
            title: req.body.title,
            note: req.body.note,
            date: req.body.date,
        }, {
            new: true
        })

        if (!updatedNotes) {
            res.status(404).json({
                error: "Notes not found!"
            })
        }

        res.status(200).json({
            message: "Notes updated successfully!",
            updatedNotes
        })

    } catch (error) {
        console.log("Failed to update notes " + error);
        res.status(500).send("Failed to update the notes!")

    }
})

// fetch all notes
//POST request

app.get("/fetch", (req, res) => {
    Data.find({}).then((DBitems) => {
        res.send(DBitems)
    }).catch((err) => {
        res.status(500).send("failed to fetch notes");
    })
})


// https://192.168.39.137:8081/create
var server = app.listen(8081, "192.168.1.2", () => {
    console.log('Server is running!')
})