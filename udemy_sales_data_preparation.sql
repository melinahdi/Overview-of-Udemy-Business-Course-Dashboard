USE udemy_sales;
SHOW TABLES;
SELECT * FROM bc_sales;

# check data type for each column
SELECT column_name,data_type from information_schema.columns WHERE table_name='bc_sales';

# changing avg_rating, avg_rating_recent, rating format
SELECT avg_rating, avg_rating_recent, rating FROM bc_sales;

ALTER TABLE bc_sales MODIFY COLUMN avg_rating DECIMAL(6,5);
ALTER TABLE bc_sales MODIFY COLUMN avg_rating_recent DECIMAL(6,5);
ALTER TABLE bc_sales MODIFY COLUMN rating DECIMAL(6,5);

# convert created and published_time data type to datetime
SELECT created, published_time FROM bc_sales;
# remove T and Z string first
UPDATE bc_sales SET created = REPLACE(created, 'T', ' ');
UPDATE bc_sales SET created = REPLACE(created, 'Z', ' ');
UPDATE bc_sales SET published_time = REPLACE(published_time, 'T', ' ');
UPDATE bc_sales SET published_time = REPLACE(published_time, 'Z', ' ');

ALTER TABLE bc_sales MODIFY COLUMN created DATETIME;
ALTER TABLE bc_sales MODIFY COLUMN published_time DATETIME;
SELECT column_name,data_type from information_schema.columns WHERE table_name='bc_sales' AND column_name='created';
SELECT column_name,data_type from information_schema.columns WHERE table_name='bc_sales' AND column_name='published_time';

# check missing value
SELECT * FROM bc_sales WHERE id IS NULL; # there's no missing value in ID column
SELECT * FROM bc_sales WHERE title IS NULL; # there's no missing value in title column
SELECT * FROM bc_sales WHERE url IS NULL; # there's no missing value in url column
SELECT * FROM bc_sales WHERE is_paid IS NULL; # there's no missing value in is_paid column
SELECT * FROM bc_sales WHERE num_subscribers IS NULL; # there's no missing value in num_subscribers column
SELECT * FROM bc_sales WHERE avg_rating IS NULL; # there's no missing value in avg_rating column
SELECT * FROM bc_sales WHERE avg_rating_recent IS NULL; # there's no missing value in avg_rating_recent column
SELECT * FROM bc_sales WHERE rating IS NULL; # there's no missing value in rating column
SELECT * FROM bc_sales WHERE num_reviews IS NULL; # there's no missing value in num_reviews column
SELECT * FROM bc_sales WHERE is_wishlisted IS NULL; # there's no missing value in is_wishlisted column
SELECT * FROM bc_sales WHERE num_published_lectures IS NULL; # there's no missing value in num_published_lectures column
SELECT * FROM bc_sales WHERE num_published_practice_tests IS NULL; # there's no missing value in num_published_practice_tests column
SELECT * FROM bc_sales WHERE created IS NULL; # there's no missing value in created column
SELECT * FROM bc_sales WHERE published_time IS NULL; # there's no missing value in published_time column
SELECT * FROM bc_sales WHERE discount_price__amount IS NULL; # there's no missing value in discount_price__amount column
SELECT * FROM bc_sales WHERE discount_price__currency IS NULL; # there's 510 missing values in discount_price__currency column
SELECT * FROM bc_sales WHERE price_detail__amount IS NULL; # there's no missing value in price_detail__amount column
SELECT * FROM bc_sales WHERE price_detail__currency IS NULL; # there's no missing value in price_detail__currency column

# handling missing values
UPDATE bc_sales SET discount_price__currency = COALESCE(NULL, 'INR');
# check missing values again
SELECT * FROM bc_sales WHERE discount_price__amount IS NULL; 

# check duplicate record
/* partition by could be by title column and when you try you will get some duplicate record but if you look
closer, though there's similarity in title there's difference in the url column */
SELECT *, ROW_NUMBER() OVER(PARTITION BY title) AS count_row FROM bc_sales ORDER BY count_row;
SELECT * FROM bc_sales WHERE title='Interpreting Financial Statements';

# the correct duplicate record check, there's no duplicate record
SELECT *, ROW_NUMBER() OVER(PARTITION BY url) AS count_row FROM bc_sales ORDER BY count_row;

# split date and time in created and publish time column;
ALTER TABLE bc_sales ADD created_date DATE; 
ALTER TABLE bc_sales ADD created_time TIME; 
UPDATE bc_sales SET created_date = DATE(created);
UPDATE bc_sales SET created_time = TIME(created);
ALTER TABLE bc_sales DROP created;

ALTER TABLE bc_sales ADD published_time_date DATE; 
ALTER TABLE bc_sales ADD published_time_time TIME; 
UPDATE bc_sales SET published_time_date = DATE(published_time);
UPDATE bc_sales SET published_time_time = TIME(published_time);
ALTER TABLE bc_sales DROP published_time;

# due the currency is in INR, the conversion process to Indonesia rupiah is undertaken based on rupiah exchange rate now
# change discount_price__currency and price_detail__currency column from INR to IDR
UPDATE bc_sales SET discount_price__currency='IDR';
UPDATE bc_sales SET price_detail__currency='IDR';

# times discount_price__amount and price_detail__amount column with 191.97
UPDATE bc_sales SET discount_price__amount=discount_price__amount*191.97;
UPDATE bc_sales SET price_detail__amount=price_detail__amount*191.97;
SELECT * FROM bc_sales;





