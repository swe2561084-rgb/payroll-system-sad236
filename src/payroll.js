'use strict';

// Ажилтны НДШ-ийн хувь (11.5%). Хувь хуулиар өөрчлөгдөж болох тул параметрээр өгнө.
const NDS_RATE_DEFAULT = 0.115;

function assertMoney(value, name) {
  if (typeof value !== 'number' || !Number.isFinite(value) || value < 0) {
    throw new RangeError(`${name} нь 0-ээс багагүй тоо байх ёстой`);
  }
}

// НДШ = үндсэн цалин × НДШ-ийн хувь
function calculateNds(baseSalary, ndsRate = NDS_RATE_DEFAULT) {
  assertMoney(baseSalary, 'baseSalary');
  if (typeof ndsRate !== 'number' || ndsRate < 0 || ndsRate > 1) {
    throw new RangeError('ndsRate нь 0-ээс 1-ийн хооронд байх ёстой');
  }
  return Math.round(baseSalary * ndsRate);
}

// Цэвэр цалин = үндсэн цалин + нэмэгдэл − НДШ − суутгал
function calculateNetSalary({ baseSalary, bonus = 0, deduction = 0, ndsRate = NDS_RATE_DEFAULT }) {
  assertMoney(bonus, 'bonus');
  assertMoney(deduction, 'deduction');
  const nds = calculateNds(baseSalary, ndsRate);
  return baseSalary + bonus - nds - deduction;
}

module.exports = { NDS_RATE_DEFAULT, calculateNds, calculateNetSalary };
