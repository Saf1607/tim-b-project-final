// src/stores/userStore.js
import { defineStore } from 'pinia';
import axios from '@/utils/axios';

export const useUserStore = defineStore('user', {
  state: () => ({
    //menyimpan data yang berhubungan dengan status pengguna
    user: null,  // Data user yang diambil setelah login
    token: localStorage.getItem('token') || null,  // Menyimpan token dari localStorage jika ada
  }),

  actions: {
    // Fungsi fetchUser untuk mengambil informasi akun setelah login
    //fungsi yang berfungsi untuk memanipulasi state dan melakukan operasi asynchronous, 
    // seperti meminta data dari API atau menyimpan data.
    async fetchUser() {
      if (!this.token) {
        console.error('No token found');
        return;
      }

      try {
        // Menggunakan token di header untuk autentikasi
        const response = await axios.get('/account/my', {
          headers: {
            Authorization: `Bearer ${this.token}`,  // Menambahkan token ke header
          },
        });
        this.user = response.data.data;  // Menyimpan data user yang didapatkan dari API
      } catch (error) {
        console.error('Error fetching user data:', error);
      }
    },

    // Fungsi login untuk menyimpan token setelah login sukses
    async login(credentials) {
      try {
        const response = await axios.post('/auth/login', credentials);  
        this.token = response.data.token;  // Menyimpan token dari respons API
        localStorage.setItem('token', this.token);  // Menyimpan token ke localStorage
        await this.fetchUser();  // Mengambil informasi user setelah login
      } catch (error) {
        console.error('Error during login:', error);
        throw error;  // Melemparkan error agar bisa ditangani di komponen
      }
    },

    // Fungsi logout untuk menghapus token dan data user
    logout() {
      this.user = null;  // Menghapus data user
      this.token = null;  // Menghapus token
      localStorage.removeItem('token');  // Menghapus token dari localStorage
      //Setelah logout, pengguna akan dianggap belum terautentikasi, dan tidak ada data pengguna yang tersedia.
    },

    // Fungsi untuk memperbarui password atau data lainnya
    async updatePassword(newPassword) {
      if (!this.token) {
        console.error('No token found');
        return;
      }

      try {
        const response = await axios.post('/auth/changepassword', {
          new_password: newPassword,  // Parameter baru password
        }, {
          headers: {
            Authorization: `Bearer ${this.token}`,  // Menambahkan token ke header
          },
        });

        // Jika berhasil, Anda bisa menambahkan sesuatu untuk menunjukkan keberhasilan
        console.log('Password changed successfully:', response.data);
      } catch (error) {
        console.error('Error changing password:', error);
      }
    },
  },
});
