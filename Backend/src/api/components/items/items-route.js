import express from 'express';

import {
  filterItems,
  findItem,
  makeItem,
  editItem,
  removeItem,
  filterCategories,
  filterBrands,
} from './items-controller.js';

const route = express.Router();

export default (app) => {
  app.use('/items', route);

  // Product listing and filtering
  route.get('/', filterItems);

  // Product metadata
  route.get('/categories', filterCategories);
  route.get('/brands', filterBrands);

  // Individual product
  route.get('/:id', findItem);
  route.post('/', makeItem);
  route.patch('/:id', editItem);
  route.delete('/:id', removeItem);
};
