import ItemsModel from '../../../models/items-schema.js';

const itemsData = [
  {
    title: 'Trail Running Shoe',
    description: 'Lightweight mesh upper with a grippy outsole for wet trails.',
    price: 'Rp 890.000',
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
    price: 'Rp 750.000',
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
    price: 'Rp 1.200.000',
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
    price: 'Rp 250.000',
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
    price: 'Rp 300.000',
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
    price: 'Rp 290.000',
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
    price: 'Rp 459.000',
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
    price: 'Rp 200.000',
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
  {
    title: 'Dark Secret EDP 15ML',
    description:
      'Mykonos Dark Secret adalah parfum unisex berkarakter manis hangat dengan perpaduan aroma black cherry, rempah kayu manis, praline, serta amber dan kayu-kayuan yang memberi kesan misterius sekaligus elegan.',
    price: '100',
    rating: 4.9,
    stock: 50,
    brand: 'MYKONOS',
    category: 'cosmetics',
    sku: 'DS-50',
    thumbnail:
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795164175/mykonos1.webp',
    images: [
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795164175/mykonos1.webp',
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795164187/mykonos2.webp',
    ],
    video:
      'https://drive.google.com/file/d/1r1zIwwmi27638g64AR4sKmfEKOHi-jiz/view?usp=drive_link',
  },
  {
    title: 'Kipas Turbo GFS001',
    description:
      'Kipas angin turbo portabel berkecepatan tinggi dengan 100 tingkat pengaturan angin, layar LED digital, dan motor senyap yang praktis untuk dibawa bepergian maupun diletakkan di meja.',
    price: '149',
    rating: 4.8,
    stock: 75,
    brand: 'Goojodoq',
    category: 'electronics',
    sku: 'KTG-75',
    thumbnail:
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795164154/goojodoq1.webp',
    images: [
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795164154/goojodoq1.webp',
      'https://res.cloudinary.com/gsf35r1h/image/upload/f_auto,q_auto/goojodoq2',
    ],
    video:
      'https://drive.google.com/file/d/19-abpEoZBm-DzdbjYJ2CxtRd1a0VxMks/view?usp=drive_link',
  },  
  {
    title: 'Spray Plaster',
    description:
      'Hansaplast Spray Plaster adalah plester semprot cepat kering yang membentuk lapisan tipis transparan, fleksibel, dan tahan air untuk melindungi luka ringan seperti goresan dan lecet.',
    price: '152',
    rating: 4.9,
    stock: 63,
    brand: 'Hansaplast',
    category: 'health',
    sku: 'SP-63',
    thumbnail:
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795164270/images.jpg',
    images: [
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795164270/images.jpg',
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795164224/hansaplast1.avif',
    ],
    video:
      'https://drive.google.com/file/d/1yUmOZkngwp03FvDU1C5UNq6s5V6jrJ3l/view?usp=drive_link',
  },
  {
    title: 'Pikachu and Poke Ball',
    description:
      'LEGO Pokémon Pikachu and Poké Ball adalah set rakitan pajangan berisi 2.050 keping yang menghadirkan figur Pikachu berpose dinamis bersama replika Poké Ball ikonik.',
    price: '3831',
    rating: 4.5,
    stock: 40,
    brand: 'Lego',
    category: 'toys',
    sku: 'PPB-40',
    thumbnail:
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795164270/images.jpg',
    images: [
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795164270/images.jpg',
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795164224/hansaplast1.avif',
    ],
    video:
      'https://drive.google.com/file/d/1fWlZMcvBC0owcFP1Pmi7un_56hRIlmmn/view?usp=drive_link',
  },
  {
    title: 'Mood Glowy Tint',
    description:
      'Peripera Ink Mood Glowy Tint adalah lip tint bertekstur ringan yang melembapkan dan memberikan kilau glossy alami tanpa rasa lengket.',
    price: '221',
    rating: 4.7,
    stock: 55,
    brand: 'Peripera',
    category: 'cosmetics',
    sku: 'MGT-55',
    thumbnail:
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795358152/id-11134207-8224y-mkdcdcz27h1j1e.jpg',
    images: [
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795358152/id-11134207-8224y-mkdcdcz27h1j1e.jpg',
      'https://res.cloudinary.com/gsf35r1h/image/upload/v1795358182/s-l1200.png',
    ],
    video:
      'https://drive.google.com/file/d/1lYmxaBhZqE87fTuX7voeOyPXFo_cQ8tD/view?usp=drive_link',
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
