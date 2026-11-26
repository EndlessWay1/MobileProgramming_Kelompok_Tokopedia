const express = requires("express");
const router = express.Router();

const notificationController = require("./notifications-controller");

//mengambil jumlah notifikasi belum dibaca
router.get(
    "/unread-count",
    notificationController.getUnreadCount
);

//ambil daftar notifikasi
router.get(
    "/",
    notificationController.getNotifications
);

//menandai semua notifikasi sebagai dibaca
router.patch(
    "/read-all",
    notificationController.markAllNotificationsAsRead
);

//menandai satu notifikasi sebagai dibaca
router.patch(
    "/:id/read",
    notificationController.markNotificationsAsRead
);

module.exports = router;