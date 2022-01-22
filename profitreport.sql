 
create or replace view profitreport as
SELECT DATE_TRUNC('month',solddate) AS monthsold,
      COUNT(o.referencenumber) orders,
      SUM(subtotalprice) AS subtotalprice,
      SUM(successfees) AS successfees,
      SUM(totalshippingprice) AS totalshippingprice,
      SUM(totalsaleprice) AS totalsaleprice,
      SUM(paymentmethodfee) AS paymentmethodfee,
      SUM(COST) AS COST,
      CAST(SUM(o.totalsaleprice - o.totalsaleprice /(1 +0.15)) AS DECIMAL(10,2)) gstToPay,
      CAST(SUM(c.cost*.15) AS DECIMAL(10,2)) gstPaid,
      CAST(SUM((o.totalsaleprice - o.totalsaleprice /(1 +0.15)) -(c.cost*.15)) AS DECIMAL(10,2)) AS gstTally,
      CAST(
         sum(o.totalsaleprice
               -o.successfees
               -o.paymentmethodfee
               -c.cost
               -((o.totalsaleprice - o.totalsaleprice/(1+0.15))-(c.cost * .15)) )
AS DECIMAL(10,2)) profit
FROM orders o
 LEFT JOIN products p ON o.productid = p.productid
 LEFT JOIN ordercost c
        ON o.referencenumber = c.referencenumber
       AND c.refunded = FALSE
GROUP BY monthsold;
