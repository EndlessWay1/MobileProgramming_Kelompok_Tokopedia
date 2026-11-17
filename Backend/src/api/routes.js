import express from 'express';
import itemsRoute from './components/items/items-route.js';

export default () => {
  const app = express.Router();

  app.get('/csrf-token', async (req, res) => {
    res.json({ csrfToken: req.cookies.csrf_token_client });
  });

  itemsRoute(app);

  return app;
};
