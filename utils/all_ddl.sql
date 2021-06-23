-- create db and schema
CREATE DATABASE IF NOT EXISTS code_breakfast;
CREATE SCHEMA IF NOT EXISTS code_breakfast.dummy_schema;

-- source
CREATE MATERIALIZED SOURCE code_breakfast.dummy_schema.market_orders_raw 
FROM PUBNUB
    SUBSCRIBE KEY 'sub-c-4377ab04-f100-11e3-bffd-02ee2ddab7fe'
    CHANNEL 'pubnub-market-orders';

-- view
CREATE VIEW code_breakfast.dummy_schema.market_orders AS
    SELECT
        val->>'symbol' AS symbol,
        (val->'bid_price')::float AS bid_price,
        (val->'order_quantity')::int AS quantity,
        val->>'trade_type' AS trade_type,
        (val->'timestamp')::int AS timestamp_col
    FROM (SELECT text::jsonb AS val FROM code_breakfast.dummy_schema.market_orders_raw);

-- materialized views for analytics
CREATE MATERIALIZED VIEW code_breakfast.dummy_schema.avg_bid_price AS
    SELECT 
        symbol AS company,
        AVG(bid_price) AS avg_bid_price
    FROM code_breakfast.dummy_schema.market_orders
    WHERE timestamp_col >= (SELECT MAX(timestamp_col) FROM code_breakfast.dummy_schema.market_orders) - 60
    GROUP BY 1;

CREATE MATERIALIZED VIEW code_breakfast.dummy_schema.price_evolution AS
    SELECT 
        symbol AS company,
        bid_price,
        timestamp_col
    FROM code_breakfast.dummy_schema.market_orders
    WHERE timestamp_col >= (SELECT MAX(timestamp_col) FROM code_breakfast.dummy_schema.market_orders) - 300
    ORDER BY timestamp_col DESC;

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