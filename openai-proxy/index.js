const functions = require('@google-cloud/functions-framework');
const axios = require('axios');

functions.http('openaiProxy', async (req, res) => {
  // 1. CORS Headers
  res.set('Access-Control-Allow-Origin', '*');
  if (req.method === 'OPTIONS') {
    res.set('Access-Control-Allow-Methods', 'POST');
    res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    res.set('Access-Control-Max-Age', '3600');
    res.status(204).send('');
    return;
  }

  // 2. Only allow POST
  if (req.method !== 'POST') {
    res.status(405).send('Method Not Allowed');
    return;
  }

  try {
    const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
    
    // 5. Forward the request to OpenAI
    const response = await axios.post('https://api.openai.com/v1/chat/completions', req.body, {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${OPENAI_API_KEY}`
      }
    });

    res.status(200).json(response.data);
  } catch (error) {
    console.error('Proxy Error:', error.response ? error.response.data : error.message);
    res.status(error.response ? error.response.status : 500).send(error.message);
  }
});
