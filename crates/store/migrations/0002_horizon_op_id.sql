-- Add a Horizon operation id (TOID) for idempotent deposit dedup.
--
-- A Horizon payment record carries a globally-unique `id` (the TOID, encoding ledger + tx + op).
-- It is the most reliable key for "have we already recorded this exact on-chain operation?", more
-- robust than (tx_hash, operation_index) when the operation index is not directly available from
-- the payments endpoint. Deposits dedup on this; replays/reorged re-deliveries become no-ops.

ALTER TABLE transactions ADD COLUMN horizon_op_id TEXT;

CREATE UNIQUE INDEX uq_tx_horizon_op_id
    ON transactions (horizon_op_id)
    WHERE horizon_op_id IS NOT NULL;

-- Uniqueness of a muxed address is already guaranteed by UNIQUE(wallet_id, muxed_id) — a muxed
-- address is a pure function of the wallet's base account + id. The standalone UNIQUE(muxed_address)
-- is redundant and only complicates testing/sharding, so drop it.
ALTER TABLE addresses DROP CONSTRAINT addresses_muxed_address_key;
