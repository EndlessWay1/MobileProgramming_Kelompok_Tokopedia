import mongoose from 'mongoose';

import {
  getItems,
  getItemById,
  createItem,
  updateItem,
  deleteItem,
  getCategories,
  getBrands,
} from './items-service.js';

// Get all items
const filterItems = async (req, res) => {
  try {
    const result = await getItems(req.query);

    res.status(200).json({
      success: true,
      ...result,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get item by ID
const findItem = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.isValidObjectId(id)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid item ID',
      });
    }

    const item = await getItemById(id);

    if (!item) {
      return res.status(404).json({
        success: false,
        message: 'Item not found',
      });
    }

    res.status(200).json({
      success: true,
      item,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Create item
const makeItem = async (req, res) => {
  try {
    const item = await createItem(req.body);

    res.status(201).json({
      success: true,
      message: 'Item created successfully',
      item,
    });
  } catch (error) {
    res.status(error.code === 11000 ? 409 : 400).json({
      success: false,
      message: error.code === 11000 ? 'SKU already exists' : error.message,
    });
  }
};

// Update item
const editItem = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.isValidObjectId(id)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid item ID',
      });
    }

    const item = await updateItem(id, req.body);

    if (!item) {
      return res.status(404).json({
        success: false,
        message: 'Item not found',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Item updated successfully',
      item,
    });
  } catch (error) {
    res.status(error.code === 11000 ? 409 : 400).json({
      success: false,
      message: error.code === 11000 ? 'SKU already exists' : error.message,
    });
  }
};

// Delete item
const removeItem = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.isValidObjectId(id)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid item ID',
      });
    }

    const item = await deleteItem(id);

    if (!item) {
      return res.status(404).json({
        success: false,
        message: 'Item not found',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Item deleted successfully',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get categories
const filterCategories = async (req, res) => {
  try {
    const categories = await getCategories();

    res.status(200).json({
      success: true,
      categories,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// Get brands
const filterBrands = async (req, res) => {
  try {
    const brands = await getBrands();

    res.status(200).json({
      success: true,
      brands,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export {
  filterItems,
  findItem,
  makeItem,
  editItem,
  removeItem,
  filterCategories,
  filterBrands,
};
