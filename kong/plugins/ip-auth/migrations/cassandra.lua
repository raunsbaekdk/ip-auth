return {
  {
    name = "2017-07-01-172400_init_ipauth",
    up =  [[
      CREATE TABLE IF NOT EXISTS ipauth_credentials(
        id uuid,
        consumer_id uuid,
        ip text,
        created_at timestamp,
        PRIMARY KEY (id)
      );

      CREATE INDEX IF NOT EXISTS ON ipauth_credentials(ip);
      CREATE INDEX IF NOT EXISTS ipauth_consumer_id ON ipauth_credentials(consumer_id);
    ]],
    down = [[
      DROP TABLE ipauth_credentials;
    ]]
  }
}