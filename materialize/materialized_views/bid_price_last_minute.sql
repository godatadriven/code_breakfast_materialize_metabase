CREATE MATERIALIZED VIEW code_breakfast.dummy_schema.avg_bid_price AS
    SELECT 
        symbol AS company,
        AVG(bid_price) AS avg_bid_price
    FROM code_breakfast.dummy_schema.market_orders
    WHERE timestamp_col >= (SELECT MAX(timestamp_col) FROM code_breakfast.dummy_schema.market_orders) - 60
    GROUP BY 1;