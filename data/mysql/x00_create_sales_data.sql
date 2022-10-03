USE demo;

CREATE TABLE sales_data_raw(
   Row_ID        INTEGER  NOT NULL PRIMARY KEY AUTO_INCREMENT,
   Order_ID     BIGINT NOT NULL,
   Order_Date    DATE  NOT NULL,
   Ship_Date     DATE  NOT NULL,
   Ship_Mode     VARCHAR(14) NOT NULL,
   Customer_ID   VARCHAR(8) NOT NULL,
   Customer_Name VARCHAR(22) NOT NULL,
   Segment       VARCHAR(11) NOT NULL,
   Country       VARCHAR(13) NOT NULL,
   City          VARCHAR(17) NOT NULL,
   Province         VARCHAR(20) NOT NULL,
   Postal_Code   INTEGER ,
   Region        VARCHAR(7) NOT NULL,
   Product_ID    VARCHAR(15) NOT NULL,
   Category      VARCHAR(15) NOT NULL,
   SubCategory   VARCHAR(11) NOT NULL,
   Product_Name  VARCHAR(127) NOT NULL,
   Sales         NUMERIC(9,4) NOT NULL,
   UPDATE_TS TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);