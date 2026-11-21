import express from 'express';
import itemsRoute from './components/items/items-route.js';
import { Readable } from 'node:stream';

export default () => {
  const app = express.Router();

  app.get('/csrf-token', async (req, res) => {
    res.json({ csrfToken: req.cookies.csrf_token_client });
  });

  app.get('/videos/:id', async (req, res) => {
    try {
      const { id } = req.params;

      const url = `https://drive.usercontent.google.com/download?id=${encodeURIComponent(id)}&export=download`;

      const headers = {};

      if (req.headers.range) {
        headers.Range = req.headers.range;
      }

      const response = await fetch(url, { headers });

      if (!response.ok && response.status !== 206) {
        return res.status(response.status).end();
      }

      res.status(response.status);
      res.setHeader('Content-Type', 'video/mp4');
      res.setHeader('Content-Disposition', 'inline');
      res.setHeader('Accept-Ranges', 'bytes');

      for (const header of ['content-length', 'content-range']) {
        const value = response.headers.get(header);

        if (value) {
          res.setHeader(
            header === 'content-length' ? 'Content-Length' : 'Content-Range',
            value
          );
        }
      }

      if (!response.body) {
        return res.end();
      }

      Readable.fromWeb(response.body).pipe(res);
    } catch (error) {
      console.error('Video streaming error:', error);
      res.status(500).end();
    }
  });

  itemsRoute(app);

  return app;
};
