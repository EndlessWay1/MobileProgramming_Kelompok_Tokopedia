import ItemsModel from '../../../models/items-schema.js';

const itemsData = [
  {
    title: 'Trail Running Shoe',
    description: 'Lightweight mesh upper with a grippy outsole for wet trails.',
    price: 89,
    discountPercentage: 15,
    rating: 5,
    stock: 42,
    brand: 'Northpeak',
    category: 'footwear',
    sku: 'TRS-0042',
    thumbnail:
      'https://trail-running-shoe.hostmora.app/trail-running-shoe1.jpg',
    images: [
      'https://trail-running-shoe.hostmora.app/Trail Running Shoe2.jpeg',
      'https://trail-running-shoe.hostmora.app/trail-running-shoe1.jpg',
    ],
    video:
      'https://drive.google.com/uc?id=12lNTPoqxdepqrYepfuj5VToU4h7HvdmM&export=download',
  },
  {
    title: 'Urban Running Sneakers',
    description:
      'Comfortable everyday sneakers with breathable fabric and cushioned soles.',
    price: 75,
    discountPercentage: 10,
    rating: 4.5,
    stock: 28,
    brand: 'Northpeak',
    category: 'footwear',
    sku: 'URS-0028',
    thumbnail:
      'https://trail-running-shoe.hostmora.app/urban-running-sneakers-2.webp',
    images: [
      'https://trail-running-shoe.hostmora.app/urban-running-sneakers-2.webp',
      'https://trail-running-shoe.hostmora.app/urban-running-sneakers.webp',
    ],
    video:
      'https://drive.google.com/uc?id=1hCIrRa5L3z-BRxSuEYHFyiiv6fOQCyDy&export=download',
  },
  {
    title: 'Classic Leather Backpack',
    description:
      'Premium leather backpack with multiple compartments for daily essentials.',
    price: 120,
    discountPercentage: 20,
    rating: 4.8,
    stock: 15,
    brand: 'UrbanCraft',
    category: 'bags',
    sku: 'CLB-0015',
    thumbnail:
      'https://trail-running-shoe.hostmora.app/classic-leather-backpack1.webp',
    images: [
      'https://trail-running-shoe.hostmora.app/classic-leather-backpack1.webp',
      'https://trail-running-shoe.hostmora.app/urban-running-sneakers-2.webp',
    ],
    video:
      'https://drive.google.com/uc?id=1V6SOn8lzWSSRvTdgDVq74PoYdoHQTx8D&export=download',
  }, // IM HERE
  {
    title: 'Wireless Bluetooth Headphones',
    description:
      'Noise-isolating wireless headphones with long battery life and deep bass.',
    price: 149,
    discountPercentage: 25,
    rating: 4.7,
    stock: 35,
    brand: 'Soundwave',
    category: 'electronics',
    sku: 'WBH-0035',
    thumbnail:
      'https://trail-running-shoe.hostmora.app/wireless-bluetooth-headphones1.jpeg',
    images: [
      'https://trail-running-shoe.hostmora.app/wireless-bluetooth-headphones1.jpeg',
      'https://trail-running-shoe.hostmora.app/wireless-bluetooth-headphones2.jpeg',
    ],
    video:
      'https://drive.google.com/uc?id=1ZVqijqm6boNY2rI2WLRVVGoBF4NfKlCv&export=download',
  },
  {
    title: 'Minimalist Wrist Watch',
    description:
      'Elegant minimalist watch featuring a stainless steel case and leather strap.',
    price: 199,
    discountPercentage: 5,
    rating: 4.9,
    stock: 12,
    brand: 'Chronos',
    category: 'accessories',
    sku: 'MWW-0012',
    thumbnail:
      'https://trail-running-shoe.hostmora.app/minimalist-wrist-watch1.jpg',
    images: [
      'https://trail-running-shoe.hostmora.app/minimalist-wrist-watch1.jpg',
      'https://trail-running-shoe.hostmora.app/minimalist-wrist-watch2.jpg',
    ],
    video:
      'https://drive.google.com/uc?id=1ZxRyMuNsTEoNUmfGfm0abRnMx870rTmD&export=download',
  },
  {
    title: 'Cotton Oversized T-Shirt',
    description:
      'Soft premium cotton oversized t-shirt suitable for casual everyday wear.',
    price: 29,
    discountPercentage: 0,
    rating: 4.3,
    stock: 65,
    brand: 'BasicWear',
    category: 'clothing',
    sku: 'COT-0065',
    thumbnail:
      'https://trail-running-shoe.hostmora.app/cotton-oversized-t-shirt1.jpeg',
    images: [
      'https://trail-running-shoe.hostmora.app/cotton-oversized-t-shirt1.jpeg',
      'https://trail-running-shoe.hostmora.app/cotton-oversized-t-shirt2.jpeg',
    ],
    video:
      'https://drive.google.com/uc?id=1ZmpXymc_stUlPX4YmGXktQJ4xBtMViTQ&export=download',
  },
  {
    title: 'Polarized Sports Sunglasses',
    description:
      'Lightweight polarized sunglasses offering UV protection for outdoor activities.',
    price: 55,
    discountPercentage: 12,
    rating: 4.6,
    stock: 0,
    brand: 'VisionPro',
    category: 'accessories',
    sku: 'PSS-0000',
    thumbnail:
      'https://trail-running-shoe.hostmora.app/polarized-sports-sunglasses1.jpeg',
    images: [
      'https://trail-running-shoe.hostmora.app/polarized-sports-sunglasses1.jpeg',
      'https://trail-running-shoe.hostmora.app/polarized-sports-sunglasses2.jpeg',
      'https://trail-running-shoe.hostmora.app/polarized-sports-sunglasses3.jpeg',
      'https://trail-running-shoe.hostmora.app/polarized-sports-sunglasses4.jpeg',
    ],
    video:
      'https://drive.google.com/uc?id=1oh_PDZ63_UtEtmWAg6fNieJ-0BXIiUul&export=download',
  },
  {
    title: 'Portable Power Bank',
    description:
      'Compact 20000mAh power bank with fast charging and dual USB output.',
    price: 49,
    discountPercentage: 15,
    rating: 4.4,
    stock: 50,
    brand: 'VoltTech',
    category: 'electronics',
    sku: 'PPB-0050',
    thumbnail:
      'https://trail-running-shoe.hostmora.app/portable-power-bank1.jpeg',
    images: [
      'https://trail-running-shoe.hostmora.app/portable-power-bank1.jpeg',
      'https://trail-running-shoe.hostmora.app/portable-power-bank2.jpeg',
    ],
    video:
      'https://drive.google.com/uc?id=1kKG9rql8PV5dtaRxYTdUUmd50IF8NEUK&export=download',
  },
];

// Seed database
const seedItems = async (db) => {
  const Items = db.models.Items || ItemsModel(db);

  const operations = itemsData.map((item) => ({
    updateOne: {
      filter: { sku: item.sku },
      update: {
        $setOnInsert: item,
      },
      upsert: true,
    },
  }));

  const result = await Items.bulkWrite(operations);

  console.log('Items seeding completed:', {
    inserted: result.upsertedCount,
    matched: result.matchedCount,
  });

  return result;
};

export { itemsData, seedItems };
