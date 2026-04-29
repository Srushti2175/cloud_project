import asyncHandler from 'express-async-handler'
import express, { Request, Response, NextFunction } from 'express'
import cors from 'cors'

// your existing imports
// import logger, routes, db, etc...

const app = express()

// -------------------- MIDDLEWARE --------------------
const corsOption: cors.CorsOptions = {
  origin: '*',
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}

app.use(cors(corsOption))
app.options('*', cors(corsOption))
app.use(express.json())
app.use(express.static('public'))

// -------------------- HEALTH CHECK --------------------
app.get('/health', (req: Request, res: Response) => {
  res.status(200).send('OK')
})

// -------------------- ROUTES --------------------
app.get(
  '/',
  asyncHandler((req: Request, res: Response, next: NextFunction) => {
    return res
      .status(200)
      .json(new ApiResponse(200, { msg: 'Hello from server!' }))
  })
)
