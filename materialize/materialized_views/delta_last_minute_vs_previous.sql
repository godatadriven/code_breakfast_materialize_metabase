CREATE MATERIALIZED VIEW code_breakfast.dummy_schema.delta_bid_price AS

    WITH last_minute AS (
        SELECT 
            symbol AS company,
            AVG(bid_price) AS avg_bid_price_last_min
        FROM code_breakfast.dummy_schema.market_orders
        WHERE timestamp_col >= (SELECT MAX(timestamp_col) FROM code_breakfast.dummy_schema.market_orders) - 60
        GROUP BY 1
    )
    
    , prev_minute AS (
        SELECT 
            symbol AS company,
            AVG(bid_price) AS avg_bid_price_prev_min
        FROM code_breakfast.dummy_schema.market_orders
        WHERE timestamp_col BETWEEN (SELECT MAX(timestamp_col) FROM code_breakfast.dummy_schema.market_orders) - 120 
                                AND (SELECT MAX(timestamp_col) FROM code_breakfast.dummy_schema.market_orders) - 60
        GROUP BY 1
    )
    SELECT 
        lm.company,
        lm.avg_bid_price_last_min,
        pm.avg_bid_price_prev_min,
        lm.avg_bid_price_last_min - pm.avg_bid_price_prev_min AS delta
    FROM last_minute lm
    INNER JOIN prev_minute pm 
        ON lm.company = pm.company;