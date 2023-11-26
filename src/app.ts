import express, { Request, Response } from 'express';
import * as vars from 'env-var';
import axios from 'axios';

const app = express();

app.get('/', function (req: Request, res: Response) {
  res.send('Hello world from AWS Fargate (in Typescript)');
});

app.get('/ping', function (req: Request, res: Response) {
  console.log('Ping');
  res.send('PING!');
});

app.get('/env', function (req: Request, res: Response) {
  console.log('SUPABASE_URL', vars.get('SUPABASE_URL').asString());
  res.send('Env vars');
});

app.get('/db', async function (req: Request, res: Response) {
  const SUPABASE_URL = vars.get('SUPABASE_URL').asString();
  const SUPABASE_API_KEY = vars.get('SUPABASE_API_KEY').asString();
  try {
    const dbResult = await axios.get(`${SUPABASE_URL}/rest/v1/test`, {
      headers: {
        apikey: SUPABASE_API_KEY,
        Authorization: `Bearer ${SUPABASE_API_KEY}`
      }
    });
    res.status(200).send(dbResult.data);
  } catch (e) {
    console.log('Error fetching data from db', e);
    res.status(400).send(e);
  }
});

app.listen(80, function () {
  console.log('App is listening on port 80!');
});
