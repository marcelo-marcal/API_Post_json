import knex from 'knex';
import Oracle from 'oracledb';

Oracle.initOracleClient({ libDir: process.env.ORACLE_DIR });
//Oracle.initOracleClient({ libDir: "/home/marcelo/Documentos/DataIntegra/DB/instantclient_19_6_win64" });

const db = knex({
  client: 'oracledb',

  connection: {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB,
  },
  pool: {
    min: 1,
    max: 10,
  },
});

export default db;
