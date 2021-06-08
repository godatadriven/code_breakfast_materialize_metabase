CREATE MATERIALIZED VIEW avg_bid_price AS
    SELECT 
        symbol AS company,
        AVG(bid_price) AS avg_bid_price
    FROM code_breakfast.dummy_schema.market_orders
    WHERE timestamp_col >= timestamp_col - 60
    GROUP BY 1;