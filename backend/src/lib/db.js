import mongoose from "mongoose";
import { MongoMemoryServer } from "mongodb-memory-server";

let memoryServer;

export const connectDB = async () => {
  try {
    const uriFromEnv = process.env.MONGODB_URI;
    const mongoUri = uriFromEnv || (await getInMemoryMongoUri());
    const conn = await mongoose.connect(mongoUri);
    console.log(`MongoDB connected: ${conn.connection.host}`);
  } catch (error) {
    console.log("MongoDB connection error:", error);
  }
};

const getInMemoryMongoUri = async () => {
  if (!memoryServer) {
    memoryServer = await MongoMemoryServer.create();
    console.log("Using in-memory MongoDB (no MONGODB_URI configured).");

    const shutdown = async () => {
      if (memoryServer) {
        await memoryServer.stop();
      }
    };

    process.on("SIGINT", shutdown);
    process.on("SIGTERM", shutdown);
  }

  return memoryServer.getUri();
};
