import dbExports from "../../../models/index.js";

const {Notifications} = dbExports;

//ambil daftar notifikasi
const getNotifications = async ({ category, limit = 50 } = {}) => {
    const filter = {};

    if (category) {
        filter.category = category;
    }

    const currentLimit = Math.min(100, Math.max(1, Number(limit) || 50));

    return Notifications.find(filter)
        .sort({ createdAt: -1})
        .limit(currentLimit)
        .lean();
};

//hitung notifikasi yang belum dibaca
const getUnreadCount = async () => {
    return Notifications.countDocuments({
        isRead: false,
    });
};

//buat notifikasi
const createNotification = async (data) => {
    return Notifications.create(data);
};

//buat tandain 1 notifikasi sudah dibaca
const markNotificationAsRead = async (id) => {
    return Notifications.findByIdAndUpdate(
        id,
        {
            $set: {
                isRead: true,
            },
        },
        {
            new: true,
            runValidators: true,
        },
    );
};

//buat tandain seluruh notifikasi sudah dibaca
const markAllNotificationsAsRead = async () => {
    return Notifications.updateMany(
        {
            isRead: false,
        },
        {
            $set: {
                isRead: true,
            },
        }
    );
};

export {
    getNotifications,
    getUnreadCount,
    createNotification,
    markNotificationAsRead,
    markAllNotificationsAsRead,
};
