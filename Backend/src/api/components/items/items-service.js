import dbExports from '../../../models/index.js';

import {
  createNotification,
} from '../notifications/notifications-service.js';

const { Items } = dbExports;

// jika gagal membuat notifikasi, proses produk tetep jalan
const createNotificationSafely = async(data) => {
  try {
    await createNotification(data);
  } catch (error) {
    console.error('Failed to create notification:', error);
  }
};
// Get all items with filtering, searching, and pagination

const getItems = async ({
  search,
  category,
  brand,
  minPrice,
  maxPrice,
  sort = 'createdAt',
  order = 'desc',
  page = 1,
  limit = 12,
} = {}) => {
  const filter = {};

  if (search) {
    filter.$or = [
      { title: { $regex: search, $options: 'i' } },
      { description: { $regex: search, $options: 'i' } },
      { brand: { $regex: search, $options: 'i' } },
      { sku: { $regex: search, $options: 'i' } },
    ];
  }

  if (category) filter.category = category;
  if (brand) filter.brand = brand;

  if (minPrice !== undefined || maxPrice !== undefined) {
    filter.price = {};

    if (minPrice !== undefined) {
      filter.price.$gte = Number(minPrice);
    }

    if (maxPrice !== undefined) {
      filter.price.$lte = Number(maxPrice);
    }
  }

  const currentPage = Math.max(1, Number(page) || 1);
  const currentLimit = Math.min(100, Math.max(1, Number(limit) || 12));

  const sortOrder = order === 'asc' ? 1 : -1;

  const [items, total] = await Promise.all([
    Items.find(filter)
      .sort({ [sort]: sortOrder })
      .skip((currentPage - 1) * currentLimit)
      .limit(currentLimit)
      .lean(),

    Items.countDocuments(filter),
  ]);

  return {
    items,
    pagination: {
      total,
      page: currentPage,
      limit: currentLimit,
      totalPages: Math.ceil(total / currentLimit),
      hasNextPage: currentPage * currentLimit < total,
      hasPrevPage: currentPage > 1,
    },
  };
};

// Get a single item
const getItemById = async (id) => {
  return Items.findById(id);
};

// Create a new item
const createItem = async (data) => {
  const item = await Items.create(data);

  //notification ketika produk dibuat
  await createNotificationSafely({
    storeName: 'Info Toko',
    title: 'Produk baru tersedia!',
    message: `${item.title} sekarang sudah tersedia di toko kami.`,
    category: 'store',
    imageUrl: item.thumbnail || null,
    relatedEntityType: `item`,
    relatedEntityId: String(item._id),
  });
  return item;
};

// Update an existing item
const updateItem = async (id, data) => {
  const previousItem = await Items.findById(id).lean();

  if (!previousItem) {
    return null;
  }

  const updatedItem = await Items.findByIdAndUpdate(
    id,
    data,
    {
      new: true,
      runValidators: true,
    }
  );

  if (!updatedItem){
    return null;
  }

  const oldDiscount = Number(
    previousItem.discountPercentage || 0
  );

  const newDiscount = Number(
    updatedItem.discountPercentage || 0
  );

  // Notification jika diskon bertambah
  if (newDiscount > oldDiscount && newDiscount > 0) {
    await createNotificationSafely({
      storeName: 'Promo Toko',
      title: 'Promo spesial untukmu!',
      message: `${updatedItem.title} sekarang mendapatkan diskon ${newDiscount}%.`,
      category: 'promo',
      imageUrl: updatedItem.thumbnail || null,
      relatedEntityType: 'item',
      relatedEntityId: String(updatedItem._id),
    });
  }

  return updatedItem;
};

// Delete an item
const deleteItem = async (id) => {
  return Items.findByIdAndDelete(id);
};

// Get available categories
const getCategories = async () => {
  return Items.distinct('category');
};

// Get available brands
const getBrands = async () => {
  return Items.distinct('brand');
};

export {
  getItems,
  getItemById,
  createItem,
  updateItem,
  deleteItem,
  getCategories,
  getBrands,
};
