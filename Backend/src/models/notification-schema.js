export default (db) => {
    const NotificationSchema = new db.Schema(
        {
            storeName: {
                type: String, 
                default: 'Info Toko',
                trim: true,
            },

            title: {
                type: String,
                required: true,
                trim: true,
            },

            message: {
                type: String,
                required: true,
                trim: true,
            },

            category: {
                type: String,
                required: true,
                enum: ['store', 'promo', 'order', 'finance', 'live'],
            },

            imageUrl: {
                type: String,
                default: null,
            },

            isRead: {
                type: Boolean,
                default: false,
            },

            relatedEntityType: {
                type: String,
                default: null,
            },

            relatedEntityId: {
                type: String,
                default: null,
            },
        },
        {
            timestamps: true,
        }
    );

    NotificationSchema.index({ createdAt: -1});
    NotificationSchema.index({ isRead: 1, createdAt: -1});
    NotificationSchema.index({ category: 1, createdAt: -1});

    return(
        db.models.Notifications || 
        db.model('Notifications', NotificationSchema)
    ); 
};