--liquibase formatted sql

--changeset jma:004_1 dbms:oracle

-- Comments:
--    Create RPT_DATE_DIM for date and hr dimension.
--
CREATE TABLE RPT_DATE_DIM (
   id             INTEGER   not null,
   date_value     DATE      not null,
   hour_value     NUMBER(2) not null,
   mmYYYY_value   CHAR(7)   not null,
   primary key   (id)
);
