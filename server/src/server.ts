import { clerkMiddleware } from "@clerk/express";
import "dotenv/config";
import express from "express";

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(clerkMiddleware());

app.get("/", (req, res) => {
    res.send("Hello World");
});

app.use((req, res) => {
    res.status(404).json({ error: "End point not found" });
});

const PORT = parseInt(process.env.PORT || "8989");
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
