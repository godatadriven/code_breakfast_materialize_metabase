CREATE MATERIALIZED VIEW code_breakfast.dummy_schema.price_evolution AS
    SELECT 
        symbol AS company,
        bid_price,
        timestamp_col
    FROM code_breakfast.dummy_schema.market_orders
    WHERE timestamp_col >= (SELECT MAX(timestamp_col) FROM code_breakfast.dummy_schema.market_orders) - 300;