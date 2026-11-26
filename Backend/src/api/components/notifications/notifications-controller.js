import mongoose from 'mongoose';

import {
    getNotifications,
    getUnreadCount,
    markNotificationAsRead,
    markAllNotificationsAsRead,
} from './notifications-service.js';
import { count } from 'console';

const allowedCategories = [
    'store',
    'promo',
    'order',
    'finance',
    'live',
];

//GET semua notifikasi
exports.getNotifications = async (req, res) => {
    try{
        const category = req.query.category || "all";

        if (
            category !== "all" &&
            !allowedCategories.includes(category)
         ) {
                return res.status(400).json({
                    success: false,
                    message: "Kategori notifikasi tidak valid",
                });
           }

            const requestedLimit = Number(req.query.limit || 30);

            const limit = Number.isFinite(requestedLimit)
                ? Math.min(Math.max(Math.trunc(requestedLimit), 1), 100) : 30;
            const notifications = await notificationService.getNotifications(category, limit);

            return res.status(200).json({
                success: true,
                count: notifications.length,
                data: notifications,
            });
        }   catch(error) {
            console.error("Get notifications error:", error);

            return res.status(500).json({
                success: false,
                message: "Gagal mengambil notifikasi",
            });
        }
    };

//GET jumlah notifikasi yang belum dibaca
exports.getUnreadCount = async (req, res) => {
    try {
        const count = await notificationService.getUnreadCount();

        return res.status(200).json({
            sucess: true,
            unreadCount: count,
        });
    } catch (error){
        console.error("Get unread count error: ", error);

        return res.status(500).json({
            sucess: false,
            message: "Gagal menghitung notifikasi",
        });
    }
};

//PATCH satu notifikasi menjadi sudah dibaca
exports.markNotificationAsRead = async (req, res) => {
    try {
        const {id} = req.params;

        if(!mongoose.isValidObjectId(id)) {
            return res.status(400).json({
                success: false,
                message: "ID notifikasi tidak valid",
            });
        }

        const notification = await notificationService.markAllNotificationsAsRead(id);

        if(!notification) {
            return res.status(400).json({
                success: false,
                message: "Notifikasi tidak ditemukan",
            });
        }

        return res.status(200).json({
            success: true,
            message: "Notifikasi berhasil dibaca",
            data: notification,
        });
    } catch (error) {
        console.error("Mark notification error: ", error);

        return res.status(500).json({
            success: false,
            message: "Gagal memperbarui notifikasi",
        });
    }
};

//PATCH semua notifikasi sudah dibaca
exports.markAllNotificationsAsRead = async (req, res) => {
  try {
    const result =
      await notificationService.markAllNotificationsAsRead();

    return res.status(200).json({
      success: true,
      message: "Semua notifikasi berhasil dibaca",
      modifiedCount: result.modifiedCount,
    });
  } catch (error) {
    console.error("Mark all notifications error:", error);

    return res.status(500).json({
      success: false,
      message: "Gagal memperbarui semua notifikasi",
    });
  }
};



