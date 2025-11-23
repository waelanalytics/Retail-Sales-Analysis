use sales_db;
-- التأكد من استخدام قاعدة البيانات الصحيحة
USE sales_db;

-- إنشاء جدول المبيعات مع تحديد أنواع البيانات الصحيحة يدوياً
CREATE TABLE retail_sales (
    InvoiceNo VARCHAR(255),
    StockCode VARCHAR(255),
    Description TEXT,
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(255),
    TotalPrice DECIMAL(10, 2)
);

-- التحقق من أن الجدول تم إنشاؤه
SELECT * FROM retail_sales limit 10;

-- الخطوة النهائية: تحميل البيانات من ملف CSV إلى الجدول
LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 5.7' -- <--- الصق المسار هنا
INTO TABLE retail_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS; -- هذا السطر مهم جداً لتجاهل صف العناوين
SHOW VARIABLES LIKE 'secure_file_priv';

-- الضربة القاضية
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/retail_sales.csv'
INTO TABLE retail_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
-- الخطوة 1: حذف الجدول القديم
DROP TABLE retail_sales;

-- الخطوة 3: الضربة القاضية النهائية
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/retail_sales.csv'
INTO TABLE retail_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- استعلام النصر
SELECT * FROM retail_sales LIMIT 50;

-- السؤال التحليلي الأول: ما هي أكثر 10 دول تحقيقاً للإيرادات؟

SELECT
    Country, -- اختر الدولة
    SUM(TotalPrice) AS TotalRevenue -- اجمع كل الإيرادات وسمِّ العمود TotalRevenue
FROM
    retail_sales -- من جدول المبيعات الخاص بنا
GROUP BY
    Country -- قم بتجميع الصفوف حسب كل دولة
ORDER BY
    TotalRevenue DESC -- رتب النتائج تنازلياً (من الأعلى إلى الأقل)
LIMIT 10; -- أعطني أول 10 نتائج فقط

-- السؤال التحليلي الثاني: من هم أفضل 10 عملاء؟

SELECT
    CustomerID, -- اختر رقم العميل
    SUM(TotalPrice) AS TotalSpending -- اجمع كل إنفاقهم وسمِّ العمود TotalSpending
FROM
    retail_sales
WHERE
    CustomerID IS NOT NULL -- تجاهل المبيعات التي ليس لها عميل مسجل
GROUP BY
    CustomerID -- قم بتجميع المبيعات حسب كل عميل
ORDER BY
    TotalSpending DESC -- رتبهم من الأكثر إنفاقاً إلى الأقل
LIMIT 10; -- أعطني أول 10 عملاء فقط
