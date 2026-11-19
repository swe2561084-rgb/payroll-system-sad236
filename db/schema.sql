-- Цалин тооцооллын систем: PostgreSQL схем (ER диаграммтай нийцнэ)
CREATE TABLE employee_role (
  role_id      SERIAL PRIMARY KEY,
  name         VARCHAR(30) NOT NULL UNIQUE,
  description  TEXT
);

CREATE TABLE employee (
  employee_code    VARCHAR(10) PRIMARY KEY,
  role_id          INT NOT NULL REFERENCES employee_role(role_id),
  name             VARCHAR(60) NOT NULL,
  job_title        VARCHAR(60) NOT NULL,
  base_salary      BIGINT NOT NULL CHECK (base_salary >= 0),
  login_code_hash  VARCHAR(100) NOT NULL
);

CREATE TABLE pay_period (
  period_id     SERIAL PRIMARY KEY,
  period_year   INT NOT NULL,
  period_month  INT NOT NULL CHECK (period_month BETWEEN 1 AND 12),
  status        VARCHAR(20) NOT NULL DEFAULT 'Нээлттэй',
  UNIQUE (period_year, period_month)
);

CREATE TABLE payroll (
  payroll_id     SERIAL PRIMARY KEY,
  employee_code  VARCHAR(10) NOT NULL REFERENCES employee(employee_code),
  period_id      INT NOT NULL REFERENCES pay_period(period_id),
  base_salary    BIGINT NOT NULL CHECK (base_salary >= 0),
  bonus          BIGINT NOT NULL DEFAULT 0 CHECK (bonus >= 0),
  deduction      BIGINT NOT NULL DEFAULT 0 CHECK (deduction >= 0),
  nds_rate       NUMERIC(4,1) NOT NULL DEFAULT 11.5,
  status         VARCHAR(20) NOT NULL DEFAULT 'Хянагдаж байгаа',
  approved_at    DATE,
  UNIQUE (employee_code, period_id)   -- нэг ажилтанд нэг сард нэг л бодолт
);

CREATE TABLE payout (
  payout_id     SERIAL PRIMARY KEY,
  payroll_id    INT NOT NULL UNIQUE REFERENCES payroll(payroll_id),
  bank_account  VARCHAR(100) NOT NULL,   -- AES-256-аар шифрлэж хадгална
  payout_date   DATE,
  status        VARCHAR(20) NOT NULL DEFAULT 'Үүссэн'
);

CREATE TABLE leave_request (
  request_id     SERIAL PRIMARY KEY,
  employee_code  VARCHAR(10) NOT NULL REFERENCES employee(employee_code),
  decided_by     VARCHAR(10) REFERENCES employee(employee_code),
  leave_type     VARCHAR(30) NOT NULL,
  start_date     DATE NOT NULL,
  days           INT NOT NULL CHECK (days >= 1),
  status         VARCHAR(20) NOT NULL DEFAULT 'Хүлээгдэж буй'
);
