'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const { calculateNds, calculateNetSalary } = require('../src/payroll');

test('НДШ = үндсэн цалин × 11.5%', () => {
  assert.equal(calculateNds(4500000), 517500);
});

test('Цэвэр цалин: 4,500,000 + 500,000 − НДШ 517,500 = 4,482,500', () => {
  assert.equal(calculateNetSalary({ baseSalary: 4500000, bonus: 500000 }), 4482500);
});

test('Нэмэгдэлгүй, суутгалтай цалин зөв бодогдоно', () => {
  assert.equal(calculateNetSalary({ baseSalary: 3200000, deduction: 100000 }), 2732000);
});

test('НДШ-ийн хувь өөрчлөгдвөл тооцоо дагаж өөрчлөгдөнө', () => {
  assert.equal(calculateNetSalary({ baseSalary: 4000000, bonus: 400000, ndsRate: 0.1 }), 4000000);
});

test('Сөрөг цалин өгвөл алдаа шиднэ', () => {
  assert.throws(() => calculateNetSalary({ baseSalary: -1 }), RangeError);
});

test('Хувь 0..1-ээс гарвал алдаа шиднэ', () => {
  assert.throws(() => calculateNds(1000000, 1.5), RangeError);
});
