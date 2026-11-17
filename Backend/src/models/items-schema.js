export default (db) => {
  const ItemSchema = new db.Schema(
    {
      title: {
        type: String,
        required: true,
        trim: true,
      },
      description: {
        type: String,
        default: '',
      },
      price: {
        type: Number,
        required: true,
        min: 0,
      },
      discountPercentage: {
        type: Number,
        default: 0,
        min: 0,
        max: 100,
      },
      rating: {
        type: Number,
        default: 0,
        min: 0,
        max: 5,
      },
      stock: {
        type: Number,
        required: true,
        default: 0,
        min: 0,
      },
      brand: {
        type: String,
        trim: true,
        default: '',
      },
      category: {
        type: String,
        required: true,
        lowercase: true,
        trim: true,
      },
      sku: {
        type: String,
        required: true,
        unique: true,
        uppercase: true,
        trim: true,
      },
      thumbnail: {
        type: String,
        default: '',
      },
      images: {
        type: [String],
        default: [],
      },
      video: {
        type: String,
        default: null,
      },
    },
    {
      timestamps: true,
    }
  );

  // Calculate discounted price
  ItemSchema.virtual('discountedPrice').get(function () {
    return this.price * (1 - this.discountPercentage / 100);
  });

  return db.models.Items || db.model('Items', ItemSchema);
};
