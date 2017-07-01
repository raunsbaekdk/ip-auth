return {
  {
    name = "2017-07-01-172400_init_ipauth",
    up = [[
      CREATE TABLE IF NOT EXISTS ipauth_credentials(
        id uuid,
        consumer_id uuid REFERENCES consumers (id) ON DELETE CASCADE,
        ip text UNIQUE,
        created_at timestamp without time zone default (CURRENT_TIMESTAMP(0) at time zone 'utc'),
        PRIMARY KEY (id)
      );

      DO $$
      BEGIN
        IF (SELECT to_regclass('ipauth_key_idx')) IS NULL THEN
          CREATE INDEX ipauth_key_idx ON ipauth_credentials(ip);
        END IF;
        IF (SELECT to_regclass('ipauth_consumer_idx')) IS NULL THEN
          CREATE INDEX ipauth_consumer_idx ON ipauth_credentials(consumer_id);
        END IF;
      END$$;
    ]],
    down = [[
      DROP TABLE ipauth_credentials;
    ]]
  }
}