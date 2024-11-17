import axios from 'axios';
//melakukan HTTP requests (permintaan HTTP) dari aplikasi berbasis Vue.js 
//(atau framework JavaScript lainnya) ke server atau API. 

const BASE_URL = 'http://localhost:8080/api';

export function getBillerList() {
  return axios.get(`${BASE_URL}/billers`);
}

export function checkBillerAccount(billerId, accountId) {
    return axios.get(`${BASE_URL}/biller/${billerId}/account/${accountId}`);
  }

export function payBillerAccount(payload) {
  return axios.post(`${BASE_URL}/billers/pay`, payload);
}
