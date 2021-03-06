CREATE VIEW code_breakfast.dummy_schema.market_orders AS
    SELECT
        val->>'symbol' AS symbol,
        (val->'bid_price')::float AS bid_price,
        (val->'order_quantity')::int AS quantity,
        val->>'trade_type' AS trade_type,
        (val->'timestamp')::int AS timestamp_col
    FROM (SELECT text::jsonb AS val FROM code_breakfast.dummy_schema.market_orders_raw);